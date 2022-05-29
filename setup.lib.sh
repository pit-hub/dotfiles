
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

function target_home()
{
    local TARGET_HOME_PATH=$(getent passwd $(id -u -n ${SUDO_USER:-$USER}) | cut -d: -f6) # user home folder

    if [ -z "${TARGET_HOME_PATH}" ] ; then
        TARGET_HOME_PATH="${HOME}"
    fi

    if [ -z "${TARGET_HOME_PATH}" ] ; then
        TARGET_HOME_PATH="~"
    fi

    echo "${TARGET_HOME_PATH}"
}

function setup_log_info()
{
  echo "[INF] $*"
  if [ ! -z "$SETUP_LOG_FILE" ]; then
    echo "[INF] $*" >> "$SETUP_LOG_FILE"
  fi
}

function setup_log_warning()
{
  echo "[WRN] $*"
  if [ ! -z "$SETUP_LOG_FILE" ]; then
    echo "[WRN] $*" >> "$SETUP_LOG_FILE"
  fi
}

function setup_log_error()
{
  echo "[ERR] $*"
  if [ ! -z "$SETUP_LOG_FILE" ]; then
    echo "[ERR] $*" >> "$SETUP_LOG_FILE"
  fi
}

function setup_log_debug()
{
  echo "[DBG] $*"
  if [ ! -z "$SETUP_LOG_FILE" ]; then
    echo "[DBG] $*" >> "$SETUP_LOG_FILE"
  fi
}

function setup_get_distro_id()
{
  echo "$(source /etc/os-release && echo $ID)"
}

export INST_SCRIPT_PATH=$(script_path)

setup_log_info "Exec setup for $(basename $INST_SCRIPT_PATH) - $INST_SCRIPT_PATH $*"
