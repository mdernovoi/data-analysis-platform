

# Services and default credentials

Reference the [architecture overview](architecture.md) for an overview of what services the Data Analysis Platform consists of.

Reference [files and directories](files_and_directories.md) to understand the files referenced here.

## custom development environment

**Services**

- SSH: `:22`
- Jupyter Notebook: `:8888`

**Credentials**

- SSH

    authorized keys: `authorized_keys` in `src/environments/secrets` 
    host identity: `ssh_host_rsa_key` and `ssh_host_rsa_key.pub` in `src/environments/secrets` 

    **NOTE**: Setting the same host identity for all development containers is required. Otherwise, you must manually remove the previous identity from your local `known_hosts` file during each connection to the same IP.

- Jupyter Notebook:

    user: none
    password: from `src/environments/secrets/jupyter_notebook_password.txt`

    **NOTE**: This password has to be manually hashed and set in the `src/environments/dev-python-r/jupyter_notebook_config.py` file at `c.NotebookApp.password`. **Comments in the config file describe how to generate a hashed password**.

## service-host

### gitlab

**Services**

- GitLab: `http(s)://gitlab.mydomain.com`
- SSH for repository push / pull: `gitlab.mydomain.com:2222`
- Docker container registry: `http(s)://gitlab-registry.mydomain.com:5005`

**Credentials**

user: `root`

password: `infrastructure/secrets/gitlab_initial_root_password.txt`

### mlflow

**Services**

- MLflow: `http(s)://mlflow.mydomain.com`

**Credentials**

The nginx-proxy of the service-host performs HTTP Basic Authentication. Configuration in the MLflow section of `infrastructure/config/nginx-proxy/nginx-service.conf`.

- [How to create a new user-password pair](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-http-basic-authentication/) (or consult the `mlflow_nginx-proxy_htpasswd` file).

- [How to specify Basic Authentication credentials when logging to the tracking server](https://www.mlflow.org/docs/latest/tracking.html#logging-to-a-tracking-server) (MLFLOW_TRACKING_USERNAME and MLFLOW_TRACKING_PASSWORD environment variables).

user: in `infrastructure/secrets/mlflow_nginx-proxy_htpasswd`

password (hashed): in `infrastructure/secrets/mlflow_nginx-proxy_htpasswd`

### minio

**Services**

- Minio API eindpoint: `http(s)://minio.mydomain.com`
- Minio web GUI (browser redirects here from `http(s)://minio.mydomain.com`): `http(s)://minio-console.mydomain.com`

**Credentials**

user: `MINIO_ROOT_USER` in `infrastructure/secrets/minio_MINIO_SECRETS.env`

password: `MINIO_ROOT_PASSWORD` in `infrastructure/secrets/minio_MINIO_SECRETS.env`

### postgres-service

**Services**

- External access: `postgres-service.mydomain.com:54321`
- Internal access: `postgres-service.mydomain.com:5432`

**Credentials**

user: `postgres`

password: `POSTGRES_PASSWORD` in `infrastructure/secrets/postgres-service_POSTGRES_PASSWORD.env`

### postgres-data

**Services**

- External access: `postgres-data.mydomain.com:54322`
- Internal access: `postgres-data.mydomain.com:5432`

**Credentials**

user: `postgres`

password: `POSTGRES_PASSWORD` in `infrastructure/secrets/postgres-data_POSTGRES_PASSWORD.env`

### pgadmin

**Services**

- PgAdmin: `http(s)://pgadmin.mydomain.com`

**Credentials**

user: `PGADMIN_DEFAULT_EMAIL` in `infrastructure/ansible/role_service-host/templates/service-compose.yaml.j2`

password: `PGADMIN_DEFAULT_PASSWORD` in `infrastructure/secrets/pgadmin_PGADMIN_DEFAULT_PASSWORD.env`


### portainer

**Services**

- Portainer: `http(s)://portainer-service.mydomain.com`

**Credentials**

user: `user` in `infrastructure/secrets/portainer_credentials.txt`

password: `password` in `infrastructure/secrets/portainer_credentials.txt`

**NOTE**: Portainer credentials are defined during the [installation process](provision.md). The container only allows setting the initial credentials for a limited time after the first start.

### nginx-proxy

**Services**

none

**Credentials**

none

## runner-host (1..n)

### gitlab-runner (1..n)

The [installation guide](provision.md) describes how to create GitLab runners.

**Services**

none

**Credentials**

none

### portainer

**Services**

- Portainer: `http(s)://portainer-service.mydomain.com`

**Credentials**

user: `user` in `infrastructure/secrets/portainer_credentials.txt`

password: `password` in `infrastructure/secrets/portainer_credentials.txt`

**NOTE**: Portainer credentials are defined during the [installation process](provision.md). The container only allows setting the initial credentials for a limited time after the first start.

### nginx-proxy

**Services**

none

**Credentials**

none





