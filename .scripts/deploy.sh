echo "Begin creating the deploy script to be executed on the Virtual Server Instance"
# Steps required to deploy your application to the Virtual Server Instance goes here.
# This step creates a temporary file with name deploy.sh and runs the file on the host as part of deployment process.
# You may modify the contents of the script present between DEPLOY_SCRIPT tags to script the steps needed to carry out
# a deployment. These steps may require:
#   - Stopping the running application or web server
#   - Cleaning up / Backing up the previous
#   - Starting the application or web server with new binary

#!/bin/bash
cd ${WORKDIR}/
        
DeployApplication() {
    PID=`pgrep -f "java -Dserver.port=8080 -Dserver.address=0.0.0.0 -jar $APPNAME.jar " || true;`
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
    if [ -s /home/${HOST_USER_NAME}/app/$APPNAME.jar ]; then
        nohup java -Dserver.port=8080 -Dserver.address=0.0.0.0  -jar /home/${HOST_USER_NAME}/app/$APPNAME.jar > /dev/null 2>&1 &
        echo "Successfully deployed the app to VSI Instance"
    else
        echo "Artifact is not available."
        exit 1;
    fi
}
DeployApplication
# Deployment script ends here.
echo "Finished creating the deploy script to be executed on the Virtual Server Instance"
