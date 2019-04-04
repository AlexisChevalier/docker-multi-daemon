#! /bin/bash

set -eu

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

USE_REMOTE_DOCKER_FILE=~/.useRemoteDocker

# PATH TO YOUR HOSTS FILE
: ${ETC_HOSTS="/etc/hosts"}

# DEFAULT IP FOR HOSTNAME
DEFAULT_IP="127.0.0.1"
REMOTE_IP="<REMOTE-IP>"
HOST_NAME="docker-host.local"

VERBOSE=false

function removeHost() {
    local HOSTNAME=$1
    local HOST_REGEX="\(\s\+\)${HOSTNAME}\s*$"
    local HOST_LINE="$(grep -e "${HOST_REGEX}" ${ETC_HOSTS})"
    
    if [ -n "${HOST_LINE}" ]; then
        [ ${VERBOSE} == true ] && echo "${HOSTNAME} Found in your ${ETC_HOSTS}, Removing now..."
        sed -i '' "/${HOSTNAME}/d" /etc/hosts
        #sed -i '' -e "s/${HOST_REGEX}/\1/g" -e "/^[^#][0-9\.]\+\s\+$/d" ${ETC_HOSTS}
    else
        [ ${VERBOSE} == true ] && echo "${HOSTNAME} was not found in your ${ETC_HOSTS}";
    fi
}

function addHost() {
    local HOSTNAME=$1
    local IP=${2:-${DEFAULT_IP}}

    local HOST_REGEX="\(\s\+\)${HOSTNAME}\s*$"
    local HOST_LINE="$(grep -e "${HOST_REGEX}" ${ETC_HOSTS})"
    
    if [ -n "${HOST_LINE}" ]; then
        [ ${VERBOSE} == true ] && echo "${HOSTNAME} already exists : ${HOST_LINE}"
    else
        [ ${VERBOSE} == true ] && echo "Adding ${HOSTNAME} to your ${ETC_HOSTS}";
        echo -e "${IP}\t${HOSTNAME}" >> ${ETC_HOSTS}
        [ ${VERBOSE} == true ] && echo -e "${HOSTNAME} was added succesfully \n ${HOST_LINE}";
        killall -HUP mDNSResponder;echo DNS cache has been flushed
    fi
}

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
    removeHost $HOST_NAME 
    addHost $HOST_NAME $DEFAULT_IP
  	echo "Docker will now use the local daemon (host $HOST_NAME)"
else
  	echo 1 > $USE_REMOTE_DOCKER_FILE
    removeHost $HOST_NAME 
    addHost $HOST_NAME $REMOTE_IP
  	echo "Docker will now use the remote daemon (host $HOST_NAME)"
fi

# Execute
$@
