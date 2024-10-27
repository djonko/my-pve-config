#!/bin/bash

set -e  # Exit on any error

echo "Starting Ubuntu server cleanup..."

# 1. Update & Upgrade Packages
echo "Updating and upgrading packages..."
sudo apt update && sudo apt upgrade -y

# 2. Remove Unused Packages
echo "Removing unused packages..."
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean

# 3. Clear Logs
echo "Clearing old logs..."
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=10d
sudo rm -rf /var/log/*.gz
sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;



# 7. Clean Docker (if installed)
if command -v docker &> /dev/null; then
  echo "Cleaning Docker..."
  sudo docker system prune -a --volumes -f
else
  echo "Docker not installed. Skipping Docker cleanup..."
fi

# 8. Remove Old Kernels (Careful!)
echo "Removing old kernels..."
sudo dpkg --list | grep linux-image | awk '{print $2}' | grep -v $(uname -r) | while read -r line; do
  sudo apt purge -y "$line"
done
sudo update-grub

# 9. Clear Cache and Temporary Files
echo "Clearing cache and temporary files..."
sudo find /var/cache -type f -delete
sudo find /tmp -type f -atime +10 -delete

# 10. Show Disk Usage Summary
echo "Disk usage after cleanup:"
df -h

echo "Cleanup completed successfully!"
