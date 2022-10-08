sudo qm create 8000 --memory 2048 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
sudo qm importdisk 8000 jammy-server-cloudimg-amd64.img zfsa
sudo qm set 8000 --scsihw virtio-scsi-pci --scsi0 zfsa:vm-8000-disk-0
sudo qm set 8000 --ide2 zfsa_mp:cloudinit
sudo qm set 8000 --boot c --bootdisk scsi0
sudo qm set 8000 --serial0 socket --vga serial0
