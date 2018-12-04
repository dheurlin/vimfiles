#/bin/bash

TARGET="$1"

# Build the pdf
# pandoc -o "$TARGET.pdf" "$TARGET" --standalone -F pandoc-citeproc --csl ~/.vim/ieee.csl
pandoc -o "$TARGET.pdf" --pdf-engine=xelatex "$TARGET"

# Make zathura refresh
# killall -HUP zathura &> /dev/null
