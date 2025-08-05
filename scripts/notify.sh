#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 message"
  exit 1
fi

if [[ -z "$1" ]]; then
  echo "message cannot be empty"
  exit 2
fi

message=$(echo "$1" | jq -R)
curl -X POST -H "Content-Type: application/json" -d "{ \"title\": \"Alert\", \"message\": $message}" https://gotify.myhome.duckdns.org/message?token={your_token_here}
