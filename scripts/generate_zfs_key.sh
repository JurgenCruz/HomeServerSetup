#!/bin/bash

mkdir /keys
if [ $? -ne 0 ]; then
    echo "Error creating directory for key. Aborting." >&2
    exit 1
fi
openssl rand -hex 32 > /keys/Tank.dat
if [ $? -ne 0 ]; then
    echo "Error generating key wwith openssl. Aborting." >&2
    exit 2
fi
