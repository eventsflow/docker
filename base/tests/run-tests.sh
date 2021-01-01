#!/usr/bin/env bash

set -e

echo '[INFO] Run tests'

echo '[INFO] Print out outdated python packages' && \
    pip3 list --outdated

