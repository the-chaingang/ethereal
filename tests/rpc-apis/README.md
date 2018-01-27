# Configuring RPC APIs

This test confirms that `ethereal` nodes can be configured independently of each other to expose
different [Ethereum Management APIs](https://github.com/ethereum/go-ethereum/wiki/Management-APIs)
over the JSON-RPC port.

There are two nodes in the test network:

1. `node-1` is a `geth` node, spun up to expose the JSON-RPC server in its default configuration
which does not expose the `admin` API.

2. `node-2` is a `geth` node, spun up to expose the JSON-RPC server in a configuration which exposes
the `admin` API.

The [tests](./test.sh) check that:

1. The `admin` API *is not* accessible when a `geth` client attaches to `node-1` through the
JSON-RPC API.

2. The `admin` API *is* accessiblye when a `geth` client attaches to `node-2` through the JSON-RPC
API.

Note that configuring `node-2` to expose the `admin` API was as simple as passing the

```
--rpcapi <other apis>,admin
```

to the node at runtime (see `node-2` definition in the [manifest](./docker-compose.yaml)).
