
# Architecture overview


[**FULL-SIZE DIAGRAM**](res/architecture_overview.pdf)

![architecture overview diagram](https://github.com/mdernovoi/data-analysis-platform-static-content/blob/main/res/architecture_overview.png)

[**FULL-SIZE DIAGRAM**](res/architecture_overview.pdf)

## Concepts and ideas

The main goal of the Data Analysis Platform is to select useful tools and to create a unified and extensible infrastructure framework that 

- is easy to deploy and manage
- can be deployed on-premise and on customer infrastructure (for data protection reasons)
- is easily extensible and customizable to meet your requirements
- reduces the burden of experiment management in data analysis projects.

### Extensible and technology agnostic

The Data Analysis Platform is an extensible and technology-agnostic framework for your data analysis projects.

Several services, such as GitLab, MLflow, Postgres, Minio, etc., are currently deployed with docker compose (see `data-analysis-platform/infrastructure/ansible/role_*-host/templates/*-compose.yml.j2`) and configured with dynamically generated config files.

Ansible tasks in `data-analysis-platform/infrastructure/ansible` configure hosts to be able to run docker containers, create all required directories, and generate configuration files from templates.

You can fully customize all these steps: 

- remove or add ansible tasks
- modify the docker compose files
- use external services (e.g., Amazon S3 instead of Minio or full-fledged VMs instead of docker containers). 

Files in the `data-analysis-platform` repository act as templates for your own setup. **They are overwritten during upgrades**.

Files in the `custom-data-analysis-platform-template` repository suggest how you could integrate your own infrastructure definition code with the `data-analysis-platform` templates. **They remain under your control and are not touched during upgrades**.

**TIP**: If you want to keep a simple upgrade path and do not require extensive modifications of the Data Analysis Platform, it is beneficial not to modify your copy of the reference files too much since, during every upgrade, you have to apply new changes to your own configuration manually.

### Use specialized tools instead of a single e2e solution

Another idea the Data Analysis Platform is built upon is that **several specialized tools are often better** than one e2e platform that claims to be able to do everything. That is why several standalone services such as GitLab, MLflow, Minio, and Postgres are used.

**GitLab** is an excellent platform for software development, project management, collaboration, and CI/CD. It has been in development for a long time and offers many valuable features. 

The main use-case besides managing your code is to **run experiments and data transformation workflows in a repeatable fashion with GitLab Runners** (examples can be found in the `src` directory and on the [website of the CML project](https://cml.dev/)).

**MLflow** is a tool for tracking experiment results, metrics, parameters, and artifacts. It also provides a unified interface for model sharing that cloud providers support.

Other services, such as Postgresql, Minio, etc., offer additional management and data storage functionality.

## System components

Please reference the above architecture overview diagram and the [services and credentials overview](credentials_services.md) for service names, URLs, network connections, and exposed ports.

### development machine

Modern IDEs such as DataSpell (recommended), PyCharm, or VSCode support remote development over SSH and connections to remote Jupyter Notebook servers. 

This allows development in pre-defined environments on machines with much more computing power than your local system. These aspects are especially important for data analysis projects since much compute power is usually required, and all software versions must be fixed for reproducibility.

However, no IDE requires the remote development target to be an actual machine or VM. You can use [custom docker environments](environments.md) with your software and connect to them over SSH. This allows you to have a fixed execution environment that stays the same regardless of where you run it (at least while the kernel API does not change too much).

### service-host

A host where all primary services run. 

Only one instance of the `service-host` is required.

#### gitlab

A [GitLab](https://about.gitlab.com/en-us/) Community Edition container for collaboration, project management, source code management, and **pipeline execution**.

To ensure **reproducibility**, run your code with GitLab Pipelines in [custom Docker environments](environments.md) that are reset before every run. Do not let "dirty" global variables or artifacts of previous runs distort your results ever again.

Leverage the full power of GitLab by connecting to **Kubernetes** for distributed learning and resource management. In addition, off-the-shelf CI/CD features for **model deployment** and powerful collaboration and project planning features will make your life easier.

GitLab also provides a custom docker image registry accessible at `gitlab-registry.mydomain.com` where you can store your [custom Docker environments](environments.md).

#### mlflow

[MLflow](https://mlflow.org/) helps to **track**, compare and analyze parameters, **metrics**, and **artifacts** of your experiments. 

Your GitLab Pipelines run experiments and store results in MLflow, where you can review and analyze them.

Metrics and parameters are stored in the `postgres-service` database. Artifacts are stored in the `minio` S3 storage.

#### minio

[Minio](https://min.io/) is an S3-compatible on-premise object storage for your data.

Experiment artifacts gathered by MLflow are stored here.

#### postgres-service

A [PostgreSQL](https://www.postgresql.org/) database for tabular data of your primary services.

Experiment metrics and parameters gathered by MLflow are stored here.

#### postgres-data

A [PostgreSQL](https://www.postgresql.org/) database for your tabular datasets.

Store your tabular datasets here to leverage the full power of data management in databases (this is better than juggling tons of CSVs).

**NOTE**: `postgres-service` and `postgres-data` are separated for easier management since dataset management in `postgres-data` requires custom database performance settings (bulk inserts and reads).

#### pgadmin

[PGAdmin](https://www.pgadmin.org/) is the most common web UI for PostgreSQL management.

#### portainer

[Portainer](https://www.portainer.io/) is a universal container management platform for Docker and Kubernetes. Typing Docker CLI commands can get tedious fast.

**NOTE**: This container is directly connected to the docker socket, and by nature, it has access to every file on the host machine. Portainer provides details about [Docker Roles and Permissions](https://docs.portainer.io/advanced/docker-roles-and-permissions) as well as a blog titled [Secure Your Portainer Setup with Security Controls](https://www.portainer.io/blog/secure-your-portainer-setup-with-security-controls) to help understand this more in detail. If you want to harden your setup, this service can be removed since it is optional for the operation of the Data Analysis Platform.

#### nginx-proxy

An [nginx](https://www.nginx.com/) based reverse proxy that manages access to all docker containers since they are not accessible from the outside for security reasons.

Additionally, a reverse proxy allows access to multiple services on the same port (80 / 443) just by using different request URLs (e.g., `http://gitlab.mydomain.com` and `http://minio.mydomain.com` both go through the default `80` port of the `nginx-proxy` container but get redirected to two different containers internally).

### runner-host (1..n)

A host where experiments and computation tasks are executed. Multiple `runner-host` instances can exist to scale the available compute resources.

**NOTE**: The `service-host` and `runner-host` subsystems can be deployed on the same host. However, an installation on different machines is recommended to preserve the functionality of `service-host` services in case the `runner-host` crashes due to computation errors (e.g., out-of-memory error).

#### gitlab-runner (1..n)

One or several [GitLab Runner](https://docs.gitlab.com/runner/) instances that execute GitLab pipelines.

By default, they are configured to use the docker executor that creates a new container for every pipeline step (see `gitlab-runner pipeline container` on the architecture diagram), thus ensuring isolation and reproducibility of results.

#### development environment (0..n)

Zero or several containers of your [custom Docker environments](environments.md) for development. You can connect to them with the remote development capabilities of modern IDEs.

The idea is to use the same container for development and during GitLab pipeline execution. The reason for full-fledged docker containers is that many Python and R packages require system-level dependencies which can not be managed with `venv` or `renv`.

These containers are ephemeral. If something goes wrong, you can recreate them. All the code will automatically be copied into the containers by your IDE.

#### portainer

[Portainer](https://www.portainer.io/) is a universal container management platform for Docker and Kubernetes. Typing Docker CLI commands can get tedious fast.

**NOTE**: This container is directly connected to the docker socket, and by nature, it has access to every file on the host machine. Portainer provides details about [Docker Roles and Permissions](https://docs.portainer.io/advanced/docker-roles-and-permissions) as well as a blog titled [Secure Your Portainer Setup with Security Controls](https://www.portainer.io/blog/secure-your-portainer-setup-with-security-controls) to help understand this more in detail. If you want to harden your setup, this service can be removed since it is optional for the operation of the Data Analysis Platform.

#### nginx-proxy

An [nginx](https://www.nginx.com/) based reverse proxy that manages access to all docker containers since they are not accessible from the outside for security reasons.

Additionally, a reverse proxy allows access to multiple services on the same port (80 / 443) just by using different request URLs (e.g., `http://gitlab.mydomain.com` and `http://minio.mydomain.com` both go through the default `80` port of the `nginx-proxy` container but get redirected to two different containers internally).






      


