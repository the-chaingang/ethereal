#!/bin/bash

set -eu -o pipefail

# Assert variables are defined (thanks to "set -u")
RPC_URL_1=$RPC_URL_1
RPC_URL_2=$RPC_URL_2

bash /opt/tests/test-node.sh $RPC_URL_1 false
bash /opt/tests/test-node.sh $RPC_URL_2 true

exit 0
