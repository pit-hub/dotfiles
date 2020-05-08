#!/usr/bin/env bash

set -e

# Avoid warnings by switching to noninteractive
DEBIAN_FRONTEND=noninteractive

apt-get update \
    && apt-get -y install fish 2>&1 \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

#locale-gen en_US.UTF-8
#update-locale LANG=en_US.UTF-8
