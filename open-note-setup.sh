#/bin/bash

# Opens the pdf version of the current md file,
# and positions the windows so that the terminal takes up
# the left half of the screen, and mupdf the right half

# Open the file in mupdf and wait for it to start
(mupdf-gl "$1" &)
# until pids=$(pgrep zathura)
until pids=$(pgrep mupdf-gl)
do 
    sleep 1
done

# mupdf has now started. Here's the applescript to position the windows

osascript <<END
tell application "System Events"

	set m to the first process whose name is "mupdf-gl"

	tell application "Finder" to set ssize to bounds of window of desktop

	tell the first window of m
		set its position to {(item 3 of ssize) / 2, 21}
		set its size to {(item 3 of ssize) / 2, (item 4 of ssize) - 21}
	end tell
end tell

tell application "iTerm" 
    set the bounds of its first window to {0,21,(item 3 of ssize) / 2, (item 4 of ssize)}
end tell
END

