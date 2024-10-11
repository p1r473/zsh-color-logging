#!/bin/zsh

function edebug ()  { verb_lvl=$dbg_lvl elog "${White}DEBUG${NoColor} + $1" "$2" "$3" "$4" "$5"; }
function eok ()     { verb_lvl=$ok_lvl elog "${Green}SUCCESS${NoColor} ++ $1" "$2" "$3" "$4" "$5"; }
function einfo ()   { verb_lvl=$inf_lvl elog "${White}INFO${NoColor} +++ $1" "$2" "$3" "$4" "$5"; }
function ewarn ()   { verb_lvl=$wrn_lvl elog "${Yellow}${Underlined}${Bold}WARNING${ResetAttr}${NoColor} ++++ $1" "$2" "$3" "$4" "$5"; }
function enotify () { verb_lvl=$ntf_lvl elog "${Blue}NOTIFY${NoColor} +++++ $1" "$2" "$3" "$4" "$5"; }
function eerror ()  { verb_lvl=$err_lvl elog "${LightOrange}${Underlined}${Bold}ERROR${ResetAttr}${NoColor} ++++++ $1" "$2" "$3" "$4" "$5"; }
function ecrit ()   { verb_lvl=$crt_lvl elog "${Red}${Underlined}${Bold}CRITICAL${ResetAttr}${NoColor} +++++++  $1" "$2" "$3" "$4" "$5"; }
function eecho ()   { verb_lvl=$echo_lvl elog "${White}ECHO${NoColor} + $1" "$2" "$3" "$4" "$5"; }
function esilent () { verb_lvl=$silent_lvl elog "$1" "$2" "$3" "$4" "$5"; }

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
    local current_script="$0"
    local message="$1"
    local notify="${2:-false}"
    local log_date_flag="${3:-false}"
    local log="${4:-true}"
    local echo="${5:-true}"
    local msg=""
    local push_msg=""
    local timestamp=""

    # Check if current_script is an actual script name or just a placeholder
    if [[ "$current_script" == "false" || "$current_script" == "true" || -z "$current_script" ]]; then
        # Reassign arguments if current_script is just a placeholder or empty
        current_script=""
        notify="${2:-false}"
        log_date_flag="${3:-false}"
        log="${4:-true}"
        echo="${5:-true}"
    fi

    # Set the timestamp only if log_date_flag is true
    if [[ "$log_date_flag" == "true" ]]; then
        timestamp="$(date '+%b %e %T') "  # Include timestamp
    fi

    # Attempt to determine current_script based on current_script or fallback
    if [[ -n "$current_script" && "$current_script" != "false" ]]; then
        current_script=$(basename "$current_script")
    else
        # No valid script name provided, fallback to empty
        current_script=""
    fi

    # Construct the message with the timestamp if the flag is set
    if [[ -n "$current_script" ]]; then
        msg="${timestamp} ${current_script}: ${message}"
    else
        msg="${timestamp} ${message}"
    fi

    # Logging logic
    if [ $verbosity -ge $verb_lvl ]; then
        if [[ "$log" == "true" ]]; then
            logger -p local0.notice -t "$current_script" "$message"
        fi
        if [[ "$echo" == "true" ]]; then
            echo -e "$msg"
        fi
    elif [ "$echo_if_nodebug" = true ]; then
        if [[ "$echo" == "true" ]]; then
            echo -e "$msg"
        fi
    fi

    # Notification logic with full message and timestamp if enabled
    if [[ "$notify" == "true" ]] && [ $push_level -ge $verb_lvl ]; then
        push_msg=$(echo -e "$msg" | strip_colors)
        Pushover "$push_msg"
        Pushbullet "$push_msg"
    fi
}

function Pushover {
    local msg=$1
    if [[ -n "$YOUR_PUSHOVER_API_TOKEN" && -n "$YOUR_PUSHOVER_USER_KEY" ]]; then
        curl -s --form-string "token=$YOUR_PUSHOVER_API_TOKEN" --form-string "user=$YOUR_PUSHOVER_USER_KEY" --form-string "message=$msg on server $(hostname)" https://api.pushover.net/1/messages.json &> /dev/null
    fi
}

function Pushbullet {
    local msg=$1
    if [[ -n "$YOUR_PUSHBULLET_API_TOKEN" ]]; then
        curl --silent -u "$YOUR_PUSHBULLET_API_TOKEN" -d type="note" -d body="$msg on server $(hostname)" -d title="$msg on server $(hostname)" 'https://api.pushbullet.com/v2/pushes' &> /dev/null
    fi
}
function strip_colors() {
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

