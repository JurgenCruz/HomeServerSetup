#!/bin/bash

dnf install -y cockpit git
systemctl enable --now cockpit.socket
firewall-cmd --permanent --add-service=cockpit
firewall-cmd --reload
dnf install -y cockpit-packagekit cockpit-navigator python3-pcp
git clone https://github.com/45drives/cockpit-zfs-manager.git
cp -r cockpit-zfs-manager/zfs /usr/share/cockpit/
