#!/bin/bash

mkdir -p /Apps/nextcloud/app
mkdir -p /Apps/nextcloud/db/data
mkdir /Apps/nextcloud/db/config
chown -R mediacenter:mediacenter /Apps/nextcloud
chmod -R 774 /Apps/nextcloud
