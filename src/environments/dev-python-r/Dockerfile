ARG BASE_IMAGE_NAME=dev-base
# Example: gitlab-registry.mydomain.com:5005/dev/environments
ARG BASE_IMAGE_REPOSITORY={{TODO:REPLACE}}
ARG BASE_IMAGE_TAG=latest

FROM ${BASE_IMAGE_REPOSITORY}/${BASE_IMAGE_NAME}:${BASE_IMAGE_TAG}

# NOTE:
# The kaniko-executor, which is used to build these images in gitlab ci pipelines
# seems to ignore --chown and --chmod COPY flags. Therefore these modifications
# have to be applied manually.
# However, further investigations have shown, that these flags are not completely ignored.
# The behaviour of the kaniko-executor is very strange.

USER root
WORKDIR /home/devuser

# Helper scripts
COPY --chown=devuser:devuser scripts_tmp/ build/scripts
RUN chown -R devuser:devuser build/scripts && \
    chmod 777 build/scripts

##################
##### Python #####
##################

# Install Python

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python-is-python3 

#############
##### R #####
#############

# Install R

RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo gpg --dearmor -o /usr/share/keyrings/r-project.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/r-project.gpg] https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" | sudo tee -a /etc/apt/sources.list.d/r-project.list
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    r-base \
    r-base-dev

# Grant devuser access to R package library
# ref: https://stackoverflow.com/questions/32540919/library-is-not-writable/36696488#comment95292973_36696488
RUN usermod -a -G staff devuser && \
    chown -R root:staff /usr/local/lib/R && \
    chmod -R 775 /usr/local/lib/R

######################
##### R packages #####
######################

# R packages can have system package dependencies.
# To automatically resolve and install them the `rspm` package from RStudio is used.

# Install rspm dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    apt-file

# Packages to install
COPY --chown=devuser:devuser r_packages.json build
RUN chown devuser:devuser build/r_packages.json && \
    chmod 666 build/r_packages.json

# Install R packages.
# Must be run as a non-root user due to how apt works under the hood. 
# Apt is used by rspm to install packages. 
USER devuser
RUN Rscript build/scripts/install_r_packages.R "build/r_packages.json"

###########################
##### Python packages ##### 
###########################

# Install Python packages
COPY --chown=devuser:devuser requirements.txt build
RUN chown devuser:devuser build/requirements.txt && \
    chmod 666 build/requirements.txt
RUN pip install -r build/requirements.txt

# Configure Jupyter notebooks
COPY --chown=devuser:devuser jupyter_notebook_config.py .jupyter/jupyter_notebook_config.py
RUN chown devuser:devuser .jupyter/jupyter_notebook_config.py && \
    chmod 666 .jupyter/jupyter_notebook_config.py

######################  
##### Entrypoint #####
###################### 

# Clean up
USER root
RUN rm -rf build

COPY --chown=devuser:devuser docker-entrypoint.sh .
RUN chown devuser:devuser docker-entrypoint.sh && \
    chmod 777 docker-entrypoint.sh

USER devuser

CMD ["/bin/bash", "docker-entrypoint.sh"]

EXPOSE 22