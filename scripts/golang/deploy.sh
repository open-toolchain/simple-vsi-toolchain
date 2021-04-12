##########################################################################################
# Steps required to deploy your application to the Virtual Server Instance goes here.    #
# These steps may require:                                                               #
#   - Stopping the running application or web server                                     #
#   - Cleaning up / Backing up the previous                                              #
#   - Starting the application or web server with new binary                             #   
##########################################################################################

#!/bin/bash        
echo "Begin creating the deploy script to be executed on the Virtual Server Instance"
cd ${WORKDIR}/
DeployApplication() {
    PID=`pgrep -f  $APPNAME || true;`
    if [ -n "$PID" ]; then
        echo "Stopping the application"
        echo "The process with PID $PID will be terminated."
        kill $PID
        if [ $? == 0 ]; then
            echo "Successfully terminated process"
        else
            echo "Error terminating process"
        fi
    fi
    echo "Starting the application"
    if [ -s /home/${HOST_USER_NAME}/app/$APPNAME ]; then
        nohup /home/${HOST_USER_NAME}/app/$APPNAME > /dev/null 2>&1 &
        echo "Successfully deployed the app to VSI Instance"
    else
        echo "Artifact is not available."
        exit 1;
    fi
}
DeployApplication
echo "Finished creating the deploy script to be executed on the Virtual Server Instance"
