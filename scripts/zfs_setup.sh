#!/bin/bash

dnf install -y "https://zfsonlinux.org/fedora/zfs-release-2-5$(rpm --eval "%{dist}").noarch.rpm" # Add ZFS repo
# ZFS is built for your specific kernel using DKMS and loaded dynamically by your kernel at boot
dnf install -y zfs
# Protect ZFS package from being uninstalled when a kernel update is not compatible
echo 'zfs' > /etc/dnf/protected.d/zfs.conf
# Queue the registration of DKMS keys for secure boot. Otherwise, the kernel will reject loading the ZFS module
# You need to supply a password that you will be asked during registration after reboot
# It can be the same as your user password if you want
mokutil --import /var/lib/dkms/mok.pub
