#!/bin/bash

mkdir /Apps
mkdir /Apps/bazarr
mkdir -p /Apps/jellyfin/config
mkdir /Apps/jellyfin/cache
mkdir /Apps/jellyseerr
mkdir /Apps/prowlarr
mkdir -p /Apps/qbittorrent/wireguard
mkdir /Apps/radarr
mkdir /Apps/sonarr
mkdir -p /Apps/technitium/config
mkdir /Apps/homeassistant
mkdir -p /Apps/nginx/data
mkdir /Apps/nginx/etc-letsencrypt
mkdir /Apps/portainer
mkdir /Apps/wireguard
chown -R mediacenter:mediacenter /Apps
chmod -R 774 /Apps
chown -R mediacenter:mediacenter /mnt/Tank/Apps
chmod -R 774 /mnt/Tank/Apps
mkdir -p /mnt/Tank/MediaCenter/media/movies
mkdir /mnt/Tank/MediaCenter/media/tv
mkdir -p /mnt/Tank/MediaCenter/torrents/movies
mkdir /mnt/Tank/MediaCenter/torrents/tv
chown -R mediacenter:mediacenter /mnt/Tank/MediaCenter
chmod -R 774 /mnt/Tank/MediaCenter
