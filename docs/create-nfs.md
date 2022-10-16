# Create an NFS server in ubuntu-server(tested on 22.04)

1) Update the system
```bash
sudo apt update && sudo apt upgrade -y 
```
2) Install nfs-server package

```bash
sudo apt install nfs-kernel-server -y 
```

3) Add some folder to share data. For my own purpose I will use following folders
```bash
sudo mkdir -p /srv/nfs04T01/pve
sudo mkdir -p /srv/nfs04T01/pve/{server_01,server_02}
```
4) change permission of share folder
```bash
sudo chown -R nobody:nogroup /srv/nfs04T01/pve
```



5) We now need to edit the exports file to tell the server what folder and how to share the folder
```bash
sudo nano /etc/exports
```
add those lines:
```text
/srv/nfs04T01/pve/server_01 192.168.20.0/24(rw,sync,no_subtree_check)
/srv/nfs04T01/pve/server_02 192.168.20.0/24(rw,sync,no_subtree_check)
```
6) restart the nfs service after making changes
```shell
sudo systemctl restart nfs-kernel-server
```
