

2 VMs are a requirement if static dns is used

### Install Ansible

Follow the [official guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) or execute the commands below.

Execute as a non-root user!!!! Otherwise paths will be messed up.
```Shell
sudo apt-get install -y python3-pip && \
    python3 -m pip install --user ansible && \
    # Add Ansible to PATH 
    echo 'PATH="$PATH:~/.local/bin"' >> ~/.bashrc && \
    source ~/.bashrc
```

### Execute ansible playbook

 1) In the `project_source_dir/infrastructure/ansible` directory execute:

For a **Service** host:
```Shell
ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
```

For a **Runner** host:
```Shell
ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
```

2) Log out and log back in to apply group assignment changes and load environment variables.


### Start Docker

docker compose \
--project-name data-analysis-platform-service \
--file /var/opt/data_analysis_platform/provision/service-compose.yaml \
--profile all \
  up

docker compose \
--project-name data-analysis-platform-runner \
--file /var/opt/data_analysis_platform/provision/runner-compose.yaml \
--profile all \
  up
