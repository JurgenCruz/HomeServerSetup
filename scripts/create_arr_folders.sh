#!/bin/bash

mkdir /Apps/bazarr
mkdir -p /Apps/jellyfin/config
mkdir /Apps/jellyfin/cache
mkdir /Apps/jellyseerr
mkdir /Apps/prowlarr
mkdir -p /Apps/qbittorrent/wireguard
mkdir /Apps/radarr
mkdir /Apps/sonarr
chown mediacenter:mediacenter /Apps/bazarr
chmod 774 /Apps/bazarr
chown -R mediacenter:mediacenter /Apps/jellyfin
chmod -R 774 /Apps/jellyfin
chown mediacenter:mediacenter /Apps/jellyseerr
chmod 774 /Apps/jellyseerr
chown mediacenter:mediacenter /Apps/prowlarr
chmod 774 /Apps/prowlarr
chown -R mediacenter:mediacenter /Apps/qbittorrent
chmod -R 774 /Apps/qbittorrent
chown mediacenter:mediacenter /Apps/radarr
chmod 774 /Apps/radarr
chown mediacenter:mediacenter /Apps/sonarr
chmod 774 /Apps/sonarr
