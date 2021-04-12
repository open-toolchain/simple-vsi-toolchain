##########################################################################################
# File: cleanup.sh                                                                       #
# Description: Run the cleanup script to clean previous build                            #
#              WORKDIR: Directory points to the current build.                           #
##########################################################################################

WORKDIR=/home/${HOST_USER_NAME}/app

echo "WORKDIR is [$WORKDIR]"
if [[ -z "$HOST_USER_NAME" ]]; then
    echo "Please provide User name to log on to Virtual Server Instance"
    exit 1;
elif [[ ! -z "$HOST_PASSWORD" ]]; then
    echo "Using SSH Password to log on to Virtual Server Instance"
    sudo apt-get update && sudo apt-get install sshpass -y
    SSH_CMD="sshpass -p $HOST_PASSWORD"
    SSH_ARG="-o UserKnownHostsFile=/dev/null"
elif [[ ! -z "$HOST_SSH_KEYS" ]]; then
    echo "Using SSH Key to log on to Virtual Server Instance"
    echo $HOST_SSH_KEYS | base64 -d  > vsi.key
    chmod 400 vsi.key
    SSH_ARG="-i vsi.key"
else
    echo "Please provide either SSH Password or SSH Key provided to log on to Virtual Server Instance."
    exit 1;
fi

$SSH_CMD ssh $SSH_ARG -o StrictHostKeyChecking=no $HOST_USER_NAME@$VIRTUAL_SERVER_INSTANCE  env RESTOREFILE=$RESTOREFILE HOST_USER_NAME=$HOST_USER_NAME  'bash -s' < ./scripts-repo/${subpath}/cleanup.sh
          