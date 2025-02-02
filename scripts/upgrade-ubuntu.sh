sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

#  Remove Unnecessary Packages
sudo apt autoremove --purge -y

# Do the release
sudo do-release-upgrade

# Clean after
sudo apt autoremove --purge -y
sudo apt clean