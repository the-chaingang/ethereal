# `connectivity` test

The goal of this test is to bring up two fullnodes along with a bootnode, and test (and verify) that fullnodes are peers to each other.

This proves that Ethereal framwork can be used to reliably bring multiple nodes that can network with each other as peers.

# How to run 
`docker-compose up --build --exit-code-from test`

## Expected output
`connectivity_test_1 exited with code 0`