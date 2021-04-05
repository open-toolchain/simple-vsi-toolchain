echo "Begin creating the backup script to be executed on the Virtual Server Instance"
WORKDIR=/home/${HOST_USER_NAME}/app
BACKUPDIR=${WORKDIR}_backup
cat > backup.sh << BACKUP_SCRIPT
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
        
BACKUP_SCRIPT
echo "Finished creating the backup script to be executed on the Virtual Server Instance"
