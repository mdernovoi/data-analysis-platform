

# Gitlab Pipeline Example

## Architecture

**NOTE**: Reference [`data-analysis-platform/docs/environments.md`](../../docs/environments.md) and [`data-analysis-platform/src/environments/README.md`](../environments/README.md) to understand the workflow with custom docker environments.

This repository contains instructions on using your custom docker development environments (from [`data-analysis-platform/src/environments`](../environments/)) in reproducible GitLab data analysis pipelines. 

The main idea of this example is that doing everything in Jupyter Notebooks is not reproducible and bad for future deployments to production. 

Therefore, it is recommended to use notebooks only for quick experiments. However, once your code in notebooks reaches a somewhat ready state, it should be packaged into Python packages and executed in plain scripts.

These scripts are executed in your custom docker environments by the GitLab Runner. They can modify data from your data storage, log experiment results to MLflow, and create [simple reports](https://cml.dev/) as pipeline run artifacts.

Since GitLab pipelines are very flexible, you can do whatever you want in them and always be sure that you are getting **reproducible and accurate** results.

## QuickStart

1) Install prerequisites.

    ```Shell
    sudo apt install \
    build-essential \
    git \
    grep
    ``` 

3) Create a new `my-pipeline` GitLab project.

    - Projects --> New project

    - Project name: `my-pipeline`

    - No README initialization

4) Clone the `my-pipeline` repository to a location of your choice.

    ```Shell
    git clone ssh://git@gitlab.REPLACE:2222/REPLACE/my-pipeline.git
    ```

5) Copy the contents of the `data-analysis-platform/src/gitlab_ci_pipeline_example` folder into your new local repository directory.

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

9) Create CI/CD pipeline secrets.

    - In the `my-pipeline` project, go to Project Settings --> CI/CD --> Secure Files.

    - For each file in the `secrets` directory:

        Upload it to GitLab as a `Secure File`. 

10)  **NOTE**: If you are not using TLS, adding the GitLab registry to `insecure-registries` in the `/etc/docker/daemon.json` configuration file of the host where the GitLab runner is executing your code is necessary. Remember to restart docker after configuration changes!

    ```json
    {
    "insecure-registries" : ["http://gitlab-registry.mydomain.com:5005"]
    }
    ```

    **NOTE**: Using insecure HTTP connections in a production environment is not recommended.

11) Push the repository to GitLab and wait for all pipelines to execute.

    ```Shell
    git add .
    git commit -m "Initial commit"
    git push
    ```
13) Observe how the pipeline executes and a new experiment run is logged in MLflow.

    Visit the [MLflow documentation page](https://mlflow.org/docs/latest/tutorials-and-examples/index.html) to learn more about experiments and tracking.


## Files and Directories

### `scripts`

Your scripts that are executed in pipelines.

### `secrets`

Secrets (passwords, keys, etc.) used during the execution of your scripts.

Usually, a specialized vault is used for secret management, but dynamically mounted files are sufficient for simplicity.

### `.gitlab-ci.yml`

GitLab pipeline definition.

### `requirements.txt`

Python packages that are required to execute your code.

**NOTE**: It is recommended to use pre-defined docker development environments (see `data-analysis-platform/src/environments`) and not to install all packages for every run.

### `Makefile`

A Makefile that simplifies some tedious operations (see the [quick start](#quickstart)).

## Credentials and Services

**Services**

none

**Credentials**

- `mlflow_MINIO_KEYS.env`: credentials to access the minio object storage.

- `mlflow_BASIC_AUTHENTICATION.env`: credentials for HTTP Basic Authentication of the MLflow instance.




