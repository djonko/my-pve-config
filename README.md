# my-pve-config 🚀

> Personal homelab configurations for Proxmox VE, Docker, Ansible, Kubernetes, and Linux.

## Overview

This repo is a collection of configurations, scripts, and Docker Compose stacks used to manage a **Proxmox-based homelab**. It covers everything from infrastructure provisioning to self-hosted applications.

## Structure

```
my-pve-config/
├── ansible/            # Ansible playbooks & inventory for VM management
├── docker/             # Docker Compose stacks for self-hosted services
│   ├── apps/           # Individual applications (40+ services)
│   ├── media-stream/   # Media stack (*arr, Jellyfin, torrent, streaming)
│   └── traefik/        # Reverse proxy & SSL (Traefik + DNS challenge)
├── kubernetes/         # K8s & cloud-init templates for Proxmox
├── proxmox/            # Proxmox storage & cluster configs
├── scripts/            # Shell utilities (install, backup, cleanup, GPU, SSH)
├── devices/            # Device-specific configs (auto-cpufreq, Alexa)
└── docs/               # Documentation & how-to guides
```

## 🐳 Docker Applications

### Media Streaming
| Service | Description |
|---------|-------------|
| **Jellyfin** | Media server with NVIDIA GPU transcoding |
| **Radarr** | Movie management |
| **Sonarr** | TV series management |
| **Lidarr** | Music management |
| **Prowlarr** | Indexer management |
| **Bazarr** | Subtitle management |
| **Whisparr** | Adult content management |
| **Jackett** | Torrent indexer proxy |
| **TorrServer** | Torrent streaming |
| **FlareSolverr** | Cloudflare challenge solver |

### Self-Hosted Apps (selected)
- **AI/LLM**: Ollama, AnythingLLM
- **Photos**: Immich
- **Productivity**: Vikunja (tasks), Planka (kanban), Penpot (design), Excalidraw, Wekan
- **Finance**: Ghostfolio, Firefly III, InvoiceShelf, Manager.io
- **Communication**: Mattermost + Jitsi, Mailrise
- **Storage & Sync**: Syncthing, MinIO, FileBrowser, Filestash, Rclone
- **Backup**: Restic, Duplicati, Offen
- **Web**: WordPress, SearXNG, Linkwarden, Docuseal
- **Monitoring**: Grafana, Speedtest
- **Dev Tools**: Proxmox MCP, Portabase, Typesense, ConvertX
- **Other**: Gotify (notifications), Radicale (CalDAV/CardDAV), Pingvin Share, Pastefy, IT-Tools

### Infrastructure
- **Traefik** — Reverse proxy with Let's Encrypt (DNS challenge via Dynu)
- **Watchtower** — Automatic container updates
- **WebDAV** — File access over WebDAV

## 🤖 Ansible

Playbooks for managing VMs across multiple Proxmox nodes:

| Playbook | Purpose |
|----------|---------|
| `apt.yml` | System upgrade on all VMs |
| `reboot.yml` | Reboot systems |
| `remote-docker.yml` | Enable Docker daemon remote access |
| `timezone.yml` | Configure timezone |
| `disable-ipv6.yml` | Disable IPv6 |
| `iftop.yml` | Install iftop |

**Inventory groups**: `pve01-vm`, `pve02-vm`, `omv-vm`

### Quick Start
```bash
# Start SSH agent and add your key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/your-private-key

# Run a playbook
ansible-playbook ./playbooks/apt.yml \
  --user <remoteUser> \
  --ask-become-pass \
  -i ./inventory/hosts \
  --key-file "~/.ssh/your-private-key"
```

## 📜 Scripts

Shell utilities for common homelab tasks:

- **System setup**: `debian-install-docker.sh`, `ubuntu-install-docker.sh`
- **Proxmox**: cloud image creation, LXC container setup, subscription removal
- **GPU**: `install-nvidia.sh`, `install-nvidia-lxc.sh`
- **Backup**: `backup-dir.sh`, `db-restore.sh`, `minarca-backup.sh`
- **Maintenance**: `cleanup-debian.sh`, `upgrade-ubuntu.sh`
- **SSH**: `ssh-copy-id.sh`, `ssh-remove-known.sh`

See [`scripts/proxmox/`](scripts/proxmox/) for Proxmox-specific scripts.

## ☸️ Kubernetes

Scripts for creating Ubuntu cloud-init VM templates on Proxmox:
- `create-template-ubuntu.cloud.sh` — Build a reusable Ubuntu template

## 📖 Documentation

- [Proxmox Storage Config](docs/proxmox-config.md)
- [Jellyfin Setup](docs/jellyfin.md)
- [Create NFS Share](docs/create-nfs.md)
- [Mount NFS in LXC](docs/how-to-mount-nfs-lcx-proxmox.md)
- [Kernel Auto-Recovery](docs/how-to-configure-kernel-auto-recovery.md)
- [auto-cpufreq Config](devices/linux/auto-cpufreq/auto-cpufreq.md)

## 💾 Storage

| Device | Size | Mount Point | Purpose |
|--------|------|-------------|---------|
| NVME | 256 GB | `/var/lib/vz` | Proxmox templates, ISOs, VMs |
| SSD | 480 GB | `/mnt/pve/sda480gb` | Additional storage |

## License

This is a personal configuration repo — fork it and adapt it for your own homelab!
