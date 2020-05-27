#!/usr/bin/env bash

# Find the sript path. If an argument is specified returns the path where the argument file is located.
function source_lib()
{
    #detect script location (current script file or from parameter)
    local prm_script=${1:-$0}
    # Absolute path to this script, e.g. /home/user/bin/foo.sh
    local SCRIPT=$(readlink -f "${prm_script}")
    # Absolute path this script is in, thus /home/user/bin
    local SCRIPT_PATH=$(dirname "${SCRIPT}")

    [ -f "${SCRIPT_PATH}/setup.lib.sh" ] && . "${SCRIPT_PATH}/setup.lib.sh" \
        || . "${SCRIPT_PATH}/../setup.lib.sh"
}
source_lib

INST_TARGET_ROOT_PATH=~/ # user home folder

setup_log_info "FISH install ..."
[ -f "${INST_SCRIPT_PATH}/fish.install.sh" ] && "${INST_SCRIPT_PATH}/fish.install.sh" \
    || echo "FISH install file not found"
setup_log_info "FISH setup ..."
[ -f "${INST_SCRIPT_PATH}/fish.config.sh" ] && "${INST_SCRIPT_PATH}/fish.config.sh" \
    || echo "FISH config setup file not found"

# Execute config sub-config commands
setup_log_info "Execute FISH sub setup.sh"
find \
    "${INST_SCRIPT_PATH}/" \
    -maxdepth 2 -mindepth 2 \
    -type f -executable -name "setup.sh" \
    -exec '{}' \;

setup_log_info "FISH setup.sh done"
