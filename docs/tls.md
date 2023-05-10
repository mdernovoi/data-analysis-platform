
# TLS

> :warning: Before applying any changes to the system, it is recommended to take a full backup of the machine in case something goes wrong.

The default installation of the Data Analysis Platform comes with TLS disabled. This is great for testing and local development since no certificate management is required. All services are available with `http://` URLs. 

However, a setup without TLS is not recommended for a production environment since all data are transferred unencrypted.

> :warning: Currently, only publicly signed certificates are supported (e.g., by LetsEncrypt) for a TLS deployment. Integrating self-signed certificates to all components is very challenging and currently not planned.

> **TIP**: You can get a free public TLS certificate by registering a domain for approximately 1$ per month (e.g., with [Hetzner](https://www.hetzner.com/domainregistration)) and then [request a free LetsEncrypt certificate with the DNS challenge](https://ongkhaiwei.medium.com/generate-lets-encrypt-certificate-with-dns-challenge-and-namecheap-e5999a040708). 

## TLS settings

To configure TLS several places are relevant:

- The `use_tls` variable in `infrastructure/ansible/global_vars.yml` controls whether TLS should be enabled or disabled.
- Certificate files in `infrastructure/secrets`:
    
    - `fullchain.pem`: your certificate with a complete certification chain as created by LetsEncrypt.
    - `privkey.pem`: the private key of your certificate.
    - `dhparam.pem`: Diffie-Hellman pre-generated parameters (e.g., with `openssl dhparam -out dhparam.pem 4096`)

## Enable TLS

1) Set the `use_tls` variable in `infrastructure/ansible/global_vars.yml` to `true`.

2) Replace the `{{TODO:REPLACE}}` placeholders in `fullchain.pem`, `privkey.pem`, and `dhparam.pem` with your values.

3) Stop all services.

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
    stop
    ```

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
    stop
    ```


4) Regenerate all configuration files:

    ```Shell
    cd infrastructure/ansible ;\

    ansible-playbook -i hosts --ask-become-pass provision_service-host.yml ;\

    ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
    ```

5) Start all services.

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
    up
    ```

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
    up
    ```
6) Re-register all runners. Reference the [runner provisioning section](provision.md#runner-host) of the provisioning guide.

## Disable TLS

> :warning: **NOTE**: If TLS was previously enabled, browsers will protect you and not allow you to access the new `http://` urls instead of the old `https://` ones. Clear the browser data (cookies, history, etc.) to be able to access services via `http`.

1) Set the `use_tls` variable in `infrastructure/ansible/global_vars.yml` to `false`.

3) Stop all services.

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
    stop
    ```

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
    stop
    ```


4) Regenerate all configuration files:

    ```Shell
    cd infrastructure/ansible 

    ansible-playbook -i hosts --ask-become-pass provision_service-host.yml 

    ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
    ```

5) Start all services.

    ```Shell
    docker compose \
    --project-name data-analysis-platform-service \
    --file {{ paths.provision }}/service-compose.yaml \
    --profile all \
    up
    ```

    ```Shell
    docker compose \
    --project-name data-analysis-platform-runner \
    --file {{ paths.provision }}/runner-compose.yaml \
    --profile all \
    up
    ```
6) Re-register all runners. Reference the [runner provisioning section](provision.md#runner-host) of the provisioning guide.


