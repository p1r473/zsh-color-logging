#!/bin/zsh

# Function to interpret color codes for any command output
colorize_output() {
  #sed -u 's/\\e/\x1b/g'
  awk '{ gsub(/\\e/, "\x1b"); print }'
}

# Wrapper for 'tail' with color interpretation
ctail() {
  /usr/bin/tail "$@" | colorize_output
}

# Wrapper for 'head' with color interpretation
chead() {
  /usr/bin/head "$@" | colorize_output
}

# Wrapper for 'cat' with color interpretation
ccat() {
  /usr/bin/cat "$@" | colorize_output
}

#Reset
NoColor='\e[39m'

#Attributes
Bold='\e[1m'
Dim='\e[2m'
Underlined='\e[4m'
Blink='\e[5m'
Inverted='\e[7m'
Hidden='\e[8m'

#Reset Attributrs
ResetAttr='\e[0m'
ResetBold='\e[21m'
ResetDim='\e[22m'
ResetUnderlined='\e[24m'
ResetBlink='\e[25m'
ResetInverted='\e[27m'
ResetHidden='\e[28m'

#Backgrounds
BGDefault='\e[49m'
BGBlack='\e[40m'
BGRed='\e[41m'
BGGreen='\e[42m'
BGYellow='\e[43m'
BGBlue='\e[44m'
BGMagenta='\e[45m'
BGCyan='\e[46m'
BGLightGray='\e[47m'
BGDarkGray='\e[100m'
BGLightRed='\e[101m'
BGLightGreen='\e[102m'
BGLightYellow='\e[103m'
BGLightBlue='\e[104m'
BGLightMagenta='\e[105m'
BGLightCyan='\e[106m'
BGWhite='\e[107m'
BGOrangeDark='\e[48:5:166m'
BGOrangeLight='\e[48:5:208m'

#Colors
Black='\e[30m'
Red='\e[31m'
Green='\e[32m'
Yellow='\e[33m'
Blue='\e[34m'
Magenta='\e[35m'
Cyan='\e[36m'
LightGray='\e[37m'
DarkGray='\e[90m'
LightGed='\e[91m'
LightGreen='\e[92m'
LightYellow='\e[93m'
LightBlue='\e[94m'
LightMagenta='\e[95m'
LightCyan='\e[96m'
White='\e[97m'
DarkOrange='\e[38:5:166m'
LightOrange='\e[38:5:208m'

# Reset
# NoColor='\033[0m'           # Text Reset

# Regular Colors
# Black='\033[0;30m'          # Black
# Red='\033[0;31m'            # Red
# Green='\033[0;32m'          # Green
# Yellow='\033[1;33m'         # Yellow
# Blue='\033[0;34m'           # Blue
# Purple='\033[0;35m'         # Purple
# Cyan='\033[0;36m'           # Cyan
# White='\033[0;37m'          # White
# LightGray='\033[0;37m'      # Light Gray
# DarkGray='\033[1;30m'       # Dark Gray
# LightRed='\033[1;31m'       # Light Red
# LightGreen='\033[1;32m'     # Light Green
# LightBlue='\033[1;34m'      # Light Blue
# LightPurple='\033[1;35m'    # Light Purple
# LightCyan='\033[1;36m'      # Light Cyan

# Bold
# BBlack='\033[1;30m'         # Black
# BRed='\033[1;31m'           # Red
# BGreen='\033[1;32m'         # Green
# BYellow='\033[1;33m'        # Yellow
# BBlue='\033[1;34m'          # Blue
# BPurple='\033[1;35m'        # Purple
# BCyan='\033[1;36m'          # Cyan
# BWhite='\033[1;37m'         # White

# Underline
# UBlack='\033[4;30m'         # Black
# URed='\033[4;31m'           # Red
# UGreen='\033[4;32m'         # Green
# UYellow='\033[4;33m'        # Yellow
# UBlue='\033[4;34m'          # Blue
# UPurple='\033[4;35m'        # Purple
# UCyan='\033[4;36m'          # Cyan
# UWhite='\033[4;37m'         # White

# Background
# On_Black='\033[40m'         # Black
# On_Red='\033[41m'           # Red
# On_Green='\033[42m'         # Green
# On_Yellow='\033[43m'        # Yellow
# On_Blue='\033[44m'          # Blue
# On_Purple='\033[45m'        # Purple
# On_Cyan='\033[46m'          # Cyan
# On_White='\033[47m'         # White

# High Intensty
# IBlack='\033[0;90m'         # Black
# IRed='\033[0;91m'           # Red
# IGreen='\033[0;92m'         # Green
# IYellow='\033[0;93m'        # Yellow
# IBlue='\033[0;94m'          # Blue
# IPurple='\033[0;95m'        # Purple
# ICyan='\033[0;96m'          # Cyan
# IWhite='\033[0;97m'         # White

# Bold High Intensty
# BIBlack='\033[1;90m'        # Black
# BIRed='\033[1;91m'          # Red
# BIGreen='\033[1;92m'        # Green
# BIYellow='\033[1;93m'       # Yellow
# BIBlue='\033[1;94m'         # Blue
# BIPurple='\033[1;95m'       # Purple
# BICyan='\033[1;96m'         # Cyan
# BIWhite='\033[1;97m'        # White

# High Intensty backgrounds
# On_IBlack='\033[0;100m'     # Black
# On_IRed='\033[0;101m'       # Red
# On_IGreen='\033[0;102m'     # Green
# On_IYellow='\033[0;103m'    # Yellow
# On_IBlue='\033[0;104m'      # Blue
# On_IPurple='\033[10;95m'    # Purple
# On_ICyan='\033[0;106m'      # Cyan
# On_IWhite='\033[0;107m'     # White
