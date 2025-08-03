#!/bin/bash

# Loop over directories that contain .original files but no .mp3 files
find . -type f -name '*.original' -printf '%h\n' | sort -u | while IFS= read -r dir; do
  if ! find "$dir" -maxdepth 1 -type f -name '*.mp3' | grep -q .; then
    echo "Processing directory: $dir"

    # For each .original file in that dir, split into chunks
    find "$dir" -maxdepth 1 -type f -name '*.mp3.original' | while IFS= read -r orig; do
      base="$(basename "${orig%.mp3.original}")"
      echo "  Splitting $orig into chunks..."
      ffmpeg -hide_banner -loglevel warning -i "$orig" -f segment -segment_time 6000 -c copy "$dir/${base}_chunk_%03d.mp3"
    done
  else
    echo "Skipping $dir: mp3(s) already exist"
  fi
done

