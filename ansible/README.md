# Ansible config

## run playbook command 
`ansible-playbook ./playbooks/{fileToRun}.yml --user {remoteUser} --ask-become-pass -i ./inventory/hosts`

## My playbooks:
- apt.yml : upgrade systeme of all vm machine
- reboot.yml: reboot systems
- remote-docker.yml: enable remote access to docker daemon and restart it