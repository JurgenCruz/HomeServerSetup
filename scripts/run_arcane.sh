#!/bin/bash

cp ./files/arcane-stack.yml /Apps/
docker compose -f /Apps/arcane-stack.yml up -d
