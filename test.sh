#!/bin/zsh
source ${0:A:h}/zsh-color-logging.plugin.zsh
nodebug
ewarn "this is a warning"
eerror "this is an error"
einfo "this is an information"
edebug "this is a debug statement"
ecrit "CRITICAL MESSAGE"
edumpvar $HOSTNAME
debug
ewarn "this is a warning"
eerror "this is an error"
einfo "this is an information"
edebug "this is a debug statement"
ecrit "CRITICAL MESSAGE"
edumpvar $HOSTNAME
nodebug
tail -n 6 /var/log/syslog
