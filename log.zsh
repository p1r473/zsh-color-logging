#!/bin/zsh 

LOG_LOCATION="/var/log/syslog"

function edebug ()  { verb_lvl=$dbg_lvl elog "$0" "${White}DEBUG${NoColor} + $1" "$2" "$3"; }
function eok ()     { verb_lvl=$ok_lvl elog "$0" "${Green}SUCCESS${NoColor} ++ $1" "$2" "$3"; }
function einfo ()   { verb_lvl=$inf_lvl elog "$0" "${White}INFO${NoColor} +++ $1" "$2" "$3"; }
function ewarn ()   { verb_lvl=$wrn_lvl elog "$0" "${Yellow}${Underlined}${Bold}WARNING${ResetAttr}${NoColor} ++++ $1" "$2" "$3"; }
function enotify () { verb_lvl=$ntf_lvl elog "$0" "${Blue}NOTIFY${NoColor} +++++ $1" "$2" "$3"; }
function eerror ()  { verb_lvl=$err_lvl elog "$0" "${LightOrange}${Underlined}${Bold}ERROR${ResetAttr}${NoColor} ++++++ $1" "$2" "$3"; }
function ecrit ()   { verb_lvl=$crt_lvl elog "$0" "${Red}${Underlined}${Bold}CRITICAL${ResetAttr}${NoColor} +++++++  $1" "$2" "$3"; }
function eecho ()   { verb_lvl=$echo_lvl elog "$0" "${White}ECHO${NoColor} + $1" "$2" "$3"; }
function esilent () { verb_lvl=$silent_lvl elog "$0" "$1" "$2" "$3"; }

function edumpvar() {
    for var in "$@"; do
        # Determine the shell and perform indirect expansion based on the shell
        if [[ -n "$ZSH_VERSION" ]]; then
            # Zsh shell detected
            local value="${(P)var}"
        elif [[ -n "$BASH_VERSION" ]]; then
            # Bash shell detected
            local value="${!var}"
        else
            echo "Unsupported shell."
            return 1
        fi
        if [[ -z "$value" ]]; then
            edebug "$var is not set"
        else
            edebug "$var=$value"
        fi
    done
}

function elog() {
    local message="$2"
    local script_name_provided="$3"
    local notify="$4"
    local current_script=""

    # Attempt to determine current_script based on script_name_provided or fallback
    if [[ "$script_name_provided" == "True" || "$script_name_provided" == "true" || "$script_name_provided" == "False" || "$script_name_provided" == "false" ]]; then
        # $2 is a notification flag, not a script name
        notify="$script_name_provided"
        # Set to a default or meaningful name since it's being sourced/invoked in a way that doesn't provide it
        if echo "$1" | grep -q -E '\.sh$|\.py$'; then
            current_script=$(basename "$1" | sed 's/\.[^.]*$//' | sed 's/[\.\/]//g')
        else
            current_script=""
        fi
    elif [[ -n "$script_name_provided" ]]; then
        # Use the provided script name, removing the file extension
        current_script=$(basename "$script_name_provided")
    else
        # No script name provided; use a meaningful default
        if echo "$0" | grep -q -E '\.sh$|\.py$'; then
            current_script=$(basename "$1" | sed 's/\.[^.]*$//' | sed 's/[\.\/]//g')
        else
            current_script=""
        fi
    fi

    # Construct the message
    if [[ -n "$current_script" ]]; then
        msg="${current_script}: ${message}"
    else
        msg="${message}"
    fi

    # Logging logic
    if [ $verbosity -ge $verb_lvl ]; then
        logger -p local0.notice -t "$current_script" "$message"
    fi
    echo -e "$msg"

    # Notification logic
    if [[ "$notify" == "true" ]] && [ $push_level -ge $verb_lvl ]; then
        local push_msg=$(echo -e "$msg" | strip_colors)
        Pushover "$push_msg"
        Pushbullet "$push_msg"
    fi
}

function Pushover {
    local msg=$1
    curl -s --form-string "token=$YOUR_PUSHOVER_API_TOKEN" --form-string "user=$YOUR_PUSHOVER_USER_KEY" --form-string "message=$1 on server $(hostname)" https://api.pushover.net/1/messages.json &> /dev/null 
}

function Pushbullet {
    local msg=$1
    curl --silent -u "$YOUR_PUSHBULLET_API_TOKEN" -d type="note" -d body="$1 on server $(hostname)" -d title="$1 on server $(hostname)" 'https://api.pushbullet.com/v2/pushes' &> /dev/null
}

function strip_colors() {
    #sed 's/\x1B\[[0-9;]*[mK]//g' | sed 's/\x1B\[38:5:[0-9:]*m//g' | sed 's/\x1B\[48:5:[0-9:]*m//g'
    sed 's/\x1B\[[0-9;:]*[mK]//g'
}

shift $((OPTIND-1))

while getopts ":sVG" opt ; do
# shellcheck disable=SC2220
        case $opt in
	        S)
	            verbosity=$silent_lvl
	            edebug "-s specified: Silent mode"
	            ;;
	        V)
	            verbosity=$inf_lvl
	            edebug "-V specified: Verbose mode"
	            ;;
	        G)
	            verbosity=$dbg_lvl
	            edebug "-G specified: Debug mode"
	            ;;
	        \?)
	        echo "Invalid option: -$OPTARG" >&2
	        ;;
    	esac
done

