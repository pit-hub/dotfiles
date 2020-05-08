#!/usr/bin/env bash

set -e

fisher add FabioAntunes/fish-nvm
fisher add edc/bass

# Execute sub-config commands
# find \
#     "${INST_SCRIPT_PATH}/" \
#     -maxdepth 2 -mindepth 2 \
#     -type f -executable -name "setup.sh"\
#     -exec '{}' \;
