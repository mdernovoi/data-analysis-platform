
TODO :construction: **Currently under construction** :construction:

## HOWTO use

1) Replace all `{{TODO:REPLACE}}` in this folder with appropriate values.

> :warning: Pay attention to comments before and after the `{{TODO:REPLACE}}` placeholders for further details.

2) (Optional) Create a`dev` group with internal visibility in Gitlab.

3) Initialize a new git repository in this directory.

4) Create a GitLab project (e.g., `environments` with internal visibility).

5) Create pipeline variables from the `secrets` directory in Settings --> CI/CD --> Variables of the GitLab project. 

    **Reason**: the kaniko executor image does not allow to use the Secret Files feature of Gitlab CI/CD pipelines.

    - Create variables of type `file` with names of files in the `secrets` directory as keys and the content of these files as values. **NOTE**: Some file names contain forbidden characters such as dots, etc. Replace all illegal characters with underscores and consult variable names in the `.gitlab-ci.yml` file for specific values to ensure compatibility.
    - Remove the `Protect variable` flag.
    - Try to apply the `Mask variable` flag (not always possible).

6) Push files to GitLab and let GitLab build all Docker environments.

### Generate SSH keys

```
ssh-keygen -f ssh_host_rsa_key -N '' -t rsa -b 4096
ssh-keygen -f ssh_host_ecdsa_key -N '' -t ecdsa -b 521
ssh-keygen -f ssh_host_ed25519_key -N '' -t ed25519 -b 521
```

