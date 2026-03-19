#!/bin/bash

domain=XXX
token=YYY
device=$(nmcli d | grep ethernet | grep connected | head -1)
set -- $device
ipv6=$(ip addr show dev "$1" | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d' | grep -v '^fd00' | grep -v '^fe80' | head -1)
if [ -z "$ipv6" ]; then
    curl -s -S -o ~/duckv6.log "https://www.duckdns.org/update?domains=$domain&token=$token&ip=&ipv6=$ipv6&verbose=true" 2> ~/duckv6_status.log
fi
curl -s -S -o ~/duck.log "https://www.duckdns.org/update?domains=$domain&token=$token&ip=&verbose=true" 2> ~/duck_status.log