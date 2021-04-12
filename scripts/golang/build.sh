######################################################################################
# File: build.sh                                                                     #
# Description: This files is used to complie the app                                 #
######################################################################################

# set the GO run enviroment
source ./scripts-repo/${subpath}/go-run-time.sh

echo “Started compiling the source code.”
go build ./...
echo “Finished compiling the source code.”
