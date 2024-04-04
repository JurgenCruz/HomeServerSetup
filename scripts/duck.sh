#!/bin/bash

echo url="https://www.duckdns.org/update?domains=XXX&token=YYY&ip=" | curl -s -S -k -o ~/duck.log -K -
