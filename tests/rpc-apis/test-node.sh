#!/bin/bash

# Call this script as follows:
# $ bash test.sh <NODE_ID> {true|false}

set -e -o pipefail

RPC_URL=$1
EXISTENCE=$2

DATA_DIR="/tmp/$NODE_ID"
mkdir -p $DATA_DIR

ADMIN_EXISTS=$(/opt/go-ethereum/build/bin/geth attach $RPC_URL --preload /opt/tests/adminExists.js --exec "adminExists()")

if [ "$ADMIN_EXISTS" == "$EXISTENCE" ] ; then
    exit 0
else
    exit 1
fi
