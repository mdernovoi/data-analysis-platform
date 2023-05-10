
# Developer notes

## License

### Analyze licensing dependencies

```Shell
git clone https://github.com/nexB/scancode-toolkit
cd scancode-toolkit
docker build --tag scancode-toolkit --tag scancode-toolkit:$(git describe --tags) .
docker run -v $PWD/:/project scancode-toolkit -clipeu -n 6 --classify --json-pp /project/scan-result.json /project/data-analysis-platform
```

refs: 
- https://scancode-toolkit.readthedocs.io/en/stable/getting-started/install.html#installation-via-docker
- https://scancode-workbench.readthedocs.io/en/develop/getting-started/index.html#download-and-install


## Docker

### Useful commands

```Shell
# remove all containers
docker rm $(docker ps -aq)

docker compose logs container_name

# compose
docker-compose down
docker-compose run --rm
docker-compose rm -f
docker compose ls
docker compose up -d --remove-orphans

```

### Update services

1)  Pull latest images:

`docker compose pull`

2) Then restart containers:

`docker compose up -d --remove-orphans --file ...`

3) Optionally remove obsolete images:

`docker image prune`

## Postgres

### TLS connections

```
select * from pg_settings
where name like '%ssl%'

select pg_ssl.pid, pg_ssl.ssl, pg_ssl.version,
           pg_sa.backend_type, pg_sa.usename, pg_sa.client_addr, pg_sa.application_name
           from pg_stat_ssl pg_ssl
           join pg_stat_activity pg_sa
             on pg_ssl.pid = pg_sa.pid;
```

## Pycharm

### Remote dev file synchronization

- go to:  Settings/Preferences | Build, Execution, Deployment | Deployment | Options.
- Your deployment configuration is not marked as default so PyCharm can't use it for automatic synchronization (see the warning at the bottom). You can mark it as default in Preferences | Build, Execution, Deployment | Deployment using the Use as default button (checkmark button).
- files are only uploaded after a save operation (ctrl+s)
- ref: https://youtrack.jetbrains.com/issue/PY-46637

## GitLab

### SMTP

Send test email from github (test smtp settings).
Execute `Notify.test_email('destination_email@address.com', 'Message Subject', 'Message Body').deliver_now` in the GitLab container Ruby console.

### Build Docker images in CI pipeline

- [Why `services: docker:dind` is needed while already having `image: docker`?](https://forum.gitlab.com/t/why-services-docker-dind-is-needed-while-already-having-image-docker/43534)
- Do not use docker in docker. This is highly insecure!!! Ref. link below
- [Secure docker build in GitLab CI pipelines with Sysboxa and kaniko](https://blog.nestybox.com/2020/10/21/gitlab-dind.html)

### Resources

- [complex ci rules](https://docs.gitlab.com/ee/ci/jobs/job_control.html#complex-rules)
- [.gitlab-ci.yml reference](https://docs.gitlab.com/ee/ci/yaml/)

## Git

List remote branches:

```Shell
git branch -r
```

Checkout a remote branch as a local branch:

```Shell
git checkout -b local_branch_name origin/remote_branch_name
```

Delete branches

```Shell
// delete branch locally
git branch -d localBranchName

// delete branch remotely
git push origin --delete remoteBranchName
```

## Trademarks

### Postgres

[policy](https://www.postgresql.org/about/policies/trademarks/)

[logos](https://wiki.postgresql.org/wiki/Logo)

#### reason 

>  You may make fair use of Postgres or PostgreSQL to refer to the software in true factual statements. For example:
>
> - If it’s true, you can say in your software or documentation that certain software runs on, with, or is derived from PostgreSQL® software. 

#### attribution

`Postgres, PostgreSQL and the Slonik Logo are trademarks or registered trademarks of the PostgreSQL Community Association of Canada, and used with their permission.`

### Gitlab

[policy](https://about.gitlab.com/handbook/marketing/brand-and-product-marketing/brand/brand-activation/trademark-guidelines/)

[logos](https://about.gitlab.com/press/press-kit/)

#### reason 

WIP: Permission requested.

#### attribution

`GITLAB is a trademark of GitLab Inc. in the United States and other countries and regions.`


### MLflow

policy: Apache 2.0 license

[logos](https://github.com/mlflow/mlflow/tree/master/assets)

#### reason 

The Apache 2.0 license allows to use the trademark if `...required for reasonable and customary use in describing the origin of the Work...`

#### attribution

`MLflow is a trademark of LF Projects, LLC.`

### Nginx

policy: unknown

logos: unknown

#### reason 

Unknown

#### attribution

`NGINX is a trademark of F5, Inc.`

### Minio

[policy](https://min.io/logo)

[logos](https://min.io/logo)

#### reason 

`You can use MinIO trademarks to truthfully refer to and/or link to unmodified MinIO programs, products, services and technologies.`

#### attribution

`MINIO is a trademark of the MinIO Corporation.`

### Portainer

policy: none

logos: In permission granting email from 2023-05-12.

#### reason 

Granted permission per email on 2023-05-12 (main email account).

#### attribution

`Portainer is a trademark of Portainer.io.`


## Misc

- 
```Shell
groupadd dap
useradd -m -g dap -G sudo,vboxsf -s /bin/bash dap
passwd dap  # set password value to "dap"
```




