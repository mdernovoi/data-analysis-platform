

# Custom Docker Environments

## Architecture

**NOTE**: Reference [`data-analysis-platform/docs/environments.md`](../../docs/environments.md) to understand the workflow with custom docker environments.

This repository contains instructions on how to build custom docker development environments (images) for remote development with IDEs. 

To optimize the build process, all environments extend each other. For example, the `dev-python-r` environment is based on the `dev-base` image.

**Environments**:

- `dev-base`: the **base for all other environments**. 

    It exposes an SSH server for IDEs to connect to (port `22`).

- `dev-python-r`: a base environment with R and Python. 

    Depends on: `dev-base`

    It exposes a Jupyter Notebook server for IDEs to connect to (port `8888`).

    Some Python (`requirements.txt`) and R (`r_packages.json`) packages are installed globally. 

- `your-environment-name-here`: your project-specific custom environment.

    Depends on: `dev-python-r`

## QuickStart

1) Install prerequisites.

    ```Shell
    sudo apt install \
    build-essential \
    git \
    grep
    ``` 

2) Create a `dev` group with internal visibility in your Gitlab installation of the Data Analysis Platform.

    Groups --> New group

3) Create a new `environments` GitLab project with internal visibility in the `dev` group.

    - Projects --> New project

    - Project name: `environments`

    - Pick a group or namespace: `dev`

    - Visibility: `internal`

    - No README initialization

4) Clone the `environments` repository to a location of your choice.

    ```Shell
    git clone ssh://git@gitlab.REPLACE:2222/dev/environments.git
    ```

5) Copy the contents of the `data-analysis-platform/src/environments` folder into your new local repository directory.

6) Change into the new repository directory.

7) Update `.gitignore` to ignore the `secrets` directory.

    ```Shell
    # file: .gitignore

    # Ignore everything in secrets/ except for the .gitkeep file.
    secrets/*
    !secrets/.gitkeep
    ```

8) Replace all configuration placeholders.

    In this step, all files are searched for the `{{TODO:REPLACE}}` placeholder, and all occurrences are printed to the console.

    Carefully review the command output and replace all placeholder occurrences with reasonable values. For a description of the purpose of individual files, please reference the [files and directories](#files-and-directories) and [credentials and services](#credentials-and-services) guides.

    **NOTE**: Pay attention to comments before and after the `{{TODO:REPLACE}}` placeholders for further details.

    ```Shell
    make find-todo-replace-placeholders
    ```

9) Create CI/CD pipeline secrets variables.

    - In the `environments` project, go to Project Settings --> CI/CD --> Variables.

    - For each file in the `secrets` directory:

        - Create a new variable with the following settings:
        
            - type `file`
            - `key`: filename of the secret
            - `value`: the content of the secret
            - Remove the `Protect variable` flag
            - If possible: enable the `Mask variable` flag
        
            **NOTE**: Some filenames contain forbidden characters such as dots, etc (GitLab will warn you). Replace all illegal characters with underscores and reference variable names in the `.gitlab-ci.yml` file for specific values to ensure compatibility.


    **NOTE: The Secret Files feature of GitLab pipelines is usually used since it is more secure and flexible. However, the kaniko executor image does not allow to use this feature.

10) If you are **not using TLS** to secure your Data Analysis Platform installation **(the default)** your have to modify the `.gitlab-ci-yml`:

    - Add the `--insecure` flag to the `/kaniko/executor` script call for all jobs (for HTTP push).

    - Add the `--insecure-pull` flag to the `/kaniko/executor` script call for all jobs (for HTTP pull).

    ```Yml
    # for example: 

    # build Docker image
    - /kaniko/executor
        --insecure
        --insecure-pull
        --context "${WORKING_DIR}"
        --dockerfile "${WORKING_DIR}/Dockerfile"
        --destination "${CI_REGISTRY_IMAGE}/$IMAGE_NAME:${CI_COMMIT_TAG}"
    ```

    **NOTE**: it is not recommended to use insecure HTTP connections in a production environment.

    Reference [Google's documentation](https://github.com/GoogleContainerTools/kaniko).

11) Push the repository to GitLab and wait for all pipelines to execute.

    ```Shell
    git add .
    git commit -m "Initial commit"
    git push
    ```
