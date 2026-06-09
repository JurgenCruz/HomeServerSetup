#!/bin/bash

base_dir="/Apps/dockhand/stacks/local"
failure=0
for sub_dir in "$base_dir"/*/; do
  if [ -f "${sub_dir}compose.yaml" ]; then
    if docker compose -f "${sub_dir}compose.yaml" ps --services --filter "status=running" | grep -q .; then
      if docker compose -f "${sub_dir}compose.yaml" pull; then
        if ! docker compose -f "${sub_dir}compose.yaml" up -d; then
          failure=1
        fi
      else
        failure=1
      fi
    fi
  fi
done

if docker compose -f /Apps/dockhand-stack.yml pull; then
  if ! docker compose -f /Apps/dockhand-stack.yml up -d; then
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
