#!/bin/sh

set -e

USERNAME='vscode'
USER_UID=1000
USER_GID=1000

echo "[INFO] User name: ${USERNAME}, User ID: ${USER_UID}, Group ID: ${USER_GID}"

groupadd --gid $USER_GID $USERNAME
useradd -s /bin/bash --uid $USER_UID --gid $USERNAME -m $USERNAME

# Add sudo support for non-root user
if [ "${USERNAME}" != "root" ]; then
    mkdir -p /etc/sudoers.d/
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
fi
