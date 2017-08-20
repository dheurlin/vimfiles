#/bin/bash

if [[  "$1" = "-g" || "$1" = "--get-current" ]]; then
    
    #get the current window settings
    CUR_SETTINGS=`osascript -e 'tell application "iTerm"
    get profile name of current session of current window
    end tell'`

    printf "$CUR_SETTINGS"

elif [[(  "$1" = "-s" || "$1" = "--set" ) && "$2" != "" ]]; then

    printf "\033]50;SetProfile=$2\a"

else

    echo "Usage: iterm-prof -g / --get-current: returns current iTerm profile"
    echo "Usage: iterm-prof -s / --set PROFILE: sets the iTerm profile to PROFILE"

fi
