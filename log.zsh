#!/bin/zsh

function edebug ()  { verb_lvl=$dbg_lvl elog "$0" "${White}DEBUG${NoColor} + $1" "$2" "$3" "$4"; }
function eok ()     { verb_lvl=$ok_lvl elog "$0" "${Green}SUCCESS${NoColor} ++ $1" "$2" "$3" "$4"; }
function einfo ()   { verb_lvl=$inf_lvl elog "$0" "${White}INFO${NoColor} +++ $1" "$2" "$3" "$4"; }
function ewarn ()   { verb_lvl=$wrn_lvl elog "$0" "${Yellow}${Underlined}${Bold}WARNING${ResetAttr}${NoColor} ++++ $1" "$2" "$3" "$4"; }
function enotify () { verb_lvl=$ntf_lvl elog "$0" "${Blue}NOTIFY${NoColor} +++++ $1" "$2" "$3" "$4"; }
function eerror ()  { verb_lvl=$err_lvl elog "$0" "${LightOrange}${Underlined}${Bold}ERROR${ResetAttr}${NoColor} ++++++ $1" "$2" "$3" "$4"; }
function ecrit ()   { verb_lvl=$crt_lvl elog "$0" "${Red}${Underlined}${Bold}CRITICAL${ResetAttr}${NoColor} +++++++  $1" "$2" "$3" "$4"; }
function eecho ()   { verb_lvl=$echo_lvl elog "$0" "${White}ECHO${NoColor} + $1" "$2" "$3" "$4"; }
function esilent () { verb_lvl=$silent_lvl elog "$0" "$1" "$2" "$3" "$4"; }

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
    local notify="${4:-false}"
    local log_date_flag="${5:-false}"  # Default to false if not provided
    local current_script=""
    local msg=""
    local push_msg=""
    local timestamp=""

    # Check if script_name_provided is an actual script name or just a placeholder
    if [[ "$script_name_provided" == "false" || "$script_name_provided" == "true" || -z "$script_name_provided" ]]; then
        # Reassign arguments if script_name_provided is just a placeholder or empty
        script_name_provided=""
        notify="${3:-false}"
        log_date_flag="${4:-false}"
    fi

    # Set the timestamp only if log_date_flag is true
    if [[ "$log_date_flag" == "true" ]]; then
        timestamp="$(date '+%b %e %T') "  # Include timestamp
    fi

    # Attempt to determine current_script based on script_name_provided or fallback
    if [[ -n "$script_name_provided" && "$script_name_provided" != "false" ]]; then
        current_script=$(basename "$script_name_provided")
    else
        # No valid script name provided, fallback to empty
        current_script=""
    fi

    # Construct the message with the timestamp if the flag is set
    if [[ -n "$current_script" ]]; then
        msg="${timestamp}${current_script}: ${message}"
    else
        msg="${timestamp}${message}"
    fi

    # Logging logic
    if [ $verbosity -ge $verb_lvl ]; then
        # Use message without timestamp for logger
        logger -p local0.notice -t "$current_script" "$message"
        echo -e "$msg"  # Print message with or without timestamp based on log_date_flag
    elif [ "$echo_if_nodebug" = true ]; then
        echo -e "$msg"  # Print message with or without timestamp based on log_date_flag
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

