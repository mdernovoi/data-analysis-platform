
.PHONY: install-system-prerequisites $\
		install-ansible-prerequisites $\
		install-all-prerequisites $\
		copy-files-for-default-installation-from-templates-to-custom $\
		find-todo-replace-placeholders-in-custom-platform-infrastructure-files $\
		get-current-data-analysis-platform-templates-release $\
		checkout-latest-data-analysis-platform-templates-release $\
		upgrade-data-analysis-platform-templates-repository-to-latest-release $\
		diff-infrastructure-templates-and-custom-directories $\
		diff-src-templates-and-custom-directories

DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH := .
DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH := .

TEMPLATES_INFRASTRUCTURE_DIR := infrastructure
CUSTOM_INFRASTRUCTURE_DIR := infrastructure

TEMPLATES_SRC_DIR := src
CUSTOM_SRC_DIR := src

TEMPLATES_INFRASTRUCTURE_CONFIG_DIR := $(TEMPLATES_INFRASTRUCTURE_DIR)/config
CUSTOM_INFRASTRUCTURE_CONFIG_DIR := $(CUSTOM_INFRASTRUCTURE_DIR)/config

TEMPLATES_INFRASTRUCTURE_SECRETS_DIR := $(TEMPLATES_INFRASTRUCTURE_DIR)/secrets
CUSTOM_INFRASTRUCTURE_SECRETS_DIR := $(CUSTOM_INFRASTRUCTURE_DIR)/secrets

TEMPLATES_INFRASTRUCTURE_ANSIBLE_DIR := $(TEMPLATES_INFRASTRUCTURE_DIR)/ansible
CUSTOM_INFRASTRUCTURE_ANSIBLE_DIR := $(CUSTOM_INFRASTRUCTURE_DIR)/ansible

TEMPLATES_SRC_ENVIRONMENTS_DIR := $(TEMPLATES_SRC_DIR)/environments
CUSTOM_SRC_ENVIRONMENTS_DIR := $(CUSTOM_SRC_DIR)/environments

TEMPLATES_SRC_GITLAB_CI_EXAMPLE_DIR := $(TEMPLATES_SRC_DIR)/gitlab_ci_pipeline_example
CUSTOM_SRC_GITLAB_CI_EXAMPLE_DIR := $(CUSTOM_SRC_DIR)/gitlab_ci_pipeline_example


LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL := $\
        "https://api.github.com/repos/mdernovoi/data-analysis-platform/releases/latest" 

install-system-prerequisites :
	@echo "Installing prerequisites..."
	@echo "System packages"
	sudo apt-get install -y \
		apache2-utils \
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

