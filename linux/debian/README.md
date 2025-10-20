# Debian / Ubuntu update scripts

This folder contains simple, well-documented scripts for performing package updates on Debian-based systems (Debian, Ubuntu, and derivatives).

Files:

- `system-update.sh`: Safe, minimal updates focused on security/unattended upgrades. Intended for cron or periodic runs.
- `full-update.sh`: Full system upgrade (dist-upgrade), optionally reboots if requested. Intended for interactive or admin-run updates.

Why a `linux/debian` folder?

Keeping distribution-specific scripts under `linux/<distro>` makes it easier to add RedHat/CentOS (`linux/redhat`) or SUSE (`linux/suse`) variants later. It also makes CI/automation targeting easier.

Usage examples:

Non-interactive system update (good for cron):

    sudo bash linux/debian/system-update.sh

Full upgrade with automatic yes and reboot if required:

    sudo bash linux/debian/full-update.sh --yes --reboot

Notes and recommendations:

- Run these scripts as root (they auto-elevate with `sudo` if needed).
- Place cron jobs or systemd timers that call `system-update.sh` for periodic unattended updates.
- Consider installing `unattended-upgrades` for better security-only patch management.
- For servers, prefer `system-update.sh` via a scheduled job; reserve `full-update.sh` for maintenance windows.

Conventions and next steps:

- Add `linux/redhat` and `linux/suse` directories for RPM-based systems.
- Optionally provide a `setup` script to install `unattended-upgrades` and configure automatic security patches.
- Add tests or a `--dry-run` mode if you want to validate the behavior without making changes.
