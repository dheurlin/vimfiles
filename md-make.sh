#/bin/bash

TARGET="$1"

# Build the pdf
# pandoc -o "$TARGET.pdf" --template="/Users/$USER/Dropbox/pandoc_templates/notes.latex" "$TARGET"
pandoc -o "$TARGET.pdf" "$TARGET" --standalone -F pandoc-citeproc --csl ~/.vim/ieee.csl

# Make zathura refresh
killall -HUP zathura &> /dev/null
