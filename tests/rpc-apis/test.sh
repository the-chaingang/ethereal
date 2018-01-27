#!/bin/bash

# Leave some time for HTTP endpoints to open
sleep 1

set -eux -o pipefail

# Assert variables are defined (thanks to "set -u")
RPC_URL_1=$RPC_URL_1
RPC_URL_2=$RPC_URL_2

bash /opt/tests/test-node.sh $RPC_URL_1 false
bash /opt/tests/test-node.sh $RPC_URL_2 true

exit 0
