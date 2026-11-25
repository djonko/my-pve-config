#!/usr/bin/env bash
set -Eeuo pipefail

############################
# Configuration
############################

APP_USER="accounting"
APP_NAME="Manager"
SOURCE_DIR="/home/${APP_USER}/.config/Manager"
BACKUP_ROOT="/opt/backups/manager"
RETENTION_DAYS=30
LOG_FILE="/var/log/manager-backup.log"

# Gotify placeholders
# Example:
# GOTIFY_URL="https://gotify.example.com/message"
# GOTIFY_TOKEN="YOUR_TOKEN"
GOTIFY_URL=""
GOTIFY_TOKEN=""

############################
# Helpers
############################

timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}

log() {
  local msg="$1"
  echo "[$(timestamp)] $msg" | tee -a "$LOG_FILE"
}

send_gotify() {
  local title="$1"
  local message="$2"
  local priority="${3:-5}"

  if [[ -z "$GOTIFY_URL" || -z "$GOTIFY_TOKEN" ]]; then
    log "Gotify not configured. Skipping notification."
    return 0
  fi

  curl -fsS -X POST \
    -H "Content-Type: application/json" \
    "${GOTIFY_URL}?token=${GOTIFY_TOKEN}" \
    -d "$(printf '{"title":"%s","message":"%s","priority":%s}' \
      "$title" "$message" "$priority")" \
    >/dev/null || log "Failed to send Gotify notification."
}

cleanup_on_error() {
  local exit_code=$?
  log "Backup failed with exit code ${exit_code}."
  send_gotify "Manager backup failed" \
    "The backup on $(hostname) failed. Check ${LOG_FILE}." 8
  exit "$exit_code"
}
trap cleanup_on_error ERR

require_root() {
  if [[ "${EUID}" -ne 0 ]]; then
    echo "This script must run as root."
    exit 1
  fi
}

check_source_exists() {
  if [[ ! -d "$SOURCE_DIR" ]]; then
    log "Source directory not found: $SOURCE_DIR"
    exit 1
  fi
}

check_active_xrdp_sessions() {
  # Looks for active xrdp sessions owned by APP_USER.
  # If one exists, abort to avoid backing up while someone is using the app.
  local active_sessions
  active_sessions="$(loginctl list-sessions --no-legend 2>/dev/null | awk '{print $1}')"

  local found=0
  for sid in $active_sessions; do
    local name state remote service
    name="$(loginctl show-session "$sid" -p Name --value 2>/dev/null || true)"
    state="$(loginctl show-session "$sid" -p State --value 2>/dev/null || true)"
    remote="$(loginctl show-session "$sid" -p Remote --value 2>/dev/null || true)"
    service="$(loginctl show-session "$sid" -p Service --value 2>/dev/null || true)"

    if [[ "$name" == "$APP_USER" && "$state" == "active" && "$service" == "xrdp-sesman" ]]; then
      log "Active xRDP session detected for user ${APP_USER} (session ${sid}). Aborting backup."
      exit 1
    fi
  done

  # Extra fallback check for xrdp processes owned by the user.
  if pgrep -u "$APP_USER" -f 'xrdp|xorgxrdp|Xorg.*xrdp' >/dev/null 2>&1; then
    log "xRDP-related process still running for ${APP_USER}. Aborting backup."
    exit 1
  fi
}

stop_manager_if_running() {
  if pgrep -u "$APP_USER" -f 'Manager|ManagerServer' >/dev/null 2>&1; then
    log "Manager process detected. Attempting graceful stop."
    pkill -u "$APP_USER" -f 'Manager|ManagerServer' || true
    sleep 5
  fi

  if pgrep -u "$APP_USER" -f 'Manager|ManagerServer' >/dev/null 2>&1; then
    log "Manager still running. Forcing stop."
    pkill -9 -u "$APP_USER" -f 'Manager|ManagerServer' || true
    sleep 2
  fi

  if pgrep -u "$APP_USER" -f 'Manager|ManagerServer' >/dev/null 2>&1; then
    log "Unable to stop Manager. Aborting backup."
    exit 1
  fi

  log "No Manager process running."
}

double_check_files_not_open() {
  if lsof +D "$SOURCE_DIR" 2>/dev/null | grep -q .; then
    log "Files under ${SOURCE_DIR} are still open. Aborting backup."
    exit 1
  fi
  log "No open files detected under ${SOURCE_DIR}."
}

run_backup() {
  local host ts backup_dir latest_link archive_name archive_path
  host="$(hostname -s)"
  ts="$(date '+%Y%m%d-%H%M%S')"
  backup_dir="${BACKUP_ROOT}/${host}-${ts}"
  latest_link="${BACKUP_ROOT}/latest"

  mkdir -p "$backup_dir"
  mkdir -p "$BACKUP_ROOT"

  log "Starting rsync backup to ${backup_dir}"
  rsync -aHAX --delete \
    "${SOURCE_DIR}/" \
    "${backup_dir}/"

  archive_name="${host}-${ts}.tar.gz"
  archive_path="${BACKUP_ROOT}/${archive_name}"

  log "Creating compressed archive ${archive_path}"
  tar -C "$backup_dir" -czf "$archive_path" .

  ln -sfn "$backup_dir" "$latest_link"

  log "Backup completed successfully."
  log "Backup directory: ${backup_dir}"
  log "Archive created: ${archive_path}"
}

apply_retention() {
  log "Applying retention: deleting backups older than ${RETENTION_DAYS} days."
  find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d -name '*-[0-9]*' -mtime +"$RETENTION_DAYS" -exec rm -rf {} +
  find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type f -name '*.tar.gz' -mtime +"$RETENTION_DAYS" -delete
}

main() {
  require_root
  check_source_exists

  touch "$LOG_FILE"
  chmod 640 "$LOG_FILE"

  log "========== Manager backup job started =========="
  check_active_xrdp_sessions
  stop_manager_if_running
  double_check_files_not_open
  run_backup
  apply_retention
  send_gotify "Manager backup success" \
    "Backup completed successfully on $(hostname). Source: ${SOURCE_DIR}. Destination: ${BACKUP_ROOT}" 4
  log "========== Manager backup job finished =========="
}

main "$@"