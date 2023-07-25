#!/bin/bash
HOST_N=$1
MYVM_PATH=/home/"$USER"/"$HOST_N"

if [ ! -d "$MYVM_PATH" ]; then
  mkdir "$MYVM_PATH"
fi
sudo vmhgfs-fuse .host:/"$HOST_N" "$MYVM_PATH" -o allow_other -o uid="$UID"