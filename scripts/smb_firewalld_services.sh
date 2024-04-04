#!/bin/bash

firewall-cmd --permanent --add-service samba-dc
firewall-cmd --permanent --add-service samba
firewall-cmd --reload
systemctl enable --now smb
