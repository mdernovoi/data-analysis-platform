
# Initial System Provisioning

> :warning: Installing the Data Analysis Platform on a dedicated Host (physical or virtual) is recommended. Several changes to system settings are made during provisioning. Alternatively, you can review the `Makefile` and Ansible tasks in `infrastructure/ansible` to verify compatibility with your current setup.
>
> A non-exhaustive list of system changes:
> - Installation of Ansible
> - Installation of Docker
> - Configuration of Docker logging (journald)
> - Configuration of journald
> - Static DNS entries in `/etc/hosts`

> :warning: **NOTE**: reference the [architecture description](architecture.md) and the [files and directories overview](files_and_directories.md) to understand how the Data Analysis Platform is structured and how it works. **This is required to understand the provisioning process.**

This guide describes a **standard installation** on a **local machine (no remote ansible)**. To learn how to customize your setup, please refer to [the customization guide](customization.md).

## Prepare the deployment

1) Install the `build-essential` package.

    ```Shell
    sudo apt install build-essential
    ``` 

2) Clone the `custom-data-analysis-platform-template` repository.

    ```Shell
    git clone --recursive https://github.com/mdernovoi/custom-data-analysis-platform-template.git
    ```

    ```Shell
    cd custom-data-analysis-platform-template
    ```
3) Install prerequisites.

    Install all required prerequisites:

    ```Shell
    make install-all-prerequisites
    ```

    Add newly installed ansible to PATH:

    ```Shell
    echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc ;\
    source ~/.bashrc
    ```

    **TIP**: To review all prerequisites review the `install-all-prerequisites` target in the `Makefile`.

    **Alternatively**:
    
    - Install only system packages:
      ```Shell
      make install-system-prerequisites
      ``` 
    - Install only ansible:

      Another way to install ansible is by following the [official guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).

      ```Shell
      make install-ansible-prerequisites
      ```

      Add newly installed ansible to PATH:

      ```Shell
      echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc ;\
      source ~/.bashrc
      ```


4) Checkout the latest stable version of the data-analysis-platform repository (the latest release).

    ```Shell
    make checkout-latest-data-analysis-platform-src-release
    ```

5) Copy src templates to runtime directories.

    Please reference the [architecture guide](architecture.md) and the [the customization guide](customization.md) to understand what happens in this step.

    ```Shell
    make copy-files-for-default-installation-from-src-to-runtime
    ```

6) Replace all configuration placeholders.

    In this step, all runtime files are searched for the `{{TODO:REPLACE}}` placeholder, and all occurrences are printed to the console.

    Carefully review the command output and replace all placeholder occurrences with reasonable values. For a description of the purpose of individual files, please reference the [architecture guide](architecture.md).

    > :warning: **NOTE**: The default installation of the Data Analysis Platform is not secured by TLS. Thus, placeholders in the `fullchain.pem`, `dhparam.pem`, and `privkey.pem` files do not have to be replaced with actual values. 
    >
    >To learn how to enable TLS, reference the [tls guide](tls.md).

    ```Shell
    make find-todo-replace-placeholders-in-runtime-files
    ```
    
## Deploy the platform

> **NOTE**: The `service-host` and `runner-host` subsystems can be deployed on the same host. However, an installation on different machines is recommended to preserve the functionality of `service-host` services in case the `runner-host` crashes due to computation errors (e.g., out-of-memory error).

### Service host

1) Provision the system with ansible.

    ```Shell
    cd infrastructure/ansible ;\
    ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
    ```

    > **NOTE**: Ignore the "Provision minio" task failure. This is by design since the Minio service still needs to be deployed and thus can not be provisioned.

2) Reboot to apply group assignment changes and load environment variables (a re-login does not suffice).

3) Replace the `{{ paths.provision }}` placeholder with the value specified in `infrastructure/ansible/global_vars.yml` and execute:

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile first-stage \
      up
    ```

4) (If applicable) Open the Portainer UI in the browser at `http(s)://portainer-service.(mydomain.com)` and:

    - Set the initial root account password.
    - Save this password somewhere (e.g., in `infrastructure/secrets/portainer_credentials.txt`).

    > :warning: If you are too slow, you might encounter a timeout, and Portainer will refuse to set the initial password, prompting a login. If this happens, delete all files under `{{ path_base }}` from the `infrastructure/ansible/global_vars.yml` file and restart with step 1.

