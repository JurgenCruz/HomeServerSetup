#!/bin/bash

/bin/mail -s "SMARTD_MESSAGE" "SMARTD_ADDRESS" < "SMARTD_FULLMESSAGE"
/usr/local/sbin/notify.sh "SMART reports $SMARTD_DEVICE has a $SMARTD_FAILTYPE failure!"
