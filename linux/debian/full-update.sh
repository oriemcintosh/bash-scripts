#!/usr/bin/env bash
set -euo pipefail

# full-update.sh
# Perform a full system upgrade including kernel packages and optional distribution upgrades.
# - requires root (auto-elevate via sudo)
# - prompts before doing a dist-upgrade or reboot unless --yes is provided
# - creates a simple transaction log in /var/log/full-update.log

LOG_FILE="/var/log/full-update.log"

usage() {
  cat <<EOF
Usage: $0 [--yes|-y] [--reboot|-r]

Options:
  -y, --yes    Run non-interactively and assume yes to prompts
  -r, --reboot Reboot automatically if required after updates
  -h, --help   Show this help
EOF
}

ensure_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Re-running as root using sudo..."
    exec sudo bash "$0" "$@"
  fi
}

timestamp() { date --rfc-3339=seconds; }

WAIT_MAX=30

wait_for_apt_lock() {
  local tries=0
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1 || fuser /var/lib/apt/lists/lock >/dev/null 2>&1 || fuser /var/cache/apt/archives/lock >/dev/null 2>&1; do
    if [ "$tries" -ge "$WAIT_MAX" ]; then
      echo "Timed out waiting for apt/dpkg locks" | tee -a "$LOG_FILE"
      return 1
    fi
    echo "Waiting for apt/dpkg lock to be released... (attempt $((tries+1)))" | tee -a "$LOG_FILE"
    sleep 2
    tries=$((tries+1))
  done
  return 0
}

main() {
  local ASSUME_YES=0
  local AUTO_REBOOT=0

  # parse args
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -y|--yes) ASSUME_YES=1; shift ;;
      -r|--reboot) AUTO_REBOOT=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) echo "Unknown arg: $1"; usage; exit 2 ;;
    esac
  done

  ensure_root
  mkdir -p "$(dirname "$LOG_FILE")"
  echo "$(timestamp) - START full-update" | tee -a "$LOG_FILE"

  if ! wait_for_apt_lock; then
    echo "Failed to acquire apt locks" | tee -a "$LOG_FILE"
    exit 2
  fi

  echo "Updating package lists..." | tee -a "$LOG_FILE"
  apt-get update 2>&1 | tee -a "$LOG_FILE"

  echo "Performing full upgrade (may install/remove packages)..." | tee -a "$LOG_FILE"
  if [ "$ASSUME_YES" -eq 1 ]; then
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' 2>&1 | tee -a "$LOG_FILE"
  else
    apt-get dist-upgrade 2>&1 | tee -a "$LOG_FILE"
  fi

  echo "Cleaning up..." | tee -a "$LOG_FILE"
  apt-get autoremove -y 2>&1 | tee -a "$LOG_FILE" || true
  apt-get autoclean -y 2>&1 | tee -a "$LOG_FILE" || true

  if [ -f /var/run/reboot-required ] || [ -f /var/run/reboot-required.pkgs ]; then
    echo "Reboot required after updates" | tee -a "$LOG_FILE"
    if [ "$AUTO_REBOOT" -eq 1 ]; then
      echo "Rebooting now by request" | tee -a "$LOG_FILE"
      reboot
    else
      echo "Run 'sudo reboot' to restart or re-run with --reboot to reboot automatically." | tee -a "$LOG_FILE"
    fi
  fi

  echo "$(timestamp) - END full-update" | tee -a "$LOG_FILE"
}

main "$@"
