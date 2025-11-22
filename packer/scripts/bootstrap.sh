#!/bin/bash
# Bootstrap script to install Python for Ansible provisioning
set -euo pipefail

pacman -Sy --noconfirm sudo python
