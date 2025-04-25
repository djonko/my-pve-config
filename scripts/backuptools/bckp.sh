#!/bin/bash

set -euo pipefail

# Default source paths
DEFAULT_PATHS=("/opt/data-docker" "/opt/data-etc")

# Backup destination
BACKUP_DIR="$HOME/backups"
mkdir -p "$BACKUP_DIR"

# How many backups to keep per path
MAX_BACKUPS=5

# Timestamp for backup files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Usage
usage() {
    echo "Usage: $0 {backup|restore} [optional_paths...]"
    exit 1
}

# Rotate backups function
rotate_backups() {
    local base_name="$1"
    local backups
    backups=($(ls -t "$BACKUP_DIR" | grep "^${base_name}_backup_.*\.tar\.gz$" || true))

    if [ "${#backups[@]}" -le "$MAX_BACKUPS" ]; then
        return
    fi

    # Remove oldest backups
    for ((i=MAX_BACKUPS; i<${#backups[@]}; i++)); do
        echo "Removing old backup: ${backups[$i]}"
        rm -f "$BACKUP_DIR/${backups[$i]}"
    done
}

# Backup function
backup() {
    local paths=("${@:-${DEFAULT_PATHS[@]}}")
    for path in "${paths[@]}"; do
        if [ ! -d "$path" ]; then
            echo "Warning: Path $path does not exist, skipping."
            continue
        fi
        base_name=$(basename "$path")
        backup_file="$BACKUP_DIR/${base_name}_backup_$TIMESTAMP.tar.gz"
        tar czpf "$backup_file" -C "$(dirname "$path")" "$base_name"
        echo "Backed up $path to $backup_file"
        rotate_backups "$base_name"
    done
}

# Restore function
restore() {
    local paths=("${@:-${DEFAULT_PATHS[@]}}")
    for path in "${paths[@]}"; do
        base_name=$(basename "$path")
        latest_backup=$(ls -t "$BACKUP_DIR" | grep "^${base_name}_backup_.*\.tar\.gz$" | head -n1)
        if [ -z "$latest_backup" ]; then
            echo "No backup found for $base_name."
            continue
        fi
        if [ ! -d "$path" ]; then
            echo "Warning: Destination $path does not exist. Creating it."
            mkdir -p "$path"
        fi
        tar xzpf "$BACKUP_DIR/$latest_backup" -C "$(dirname "$path")"
        echo "Restored $path from $latest_backup"
    done
}

# Main logic
if [ $# -lt 1 ]; then
    usage
fi

ACTION=$1
shift

case "$ACTION" in
    backup)
        backup "$@"
        ;;
    restore)
        restore "$@"
        ;;
    *)
        usage
        ;;
esac
