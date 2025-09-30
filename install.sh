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
        || ([ -f "${SCRIPT_PATH}/../setup.lib.sh" ] && . "${SCRIPT_PATH}/../setup.lib.sh") \
        || true
}
source_lib

# If '~/dotfiles-dev/setup.sh' is found run it instead of cuurent dir setup.sh
# Used in development and testing.

setup_log_info "Exec install for $(basename $INST_SCRIPT_PATH) - $INST_SCRIPT_PATH $*"

setup_log_info "Execution a configuration script: $0"

setup_log_info "User home: $(target_home)"

[ -f "${HOME}/dotfiles-dev/setup.sh" ] && "${HOME}/dotfiles-dev/setup.sh" \
    || (setup_log_error "A setup.sh not found in '~/dotfiles-dev' or '${INST_SCRIPT_PATH}'")

[ -f "${HOME}/.gitconfig" ] \
    && cat "${HOME}/.gitconfig" > ${HOME}/.gitconfig-on-dotfile-install \
    || echo "# git config file notfound: ${HOME}/.gitconfig" > ${HOME}/.gitconfig-on-dotfile-install

exit 0
