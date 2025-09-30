#!/usr/bin/env bash

if [[ $UID -ne 0 ]]; then
    echo "Executing as root: $0 $@"
    sudo --preserve-env -p 'Restarting as root, password: ' bash $0 $@
    exit $?
fi

# Find the sript path. If an argument is specified returns the path where the argument file is located.
function source_lib()
{
    #detect script location (current script file or from parameter)
    local prm_script=${1:-$0}
    # Absolute path to this script, e.g. /home/user/bin/foo.sh
    local SCRIPT=$(readlink -f "${prm_script}")
    # Absolute path this script is in, thus /home/user/bin
    SCRIPT_PATH=$(dirname "${SCRIPT}")

    [ -f "${SCRIPT_PATH}/setup.lib.sh" ] && . "${SCRIPT_PATH}/setup.lib.sh" \
        || . "${SCRIPT_PATH}/../setup.lib.sh"
}
source_lib

INST_TARGET_ROOT_PATH=/ # Rsync with the system root folder

setup_log_info "Global setup.sh"

# Sync systeme wide configuration files
#     -r --dry-run \ # Do nothing, for debug and test
#     -v \ # Verbouse, for debug and test
rsync -r \
    --chown=root:root \
    --chmod=u=rw,go=r \
    --exclude-from="${INST_SCRIPT_PATH}/setup.rsync.exclude.txt" \
    "${INST_SCRIPT_PATH}/" \
    "${INST_TARGET_ROOT_PATH}/"

setup_log_info "Global setup.sh done"
