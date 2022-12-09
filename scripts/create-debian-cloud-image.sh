#!/bin/bash
NXT=$((0+1))
USER_HOME_NAME=$1
HOME_USER="/home/$USER_HOME_NAME"
WORK_DIR="$HOME_USER/tmp/cloudImage"
DOWNLOAD_URL="https://cdimage.debian.org/cdimage/cloud/bullseye/latest/debian-11-generic-amd64.qcow2"
IMG_NAME="debian-11-generic-amd64.qcow2"
## Step 1: Download the image
echo "Step $NXT"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || exit
# If file not exist then download it
if [ ! -f "$IMG_NAME" ]; then
wget -O $IMG_NAME $DOWNLOAD_URL
fi

## Step 2: Add QEMU Guest Agent
NXT=$((NXT+1))
echo "Step $NXT"
apt update
apt install -y libguestfs-tools
virt-customize --install qemu-guest-agent -a $IMG_NAME
NXT=$((NXT+1))
echo "Step $NXT"

## Step 3: Create a VM in Proxmox with required settings and convert to template
TEMPL_NAME="debian11-cloud"
VMID="9900"
MEM="512"
DISK_SIZE=5G
DISK_STOR="zfsa"
NET_BRIDGE="vmbr0"
SSH_PUB="$HOME_USER/.ssh/id_ed25519.pub"
MY_DNS="192.168.20.2"
MY_DOMAIN="ui24.mywire.com"

qm create $VMID --name $TEMPL_NAME --memory $MEM --net0 virtio,bridge=$NET_BRIDGE --localtime true --nameserver $MY_DNS --searchdomain $MY_DOMAIN
qm importdisk $VMID $IMG_NAME $DISK_STOR
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $DISK_STOR:vm-$VMID-disk-0
qm set $VMID --ide2 $DISK_STOR:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0
qm set $VMID --ipconfig0 ip=dhcp
qm set $VMID --sshkey "$SSH_PUB"
qm set $VMID --agent enabled=1
qm resize $VMID scsi0 "$DISK_SIZE"
qm template $VMID
#rm $IMG_NAME

NXT=$((NXT+1))
echo "Step $NXT:  END"