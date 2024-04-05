#!/bin/bash

echo '{ "selinux-enabled": true }' > /etc/docker/daemon.json
systemctl restart docker.service
setsebool -P virt_sandbox_use_netlink 1
setsebool -P domain_kernel_load_modules 1
setsebool -P container_use_devices 1
setsebool -P rsync_full_access 1
semodule -i ./files/{arr.cil,qbittorrent.cil,wireguard.cil,rsync.cil} /usr/share/udica/templates/{base_container.cil,net_container.cil}
