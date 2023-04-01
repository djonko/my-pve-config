# Ansible config

## run playbook command 
`ansible-playbook ./playbooks/{fileToRun}.yml --user {remoteUser} --ask-become-pass -i ./inventory/hosts --key-file "{private-keypath}"`

## My playbooks:
- apt.yml : upgrade systeme of all vm machine
- reboot.yml: reboot systems
- remote-docker.yml: enable remote access to docker daemon and restart it

## steps
- start ssh agent
- add your private-key to ssh
    `ssh-add {private-key}`
- run the command

## trouble shouting 
