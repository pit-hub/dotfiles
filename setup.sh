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

export SETUP_LOG_FILE="${INST_SCRIPT_PATH}/setup.log"
env > "${INST_SCRIPT_PATH}/setup.env.log"
echo "[INF] dotfile main setup started." > "$SETUP_LOG_FILE"

# Execute sub-config commands
setup_log_info "Execute sub setup.sh"
find \
    "${INST_SCRIPT_PATH}/" \
    -maxdepth 2 -mindepth 2 \
    -type f -executable -name "setup.sh"\
    -exec '{}' \;

# find "${INST_SCRIPT_PATH}/" -maxdepth 1 -mindepth 1 -type d -not -wholename "*/.git*" | while read setup_dir; do
#     echo $setup_dir
#     #echo find -maxdepth 2 -perm /a=x
# done
# case $(cat /etc/*-release | grep -E '$ID=(.+)$') in
#     "ID=debian") debian/install.sh ;;
#       *) echo "Unsuported automatic install for this distro!" && return;;
# esac

setup_log_info "dotfile main setup exiting with code: $?."

exit 0
