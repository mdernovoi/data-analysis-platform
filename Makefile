
.DEFAULT_GOAL := install_service

INFRASTRUCTURE_DIR := infrastructure

INFRASTRUCTURE_CONFIG_DIR := ${INFRASTRUCTURE_DIR}/config
INFRASTRUCTURE_CONFIG_TEMPLATES_DIR := ${INFRASTRUCTURE_DIR}/config_templates

INFRASTRUCTURE_SECRETS_DIR := ${INFRASTRUCTURE_DIR}/secrets
INFRASTRUCTURE_SECRETS_TEMPLATES_DIR := ${INFRASTRUCTURE_DIR}/secrets_templates

INFRASTRUCTURE_ANSIBLE_DIR := ${INFRASTRUCTURE_DIR}/ansible
INFRASTRUCTURE_ANSIBLE_TEMPLATES_DIR := ${INFRASTRUCTURE_DIR}/ansible_templates


install-service :
	@echo "TODO: Checking if custom configuration exists..."
	@echo "TODO: Checking if all {{TODO:REPLACE}} placeholders have been replaced with actual values..."
	@echo "Running ansible..."
	$(eval CURRENT_WDIR := $(pwd))
	cd ${INFRASTRUCTURE_ANSIBLE_DIR}
	#ansible-playbook -i hosts --ask-become-pass provision_service-host.yml
	cd ${CURRENT_WDIR}

install-runner :
	@echo "TODO: Checking if custom configuration exists..."
	@echo "TODO: Checking if all {{TODO:REPLACE}} placeholders have been replaced with actual values..."
	@echo "Running ansible..."
	$(eval CURRENT_WDIR := $(pwd))
	cd ${INFRASTRUCTURE_ANSIBLE_DIR}
	#ansible-playbook -i hosts --ask-become-pass provision_runner-host.yml
	cd ${CURRENT_WDIR}

upgrade-code :
	@echo "Upgrading code..."
	$(eval OLD_VERSION := $(git describe --tags --abbrev=0))
	$(eval NEW_VERSION := $(curl --silent "https://api.github.com/repos/mdernovoi/data-analysis-platform/releases/latest" $\
	 | jq '.tag_name' | sed 's/"//g') )
	@echo "Current version: ${OLD_VERSION}"
	@echo "New version: ${NEW_VERSION}"
	git fetch --all --tags | git checkout tags/${NEW_VERSION}
	@echo "Template diffs of current and latest version..."
	@echo "Please review them carefully and make adjustments to your installation."
	git diff tags/${OLD_VERSION} -- ${INFRASTRUCTURE_CONFIG_TEMPLATES_DIR}
	git diff tags/${OLD_VERSION} -- ${INFRASTRUCTURE_SECRETS_TEMPLATES_DIR}
	git diff tags/${OLD_VERSION} -- ${INFRASTRUCTURE_ANSIBLE_TEMPLATES_DIR}

upgrade-services :
	@echo "NOT IMPLEMENTED: Upgrading services..."

clean :
	@echo "Cleaning secrets..."
	find ${INFRASTRUCTURE_SECRETS_DIR}/ -type f ! -name '.gitkeep' -delete
	@echo "Cleaning config files..."
	find ${INFRASTRUCTURE_CONFIG_DIR}/ -type f ! -name '.gitkeep' -delete
	@echo "Cleaning ansible files..."
	find ${INFRASTRUCTURE_ANSIBLE_DIR}/ -type f ! -name '.gitkeep' -delete
	


# include user-defined makefiles that contain `Makefile` in their name
# NOTE: user-defined makefiles are included at the end and thus can overwrite default targets!
# Execution example: `make install-service my-target` where my-target is defined in a custom makefile
include makefiles/*Makefile*
