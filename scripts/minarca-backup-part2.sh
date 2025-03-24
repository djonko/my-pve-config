#!/bin/bash

BACKUP_DIR="/mnt/zfsa/ComputersBackups/backups"

# Update Minarca configuration file to set the new base storage directory
CONFIG_FILE="/etc/minarca/minarca-server.conf"
NEW_BASE_DIR="minarca-user-base-dir=${BACKUP_DIR}"

if ! grep -q "$NEW_BASE_DIR" "$CONFIG_FILE"; then
  echo "$NEW_BASE_DIR" | sudo tee -a "$CONFIG_FILE"
  echo "Updated $CONFIG_FILE with new base storage directory."
else
  echo "Base storage directory is already set in $CONFIG_FILE."
fi

# Set ownership and permissions for the new storage directory
sudo chown minarca:minarca ${BACKUP_DIR}
sudo chmod 750 ${BACKUP_DIR}

# Copy .ssh/authorized_keys to the new base storage directory
cp -r /backups/.ssh ${BACKUP_DIR}/

# Change ownership and permissions of the .ssh folder and its contents
sudo chown -R minarca:minarca ${BACKUP_DIR}/.ssh
sudo chmod 700 ${BACKUP_DIR}/.ssh
sudo chmod 600 ${BACKUP_DIR}/.ssh/authorized_keys

# Stop the Minarca server
sudo systemctl stop minarca-server

# Update Minarca user's home directory
sudo usermod -d ${BACKUP_DIR}/ minarca

# Restart the Minarca server
sudo systemctl start minarca-server
