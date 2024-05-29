#References
#echo ${0:A}
#echo ${0:A:h}
#echo $(dirname "${(%):-%x}")
#echo $(dirname "${(%):-%N}")
#echo $( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )

main() {
  local SCRIPT_DIR
  # Initialize SCRIPT_DIR differently for Zsh
  if [ -n "$BASH_VERSION" ]; then
    SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
  elif [ -n "$ZSH_VERSION" ]; then
    # Get the directory of the current script, considering it might be sourced
    SCRIPT_DIR=$(dirname "${(%):-%x}")  # -%x resolves to the path of the current script
  else
    echo "Unknown shell. Configuration not sourced."
    return
  fi

  # Now source the scripts from the determined directory
  source "${SCRIPT_DIR}/helper.zsh"
  source "${SCRIPT_DIR}/.credentials.conf"
  source "${SCRIPT_DIR}/config.conf"
  source "${SCRIPT_DIR}/log.zsh"
}

main
