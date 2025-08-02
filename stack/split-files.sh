#!/bin/bash
find . -type f -name "*.mp3.original" | while read -r orig; do
  dir="$(dirname "$orig")"
  base="$(basename "${orig%.mp3.original}")"
  echo "Splitting $orig into chunks in $dir..."
  ffmpeg -i "$orig" -f segment -segment_time 6000 -c copy "$dir/${base}_chunk_%03d.mp3"
done
