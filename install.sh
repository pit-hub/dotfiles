#!/usr/bin/env bash

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
        || ([ -f "${SCRIPT_PATH}/../setup.lib.sh" ] && . "${SCRIPT_PATH}/../setup.lib.sh") \
        || true
}
source_lib

# If '~/dotfiles-dev/setup.sh' is found run it instead of cuurent dir setup.sh
# Used in development and testing.

setup_log_info "Execution a configuration script: setup.sh"

[ -f "~/dotfiles-dev/setup.sh" ] && . "~/dotfiles-dev/setup.sh" \
    || ([ -f "${SCRIPT_PATH}/setup.sh" ] && "${SCRIPT_PATH}/setup.sh") \
    || (setup_log_error "A setup.sh not found in '~/dotfiles-dev' or '${SCRIPT_PATH}'")

exit 0
