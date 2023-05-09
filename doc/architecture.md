
# Architecture overview

:construction: **Currently under construction** :construction:

[**FULL-SIZE DIAGRAM**](res/architecture_overview.pdf)

![architecture overview](https://github.com/mdernovoi/data-analysis-platform-static-content/blob/main/res/architecture_overview.png)

[**FULL-SIZE DIAGRAM**](res/architecture_overview.pdf)

## Concepts and ideas

- use single tools that are good at what they do
- extensibility and flexibiity / technology agnostic


## System components

Please reference the above architecture overview diagram for service urls, network connections and exposed ports.

### service-host

Only one instance of the `service-host` is required.

#### gitlab

For collaboration, project management, source code management and **pipeline execution**.

To ensure **reproducibility**, run your code with GitLab Pipelines in [custom Docker environments](#docker-environments) that are reset before every run. Do not let "dirty" global variables or artifacts of previous runs distort your results ever again.

Leverage the whole power of GitLab by connecting to **Kubernetes** for distributed learning, using off the shelf CI/CD features for **model deployment** and leveraging the powerful collaboration and project planning features.

GitLab also provides a custom docker image registry accessible at `gitlab-registry.mydomain.com` where you can store your [custom Docker environments](#docker-environments).

#### mlflow

**Track**, compare and analyze parameters, **metrics** and **artifacts** of your experiments. `gitlab` Pipelines run experiments and store results in `mlflow` where you review and analyze them.

Metrics and parameters are stored in the `postgres-service` database. Artifacts are stored in the `minio` S3 storage.

#### minio

S3 compatible on premise object storage for your data.

Experiment artifacts of `mlflow` are stored here.

#### postgres-service

A PostgreSQL database for tabular data of your services.

Experiment metrics and parameters of `mlflow` are stored here.

#### postgres-data

A PostgreSQL database for your tabular datasets.

Store your own tabular datasets here to leverage the full power of data management in databases.

**NOTE**: `postgres-service` and `postgres-data` are separated for easier management since dataset management in `postgres-data` requires custom database performance settings (bulk inserts and reads).

#### pgadmin

A common web UI for PostgreSQL management.

#### portainer

A common web UI for Docker management since typing docker cli command can get tedious pretty fast.

**NOTE**: This container is directly connected to the docker socket and thus is a security concern since it can access every file on the host machine. If you want to harden your setup, this service can be removed since it is not strictly necessary for the operation of the Data Analysis Platform.

#### nginx-proxy

A reverse proxy that mangages access to all docker containers since they are not accessible from the outside.

Additionally it allows to access multiple serivices on the same port (80 / 443) just bu using different requested urls (e.g., `http://gitlab.mydomain.com` and `http://minio.mydomain.com` both go through the default `80` port of the `nginx-proxy` container but redirect requests to two different containers internally).

### runner-host (1..n)

There can exist multiple `runner-host` instances to scale the available compute resources.

> **NOTE**: Both the `service-host` and `runner-host` subsystems can be deployed on the same host. However, an installation on different machines is recommended to preserve the functionality of `service-host` services in case the `runner-host` crashes due to computation errors (e.g., out-of-memory error).

#### gitlab-runner (1..n)

One or several `gitlab-runner` instances that execute GitLab pipelines.

By default it is configured to use the docker executor that creates a new container for every pipeline step (see `gitlab-runner pipeline container`) thus ensuring isolation and reproducibility of results.

#### development environment (0..n)

Zero or several containers of your [custom Docker environments](#docker-environments) to which you connect with IDEs remote development capabilities auch as DataSpell (recommended) of Pycharm from JetBrains, or VSCode from Microsoft.

The idea is to use the same container for development and during GitLab pipeline execution. The reason for full-fledged docker containers is that many Python and R packages require system-level depenedencies which can not be managed with `venv` or `renv`.

These containers are ephemeral. If something goes wrong, you can just recreate them. All the code will automatically be copied into the containers by the IDEs.

#### portainer

A common web UI for Docker management since typing docker cli command can get tedious pretty fast.

**NOTE**: This container is directly connected to the docker socket and thus is a security concern since it can access every file on the host machine. If you want to harden your setup, this service can be removed since it is not strictly necessary for the operation of the Data Analysis Platform.

#### nginx-proxy

A reverse proxy that mangages access to all docker containers since they are not accessible from the outside.

Additionally it allows to access multiple services on the same port (80 / 443) just bu using different requested urls (e.g., `http://gitlab.mydomain.com` and `http://minio.mydomain.com` both go through the default `80` port of the `nginx-proxy` container but redirect requests to two different containers internally).

### docker environments

Reference the `src/environments` directory of the project.

Since many Python and R packages require system-level depenedencies which can not be managed with `venv` or `renv`, full-fledged docker containers are used for development and repeatable execution in GitLab pipelines.

The idea is to reduce the gap between development and production environmentst through the usage of the same containers for both purposes. Therefore, if something works during development, you can be sure that it will also work when the model is deployed to production.

To fully utilize the potential of a unified environemtnent SSH and a Jupyter Server are exposed allowing for remote developement. For an IDE with remote development capabilities such as DataSpell (recommended) or PyCharm from JetBrains or VSCode from Microsoft these containers look just like a regular machine. 

The IDE handels all data transfers, remote execution and debugging while the code remains on your local machine. Therefore, if something goes wrong, you can just recreate the development containers and rerun your code. 

**NOTE**: These containers can be used independently of the Data Analysis Platform. You can host them on GitHub and Docker Hub and build and run them on your local PC.


### development machine

Modern IDEs such as DataSpell (recommended), PyCharm or VSCode support remote development over SSH and connections to remote Jupyter Notebook servers. 

This allows to connect to and develop in pre-defined environemtnes on machines witch much more compute power than your local system. For data analysis projects these aspects are esepecially important, since usually a lot of compute is required and for reproducibility all software versions have to be fixed.

However, no IDE requres the remote development targets to be actual machines of VMs. You can use [custom docker containers](#docker-environments) with your own software installed in it and connect to them over SSH. This allows you to have a fixed execution environment that stays the same regardless of where your deploy it (at least while the kernel api does not change too much).

## Files and directories


### `custom-data-analysis-platform-template`

#### `data-analysis-platform`

#### `doc`

#### `infrastructure`

#### `src`

#### `Makefile`







- `infrastructure/secrets`

      - `fullchain.pem`: TLS certificates (reference the [tls guide](tls.md))
      - `privkey.pem`: TLS private key (reference the [tls guide](tls.md))
      - `dhparam.pem`: TLS DH parameters (reference the [tls guide](tls.md))

    - `infrastructure/config`

      - Currently nothing to replace
      
    - `infrastructure/ansible`

      - `global_vars.yml`: global ansible configuration variables.


