#!/usr/bin/env bash
#
# Unban my current public IP from CrowdSec decisions
# Simple + robust version – 2025
#

set -euo pipefail

LOGFILE="/var/log/crowdsec-unban.log"
CONTAINER="crowdsec"

# ──── Logging ────────────────────────────────────────────────
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')  $*" >> "$LOGFILE"
}

# ──── Get public IP with fallback ────────────────────────────
get_ip() {
    local ip

    # Preferred services (fast + reliable)
    for url in \
        "https://ifconfig.me" \
        "https://api.ipify.org" \
        "https://icanhazip.com"; do

        ip=$(curl -s --connect-timeout 5 --max-time 8 "$url" 2>/dev/null | tr -d ' \n\r') || continue

        # Very basic IPv4 check
        if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            echo "$ip"
            return 0
        fi
    done

    log "ERROR: Could not determine public IP"
    exit 1
}

# ──── Main ───────────────────────────────────────────────────
PUBLIC_IP=$(get_ip)
log "Public IP detected: $PUBLIC_IP"

# Is crowdsec container actually running?
if ! docker ps --filter name="^${CONTAINER}$" -q | grep -q .; then
    log "ERROR: Container '${CONTAINER}' not found or not running"
    exit 1
fi

# ──── Remove decision(s) ─────────────────────────────────────
if docker exec "${CONTAINER}" cscli decisions list -i "${PUBLIC_IP}" | grep -q .; then
    if docker exec "${CONTAINER}" cscli decisions delete -i "${PUBLIC_IP}" >/dev/null 2>&1; then
        log "SUCCESS: Removed ban for ${PUBLIC_IP}"
    else
        log "ERROR: Failed to delete decision for ${PUBLIC_IP}"
        exit 2
    fi
else
    log "No active ban found for ${PUBLIC_IP}"
fi

exit 0