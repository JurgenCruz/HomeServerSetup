#!/bin/bash

mkdir -p /Apps/nginx/data
mkdir /Apps/nginx/etc-letsencrypt
chown -R mediacenter:mediacenter /Apps/nginx
chmod -R 774 /Apps/nginx
