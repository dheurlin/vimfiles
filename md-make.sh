#/bin/bash

TARGET="$1"

# Build the pdf
pandoc -o "$TARGET.pdf" "$TARGET"

# Make mupdf refresh
killall -s SIGHUP mupdf-gl &> /dev/null
