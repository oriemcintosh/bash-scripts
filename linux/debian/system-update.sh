#!/usr/bin/env bash
set -euo pipefail

# system-update.sh
# Small, safe wrapper to perform unattended security updates and package upgrades on Debian/Ubuntu.
# - requires root (will re-run with sudo if needed)
# - avoids running concurrently with dpkg/apt locks
# - logs to /var/log/system-update.log (rotated by logrotate on many distros)

LOG_FILE="/var/log/system-update.log"

ensure_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Re-running as root using sudo..."
    exec sudo bash "$0" "$@"
  fi
}

wait_for_apt_lock() {
  local tries=0
  local max=30
  local sleep_sec=2
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
    if [ "$tries" -ge "$max" ]; then
      echo "Timed out waiting for apt/dpkg locks" | tee -a "$LOG_FILE"
      return 1
    fi
    echo "Waiting for apt/dpkg lock to be released... (attempt $((tries+1)))" | tee -a "$LOG_FILE"
    sleep "$sleep_sec"
    tries=$((tries+1))
  done
  return 0
}

timestamp() { date --rfc-3339=seconds; }

main() {
  ensure_root

  mkdir -p "$(dirname "$LOG_FILE")"
  echo "$(timestamp) - START system-update" | tee -a "$LOG_FILE"

  if ! wait_for_apt_lock; then
    echo "Failed to acquire apt locks" | tee -a "$LOG_FILE"
    exit 2
  fi

  echo "Running apt-get update..." | tee -a "$LOG_FILE"
  apt-get update -y 2>&1 | tee -a "$LOG_FILE"

  echo "Running unattended-upgrades (security) if available..." | tee -a "$LOG_FILE"
  if command -v unattended-upgrade >/dev/null 2>&1; then
    unattended-upgrade -v 2>&1 | tee -a "$LOG_FILE" || true
  elif [ -f /usr/bin/unattended-upgrade ]; then
    /usr/bin/unattended-upgrade -v 2>&1 | tee -a "$LOG_FILE" || true
  else
    echo "unattended-upgrade not installed; performing safe upgrade" | tee -a "$LOG_FILE"
    apt-get upgrade -y 2>&1 | tee -a "$LOG_FILE" || true
  fi

  echo "Cleaning apt cache..." | tee -a "$LOG_FILE"
  apt-get autoremove -y 2>&1 | tee -a "$LOG_FILE" || true
  apt-get clean 2>&1 | tee -a "$LOG_FILE" || true

  if [ -f /var/run/reboot-required ] || [ -f /var/run/reboot-required.pkgs ]; then
    echo "Reboot required after updates" | tee -a "$LOG_FILE"
  fi

  echo "$(timestamp) - END system-update" | tee -a "$LOG_FILE"
}

main "$@"
