#!/bin/bash

# start ssh
sudo service ssh start

# start jupyter
./.local/bin/jupyter-notebook

# let the container run indefinitely
sleep infinity


