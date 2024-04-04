#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 message"
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "message cannot be empty"
  exit 2
fi

curl -X POST -H "Content-Type: application/json" -d "{ \"problem\": \"{$1}\"}" http://localhost:8123/api/webhook/notify
