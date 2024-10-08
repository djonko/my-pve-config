#!/bin/bash
## How to run it
## > ./create-debian-cloud-image.sh bobdi 10G 2048

NXT=$((0+1))
HD_SIZE=$2
USER_HOME_NAME=$1
MEM=$3
HOME_USER="/home/$USER_HOME_NAME"
WORK_DIR="$HOME_USER/tmp/cloudImage"
DOWNLOAD_URL="https://cloud-images.ubuntu.com/lunar/current/lunar-server-cloudimg-amd64-disk-kvm.img"
IMG_NAME="lunar-server-kvm.qcow2"
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
TEMPL_NAME="ubuntu-cloud"
VMID="9801"

DISK_SIZE=$HD_SIZE
DISK_STOR="local"
NET_BRIDGE="vmbr0"
#SSH_PUB="$HOME_USER/.ssh/id_ed25519.pub"
MY_DNS=""
MY_DOMAIN=""

#qm create $VMID --name $TEMPL_NAME --memory $MEM --net0 virtio,bridge=$NET_BRIDGE --localtime true --nameserver $MY_DNS --searchdomain $MY_DOMAIN
qm create $VMID --name $TEMPL_NAME --memory $MEM --net0 virtio,bridge=$NET_BRIDGE --localtime true
qm importdisk $VMID $IMG_NAME $DISK_STOR
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $DISK_STOR:vm-$VMID-disk-0
qm set $VMID --ide2 $DISK_STOR:cloudinit --boot c --bootdisk scsi0 --serial0 socket --vga serial0
qm set $VMID --ipconfig0 ip=dhcp
#qm set $VMID --sshkey "$SSH_PUB"
qm set $VMID --agent enabled=1
qm resize $VMID scsi0 "$DISK_SIZE"
qm template $VMID
rm $IMG_NAME

NXT=$((NXT+1))
echo "Step $NXT:  END"