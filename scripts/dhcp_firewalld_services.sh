#!/bin/bash

firewall-cmd --permanent --add-service dhcp
firewall-cmd --reload
systemctl restart docker.service
