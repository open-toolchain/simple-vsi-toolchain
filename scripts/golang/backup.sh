######################################################################################
# File: backup.sh                                                                    #
# Description: This files creates a backup of the already running app                #
######################################################################################
echo "Begin creating the backup script to be executed on the Virtual Server Instance"
if [ -d "$WORKDIR" ]; then
    echo "Application Directory [$WORKDIR] exists"
    if [ -d "$BACKUPDIR" ]; then
        echo "Application Backup Directory [$BACKUPDIR ]exists"
        rm -rf $BACKUPDIR
    fi
        echo "Moving Application Directory [$WORKDIR] to Application Backup Directory [$BACKUPDIR]"
        mv $WORKDIR $BACKUPDIR
fi
echo "Creating new Application Direcroty [$WORKDIR]"
mkdir -p $WORKDIR
echo "Finished creating the backup script to be executed on the Virtual Server Instance"
