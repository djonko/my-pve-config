#!/bin/bash

# Exemple:
#  create_cif_entry.fstab.sh loginuser 192.168.0.0 pihole-202
#
USER_RUNNER=$1
SERVER_NAS=$2
HOST_IDNAME=$3
NAS_DIR_BKP=/mnt/zfsa/disks/docker-disk/restic-backups
LOCAL_NFS_PATH=/mnt/nfs/restic

echo "create an entry inside fstab"
sudo apt install nfs-common
mkdir -p $HOME/.restric/
touch  $HOME/.restric/restic.env


sudo mkdir -p $LOCAL_NFS_PATH
sudo chown -R "$USER_RUNNER":"$USER_RUNNER" $LOCAL_NFS_PATH
echo " copy & paste this for next command"
echo "${SERVER_NAS}:${NAS_DIR_BKP}               ${LOCAL_NFS_PATH}     nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0"
read -n 1 -s -r -p "Press any key to continue"
sudo nano /etc/fstab
sudo mount $LOCAL_NFS_PATH
sudo df -ah
echo "Press 'y' to continue or 'n' to exit."
# Wait for the user to press a key
read -s -n 1 key
case $key in
    y|Y)
        echo "Continuing..."
        ;;
    n|N)
        echo "Exiting..."
        exit 1
        ;;
    *)
        echo "Invalid input. Please press 'y' or 'n'."
        ;;
esac
mkdir -p $LOCAL_NFS_PATH/"$HOST_IDNAME"/backups
mkdir -p $LOCAL_NFS_PATH/"$HOST_IDNAME"/restore-dir
