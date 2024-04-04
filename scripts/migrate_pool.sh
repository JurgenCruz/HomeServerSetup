#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 old_pool_name raidz_type \"vdevs\""
    echo "    For example: $0 Tank raidz \"/dev/disk/by-uuid/20652732-86e0-4629-9fce-491ffb78773f /dev/disk/by-id/932801a9-8554-49a2-855c-9d0feb6689ce /dev/disk/by-id/c334816d-8990-4a2c-b621-e2047aad0b11\""
    exit 1
fi

if [[ -z "$1" ]]; then
    echo "old_pool_name cannot be empty"
    exit 2
fi

if [[ -z "$2" ]]; then
    echo "raidz_type cannot be empty"
    exit 3
fi

if [[ -z "$3" ]]; then
    echo "vdevs cannot be empty"
    exit 4
fi

# Create a snapshot of existing pool to replicate to the new pool
zfs snapshot -r "$1@migration"
if [ $? -ne 0 ]; then
    echo "Error creating snapshots of old pool. Aborting." >&2
    exit 5
fi

# Disconnect the pool to rename it
zpool export "$1"
if [ $? -ne 0 ]; then
    echo "Error exporting old pool. Aborting." >&2
    exit 6
fi

# Import it again with a different name
zpool import "$1" temp_pool
if [ $? -ne 0 ]; then
    echo "Error importing old pool with new name. Aborting." >&2
    exit 7
fi

# Create a new pool with name Tank
./create_zfs_pool.sh "$2" "$3"
if [ $? -ne 0 ]; then
    echo "Error creating new pool. Aborting." >&2
    exit 8
fi

datasets=$(zfs list -r -H -o name temp_pool | tail -n +1)
if [ $? -ne 0 ]; then
    echo "Error getting list of data sets to send. Aborting." >&2
    exit 9
fi

# Loop datasets and replicate them in the new pool using the snapshot we just generated
while read -r dataset; do
    ds=$(awk '{ sub(/.+\//, ""); print }' <<< "$dataset")
    zfs send --compressed -v "$dataset@migration" | zfs receive -o acltype=posix -o xattr=sa -o canmount=on -o mountpoint="/mnt/Tank/$ds" -v "Tank/$ds"
    if [ $? -ne 0 ]; then
        echo "Error migrating dataset $dataset. Aborting." >&2
        exit 10
    fi
done <<< "$datasets"

# Disconnect the old pool so it can be removed physically
zpool export temp_pool
if [ $? -ne 0 ]; then
    echo "Error exporting old pool after migration. you might want to export it manually as to avoid mounting collisions with new pool." >&2
    exit 11
fi
