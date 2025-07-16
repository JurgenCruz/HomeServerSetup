#!/bin/bash

echo "Enter the name of the users you created for the samba shares. Leave empty to exit"
while read -r username; do
  if [[ -z "$username" ]]; then
    break
  fi
  # Use the username in all uppercase as de share name
  upper=${username^^}
  zfs create -o canmount=on -o mountpoint="/mnt/Tank/$upper" -o casesensitivity=insensitive "Tank/$upper"
  if [ $? -ne 0 ]; then
    echo "Error creating dataset Tank/$upper. Aborting" >&2
    exit 1
  fi
  # Set the owner
  chown -h "$username:$username" "/mnt/Tank/$upper"
  # set the folder as sharable by samba
  semanage fcontext -a -t samba_share_t "/mnt/Tank/$upper(/.*)?"
  restorecon -R -v "/mnt/Tank/$upper"
done

zfs create -o canmount=on -o mountpoint=/mnt/Tank/Apps Tank/Apps
if [ $? -ne 0 ]; then
  echo "Error creating dataset Tank/Apps. Aborting" >&2
  exit 1
fi
zfs create -o canmount=on -o mountpoint=/mnt/Tank/MediaCenter Tank/MediaCenter
if [ $? -ne 0 ]; then
  echo "Error creating dataset Tank/MediaCenter. Aborting" >&2
  exit 1
fi
chown -h mediacenter:mediacenter /mnt/Tank/MediaCenter
semanage fcontext -a -t samba_share_t "/mnt/Tank/MediaCenter(/.*)?"
restorecon -R -v /mnt/Tank/MediaCenter
zfs create -o canmount=on -o mountpoint=/mnt/Tank/NextCloud Tank/NextCloud
if [ $? -ne 0 ]; then
  echo "Error creating dataset Tank/NextCloud. Aborting" >&2
  exit 1
fi
