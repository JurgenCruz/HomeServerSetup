#!/bin/bash

logger -p daemon.notice -t smartd -- "SMARTD_FULLMESSAGE"
/usr/local/sbin/notify.sh "SMART reports $SMARTD_DEVICE has a $SMARTD_FAILTYPE failure!"
