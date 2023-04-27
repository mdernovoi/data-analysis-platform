#!/bin/bash

# usage build-docker-image environment_name
# e.g.: build-docker-image dev-base

cp -r secrets/ $1/secrets_tmp
cp -r scripts/ $1/scripts_tmp
