# A two-line colored Bash prompt (PS1) with Git branch and a line decoration
# which adjusts automatically to the width of the terminal.
# Recognizes and shows Git, SVN and Fossil branch/revision.
# Screenshot: http://img194.imageshack.us/img194/2154/twolineprompt.png
# Michal Kottman, 2012

RESET="\[\033[0m\]"
WHITE_DIM="\[\033[97;2m\]"
RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
GREEN_DIM="\[\033[32;2m\]"
BLUE="\[\033[01;34m\]"
YELLOW="\[\033[0;33m\]"
YELLOW_DIM="\[\033[33;2m\]"
MAG_PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]"

function __prompt_extras {
  local EXIT="$?"
  local PS_LINE=`printf -- '- %.0s' {1..400}`
  local PS_FILL=${PS_LINE:0:$COLUMNS}
  local TIME_COLOR=$WHITE_DIM
  local PS_BRANCH=''
  local PS_HOST="\h"
  local PS_AT="@"

  if [ ! -z "${ACC_CLOUD}" ] ; then
    # PS_HOST="Azure"
    PS_HOST=$(jq --raw-output \
        '.subscriptions[] | select(.isDefault == true) | (.name)' \
        "$HOME/.azure/azureProfile.json" 2>/dev/null || echo "Azure" \
      )
  fi
  if [ ! -z "${CODESPACES}" ] ; then
    PS_HOST="cs"
  fi
  if [ "${REMOTE_CONTAINERS}" == "true" ] ; then
    PS_AT=""
    PS_HOST=""
  fi

  if [ $EXIT != 0 ]
  then
    TIME_COLOR=$RED
  fi

  if [[ "`which git 1>/dev/null 2>/dev/null && echo 0 || echo 1`" == 0 ]]
  then
    if [[ "`git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null && echo 0 || echo 1`" == 0 ]]
    then
      local ref=$(git symbolic-ref HEAD 2> /dev/null)
      local PS_BRANCH="${ref#refs/heads/}"
      local PS_GIT="${RESET}${YELLOW_DIM}|${YELLOW}${PS_BRANCH}${RESET}"
    fi
  fi


  local PS_INFO="${RESET}${GREEN}\u${RESET}${GREEN_DIM}${PS_AT}${RESET}${GREEN}${PS_HOST}${RESET}:${BLUE}\w"
  local PS_TIME="\[\033[\$((COLUMNS-10))G\] ${RESET}${TIME_COLOR}[\t]"

  PS1="${RESET}${WHITE_DIM}${PS_FILL}\[\033[0G\]${PS_INFO}${PS_GIT}${PS_TIME}\n${RESET}"'\$ '
}

tty -s && PROMPT_COMMAND=__prompt_extras || true
