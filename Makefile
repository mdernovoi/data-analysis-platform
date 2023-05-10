
.PHONY: install-system-prerequisites $\
		install-ansible-prerequisites $\
		install-all-prerequisites $\
		copy-files-for-default-installation-from-src-to-runtime $\
		find-todo-replace-placeholders-in-runtime-files $\
		get-current-data-analysis-platform-src-release $\
		checkout-latest-data-analysis-platform-src-release $\
		upgrade-data-analysis-platform-src-repository-to-latest-release

DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH := .
DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH := .

SRC_INFRASTRUCTURE_DIR := infrastructure
RUNTIME_INFRASTRUCTURE_DIR := infrastructure

SRC_INFRASTRUCTURE_CONFIG_DIR := $(SRC_INFRASTRUCTURE_DIR)/config
RUNTIME_INFRASTRUCTURE_CONFIG_DIR := $(RUNTIME_INFRASTRUCTURE_DIR)/config

SRC_INFRASTRUCTURE_SECRETS_DIR := $(SRC_INFRASTRUCTURE_DIR)/secrets
RUNTIME_INFRASTRUCTURE_SECRETS_DIR := $(RUNTIME_INFRASTRUCTURE_DIR)/secrets

SRC_INFRASTRUCTURE_ANSIBLE_DIR := $(SRC_INFRASTRUCTURE_DIR)/ansible
RUNTIME_INFRASTRUCTURE_ANSIBLE_DIR := $(RUNTIME_INFRASTRUCTURE_DIR)/ansible


LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL := $\
        "https://api.github.com/repos/mdernovoi/data-analysis-platform/releases/latest" 

install-system-prerequisites :
	@echo "Installing prerequisites..."
	@echo "System packages"
	sudo apt-get install -y \
		build-essential \
		curl \
		git \
		grep \
		jq \
		sed

install-ansible-prerequisites :
	@echo "Installing prerequisites..."
	@echo "Ansible"
	sudo apt-get install -y python3 python3-pip ;\
    python3 -m pip install --user ansible ;\

install-all-prerequisites : install-system-prerequisites install-ansible-prerequisites

copy-files-for-default-installation-from-src-to-runtime :
	@echo "Copying files for a new default installation..."
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(SRC_INFRASTRUCTURE_CONFIG_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(RUNTIME_INFRASTRUCTURE_CONFIG_DIR)/
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(SRC_INFRASTRUCTURE_SECRETS_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(RUNTIME_INFRASTRUCTURE_SECRETS_DIR)/
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(SRC_INFRASTRUCTURE_ANSIBLE_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(RUNTIME_INFRASTRUCTURE_ANSIBLE_DIR)/

find-todo-replace-placeholders-in-runtime-files :
	@echo "#######################################################################"
	@echo "#"
	@echo "# Searching for placeholders that have to be replaced with actual values..."
	@echo "# Please review and replace them with actual values before continuing the installation process."
	@echo "#"
	@echo "#######################################################################"
	@echo ""
	@echo "##### SECRETS #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(RUNTIME_INFRASTRUCTURE_SECRETS_DIR)/
	@echo ""
	@echo "##### CONFIG #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(RUNTIME_INFRASTRUCTURE_CONFIG_DIR)/
	@echo ""
	@echo "##### ANSIBLE #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(RUNTIME_INFRASTRUCTURE_ANSIBLE_DIR)/

get-current-data-analysis-platform-src-release:
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	OLD_VERSION=$$(git describe --tags --abbrev=0) ;\
	echo "Current version: $$OLD_VERSION" ;\

get-latest-data-analysis-platform-src-release:
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	LATEST_VERSION=$$(curl --silent $(LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL) $\
	 | jq '.tag_name' | sed 's/"//g') ;\
	echo "Latest release: $$LATEST_VERSION"  ;\

checkout-latest-data-analysis-platform-src-release :
	@echo "Checking out the latest release..."
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	LATEST_VERSION=$$(curl --silent $(LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL) $\
	 | jq '.tag_name' | sed 's/"//g') ;\
	echo "Latest release: $$LATEST_VERSION"  ;\
	git fetch --all --tags ;\
	git checkout tags/$$LATEST_VERSION ;\

upgrade-data-analysis-platform-src-repository-to-latest-release :
	@echo "Upgrading files..."
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	OLD_VERSION=$$(git describe --tags --abbrev=0) ;\
	NEW_VERSION=$$(curl --silent $(LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL) $\
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
	git diff tags/$$OLD_VERSION -- $(SRC_INFRASTRUCTURE_CONFIG_DIR) ;\
	git diff tags/$$OLD_VERSION -- $(SRC_INFRASTRUCTURE_SECRETS_DIR) ;\
	git diff tags/$$OLD_VERSION -- $(SRC_INFRASTRUCTURE_ANSIBLE_DIR) ;\

