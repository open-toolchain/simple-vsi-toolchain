##################################################################################################################
# File: backup.sh                                                                                                #
# Description: This files creates a backup of the already running app                                            #
#              BUILDDIR: Directory containing the artifacts related to currently deployed/running application    #
#              WORKDIR: Directory points to the current build.                                                   #
#              The script check if there any other app which is runing, if yes then store the previous running   #
#              app details in a file (RESTOREFILE)                                                               #            
##################################################################################################################
WORKDIR=/home/${HOST_USER_NAME}/app
BUILDDIR=/home/${HOST_USER_NAME}/${PIPELINERUNID}
RESTOREFILE=${WORKDIR}/previous_build.info

echo "Begin creating the backup script to be executed on the Virtual Server Instance"

echo "WORKDIR is ${WORKDIR}"
echo "BUILDDIR is ${BUILDDIR}"
echo "RESTOREFILE is ${RESTOREFILE}"

echo "Check if the app directory and a symlink exists"
if [ -d ${WORKDIR} ]; then

    echo "Application Directory [${WORKDIR}] exists."
    echo "Capturing the existing symlink of the build directory."
    OLDLINK=$(readlink -f ${WORKDIR})
    echo "removing the existing symlink of the build directory."
    rm ${WORKDIR} || echo "No Existing Symlink Exists."
    echo "Creating the new symlink of the build directory."
    ln -s ${BUILDDIR} ${WORKDIR}
    echo ${OLDLINK} >>${RESTOREFILE}
else
    echo "Creating the new symlink of the build directory."
    ln -s ${BUILDDIR} ${WORKDIR}
fi

echo "Finished creating the backup script to be executed on the Virtual Server Instance"
