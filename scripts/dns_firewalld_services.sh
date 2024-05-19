#!/bin/bash

firewall-cmd --permanent --add-service dns
firewall-cmd --reload
systemctl restart docker.service
