#!/bin/bash

array=(ks3-m01 ks3-m02 ks3-m03 ks3-pod01 ks3-pod02)
for i in "${array[@]}"
do
    ssh-keygen -R "$i"
done