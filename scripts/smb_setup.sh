#!/bin/bash

dnf install samba
systemctl enable smb --now
