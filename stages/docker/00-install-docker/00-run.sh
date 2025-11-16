#!/bin/bash -e
on_chroot << CHROOT
# Install Docker using official script
curl -fsSL https://get.docker.com | sh

# Enable Docker service
systemctl enable docker.service
CHROOT
