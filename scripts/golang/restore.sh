########################################################################################################
# File: restore.sh                                                                                     #
# Description: Steps required to restore the previos build and deploy it if current deployment fails   #
#              WORKDIR: Directory points to the current build.                                         #
########################################################################################################

WORKDIR=/home/${HOST_USER_NAME}/app
RESTOREFILE=${WORKDIR}/previous_build.info

echo "Begin creating the restore script to be executed on the Virtual Server Instance"

echo "WORKDIR ${WORKDIR}"
echo "RESTOREFILE ${RESTOREFILE}"

if [ -f ${RESTOREFILE} ]; then
    RESTOREDIR=$(head -n 1 ${RESTOREFILE})
    echo "RESTOREDIR is ${RESTOREDIR} "
    echo "Removing the symlink..."
    rm ${WORKDIR}
    echo "Restoring the symlink to previous build..."
    ln -s ${RESTOREDIR} ${WORKDIR}
else
    echo "Previous build info file does not exits"
    exit 1
fi
