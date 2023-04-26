
FROM ubuntu:22.04

# NOTE:
# The kaniko-executor, which is used to build these images in gitlab ci pipelines
# seems to ignore --chown and --chmod COPY flags. Therefore these modifications
# have to be applied manually.
# However, further investigations have shown, that these flags are not completely ignored.
# The behaviour of the kaniko-executor is very strange.

# Install common tools
# - rsync: for dataspell ide
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    dirmngr \
    fontconfig \ 
    git \
    gnupg \
    libcurl4-openssl-dev \
    locales \
    nano \
    perl \
    rsync \
    software-properties-common \
    sudo \
    tzdata \
    wget && \
    rm -rf /var/lib/apt/lists/*


# Main user to not do everything as root
# Another reason is, that applications such as R and jupyter misbehave
# if they are executed as root.
RUN useradd -rm -d /home/devuser -s /bin/bash -G sudo devuser
# Allow devuser to easily execute commands as root to make life easier.
# This should probably be changed in the future...
RUN echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/devuser

###############
##### SSH #####
###############

# Install and configure an ssh server
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    openssh-server

# Copy server identity files to make them constant across all containers.
# Otherwise every time a new container is created all ssh connections will break due 
# to changes of the identity. 
COPY --chown=root:root secrets_tmp/ssh_host*_key* /etc/ssh/
RUN chown root:root /etc/ssh/ssh_host*_key* && \
    chmod 600 /etc/ssh/ssh_host*_key*

# Allow select keys for authentication
COPY --chown=devuser:devuser secrets_tmp/authorized_keys /home/devuser/.ssh/
RUN chown devuser:devuser /home/devuser/.ssh/authorized_keys && \
    chmod 600 /home/devuser/.ssh/authorized_keys

######################  
##### Entrypoint ##### 
######################   

COPY --chown=devuser:devuser docker-entrypoint.sh .
RUN chown devuser:devuser docker-entrypoint.sh && \
    chmod 777 docker-entrypoint.sh

USER devuser

CMD ["/bin/bash", "docker-entrypoint.sh"]

EXPOSE 22