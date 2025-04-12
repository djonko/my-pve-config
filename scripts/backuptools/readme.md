# Backup & Restore Script

This script allows you to **backup** and **restore** folders easily while **preserving permissions**.  
It includes **automatic backup rotation** to keep only the latest backups.

---

## 📜 Features

- Backup and restore directories without changing file permissions or ownership
- Default folders to manage:
    - `/opt/data-docker`
    - `/opt/data-etc`
- Save backups in `~/backups`
- Keep only the **last 5 backups** per folder (automatic rotation)
- Supports **custom paths** if needed
- Easy to use with simple commands

---

## 📥 Installation

1. Download or copy the script into a file, e.g. `backup_restore.sh`.
2. Make the script executable:
   ```bash
   chmod +x backup_restore.sh
   ```

---

## ⚙️ Usage

### 1. Backup

**Backup default folders** (`/opt/data-docker` and `/opt/data-etc`):

```bash
./backup_restore.sh backup
```

**Backup custom folders** (you can specify one or more paths):

```bash
./backup_restore.sh backup /path/to/folder1 /path/to/folder2
```

🔹 Backups will be created in `~/backups` with a timestamped `.tar.gz` filename.  
🔹 Only the latest **5 backups** per folder will be kept.

---

### 2. Restore

**Restore default folders** from the latest backup:

```bash
./backup_restore.sh restore
```

**Restore custom folder(s)** (provide the paths you want to restore):

```bash
./backup_restore.sh restore /path/to/folder1 /path/to/folder2
```

🔹 The script restores the latest backup into the original folder by default.  
🔹 If the folder does not exist, it will be created automatically.

---

## 🔄 Backup Rotation

After each backup, the script:
- Lists all backups for the given folder.
- Keeps only the **latest 5 backups**.
- Automatically **deletes older backups** beyond the limit.

You can change the number of backups kept by modifying the `MAX_BACKUPS` value inside the script:

```bash
MAX_BACKUPS=5
```

---

## ❗ Notes

- Make sure to run the script with appropriate permissions if accessing system folders (use `sudo` if needed).
- The script **does not** modify the original folder permissions or ownerships.
- The backup archive files are compressed using `tar.gz` format.
- Each backup filename is timestamped to avoid overwriting previous backups.

---

## 📂 Backup File Format

Backup files are saved with the following pattern:

```
~/backups/<foldername>_backup_<timestamp>.tar.gz
```

Example:
```
~/backups/data-docker_backup_20250412_162300.tar.gz
```

---

## 📋 Example Sessions

**Simple Backup:**

```bash
./backup_restore.sh backup
```

**Backup Specific Folders:**

```bash
./backup_restore.sh backup /etc/nginx /var/www/html
```

**Simple Restore:**

```bash
./backup_restore.sh restore
```

**Restore Specific Folders:**

```bash
./backup_restore.sh restore /etc/nginx /var/www/html
```

---

## 🛠️ Requirements

- Linux system (or WSL / macOS terminal)
- `bash` shell
- Standard `tar` command installed (available by default)

---

## 📞 Support

If you have any issues, suggestions, or want to extend the script (like adding manual cleanup, custom backup folder, or email notifications), feel free to contribute!

