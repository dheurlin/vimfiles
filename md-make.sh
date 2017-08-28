#/bin/bash

TARGET="$1"

# Build the pdf
pandoc -o "$TARGET.pdf" "$TARGET"

# Make zathura refresh
killall -HUP zathura
