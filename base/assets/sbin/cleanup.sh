#!/bin/bash

set -e

PYTHON_VERSION="3.8"

cleanup_pycache() {

    _PATH=${1:-}

    echo "[INFO] Cleaning __pycache__ dirs for the path: ${_PATH}" && \
        find ${_PATH} -path '*/__pycache__/*' -delete && \
        find ${_PATH} -type d -name '__pycache__' -empty -delete
}

echo '[INFO] Cleanup apt cache: apt-get clean' && \
    apt-get clean -y 

echo '[INFO] Cleanup apt cache: apt-get autoclean' && \
    apt-get autoclean -y

echo '[INFO] Cleanup apt cache: apt-get autoremove' && \
    apt-get autoremove -y 

echo '[INFO] Remove temporary files' && \
    rm -rf \
        /tmp/* \
        /root/.cache/* \
        /var/lib/apt/lists/*

echo '[INFO] Remove __pycache__ dirs' && \
    for path in "/usr/lib/python${PYTHON_VERSION}/" \
                "/usr/local/lib/python${PYTHON_VERSION}/dist-packages"
    do
        cleanup_pycache ${path}
    done 
