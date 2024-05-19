#!/bin/bash

base_dir="/Apps/portainer/compose"
failure=0
for sub_dir in "$base_dir"/*/; do
  if [ -f "${sub_dir}docker-compose.yml" ]; then
    if docker compose -f "${sub_dir}docker-compose.yml" pull; then
      if ! docker compose -f "${sub_dir}docker-compose.yml" up -d; then
        failure=1
      fi
    else
      failure=1
    fi
  fi
done

if docker compose -f /Apps/portainer-stack.yml pull; then
  if ! docker compose -f /Apps/portainer-stack.yml up -d; then
    failure=1
  fi
else
  failure=1
fi

if [ $failure -eq 0 ]; then
  exit 0
else
  exit 1
fi
