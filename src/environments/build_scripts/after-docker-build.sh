#!/bin/bash

# usage build-docker-image environment_name
# e.g.: build-docker-image dev-base


rm -r $1/secrets_tmp
rm -r $1/scripts_tmp