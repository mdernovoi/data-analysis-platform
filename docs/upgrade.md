
# Upgrade to a new version of the Data Analysis Platform

As outlined in [the customization guide](customization.md), only files of the reference implementation of the `data-analysis-platform` are modified during upgrades.

If you want the new changes to be applied to your setup, you must review them and modify your files manually. 

Automatically upgrading your configuration is not possible since you could have modified your copy of the reference implementation files, and a forced upgrade would overwrite your custom adjustments.

To upgrade to the latest `data-analysis-platform` release, execute the following steps:

1) Go to the root of your own `custom-data-analysis-platform-template` repository directory.

2) Execute 

    ```Shell
    make upgrade-data-analysis-platform-templates-repository-to-latest-release
    ```

3) Carefully review the output of the previous command. It lists all changes between your and the latest version of the template files.

    Choose which changes you want to apply to your own configuration (e.g., service version upgrades) and modify the corresponding files in the `custom-data-analysis-platform-template` directory.

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


