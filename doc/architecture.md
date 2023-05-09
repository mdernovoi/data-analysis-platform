
:construction: **Currently under construction** :construction:

[**FULL-SIZE DIAGRAM**](res/architecture_overview.pdf)

![architecture overview](https://github.com/mdernovoi/data-analysis-platform-static-content/blob/main/res/architecture_overview.png)

- `infrastructure/secrets`

      - `fullchain.pem`: TLS certificates (reference the [tls guide](tls.md))
      - `privkey.pem`: TLS private key (reference the [tls guide](tls.md))
      - `dhparam.pem`: TLS DH parameters (reference the [tls guide](tls.md))

    - `infrastructure/config`

      - Currently nothing to replace
      
    - `infrastructure/ansible`

      - `global_vars.yml`: global ansible configuration variables.


