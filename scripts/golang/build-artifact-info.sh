
#########################################################################################################
# File: build-artifact-info.sh                                                                          #
# Description: This File is used to move binary to the appname, which will be used while deploying app. #
#              OBJECTNAME: Name of the binary stored in the Artifactory/COS                             #
#              CHECKSUM: Md5 checksum as a signature of the binary                                      #
#########################################################################################################

cd binaries	

mv go-gin-app ${APPNAME}

OBJECTNAME=binary-`date '+%Y%m%d%H%M%S'`.tar.gz
tar -cf ${OBJECTNAME} *
echo "Object Name of the archive prepared for upload is" ${OBJECTNAME}
          
CHECKSUM=`md5sum $OBJECTNAME | awk '{ print $1 }'`
echo "Checksum of the archive prepared for upload is" ${CHECKSUM}
