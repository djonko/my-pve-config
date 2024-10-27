#!/bin/bash

array=(ks301 ks302 ks303)
for i in "${array[@]}"
do
    ssh-keygen -R "$i"
done