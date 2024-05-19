#!/bin/bash

cp ./files/portainer-stack.yml /Apps/
docker compose -f /Apps/portainer-stack.yml up -d
