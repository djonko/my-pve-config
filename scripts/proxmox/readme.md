## How to upgrade proxmox lxc Debian 12 to Debian 13

1) backup the container before starting the upgrade process.
2) make sure the container has more than 5gb of free space.
3) log in proxmox host
4) run the script: 
```bash

./update-lxc-container-to-debian13.sh <CTID> [--cleanup]
```