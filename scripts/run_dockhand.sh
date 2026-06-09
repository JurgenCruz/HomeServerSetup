#!/bin/bash

cp ./files/dockhand-stack.yml /Apps/
docker compose -f /Apps/dockhand-stack.yml up -d
