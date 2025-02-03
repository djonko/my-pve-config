#!/bin/bash

# Source directory to be backed up
SOURCE_DIR="/opt/data-docker/media_stream/"

# Backup destination directory
BACKUP_DIR="/backup/media_stream_backups/"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup file name
BACKUP_FILE="${BACKUP_DIR}media_stream_backup_${TIMESTAMP}.tar.gz"

# Create the backup
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi

# Optional: Delete backups older than 7 days
find "$BACKUP_DIR" -type f -name "media_stream_backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "Old backups older than 7 days have been deleted."