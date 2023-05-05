
.DEFAULT_GOAL := install_service

INFRASTRUCTURE_DIR := infrastructure
INFRASTRUCTURE_CONFIG_DIR := ${INFRASTRUCTURE_DIR}/config
INFRASTRUCTURE_ANSIBLE_DIR := ${INFRASTRUCTURE_DIR}/ansible

SERVICE_HOST_GITLAB_CONFIG_DIR := ${INFRASTRUCTURE_CONFIG_DIR}/gitlab
SERVICE_HOST_NGINX_CONFIG_DIR := ${INFRASTRUCTURE_CONFIG_DIR}/nginx-proxy
SERVICE_HOST_DOCKER_COMPOSE_CONFIG_DIR := ${INFRASTRUCTURE_CONFIG_DIR}/docker-compose

SERVICE_HOST_ANSIBLE_DIR := ${INFRASTRUCTURE_ANSIBLE_DIR}/role_service-host
SERVICE_HOST_ANSIBLE_TEMPLATES_DIR := ${SERVICE_HOST_ANSIBLE_DIR}/templates

RUNNER_HOST_GITLAB_RUNNER_CONFIG_DIR := ${INFRASTRUCTURE_CONFIG_DIR}/gitlab-runner
RUNNER_HOST_NGINX_CONFIG_DIR := ${INFRASTRUCTURE_CONFIG_DIR}/nginx-proxy
RUNNER_HOST_DOCKER_COMPOSE_CONFIG_DIR := ${INFRASTRUCTURE_CONFIG_DIR}/docker-compose

RUNNER_HOST_ANSIBLE_DIR := ${INFRASTRUCTURE_ANSIBLE_DIR}/role_runner-host
RUNNER_HOST_ANSIBLE_TEMPLATES_DIR := ${RUNNER_HOST_ANSIBLE_DIR}/templates

install-service :
	@echo "Checking if custom configuration exists..."
	# TODO do
	@echo "Checking if all {{TODO:REPLACE}} placeholders have been replaced with actual values..."
	# TODO do
	@echo "Copying predefined configuration files to the ansible directory..."
	cp -r ${SERVICE_HOST_GITLAB_CONFIG_DIR}/*.j2 ${SERVICE_HOST_ANSIBLE_TEMPLATES_DIR}/
	cp -r ${SERVICE_HOST_NGINX_CONFIG_DIR}/*.j2 ${SERVICE_HOST_ANSIBLE_TEMPLATES_DIR}/
	cp -r ${SERVICE_HOST_DOCKER_COMPOSE_CONFIG_DIR}/*.j2 ${SERVICE_HOST_ANSIBLE_TEMPLATES_DIR}/
	cp ${INFRASTRUCTURE_CONFIG_DIR}/global_vars.yml ${INFRASTRUCTURE_ANSIBLE_DIR}/
	cp ${INFRASTRUCTURE_CONFIG_DIR}/hosts ${INFRASTRUCTURE_ANSIBLE_DIR}/
	@echo "Running ansible provisioning..."
	$(eval CURRENT_WDIR := $(pwd))
	cd ${INFRASTRUCTURE_ANSIBLE_DIR}
	#ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
	cd ${CURRENT_WDIR}

install-runner :
	@echo "Checking if custom configuration exists..."
	# TODO do
	@echo "Checking if all {{TODO:REPLACE}} placeholders have been replaced with actual values..."
	# TODO do
	@echo "Copying predefined configuration files to the ansible directory..."
	cp -r ${RUNNER_HOST_GITLAB_RUNNER_CONFIG_DIR}/*.j2 ${RUNNER_HOST_ANSIBLE_TEMPLATES_DIR}/
	cp -r ${RUNNER_HOST_NGINX_CONFIG_DIR}/*.j2 ${RUNNER_HOST_ANSIBLE_TEMPLATES_DIR}/
	cp -r ${RUNNER_HOST_DOCKER_COMPOSE_CONFIG_DIR}/*.j2 ${RUNNER_HOST_ANSIBLE_TEMPLATES_DIR}/

clean-service :
	@echo "Cleaning ansible templates..."
	find ${SERVICE_HOST_ANSIBLE_TEMPLATES_DIR}/ -type f ! -name 'README.md' -delete
	@echo "Cleaning ansible config files..."
	rm ${INFRASTRUCTURE_ANSIBLE_DIR}/global_vars.yml
	rm ${INFRASTRUCTURE_ANSIBLE_DIR}/hosts

clean-runner :
	@echo "Cleaning ansible templates..."
	find ${RUNNER_HOST_ANSIBLE_TEMPLATES_DIR}/ -type f ! -name 'README.md' -delete


# include user-defined makefiles from the custom_makefiles directory that contain `Makefile` in their name
# NOTE: user-defined makefiles are included at the end and thus can overwrite default targets!
# Execution example: `make install-service install-my-service` where install-my-service is defined in a custom makefile
include custom_makefiles/*Makefile*
