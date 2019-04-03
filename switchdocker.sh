#! /bin/bash

USE_REMOTE_DOCKER_FILE=~/.useRemoteDocker

#Defining which daemon will be used
if [ -f $USE_REMOTE_DOCKER_FILE ]
then
	USE_REMOTE_DOCKER=$(<$USE_REMOTE_DOCKER_FILE)
else
  	USE_REMOTE_DOCKER=0
fi

#Updating file to switch docker ref
if [ $USE_REMOTE_DOCKER = 1 ]
then
  	echo 0 > $USE_REMOTE_DOCKER_FILE
  	echo "Docker will now use the local daemon"
else
  	echo 1 > $USE_REMOTE_DOCKER_FILE
  	echo "Docker will now use the remote daemon"
fi
