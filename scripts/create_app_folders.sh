#!/bin/bash

mkdir /Apps
chown mediacenter:mediacenter /Apps
chmod 774 /Apps
chown mediacenter:mediacenter /mnt/Tank/Apps
chmod 774 /mnt/Tank/Apps
mkdir -p /mnt/Tank/MediaCenter/media/movies
mkdir /mnt/Tank/MediaCenter/media/tv
mkdir -p /mnt/Tank/MediaCenter/torrents/movies
mkdir /mnt/Tank/MediaCenter/torrents/tv
chown -R mediacenter:mediacenter /mnt/Tank/MediaCenter
chmod -R 774 /mnt/Tank/MediaCenter
