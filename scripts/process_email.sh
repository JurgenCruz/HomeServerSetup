#!/bin/bash

temp=$(mktemp)

while read -r line; do
  echo "$line" >> "$temp"
done

/bin/mail -s "$1" "$2" < "$temp"
/usr/local/sbin/notify.sh "$1"
