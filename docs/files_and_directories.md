
# Files and directories structure

You will have the following directory structure if you follow the [standard installation procedure](provision.md).

**NOTE**: Persistent docker mounts and generated compose and config files by default are located at `/var/opt/data_analysis_platform`. This is configured in `infrastructure/ansible/global_vars.yml`.

## `custom-data-analysis-platform-template`

The main directory of your own Data Analysis Platform repository.

You can extend and modify this directory to your heart's content. The [custom-data-analysis-platform-template](https://github.com/mdernovoi/custom-data-analysis-platform-template) repository only acts as an example of how to integrate the reference [data-analysis-platform](https://github.com/mdernovoi/data-analysis-platform) repository into your own setup.

This is accomplished through git submodules and Makefile imports (reference the `Extension of the data-analysis-platform` section of the `Makefile` in the `custom-data-analysis-platform-template` repository). 

**Usually you would copy all template files from the `data-analysis-platform` into corresponding subdirectories of this folder** (this is done during the [default installation procedure](provision.md)).
 
**NOTE**: Files in this directory are not touched by upgrades (except for the original `data-analysis-platform`).

## `docs`

Directory for your custom documentation.

## `infrastructure`

Directory for your custorm infrastructure code.

**NOTE**: This directory is required for the default installation procedure outlined in [the provisioning guide](provision.md).

## `src`

Directory for your custom application source code.

**NOTE**: This directory is required for the default installation procedure outlined in [the provisioning guide](provision.md).

## `Makefile`

Your custom Makefile that implements platform management features.

The goal is to provide the reference `data-analysis-platform` functionality inside your custom repository. This is accomplished by overwriting the `DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH` and `DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH` variables of the Makefile of the `data-analysis-platform` repository.

## `data-analysis-platform`

The reference Data Analysis Platform implementation repository.

Your own configuration files should be stored directly in the `custom-data-analysis-platform-template` directory, which is entirely under your control.

> :warning: **NOTE**: This directory will be overwritten during version upgrades and thus should be used only as a reference.

### `docs`

Documentation of the reference `data-analysis-platform`. Please start with the `index.md` file.

### `infrastructure`

Infrastructure definition templates of the Data Analysis Platform. You can copy them into your own `custom-data-analysis-platform-template/infrastructure` directory. There they can be modified and [customized](customization.md) and will survive upgrades.

**NOTE**: Only modify configurations and secrets in this directory. They are "managed" by ansible and will be overwritten during the next `ansible-playbook` (reference the [provisioning](provision.md) and [upgrade](upgrade.md) guides) command execution. 

- `secrets`

    Secrets (passwords, connection strings, etc.) that are used in different services. 
    
    They are mounted into docker containers in the docker compose files (`infrastructure/ansible/role_*-host/templates/*-compose.yml.j2`).

    Usually, a specialized vault is used for secret management, but dynamically mounted files are sufficient for simplicity.

    The file and value names are self-explanatory. Reference the [architecture diagram](architecture.md) to understand what services are used by the Data Analysis Platform.

    You can also visit the [credentials and services overview](credentials_services.md) for the default credentials of each service.


    - `fullchain.pem`: TLS certificates (reference the [tls guide](tls.md))
    - `privkey.pem`: TLS private key (reference the [tls guide](tls.md))
    - `dhparam.pem`: TLS DH parameters (reference the [tls guide](tls.md))

- `config`

    Configuration files of different services.

    They are mounted into docker containers in the docker compose files (`infrastructure/ansible/role_*-host/templates/*-compose.yml.j2`).

    They are dynamically created from templates (`infrastructure/ansible/role_*-host/templates`) in the ansible tasks (`infrastructure/ansible/role_*-host`).

- `ansible`

    Ansible tasks that configure the hosts, copy files to locations where they are expected by docker containers, and generate configuration files from templates.

    Configuration files and other templates should be modified here to get updated during the next `ansible-playbook` (reference the [provisioning](provision.md) and [upgrade](upgrade.md) guides) command execution.

    - `global_vars.yml`: global ansible configuration variables.

        Among other things, locations of persistent docker directories are configured here. The default path is `/var/opt/data_analysis_platform`.

    - `hosts`: a list of hosts ansible uses for provisioning (defaults to run on localhost).
    
    - `provision_service-host.yml`: main playbook to provision a `service-host`.
    
    - `provision_service-host.yml`: main playbook to provision a  `runner-host`.


### `src`

- `environments`

    Templates for your [custom Docker environments](environments.md).

- `gitlab_ci_pipeline_example`

    An example of how to use GitLab pipelines with MLflow and [custom docker environments](environments.md).

### `Makefile`

The Makefile of the reference `data-analysis-platform`. It simplifies provisioning, upgrades, and overall management of the platform.

**NOTE**: This file is imported by the Makefile of the `custom-data-analysis-platform-template` repository to provide functionality of the reference `data-analysis-platform` outside of its repository. This is accomplished by overwriting the `DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH` and `DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH` variables.





