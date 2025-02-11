#!/bin/bash
sudo apt install apt-transport-https ca-certificates curl lsb-release gpg git nano wget openssh-server -y

sudo curl -L https://www.ikus-soft.com/archive/minarca/public.key | sudo gpg --dearmor -o /usr/share/keyrings/minarca-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/minarca-keyring.gpg] https://nexus.ikus-soft.com/repository/apt-release-$(lsb_release -sc)/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/minarca.list > /dev/null

sudo apt install minarca-server -y



# Update Minarca configuration file to set the new base storage directory
CONFIG_FILE="/etc/minarca/minarca-server.conf"
NEW_BASE_DIR="minarca-user-base-dir=/mnt/backups"

if ! grep -q "$NEW_BASE_DIR" "$CONFIG_FILE"; then
  echo "$NEW_BASE_DIR" | sudo tee -a "$CONFIG_FILE"
  echo "Updated $CONFIG_FILE with new base storage directory."
else
  echo "Base storage directory is already set in $CONFIG_FILE."
fi

# Set ownership and permissions for the new storage directory
sudo chown minarca:minarca /mnt/backups
sudo chmod 750 /mnt/backups

# Copy .ssh/authorized_keys to the new base storage directory
cp -r /backups/.ssh /mnt/backups/

# Change ownership and permissions of the .ssh folder and its contents
sudo chown -R minarca:minarca /mnt/backups/.ssh
sudo chmod 700 /mnt/backups/.ssh
sudo chmod 600 /mnt/backups/.ssh/authorized_keys

# Stop the Minarca server
sudo systemctl stop minarca-server

# Update Minarca user's home directory
sudo usermod -d /mnt/backups/ minarca

# Restart the Minarca server
sudo systemctl start minarca-server