5) Open the Minio UI in the browser at `http(s)://minio.(mydomain.com)` and:

    - Log in with the credentials from `infrastructure/secrets/minio_MINIO_SECRETS.env`.
    - Create a new user with a `readwrite` policy for MLflow.
    - Create an access/secret key pair for this user (`Service Accounts` tab in user settings).
    - Save the keys in the `infrastructure/secrets/mlflow_MINIO_KEYS.env` file.

6) In a new terminal in the `infrastructure/ansible` directory, execute:

    ```Shell
    ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
    ```

    This will provision the S3 storage for MLflow. Verify in the Minio web UI that a `mlflow` bucket has been created.

    Now all tasks should execute successfully.

7) Stop Docker Compose by pressing `Ctrl+C` in the terminal where it was started.

8) Start all docker containers:

    > :warning: Note the difference in the `--profile` option.

    Execute: 

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
      up
    ```

    **TIP**: Add the `--detach` option to the command above to start containers in the background.

9) Now wait for GitLab to initialize (this might take several minutes) and continue with the provisioning of runner services (it can be done on the same machine).

    **TIP**: The initial GitLab user is `root`, and the password is stored in `infrastructure/secrets/gitlab_initial_root_password.txt`.

    **TIP**: Check out all provisioned services:

    - `portainer-service.{{ project_domain_name }}`
    - `pgadmin.{{ project_domain_name }}`
    - `mlflow.{{ project_domain_name }}`
    - `minio.{{ project_domain_name }}`
    - `gitlab.{{ project_domain_name }}`

### Runner host

> :warning: Due to port binding conflicts on a single-host deployment, the reverse proxy for runner services listens on port `4430` (or `8080` without TLS) instead of the usual `443` (`80`). This is configured in `infrastructure/ansible/role_runner-host/templates/runner-compose.yaml.j2` and can be changed.

1) Provision the service host first (reference the [service-host provisioning guide](#service-host)).

2) Provision the system with ansible.

    ```Shell
    cd infrastructure/ansible ;\
    ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
    ```

3) Reboot to apply group assignment changes and load environment variables (a re-login does not suffice).

4) Replace the `{{ paths.provision }}` placeholder with the value specified in `infrastructure/ansible/global_vars.yml` and execute:

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
      up
    ```

    **TIP**: Add the `--detach` option to the command above to start the containers in the background.

5) (If applicable) Open the Portainer UI in the browser at `http(s)://portainer-runner.(mydomain.com):(4430/8080)` and:

    - Set the initial root account password.
    - Save this password somewhere (e.g., in `infrastructure/secrets/portainer_credentials.txt`).

    > :warning: If you are too slow, you might encounter a timeout, and Portainer will refuse to set the initial password, prompting a login. If this happens, delete all files under `{{ path_base }}` from the `infrastructure/ansible/global_vars.yml` file and restart with step 1.

6) Register a new GitLab Runner:

    - Open the GitLab UI under `http(s)://gitlab.mydomain.com` --> Admin --> CI/CD  --> Runners --> Register an instance runner and copy the `Registration token`.
    - Replace the `{{ ... }}` placeholders in the command below with values from `infrastructure/ansible/global_vars.yml`.
    - Set the previously copied `--registration-token` value in the command below.
    - Execute in a new shell:

      ```Shell
      docker run \
      --rm -it \
      -v {{ paths.data }}/{{ host_prefix }}_gitlab-runner-generic-1/etc.gitlab-runner:/etc/gitlab-runner \
      --add-host "gitlab.{{ project_domain_name }}:{{ service_host_ip }}" \
      gitlab/gitlab-runner:ubuntu-v15.11.0 \
      register \
      --template-config /etc/gitlab-runner/config_templates/gitlab-runner-generic.config.toml \
      --non-interactive \
      --name="gitlab-runner-generic-1" \
      --registration-token="__REDACTED__" \
      --run-untagged="true" \
      --locked="false" \
      --access-level="not_protected"
      ```
    
    - Set the `concurrent` value in the runner configuration file to greater than one to allow concurrent job execution. The configuration file is located in `{{ paths.data }}/{{ host_prefix }}_gitlab-runner-generic-1/etc.gitlab-runner/config.toml`.
    - You should see a registered runner in the GitLab UI, and the runner docker container should stop printing error messages.

7) Now, you are ready to use the Data Analysis Platform.

    **TIP**: Check out all provisioned services:

    - `portainer-runner.{{ project_domain_name }}`

8) Check out the [documentation](index.md) for further steps.


