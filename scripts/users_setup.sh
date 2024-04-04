#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <admin>"
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "admin cannot be empty"
  exit 2
fi

echo "Enter the name of the user to create. Leave empty to exit"
while read -r username; do
  if [[ -z "$username" ]]; then
    break
  fi
  useradd -Ur "$username"
  usermod -aG "$username" "$1"
done
