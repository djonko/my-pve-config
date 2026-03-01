#!/usr/bin/env bash
set -euo pipefail

# upgrade-lxc-debian12-to-13.sh
# Run from Proxmox host. Upgrades a Debian 12 (bookworm) LXC to Debian 13 (trixie)
# using the lxc.generator workaround for systemd status=243/CREDENTIALS.

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <CTID> [--cleanup]"
  echo "  --cleanup  Remove /etc/systemd/system-generators/lxc after successful upgrade + verify"
  exit 1
fi

CTID="$1"
CLEANUP="${2:-}"

GEN_URL="https://sources.debian.org/data/main/d/distrobuilder/3.2-2/distrobuilder/lxc.generator"

pct_ok() { pct status "$CTID" >/dev/null 2>&1; }

pct_exec() {
  # Run a command inside the container (non-interactive).
  pct exec "$CTID" -- bash -lc "$*"
}

echo "[1/7] Checking CT $CTID exists..."
pct_ok || { echo "ERROR: CTID $CTID not found."; exit 1; }

echo "[2/7] Ensuring container is running..."
if ! pct status "$CTID" | grep -q "status: running"; then
  pct start "$CTID" >/dev/null
fi

echo "[3/7] Installing prerequisite tools (curl, ca-certificates) if missing..."
pct_exec "export DEBIAN_FRONTEND=noninteractive;
  command -v curl >/dev/null 2>&1 || (apt-get update && apt-get install -y --no-install-recommends curl ca-certificates);
  true"

echo "[4/7] Applying systemd credentials workaround (install lxc.generator + daemon-reload)..."
pct_exec "set -e;
  mkdir -p /etc/systemd/system-generators;
  curl -fsSL '$GEN_URL' | tee /etc/systemd/system-generators/lxc >/dev/null;
  chmod 0755 /etc/systemd/system-generators/lxc;
  systemctl daemon-reload || true"

echo "[5/7] Updating Debian 12 (bookworm) packages..."
pct_exec "export DEBIAN_FRONTEND=noninteractive;
  apt-get update;
  apt-get -y upgrade -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"

echo "[6/7] Switching APT sources bookworm -> trixie and performing dist-upgrade..."
pct_exec "set -e;
  export DEBIAN_FRONTEND=noninteractive;

  # Replace codename in common apt source formats:
  # - /etc/apt/sources.list + *.list
  # - deb822: /etc/apt/sources.list.d/*.sources
  shopt -s nullglob;
  for f in /etc/apt/sources.list /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources; do
    sed -i 's/bookworm/trixie/g' \"\$f\";
  done

  apt-get update;
  apt-get -y dist-upgrade -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold';
  apt-get -y autoremove;
  apt-get -y autoclean;

  # Optional in the article; safe to attempt
  apt modernize-sources || true;

  systemctl daemon-reload || true"

echo "[7/7] Rebooting CT and verifying Debian version..."
pct reboot "$CTID" >/dev/null || true

# Wait a bit for reboot, then poll status
for i in {1..60}; do
  if pct status "$CTID" | grep -q "status: running"; then
    # Try a lightweight command; if it fails, keep waiting
    if pct exec "$CTID" -- true >/dev/null 2>&1; then
      break
    fi
  fi
  sleep 2
done

OS_RELEASE="$(pct exec "$CTID" -- cat /etc/os-release 2>/dev/null || true)"
echo "$OS_RELEASE" | grep -q 'VERSION_ID="13"' || {
  echo "ERROR: Upgrade did not verify as Debian 13 (trixie)."
  echo "Container /etc/os-release output:"
  echo "$OS_RELEASE"
  exit 1
}

echo "SUCCESS: CT $CTID is now Debian 13 (trixie)."

if [[ "$CLEANUP" == "--cleanup" ]]; then
  echo "Cleanup requested: removing lxc.generator and reloading systemd..."
  pct_exec "rm -f /etc/systemd/system-generators/lxc; systemctl daemon-reload || true"
  echo "Cleanup done."
else
  echo "Note: lxc.generator left in place. You can remove it later with:"
  echo "  pct exec $CTID -- rm -f /etc/systemd/system-generators/lxc"
fi