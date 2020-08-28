#!/bin/sh

set -e

mkdir -p /sbin/dev/

if [ -f /tmp/assets/conf/pypirc ] ; then
    echo "[INFO] Update pip config" && \
    mv /tmp/assets/conf/pypirc ~/.pypirc
fi

if [ -f /tmp/assets/conf/htpasswd ] ; then
    echo "[INFO] Update pip config" && \
    mv /tmp/assets/conf/htpasswd ~/.htpasswd
fi

if [ -d /tmp/assets/sbin/ ] ; then
    echo '[INFO] Update dev scripts'
    [ -f /tmp/assets/sbin/dev/cleanup.sh ] && mv /tmp/assets/sbin/dev/cleanup.sh /sbin/dev/cleanup.sh
    [ -f /tmp/assets/sbin/dev/release.sh ] && mv /tmp/assets/sbin/dev/release.sh /sbin/dev/release.sh
    [ -f /tmp/assets/sbin/dev/run-pytests.sh ] && mv /tmp/assets/sbin/dev/run-pytests.sh /sbin/dev/run-pytests.sh
    [ -f /tmp/assets/sbin/dev/publish.sh ] && mv /tmp/assets/sbin/dev/publish.sh /sbin/dev/publish.sh
fi
