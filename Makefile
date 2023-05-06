
.PHONY: install-system-prerequisites install-ansible-prerequisites install-prerequisites &\
    copy-files-for-default-installation find-todo-replace-placeholders prepare-default-installation &\
	install-service-host install-runner-host &\
	upgrade-repository upgrade-services &\
	clean-repository clean-services clean

INFRASTRUCTURE_DIR := infrastructure

INFRASTRUCTURE_CONFIG_DIR := ${INFRASTRUCTURE_DIR}/config
INFRASTRUCTURE_CONFIG_TEMPLATES_DIR := ${INFRASTRUCTURE_DIR}/config_templates

INFRASTRUCTURE_SECRETS_DIR := ${INFRASTRUCTURE_DIR}/secrets
INFRASTRUCTURE_SECRETS_TEMPLATES_DIR := ${INFRASTRUCTURE_DIR}/secrets_templates

INFRASTRUCTURE_ANSIBLE_DIR := ${INFRASTRUCTURE_DIR}/ansible
INFRASTRUCTURE_ANSIBLE_TEMPLATES_DIR := ${INFRASTRUCTURE_DIR}/ansible_templates

MAKEFILES_DIR := makefiles
MAKEFILES_TEMPLATES_DIR := makefiles_templates

LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL := &\
        "https://api.github.com/repos/mdernovoi/data-analysis-platform/releases/latest" 

install-system-prerequisites :
	@echo "Installing prerequisites..."
	@echo "System packages"
	sudo apt-get install -y \
		build-essential \
		curl \
		git \
		grep \
      	jq

install-ansible-prerequisites :
	@echo "Installing prerequisites..."
	@echo "Ansible"
	sudo apt-get install -y python3 python3-pip ;\
    python3 -m pip install --user ansible ;\
    # Add Ansible to PATH 
    echo 'PATH="$$PATH:~/.local/bin"' >> ~/.bashrc ;\
    source ~/.bashrc

install-prerequisites : install-system-prerequisites install-ansible-prerequisites

copy-files-for-default-installation :
	@echo "Copying files for a new default installation..."
	cp -r ${INFRASTRUCTURE_SECRETS_TEMPLATES_DIR}/* ${INFRASTRUCTURE_SECRETS_DIR}/
	cp -r ${INFRASTRUCTURE_CONFIG_TEMPLATES_DIR}/* ${INFRASTRUCTURE_CONFIG_DIR}
	cp -r ${INFRASTRUCTURE_ANSIBLE_TEMPLATES_DIR}/* ${INFRASTRUCTURE_ANSIBLE_DIR}

find-todo-replace-placeholders :
	@echo "#######################################################################"
	@echo "#"
	@echo "# Searching for placeholders that have to be replaced with actual values..."
	@echo "# Please review and replace them with actual values before continuing the installation process."
	@echo "#"
	@echo "#######################################################################"
	@echo ""
	@echo "##### SECRETS #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' ${INFRASTRUCTURE_SECRETS_DIR}/
	@echo ""
	@echo "##### CONFIG #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' ${INFRASTRUCTURE_CONFIG_DIR}/
	@echo ""
	@echo "##### ANSIBLE #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' ${INFRASTRUCTURE_ANSIBLE_DIR}/

prepare-default-installation : install-prerequisites copy-files-for-default-installation &\
    find-todo-replace-placeholders

install-service-host :
	@echo "NOT IMPLEMENTED: ..."

install-runner-host :
	@echo "NOT IMPLEMENTED: ..."

upgrade-repository :
	@echo "Upgrading files..."
	@set -e ;\
	OLD_VERSION=$$(git describe --tags --abbrev=0) ;\
	NEW_VERSION=$$(curl --silent ${LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL} $\
	 | jq '.tag_name' | sed 's/"//g') ;\
	echo "Current version: $$OLD_VERSION" ;\
	echo "New version: $$NEW_VERSION"  ;\
	git fetch --all --tags ;\
	git checkout tags/$$NEW_VERSION ;\
	echo "#######################################################################" ;\
	echo "#" ;\
	echo "# Template diffs of current and latest version..." ;\
	echo "# Please review them carefully and make adjustments to your installation." ;\
	echo "#" ;\
	echo "#######################################################################" ;\
	git diff tags/$$OLD_VERSION -- ${INFRASTRUCTURE_CONFIG_TEMPLATES_DIR} ;\
	git diff tags/$$OLD_VERSION -- ${INFRASTRUCTURE_SECRETS_TEMPLATES_DIR} ;\
	git diff tags/$$OLD_VERSION -- ${INFRASTRUCTURE_ANSIBLE_TEMPLATES_DIR} ;\

upgrade-services :
	@echo "NOT IMPLEMENTED: Upgrading services..."

clean-repository :
	@echo "Removing all custom files in this repository..."
	@echo "Cleaning secrets..."
	-find ${INFRASTRUCTURE_SECRETS_DIR}/* -type f ! -name '.gitkeep' -delete
	-find ${INFRASTRUCTURE_SECRETS_DIR}/* -type d -prune -exec rm -rf {} +
	@echo "Cleaning config files..."
	-find ${INFRASTRUCTURE_CONFIG_DIR}/* -type f ! -name '.gitkeep' -delete
	-find ${INFRASTRUCTURE_CONFIG_DIR}/* -type d -prune -exec rm -rf {} +
	@echo "Cleaning ansible files..."
	-find ${INFRASTRUCTURE_ANSIBLE_DIR}/* -type f ! -name '.gitkeep' -delete
	-find ${INFRASTRUCTURE_ANSIBLE_DIR}/* -type d -prune -exec rm -rf {} +
	@echo "Cleaning makefiles..."
	-find ${MAKEFILES_DIR}/* -type f ! -name '.gitkeep' -delete
	-find ${MAKEFILES_DIR}/* -type d -prune -exec rm -rf {} +
	
clean-services :
	@echo "NOT IMPLEMENTED: Removing files of all services..."

clean : clean-repository clean-services

# include user-defined makefiles that contain `Makefile` in their name
# NOTE: user-defined makefiles are included at the end and thus can overwrite default targets!
# Execution example: `make install-service my-target` where my-target is defined in a custom makefile
-include makefiles/*Makefile*
