#!/bin/bash

curl -s -S -o ~/duck.log "https://www.duckdns.org/update?domains=XXX&token=YYY&ip=" 2> ~/duck_status.log
