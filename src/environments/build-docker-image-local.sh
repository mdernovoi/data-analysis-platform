#!/bin/bash

# usage build-docker-image environment_name
# e.g.: build-docker-image dev-base

cp -r secrets/ $1/secrets_tmp
cp -r scripts/ $1/scripts_tmp

docker build \
--tag $1 \
$1

rm -r $1/secrets_tmp
rm -r $1/scripts_tmp