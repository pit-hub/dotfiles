#!/usr/bin/env bash

set -e

if [[ $UID -ne 0 ]]; then
    echo "Executing as root: $0 $@"
    sudo --preserve-env -p 'Restarting as root, password: ' bash $0 $@
    exit $?
fi

function fish_install_get_distro_id()
{
  echo "$(source /etc/os-release && echo $ID)"
}

function fish_install_debian()
{
  # Avoid warnings by switching to noninteractive
  local DEBIAN_FRONTEND_BAK=${DEBIAN_FRONTEND}
  export DEBIAN_FRONTEND=noninteractive

  apt-get update \
    && apt-get -y install fish 2>&1 \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

  export DEBIAN_FRONTEND=${DEBIAN_FRONTEND_BAK}
}

function fish_install_alpine()
{
  apk update && \
    apk add --no-cache fish && \
    rm -f /tmp/* /etc/apk/cache/*
}

function fish_install_arch()
{
  pacman -yS --noconfirm fish \
    && paccache -rk 1
}

case $(fish_install_get_distro_id) in
  arch)
    fish_install_arch
    ;;
  debian)
    fish_install_debian
    ;;
  alpine)
    fish_install_alpine
    ;;
  *)
    echo "Unsupported Linux distribution: $(fish_install_get_distro_id)"
    exit 1
  ;;
esac

