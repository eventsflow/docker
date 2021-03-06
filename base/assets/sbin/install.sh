#!/bin/bash

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi


export DEBIAN_FRONTEND=noninteractive

echo "[INFO] Update apt index and upgrade to latest versions for core components" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        dialog apt-utils && \
    apt-get upgrade -y 
    

if [ -e /tmp/assets/conf/build-deps.packages ] && [ -s /tmp/assets/conf/build-deps.packages ] ; then
	echo "[INFO] Install build deps" && \
        apt-get install -y --no-install-recommends \
            $(cat /tmp/assets/conf/build-deps.packages) 
fi

if [ -e /tmp/assets/conf/ubuntu.packages ] && [ -s /tmp/assets/conf/ubuntu.packages ] ; then
	echo "[INFO] Install Ubuntu packages" && \
        apt-get install -y --no-install-recommends \
            $(cat /tmp/assets/conf/ubuntu.packages) 
fi

if [ -e /tmp/assets/conf/python.packages ] && [ -s /tmp/assets/conf/python.packages ] ; then
	echo "[INFO] Install Python packages" && \
        pip3 install --upgrade -r /tmp/assets/conf/python.packages
fi

if [ -d /tmp/assets/sbin/ ] ; then
    echo '[INFO] Update scripts'
    [ -f /tmp/assets/sbin/entrypoint.sh ] && mv /tmp/assets/sbin/entrypoint.sh /sbin
    [ -f /tmp/assets/sbin/install.sh ] && mv /tmp/assets/sbin/install.sh /sbin
    [ -f /tmp/assets/sbin/cleanup.sh ] && mv /tmp/assets/sbin/cleanup.sh /sbin
fi

if [ -e /tmp/assets/sbin/custom-install.sh ] && [ -s /tmp/assets/sbin/custom-install.sh ] ; then
	echo "[INFO] Run custom install script: sbin/custom-install.sh" && \
        ./tmp/assets/sbin/custom-install.sh
fi

if [ -e /tmp/assets/conf/build-deps.packages ] && [ -s /tmp/assets/conf/build-deps.packages ] ; then
	echo "[INFO] Remove build deps" && \
        apt-get --purge remove -y $(cat /tmp/assets/conf/build-deps.packages) 
fi

echo "[INFO] List of installed python packages" && \
    pip3 freeze

echo "[INFO] Remove temporary files" && \
    /sbin/cleanup.sh


