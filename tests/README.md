# `ethereal` tests

This directory contains the `ethereal` unit tests. The tests are grouped in suites, by
network topology and topic. Each suite of tests lives in a distinct subdirectory of
this directory.

To run a particular suite of tests:

1. Determine which `ethereal` image you would like to test. This will either be a
`chaingang/ethereal` image that you have built locally or an
image from our DockerHub page --
[List of available DockerHub tags](https://hub.docker.com/r/chaingang/ethereal/tags/).

1. Save the image tag under the `ETHEREAL_TAG` environment variable.

1. Enter the corresponding subdirectory of this directory.

1. Run `docker-compose up --build --exit-code-from test`.

1. Watch the test run. It will exit with code `0` if the test passed and code `1` otherwise.

1. You can check the exit code after the test has completed using `echo $?`.

1. Run `docker-compose down -v` to clean up after the test has completed.


## Available suites

- [connectivity](./connectivity) - Tests connectivity between two full nodes connected through a
bootnode.

- [rpc-apis](./rpc-apis) - Tests that RPC interface on `geth` nodes can be configured to expose
different management APIs.
