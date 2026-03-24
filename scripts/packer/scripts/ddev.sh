#!/bin/sh -eux

# Install ddev.

# DDEV won't run without a non-root user.
useradd -m ddev
# Ensure ddev can execute sudo commands without password prompt:
echo 'ddev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ddev

runuser -l ddev -w DDEV_VERSION -c "curl -fsSL https://ddev.com/install.sh | bash -s ${DDEV_VERSION:-v1.25.1}"
