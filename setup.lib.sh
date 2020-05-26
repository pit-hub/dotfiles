
# Find the sript path. If an argument is specified returns the path where the argument file is located.
function script_path()
{
    #detect script location (current script file or from parameter)
    local prm_script=${1:-$0}
    # Absolute path to this script, e.g. /home/user/bin/foo.sh
    local SCRIPT=$(readlink -f "${prm_script}")
    # Absolute path this script is in, thus /home/user/bin
    local SCRIPT_PATH=$(dirname "${SCRIPT}")
    echo "${SCRIPT_PATH}"
}

function setup_get_distro_id()
{
  echo "$(source /etc/os-release && echo $ID)"
}

export INST_SCRIPT_PATH=$(script_path)

echo "Exec setup for $(basename $INST_SCRIPT_PATH) - $INST_SCRIPT_PATH $*"
