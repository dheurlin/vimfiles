#/bin/bash

# Opens the pdf version of the current md file,
# and positions the windows so that the terminal takes up
# the left half of the screen, and zathura the right half

# Start by moving the terminal window out of the way by scaling it down
osascript /Users/danielheurlin/Dropbox/coding\ stuff/applescript/resize-iterm.scpt 0.6

# Open the file in zathura, and wait for it to start.
# the mouse click-and-drag simulator cliclick
(zathura "$1" &)
until pids=$(pgrep zathura)
do 
    sleep 1
done

# zathura has now started. Let's wait a bit longer for it to get comfy
sleep 3
# It should be open by now, so let's drag the window into place
cliclick "m:300,200" "c:+0,23" "w:200" "dd:+0,+0" "du:+640,+0"

# Now let's put the terminal window on the left hand side
cliclick "c:600,400"
osascript /Users/danielheurlin/Dropbox/coding\ stuff/applescript/resize-iterm.scpt l 
