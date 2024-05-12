# Detect shell and source files accordingly
if [ -n "$BASH_VERSION" ]; then
    SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
elif [ -n "$ZSH_VERSION" ]; then
    #SCRIPT_DIR=${0:A:h}
    SCRIPT_DIR=$(dirname "${(%):-%N}")  # More robust for sourced scripts
else
    echo "Unknown shell. Configuration not sourced."
fi
source "${SCRIPT_DIR}/helper.zsh"
source "${SCRIPT_DIR}/.credentials.conf"
source "${SCRIPT_DIR}/config.conf"
source "${SCRIPT_DIR}/log.zsh"
