set -e -o pipefail

# This step logs into the Virtual Server Instance based on the credentials provided during the Toolchain creation.
# The step: 
#   - Assumes that the upstream task has already downloaded the artifact to the /output location 
#   - Carries out all the operation within the home directory of the user i.e. /home/${HOST_USER_NAME}
#   - Copies the artifact from the /output to /home/${HOST_USER_NAME}/app which is defined as WORKDIR
#   - Runs the deploy.sh file as created in the previous step to carry out the step-by-step deployment which may include start/stop of application.

WORKDIR=/home/${HOST_USER_NAME}/app
        
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

echo "Removing the existing artifacts from the host machine and taking backup.."
BACKUPDIR=${WORKDIR}_backup
$SSH_CMD ssh $SSH_ARG -o StrictHostKeyChecking=no $HOST_USER_NAME@$VIRTUAL_SERVER_INSTANCE env WORKDIR=$WORKDIR  BACKUPDIR=$BACKUPDIR 'bash -s' < ./pipeline-repo/scripts/backup.sh

echo "Copying the artifacts to the host machine."
$SSH_CMD scp $SSH_ARG -o StrictHostKeyChecking=no ${OBJECTNAME} $HOST_USER_NAME@$VIRTUAL_SERVER_INSTANCE:${WORKDIR}

echo "Extract the new artifacts in the host machine."
$SSH_CMD ssh $SSH_ARG  -o StrictHostKeyChecking=no $HOST_USER_NAME@$VIRTUAL_SERVER_INSTANCE "cd /home/$HOST_USER_NAME/app/ && tar -xf ${OBJECTNAME} && rm ${OBJECTNAME} "

echo "Login to the VSI Instance and process the deployment."
$SSH_CMD ssh $SSH_ARG -o StrictHostKeyChecking=no \
$HOST_USER_NAME@$VIRTUAL_SERVER_INSTANCE env USERID=$USERID TOKEN=$TOKEN REPO=$REPO APPNAME=$APPNAME COSENDPOINT=$COSENDPOINT COSBUCKETNAME=$COSBUCKETNAME OBJECTNAME=$OBJECTNAME WORKDIR=$WORKDIR HOST_USER_NAME=$HOST_USER_NAME 'bash -s' < ./pipeline-repo/scripts/deploy.sh
