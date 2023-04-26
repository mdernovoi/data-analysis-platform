
## HOWTO use

1) Replace all `{{TODO:REPLACE}}` in this folder with appropriate values.

> :warning: Pay attention to comments before and after the `{{TODO:REPLACE}}` placeholders for further details.

### Generate SSH keys

```
ssh-keygen -f ssh_host_rsa_key -N '' -t rsa -b 4096
ssh-keygen -f ssh_host_ecdsa_key -N '' -t ecdsa -b 521
ssh-keygen -f ssh_host_ed25519_key -N '' -t ed25519 -b 521
```

