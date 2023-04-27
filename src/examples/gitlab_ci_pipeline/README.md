
TODO :construction: **Currently under construction** :construction:

## HOWTO use

1) Replace all `{{TODO:REPLACE}}` in this folder with appropriate values.

> :warning: Pay attention to comments before and after the `{{TODO:REPLACE}}` placeholders for further details.

2) (Optional) Create a`dev` group with internal visibility in Gitlab.

3) Initialize a new git repository in this directory.

4) Create a GitLab project (e.g. `gitlab-test` with private visibility).

5) Upload files from the `secrets` directory to Settings --> CI/CD --> Secure Files of the GitLab project.

6) Push files to GitLab and let GitLab build all Docker environments.
