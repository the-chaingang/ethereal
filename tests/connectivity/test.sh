NODES=( "node-1" "node-2" )

for NODE in ${NODES[@]} ; do
	NUM_PEERS=$(/opt/go-ethereum/build/bin/geth --verbosity 0 attach ipc:/opt/shared/$NODE/geth.ipc --exec "(function() {return admin.peers.length})()")
	echo "Node $NODE has $NUM_PEERS peers"
	if [ $NUM_PEERS -ne 1 ] ; then
		exit 1
	fi
done

exit 0
