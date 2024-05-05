#!/bin/bash

systemctl disable --now systemd-resolved.service
rm /etc/resolv.conf
