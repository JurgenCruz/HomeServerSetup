#!/bin/bash

firewall-cmd --permanent --add-service dhcp
firewall-cmd --permanent --add-service dns
firewall-cmd --permanent --add-service http
firewall-cmd --permanent --add-service https
firewall-cmd --permanent --add-port=51820/udp #Wireguard port
firewall-cmd --reload
systemctl restart docker.service
