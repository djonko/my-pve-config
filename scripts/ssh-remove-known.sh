#!/bin/bash

array=(ks301 ks302)
for i in "${array[@]}"
do
    ssh-keygen -R "$i"
done