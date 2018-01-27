#!/bin/bash

set -e -u -o pipefail

# Parameters:
# 1. IDENTITY - Test identifier; a name which will make it easy to identify logs for this test in your console
# 2. SIGNAL_DIR - Directory in which to poll for signalling files
# 3. POLL_INTERVAL - Seconds to wait between polls
# 4. POLL_ATTEMPTS - Maximum number of attempted polls of the signalling directory
# 5. TEST_SCRIPT - Script in which tests are defined; to be run after all signals have successfully been detected
#
# Command line arguments:
# A list of files to poll the $SIGNAL_DIR for

IDENTITY=$IDENTITY
SIGNAL_DIR=$SIGNAL_DIR
POLL_INTERVAL=${POLL_INTERVAL:-1}
POLL_ATTEMPTS=${POLL_ATTEMPTS:-5}
TEST_SCRIPT=${TEST_SCRIPT}

ATTEMPTS=0
while true ; do
	echo "$IDENTITY: Poll $[$ATTEMPTS+1]/$POLL_ATTEMPTS"

	if [ $ATTEMPTS -eq $POLL_ATTEMPTS ] ; then
		echo "$IDENTITY: Maximum polls exceeded"
		exit 1
	elif [ $# -eq 0 ] ; then
		echo "$IDENTITY: No signal expected"
		break
	else
		NUM_SIGNALS=0
		for SIGNAL in $@ ; do
			if [ -e "$SIGNAL_DIR/$SIGNAL" ] ; then
				NUM_SIGNALS=$[$NUM_SIGNALS+1]
			fi
		done
		
		if [ $NUM_SIGNALS -eq $# ] ; then
			echo "$IDENTITY: All signals detected - $@"
			break
		fi

		sleep $POLL_INTERVAL
		ATTEMPTS=$[$ATTEMPTS+1]
	fi
done

bash $TEST_SCRIPT
