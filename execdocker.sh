#! /bin/bash

EXEC_TYPE="$1"
shift 1

USE_REMOTE_DOCKER_FILE=~/.useRemoteDocker
REMOTE_DAEMON="ssh://user@remotehost"

#Defining which daemon will be used
if [ -f $USE_REMOTE_DOCKER_FILE ]
then
	USE_REMOTE_DOCKER=$(<$USE_REMOTE_DOCKER_FILE)
else
  	USE_REMOTE_DOCKER=0
fi

#Docker opts definition
if [ $USE_REMOTE_DOCKER == 1 ]
then
	echo "[Using remote docker daemon]"
	DOCKER_OPTS="-H=$REMOTE_DAEMON"
else
	echo "[Using local docker daemon]"
	DOCKER_OPTS=""
fi

#Executing proper command
if [ "$EXEC_TYPE" == "docker" ]
then
	docker $DOCKER_OPTS "$@"
elif [ "$EXEC_TYPE" == "compose" ]
then
	docker-compose $DOCKER_OPTS "$@"
else
	echo "Exec '$EXEC_TYPE' is unknown"
fi
