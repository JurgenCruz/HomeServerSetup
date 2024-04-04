#!/bin/bash

docker run -d --privileged -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /Apps/portainer:/data:Z portainer/portainer-ce:latest
