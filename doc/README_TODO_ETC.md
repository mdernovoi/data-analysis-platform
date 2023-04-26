
## TODO

- use bigint for every index column (not int)
- replace psycopg-binary with psycopg compiled from source
	- in dev-python-r environment
	- in api project requirements.txt
- use sqlalchemy as a proper orm and not only to execute raw sql
- add proper settings section to DataSet class from the api and synchronize it with the settings table
- rename settings into metadata in db schema and api DataSet class
- rewrite get_dataset() to use less single queries
- replace all "id" columns with "somethingsomething_id" for better readability in db schema
- set server location in minio. this might fix the issue with gitlab-registry behind a reverse proxy
- put gitlab-registry behind a reverse proxy
- use multistage docker builds to save space
- secure dev-base container ssh config
- update security.md
- configure dependabot updates

## TOKNOW

### pycharm remote dev file synchronization

- go to:  Settings/Preferences | Build, Execution, Deployment | Deployment | Options.
- Your deployment configuration is not marked as default so PyCharm can't use it for automatic synchronization (see the warning at the bottom). You can mark it as default in Preferences | Build, Execution, Deployment | Deployment using the Use as default button (checkmark button).
- files are only uploaded after a save operation (ctrl+s)
- ref: https://youtrack.jetbrains.com/issue/PY-46637

### gitlab

- Send test email from github (test smtp settings): `Notify.test_email('destination_email@address.com', 'Message Subject', 'Message Body').deliver_now`

#### build docker images:

- [Why `services: docker:dind` is needed while already having `image: docker`?](https://forum.gitlab.com/t/why-services-docker-dind-is-needed-while-already-having-image-docker/43534)
- Do not use docker in docker. This is highly insecure!!! Ref. link below
- [Secure docker build in GitLab CI pipelines with Sysboxa and kaniko](https://blog.nestybox.com/2020/10/21/gitlab-dind.html)

## REFS

### gitlab

- [complex ci rules](https://docs.gitlab.com/ee/ci/jobs/job_control.html#complex-rules)
- [.gitlab-ci.yml reference](https://docs.gitlab.com/ee/ci/yaml/)

