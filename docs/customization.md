
# Customize the Data Analysis Platform

Since the main motto of the Data Analysis Platform is to be technology agnostic, it is essential to be able to customize it to suit your local environment.

There are two components:

- The reference [data-analysis-platform](https://github.com/mdernovoi/data-analysis-platform)

- A [custom-data-analysis-platform-template](https://github.com/mdernovoi/custom-data-analysis-platform-template) which provides an example of how to integrate the reference `data-analysis-platform` into your own infrastructure.

The [files and directories](files_and_directories.md) guide describes all files and their intended use.

The `data-analysis-repository` is a git submodule of the `custom-data-analysis-platform-template` and provides a reference implementation.

The [standard installation procedure](provision.md) assumes that you closely follow the reference implementation and copies all files from the `data-analysis-platform` repository into corresponding directories of the `custom-data-analysis-platform-template`. 

Files in the `custom-data-analysis-platform-template` directory (except for the templates in the `data-analysis-platform` folder) can be arbitrarily modified and adapted to your needs.

You can: 

- remove or add ansible tasks
- modify the docker compose files
- use external services (e.g., Amazon S3 instead of Minio or full-fledged VMs instead of docker containers). 
- not use ansible or docker at all
- do whatever you want

During [upgrades](upgrade.md), only files in the reference `data-analysis-platform` directory are updated. As a result, your own infrastructure remains untouched.

**NOTE**: If you want to keep a simple upgrade path and do not require extensive modifications of the Data Analysis Platform, it is beneficial not to modify your copy of the reference files too much since, during every upgrade, you have to apply new changes to your own configuration manually.

## Perform configuration changes

**NOTE**: Files in the `custom-data-analysis-platform-template` directory (except for the templates in the `data-analysis-platform` folder) can be arbitrarily modified and adapted to your needs.

To modify your Data Analysis Platform setup:

1) Go to the root of your own `custom-data-analysis-platform-template` repository directory.

2) Perform all necessary adjustments.

4) Stop all services.

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
    stop
    ```

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
    stop
    ```

5) Regenerate all configuration files:

    ```Shell
    cd infrastructure/ansible

    ansible-playbook -i hosts --ask-become-pass provision_service-host.yml

    ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
    ```

    **NOTE**: Only change configurations through the regeneration of configuration files. Otherwise your custom changes might get overwritten during the execution of Ansible playbooks.

6) Start all services.

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
    up
    ```

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
    up
    ```

