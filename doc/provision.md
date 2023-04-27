

## Initial provisioning

> :warning: It is recommended to install the Data Analysis Platform on a dedicated Host (physical or virtual). Several changes to system settings are made during provisioning. Alternatively, you can review the Ansible tasks in `infrastructure/ansible` to verify compatibility with your current setup.
>
> A non-exhaustive list of system changes:
> - Installation of Docker
> - Configuration of Docker logging (journald)
> - Configuration of journald
> - Static DNS entries in `/etc/hosts`

### Install Ansible

Follow the [official guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) or execute the commands below.

> :warning: Execute as a non-root user! Otherwise, paths will be messed up.

```Shell
sudo apt-get install -y python3-pip && \
    python3 -m pip install --user ansible && \
    # Add Ansible to PATH 
    echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc && \
    source ~/.bashrc
```
### Configure services and secrets

TODO: :construction: **Currently under construction** :construction:

Search for `{{TODO:REPLACE}}` in the `infrastructure` directory and fill in all missing values. 

**Tip**: You can use Visual Studio Code or `egrep` to search for strings in multiple files simultaneously.

#### Services

TODO :construction: **Currently under construction** :construction:

#### Secrets

The `infrastructure/secrets_templates` contains templates for secrets the Data Analysis Platform requires.

> :warning: Currently, only publicly signed certificates are supported (e.g., signed by LetsEncrypt). Further versions will remove this limitation (reference the `Roadmap` section of the main `README.md`).

1) Copy all templates to the `infrastructure/secrets` directory, which Git ignores.

2) Replace all `{{TODO:REPLACE}}` placeholders in secrets with actual values.


### Deploy services

> **NOTE**: Both the *Service* and *Runner* services can be deployed on the same host.

#### Service host

1) In the `infrastructure/ansible` directory, execute:

```Shell
ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
```

> **NOTE**: Ignore the "Provision minio" task failure. This is by design.

2) Log out and log back in to apply group assignment changes and load environment variables.

3) Replace the `{{ paths.provision }}` placeholder with the value specified in `infrastructure/ansible/global_vars.yml` and execute:

```Shell
docker compose \
--project-name data-analysis-platform-service \
--file {{ paths.provision }}/service-compose.yaml \
--profile first-stage \
  up
```

4) Open the Minio UI in the browser at `https://minio.mydomain.com` and:

  - Create a new user for MLflow.
  - Create an access/secret key pair for this user.
  - Save the keys in the `infrastructure/secrets/mlflow_MINIO_KEYS.env` file.

5) (If applicable) Open the Portainer UI in the browser at `https://portainer-service.mydomain.com` and:

  - Set the initial root account password.
  - Save this password somewhere (e.g., in `infrastructure/secrets/portainer_credentials.txt`).

> :warning: If you are too slow, you might encounter a timeout, and Portainer will refuse to set the initial password, prompting a login. If this happens, delete all files under `{{ path_base }}` from the `infrastructure/ansible/global_vars.yml` file and restart with step 1.

6) In the `infrastructure/ansible` directory, execute:

```Shell
ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
```

This will provision the S3 storage for MLflow.

Now all tasks should execute successfully.

7) Stop Docker Compose by pressing `Ctrl + C` in the terminal where it was started.

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

**Tip**: Add the `--detach` option to the command above to start the containers in the background.

9) Now wait for GitLab to initialize (this might take several minutes) and continue with the provisioning of runner services (it can be done on the same machine).

**Tip**: The initial GitLab user is `root`, and the password is stored in `infrastructure/secrets/gitlab_initial_root_password.txt`.

#### Runner host

1) Provision the service host first.

2) In the `infrastructure/ansible` directory, execute:

```Shell
ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
```

2) Log out and log back in to apply group assignment changes and load environment variables.

3) Replace the `{{ paths.provision }}` placeholder with the value specified in `infrastructure/ansible/global_vars.yml` and execute:

```Shell
docker compose \
--project-name data-analysis-platform-runner \
--file {{ paths.provision }}/runner-compose.yaml \
--profile all \
  up
```

**Tip**: Add the `--detach` option to the command above to start the containers in the background.

4) (If applicable) Open the Portainer UI in the browser at `https://portainer-service.mydomain.com` and:

  - Set the initial root account password.
  - Save this password somewhere (e.g., in `infrastructure/secrets/portainer_credentials.txt`).

> :warning: If you are too slow, you might encounter a timeout, and Portainer will refuse to set the initial password, prompting a login. If this happens, delete all files under `{{ path_base }}` from the `infrastructure/ansible/global_vars.yml` file and restart with step 1.

5) Register a new GitLab Runner:

  - Open the GitLab UI under `https://gitlab.mydomain.com` --> Admin --> CI/CD  --> Runners --> Register an instance runner and copy the `Registration token`.
  - Replace the `{{ ... }}` placeholders in the command below with values from `infrastructure/ansible/global_vars.yml`.
  - Set the `--registration-token` value in the command below.
  - Execute:

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

6) Now, you are ready to use the Data Analysis Platform.

  Check out the [HowTo section](index.md) for further steps.

