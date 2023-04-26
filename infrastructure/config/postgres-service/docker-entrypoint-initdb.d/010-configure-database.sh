#!/bin/bash
set -e

### Create a user and database for mlflow
# $MLFLOW_DATABASE_PASSWORD is passed in docker-compose
#
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    create user mlflow with encrypted password '$MLFLOW_DATABASE_PASSWORD';
    create database mlflow with owner = mlflow;
EOSQL