copy-files-for-default-installation-from-templates-to-custom :
	@echo "Copying files for a new default installation..."
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_INFRASTRUCTURE_CONFIG_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_CONFIG_DIR)/
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_INFRASTRUCTURE_SECRETS_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_SECRETS_DIR)/
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_INFRASTRUCTURE_ANSIBLE_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_ANSIBLE_DIR)/
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_SRC_ENVIRONMENTS_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_SRC_ENVIRONMENTS_DIR)/
	cp -r $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_SRC_GITLAB_CI_EXAMPLE_DIR)/* $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_SRC_GITLAB_CI_EXAMPLE_DIR)/

find-todo-replace-placeholders-in-custom-platform-infrastructure-files :
	@echo "#######################################################################"
	@echo "#"
	@echo "# Searching for placeholders that have to be replaced with actual values..."
	@echo "# Please review and replace them with actual values before continuing the installation process."
	@echo "#"
	@echo "#######################################################################"
	@echo ""
	@echo "##### SECRETS #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_SECRETS_DIR)/
	@echo ""
	@echo "##### CONFIG #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_CONFIG_DIR)/
	@echo ""
	@echo "##### ANSIBLE #####"
	@echo ""
	-egrep -r --with-filename --line-number --context=6 '{{TODO:REPLACE}}' $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_ANSIBLE_DIR)/

get-current-data-analysis-platform-templates-release :
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	OLD_VERSION=$$(git describe --tags --abbrev=0) ;\
	echo "Current version: $$OLD_VERSION" ;\

get-latest-data-analysis-platform-templates-release :
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	LATEST_VERSION=$$(curl --silent $(LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL) $\
	 | jq '.tag_name' | sed 's/"//g') ;\
	echo "Latest release: $$LATEST_VERSION"  ;\

checkout-latest-data-analysis-platform-templates-release :
	@echo "Checking out the latest release..."
	@set -e ;\
	cd $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH) ;\
	LATEST_VERSION=$$(curl --silent $(LATEST_DATA_ANALYSIS_PLATFORM_RELEASE_GITHUB_API_URL) $\
	 | jq '.tag_name' | sed 's/"//g') ;\
	echo "Latest release: $$LATEST_VERSION"  ;\
	git fetch --all --tags ;\
	git checkout tags/$$LATEST_VERSION ;\

upgrade-data-analysis-platform-templates-repository-to-latest-release :
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
	echo "" ;\
	echo "##### CONFIG #####" ;\
	echo "" ;\
	git diff tags/$$OLD_VERSION -- $(TEMPLATES_INFRASTRUCTURE_CONFIG_DIR) ;\
	echo "" ;\
	echo "##### SECRETS #####" ;\
	echo "" ;\
	git diff tags/$$OLD_VERSION -- $(TEMPLATES_INFRASTRUCTURE_SECRETS_DIR) ;\
	echo "" ;\
	echo "##### ANSIBLE #####" ;\
	echo "" ;\
	git diff tags/$$OLD_VERSION -- $(TEMPLATES_INFRASTRUCTURE_ANSIBLE_DIR) ;\
	echo "" ;\
	echo "##### SRC/ENVIRONMENTS #####" ;\
	echo "" ;\
	git diff tags/$$OLD_VERSION -- $(TEMPLATES_SRC_ENVIRONMENTS_DIR) ;\
	echo "" ;\
	echo "##### SRC/GITLAB_CI_PIPELINE_EXAMPLE #####" ;\
	echo "" ;\
	git diff tags/$$OLD_VERSION -- $(TEMPLATES_SRC_GITLAB_CI_EXAMPLE_DIR) ;\

diff-infrastructure-templates-and-custom-directories :
	@set -e ;\
	echo "#######################################################################" ;\
	echo "#" ;\
	echo "# Diffs of infrastructure templates and custom files directories..." ;\
	echo "#" ;\
	echo "#######################################################################"
	@echo "" ;\
	echo "##### CONFIG #####" ;\
	echo "" 
	-git diff --no-index $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_INFRASTRUCTURE_CONFIG_DIR) $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_CONFIG_DIR)
	@echo "" ;\
	echo "##### SECRETS #####" ;\
	echo ""
	-git diff --no-index $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_INFRASTRUCTURE_SECRETS_DIR) $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_SECRETS_DIR)
	@echo "" ;\
	echo "##### ANSIBLE #####" ;\
	echo "" 
	-git diff --no-index $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_INFRASTRUCTURE_ANSIBLE_DIR) $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_INFRASTRUCTURE_ANSIBLE_DIR);\

diff-src-templates-and-custom-directories :
	@set -e ;\
	echo "#######################################################################" ;\
	echo "#" ;\
	echo "# Diffs of src templates and custom files directories..." ;\
	echo "#" ;\
	echo "#######################################################################"
	@echo "" ;\
	echo "##### ENVIRONMENTS #####" ;\
	echo "" 
	-git diff --no-index $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_SRC_ENVIRONMENTS_DIR) $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_SRC_ENVIRONMENTS_DIR)
	@echo "" ;\
	echo "##### GITLAB CI PIPELINE EXAMPLE #####" ;\
	echo "" 
	-git diff --no-index $(DATA_ANALYSIS_PLATFORM_TEMPLATES_PATH)/$(TEMPLATES_SRC_GITLAB_CI_EXAMPLE_DIR) $(DATA_ANALYSIS_PLATFORM_CUSTOM_VERSION_PATH)/$(CUSTOM_SRC_GITLAB_CI_EXAMPLE_DIR)
