#!/bin/bash

array=(pve01 pve02 pihole dashboard docker-ctl ngnix pwd-manager search pod-01 srv100)
for i in "${array[@]}"
do
    ssh-copy-id bobdi@$i
done