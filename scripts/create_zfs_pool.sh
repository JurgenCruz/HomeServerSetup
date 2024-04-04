#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 raidz_type \"vdevs\""
    echo "    For example: $0 raidz \"/dev/disk/by-uuid/20652732-86e0-4629-9fce-491ffb78773f /dev/disk/by-id/932801a9-8554-49a2-855c-9d0feb6689ce /dev/disk/by-id/c334816d-8990-4a2c-b621-e2047aad0b11\""
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "raidz_type cannot be empty"
    exit 2
fi

if [[ -z "$2" ]]; then
    echo "vdevs cannot be empty"
    exit 3
fi

zpool create -o cachefile=/etc/zfs/zpool.cache -o ashift=12 -O encryption=on -O keyformat=hex -O mountpoint=/mnt/Tank -O canmount=off -O keylocation=file:///keys/Tank.dat -O atime=off -O acltype=posix -O compression=lz4 -O xattr=sa Tank "$1" "$2"
if [ $? -ne 0 ]; then
    echo "Error generating pool. Aborting." >&2
    exit 1
fi
