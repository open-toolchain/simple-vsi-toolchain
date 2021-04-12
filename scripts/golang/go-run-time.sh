########################################################################################################
# File: go-run-time.sh                                                                                 #
# Description: set the run time for the GO application. Go is not supported in the ibmcloud base image #
#              thats why we explicity provide a way to get the go packages.                            #
#              This way any dependency can be installed and set in the run time enviroment.            #
#              OR replace the base image via your docker image.                                        # 
#              Python, maven, Gradle , npm are supported app in the base image.                        #
########################################################################################################

curl -L https://golang.org/dl/go1.16.2.linux-amd64.tar.gz --output go1.16.2.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz && rm -rf go1.16.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
apt update && apt install -y curl gcc jq
export PATH=$PATH:~/go/bin
go version
