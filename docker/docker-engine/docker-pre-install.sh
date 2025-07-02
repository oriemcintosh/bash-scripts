#!/bin/bash

# This script runs the following command to uninstall all conflicting packages
# that may interfere with Docker installation on Ubuntu.

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done