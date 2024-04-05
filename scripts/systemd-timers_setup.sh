#!/bin/bash

mv ./files/systemd/* /usr/local/lib/systemd/system/

systemctl daemon-reload
systemctl enable --now zfs-scrub.timer
systemctl enable --now zfs-snapshots.timer
systemctl enable --now apps-backup.timer
systemctl enable --now apps-update.timer
systemctl enable --now duck.timer
