#!/bin/bash

# Add repos
dnf -y install "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf -y install "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | tee /etc/yum.repos.d/nvidia-container-toolkit.repo
dnf makecache
# Install packages
dnf -y install akmod-nvidia xorg-x11-drv-nvidia-cuda nvidia-container-toolkit nvidia-vaapi-driver libva-utils vdpauinfo
# Generate key for Akmods which is like DKMS for Fedora
/usr/sbin/kmodgenca -a
# Enroll key to Secure Boot chain
mokutil --import /etc/pki/akmods/certs/public_key.der
# Add Nvidia runtime to Docker configuration
nvidia-ctk runtime configure --runtime=docker
# Restart Docker service.
systemctl restart docker.service
