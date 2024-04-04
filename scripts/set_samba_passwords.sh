#!/bin/bash

echo "Enter the name of the user to set password for. Leave empty to exit"
while read -r username; do
  if [[ -z "$username" ]]; then
    break
  fi
  smbpasswd -a "$username"
done
