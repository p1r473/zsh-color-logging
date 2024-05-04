#!/bin/zsh
source ${0:A:h}/zsh-color-logging.plugin.zsh
nodebug
esilent "This is silent"
ewarn "this is a warning"
eerror "this is an error"
einfo "this is an information"
edebug "this is a debug statement"
ecrit "CRITICAL MESSAGE"
eecho "this is echo"
edumpvar $HOSTNAME
debug
esilent "This is silent"
ewarn "this is a warning"
eerror "this is an error"
einfo "this is an information"
edebug "this is a debug statement"
ecrit "CRITICAL MESSAGE"
eecho "This is echo"
edumpvar $HOSTNAME
tail -n 6 /var/log/syslog
nodebug
