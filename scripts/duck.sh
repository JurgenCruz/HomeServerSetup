#!/bin/bash

domain=XXX
token=YYY
device=$(nmcli d | grep ethernet | grep connected | head -1)
set -- $device
ipv6=$(ip -6 addr show dev "$1" | awk '/inet6/ {print $2}' | cut -d/ -f1 | grep -E '^(2|3)' | head -1)
if [ -n "$ipv6" ]; then
    curl -s -S -o /root/duckv6.log "https://www.duckdns.org/update?domains=$domain&token=$token&ip=&ipv6=$ipv6&verbose=true" 2> /root/duckv6_status.log
else
    echo "no ipv6 found: $ipv6 for device $device"
fi
curl -s -S -o /root/duck.log "https://www.duckdns.org/update?domains=$domain&token=$token&ip=&verbose=true" 2> /root/duck_status.log