12) Start a docker container from a development environment image and connect your IDE to it:

    **TIP**: You can use the Portainer of your Data Analysis Platform installation for easier container management. To access images from your local GitLab installation, you have to [configure a new container registry](https://docs.portainer.io/admin/registries/add/gitlab) (`http(s)://gitlab-registry.mydomain.com:5005`) in Portainer and `Override default configuration` in the settings section.

    **NOTE**: If you are not using TLS, adding the GitLab registry to `insecure-registries` in the `/etc/docker/daemon.json` configuration file might be necessary. Remember to restart docker after configuration changes!

    ```json
    {
    "insecure-registries" : ["http://gitlab-registry.mydomain.com:5005"]
    }
    ```

    General SSH connection (Python, R, console, file transfer):

    - [Remote SSH connection with DataSpell (recommended)](https://blog.jetbrains.com/dataspell/2022/12/2022-3/)

    - [Remote SSH connection with VSCode](https://code.visualstudio.com/docs/remote/ssh)

    Jupyter Notebook connection (Jupyter Notebooks):

    - [Jupyter Notebook connection with DataSpell (recommended)](https://www.jetbrains.com/help/dataspell/configuring-jupyter-notebook.html#remote)
    
    - [Jupyter Notebook connection with VSCode](https://code.visualstudio.com/docs/datascience/jupyter-notebooks#_connect-to-a-remote-jupyter-server)

## Files and Directories

### `build_scripts`

Helper scripts for the build process.

### `dev-base`

Dockerfile and files required to build the `dev-base` image.

### `dev-python-r`

Dockerfile and files required to build the `dev-python-r` image.

This image is based on `dev-base`.

### `scripts`

Scripts used during the build process of custom development environment docker images.

### `secrets`

Secrets (passwords, keys, etc.) used during the build process of custom development environment docker images.

Usually, a specialized vault is used for secret management, but dynamically mounted files are sufficient for simplicity.

### `.gitlab-ci.yml`

GitLab pipeline definition.

### `build-docker-image-local.sh`

Script to build custom development environment docker images locally. 

**NOTE: It may require some tinkering to get everything right since this repository is primarily intended for builds in CI/CD pipelines.

### `Makefile`

A Makefile that simplifies some tedious operations (see the [quick start](#quickstart)).

## Credentials and Services

**Services**

- SSH: `ip-addr-of-docker-host:22`
- Jupyter Notebook: `ip-addr-of-docker-host:8888`

**Credentials**

- SSH

    - authorized keys: `authorized_keys` in `secrets`. 
    
        The identity of your development host that will connect to the container. Usually `~/.ssh/id_rsa.pub`

    - host identity: `ssh_host_rsa_key` and `ssh_host_rsa_key.pub` in `secrets`.

        SSH identity of development containers. Can be generated with:

        ```Shell
        ssh-keygen -f ssh_host_rsa_key -N '' -t rsa -b 4096
        ```

        **NOTE**: Setting the same host identity for all development containers is required. Otherwise, you must manually remove the previous container identity from your local `known_hosts` file during each connection to a new container with the same IP.

- Jupyter Notebook:

    - user: none

    - password: from `secrets/jupyter_notebook_password.txt`

        **NOTE**: This password has to be manually hashed and set in the `dev-python-r/jupyter_notebook_config.py` file at `c.NotebookApp.password`. **Comments in the config file describe how to generate a hashed password**.

## Customization

To create your own development environments:

- Create a new subdirectory.
- Create a Dockerfile that extends one of the existing docker images and installs your specific software.
- Extend the `.gitlab-ci.yml` to build your environment.

    **TIP**: By configuring `stages` in the `.gitlab-ci.yml`, you can enable parallel builds for environments that do not depend on each other.

## Internal developer notes

### Generate SSH keys for GitLab

```Shell
ssh-keygen -t rsa -b 4096
```



