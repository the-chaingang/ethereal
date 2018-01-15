#!/bin/bash

BIN_PATH=/opt/go-ethereum/build/bin
SHARED_DIR=/opt/shared
GENESIS_DIR=/opt/genesis

BOOTNODE_KEY_FILE=boot.key

BOOTNODE=$BIN_PATH/bootnode
GETH=$BIN_PATH/geth

echo "Running ethereal with target: $TARGET"

if [ $TARGET == "bootnode" ] ; then
	echo $(ls -l $SHARED_DIR)
	if [ -z $(ls -l $SHARED_DIR| grep $BOOTNODE_KEY_FILE) ] ; then
		$BOOTNODE -genkey $SHARED_DIR/$BOOTNODE_KEY_FILE
	fi

	$BOOTNODE -nodekey $SHARED_DIR/$BOOTNODE_KEY_FILE $@
elif [ $TARGET == "fullnode" ] ; then
	if [ -z $NODE_NAME ] ; then
		echo "ERROR: Container run with empty NODE_NAME"
		exit 1
	fi

	if [ ! -z $(ls -1 $SHARED_DIR | grep $NODE_NAME) ] ; then
		echo "WARNING: Node with name $NODE_NAME already exists"
	else
		mkdir -p $SHARED_DIR/$NODE_NAME
	fi

	if [ -z $BOOTNODE_ADDRESS ] ; then
		echo "ERROR: BOOTNODE_ADDRESS not specified"
		exit 1
	fi

	if [ -z $BOOTNODE_UDP_PORT ] ; then
		echo "WARNING: BOOTNODE_UDP_PORT not specified - using 30301"
		BOOTNODE_UDP_PORT=30301
	fi

	if [ -z $(ls -1 $GENESIS_DIR | grep $GENESIS_FILE) ] ; then
		echo "ERROR: $GENESIS_FILE not present in genesis directory"
		exit 1
	fi

	echo "GEtting ready to POLL"

	# Wait for bootnode hash to become available
	if [ -z $POLL_INTERVAL ] ; then
		POLL_INTERVAL=1
	fi
	if [ -z $RETRIES ] ; then
		RETRIES=20
	fi
	CURRENT=0
	while true ; do
		echo "wtf -> $SHARED_DIR, $BOOTNODE_KEY_FILE, $(ls -1 $SHARED_DIR | grep $BOOTNODE_KEY_FILE)"

		if [ $CURRENT -eq $RETRIES ] ; then
			exit 1
		fi

		sleep $POLL_INTERVAL
		
		if [ ! -z $(ls -1 $SHARED_DIR | grep $BOOTNODE_KEY_FILE) ] ; then
			break
		fi

		CURRENT=$[$CURRENT+1]
	done

	# At this point, $SHARED_DIR/$BOOTNODE_KEY_FILE exists
	BOOTNODE_PUBLIC_KEY=$($BOOTNODE -nodekey $SHARED_DIR/$BOOTNODE_KEY_FILE -writeaddress)
	BOOTNODE_ENODE_URL="enode://${BOOTNODE_PUBLIC_KEY}@${BOOTNODE_ADDRESS}:${BOOTNODE_UDP_PORT}"

	$GETH --datadir $SHARED_DIR/$NODE_NAME init $GENESIS_DIR/$GENESIS_FILE
	$GETH --datadir $SHARED_DIR/$NODE_NAME --rpcapi "db,eth,net,web3" --rpccorsdomain "http://localhost:8545"  --rpcaddr "0.0.0.0" --rpcport "8545"  --bootnodes $BOOTNODE_ENODE_URL $@
fi