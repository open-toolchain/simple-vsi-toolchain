# set the GO run enviroment
source ./scripts/go-run-time.sh

cd binaries	

OBJECTNAME=binary-`date '+%Y%m%d%H%M%S'`.tar.gz
tar -cf ${OBJECTNAME} *
echo "Object Name of the archive prepared for upload is" ${OBJECTNAME}
          
CHECKSUM=`md5sum $OBJECTNAME | awk '{ print $1 }'`
echo "Checksum of the archive prepared for upload is" ${CHECKSUM}
