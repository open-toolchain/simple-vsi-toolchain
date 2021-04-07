######################################################################################
# File: health-check.sh                                                              #
# Description: This File is to check the health of the deployed application          #
######################################################################################
set -e
PORT=8081
for i in {1..5}
    do
        echo "Doing Health check. Attempt Number: ${i}"
        if [ "$(curl -s -w "%{http_code}\n"  http://${VIRTUAL_SERVER_INSTANCE}:${PORT}/ -o /dev/null)" == "200" ]; then
            echo "App Health Check passed..."
            echo "Application URL http://${VIRTUAL_SERVER_INSTANCE}:${PORT}/v1/ "
            exit 0
        else
            sleep 1
        fi
    done
echo "Application Health check failed...."
exit 1
