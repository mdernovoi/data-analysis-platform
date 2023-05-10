
# Customize the Data Analysis Platform

Since the main motto of the Data Analysis Platform is to be technology agnostic, it is essential to be able to customize it to suit your local environment.

There are two components:

- The reference [data-analysis-platform](https://github.com/mdernovoi/data-analysis-platform)

- A [custom-data-analysis-platform-template](https://github.com/mdernovoi/custom-data-analysis-platform-template) which provides an example of how to integrate the reference `data-analysis-platform` into your own infrastructure.

The [files and directories](files_and_directories.md) guide describes all files and their intended use.

The `data-analysis-repository` is a git submodule of the `custom-data-analysis-platform-template` and provides a reference implementation.

The [standard installation procedure](provision.md) assumes that you closely follow the reference implementation and copies all files from the `data-analysis-platform` repository into corresponding directories of the `custom-data-analysis-platform-template`. 

Files in the `custom-data-analysis-platform-template` directory (except for the templates in the `data-analysis-platform` folder) can be arbitrarily modified and adapted to your needs.

You can: 

- remove or add ansible tasks
- modify the docker compose files
- use external services (e.g., Amazon S3 instead of Minio or full-fledged VMs instead of docker containers). 
- not use ansible or docker at all
- do whatever you want

During [upgrades](upgrade.md), only files in the reference `data-analysis-platform` directory are updated. As a result, your own infrastructure remains untouched.

**NOTE**: If you want to keep a simple upgrade path and do not require extensive modifications of the Data Analysis Platform, it is beneficial not to modify your copy of the reference files too much since, during every upgrade, you have to apply new changes to your own configuration manually.


