#!/bin/bash

echo "iptable_raw" > /etc/modules-load.d/iptable_raw.conf
modprobe iptable_raw
