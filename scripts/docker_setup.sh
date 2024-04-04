#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <admin_user>"
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "admin user cannot be empty"
    exit 2
fi

# dnf -y install dnf-plugins-core # should already be installed
dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
usermod -aG docker "$1"
