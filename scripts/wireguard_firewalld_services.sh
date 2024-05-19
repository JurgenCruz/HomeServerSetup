#!/bin/bash

firewall-cmd --permanent --add-port=51820/udp
firewall-cmd --reload
systemctl restart docker.service
