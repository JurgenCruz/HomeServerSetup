#!/bin/bash

firewall-cmd --permanent --add-service http
firewall-cmd --permanent --add-service https
firewall-cmd --reload
systemctl restart docker.service
