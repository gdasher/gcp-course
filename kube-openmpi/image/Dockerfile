FROM ubuntu:latest

# Disable prompts from apt.
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="America/Los_Angeles"


# install ssh and basic dependencies
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
      locales wget ca-certificates ssh build-essential libopenmpi-dev && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Create ssh user(openmpi) and setup ssh key dir
# - ssh identity file and authorized key file is expected to
#   be mounted at /ssh-keys/$SSH_USER
ARG SSH_USER=openmpi
ENV SSH_USER=$SSH_USER
ARG SSH_UID=1000
ARG SSH_GID=1000
RUN addgroup --gid $SSH_GID $SSH_USER
RUN adduser -q --gecos "" --disabled-password --uid $SSH_UID --gid $SSH_GID $SSH_USER
RUN mkdir -p /ssh-key/$SSH_USER && chown -R $SSH_USER:$SSH_USER /ssh-key/$SSH_USER
RUN mkdir -p /.sshd/host_keys && \
  chown -R $SSH_USER:$SSH_USER /.sshd/host_keys && chmod 700 /.sshd/host_keys
RUN mkdir -p /.sshd/user_keys/$SSH_USER && \
  chown -R $SSH_USER:$SSH_USER /.sshd/user_keys/$SSH_USER && chmod 700 /.sshd/user_keys/$SSH_USER
VOLUME /ssh-key/$SSH_USER

ARG HOME=/home/$SSH_USER
RUN mkdir -p $HOME && chown $SSH_USER:$SSH_USER $HOME && chmod 755 $HOME
VOLUME $HOME

COPY rootfs /

EXPOSE 2022

# sshd can be run either by root or $SSH_USER
CMD ["/init.sh"]
