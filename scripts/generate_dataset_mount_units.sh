#!/bin/bash

# Create file for cache. Not sure why ZED service doesn't create it itself
mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/Tank
# Restart ZED service to see if it detects the new file
systemctl restart zfs-zed.service
# Make some changes and roll them back to trigger the service to write to the cache
zfs set canmount=on Tank
zfs set canmount=off Tank
systemctl daemon-reload
