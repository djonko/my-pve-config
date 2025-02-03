#!/bin/bash

# Backup file to restore
BACKUP_FILE="$1"

# Destination directory to restore to
RESTORE_DIR="/opt/data-docker/media_stream/"

# Check if the backup file is provided
if [ -z "$BACKUP_FILE" ]; then
    echo "Usage: $0 <backup_file.tar.gz>"
    exit 1
fi

# Check if the backup file exists
if [ ! -f "$BACKUP_FILE" ]; then
    echo "Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Create the restore directory if it doesn't exist
mkdir -p "$RESTORE_DIR"

# Extract the backup file to the restore directory
tar -xzf "$BACKUP_FILE" -C "$(dirname "$RESTORE_DIR")"

# Check if the restore was successful
if [ $? -eq 0 ]; then
    echo "Restore successful: $RESTORE_DIR"
else
    echo "Restore failed!"
    exit 1
fi