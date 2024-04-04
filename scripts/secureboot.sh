#!/bin/bash

# sbctl is a tool to manage secure boot keys and signing of efi files in the EFI partition
dnf copr enable chenxiaolong/sbctl # Add sbctl's repo
dnf install -y sbctl
# Check for setup mode
status=$(sbctl status | grep "Setup Mode")
if [[ $status == *Disabled* ]]; then
  echo "Setup Mode is not enabled!"
  exit 1
fi
sbctl create-keys
sbctl enroll-keys -m # Register our keys & Microsoft's
# Sign all the efi files in the EFI partition with our key
efis=$(sbctl verify | grep "not signed")
while read -r efi; do
  # Get the name of the file from the report
  clean_efi=${efi:2}
  clean_efi=$(awk '{ sub(/ is not signed*/, ""); print }' <<< "$clean_efi")
  sbctl sign -s "$clean_efi"
done <<< "$efis"

# Sign the efi in /usr/libexec so it get's signed again after an update
sbctl sign -s -o /usr/libexec/fwupd/efi/fwupdx64.efi.signed /usr/libexec/fwupd/efi/fwupdx64.efi
