#!/bin/bash

# Current directory should be 'stack'
cd "$(dirname "$0")"

# List all subfolders (excluding files and hidden folders)
for dir in */ ; do
    # Remove trailing slash
    subfolder="${dir%/}"

    # For each audio file in the subfolder
    find "$subfolder" -maxdepth 1 -type f | while read -r audiofile; do
        # Get base name without extension
        basename="$(basename "${audiofile%.*}")"

        # For each possible transcription extension
        for ext in tsv srt json vtt txt; do
            # Build possible transcription filename in stack
            transcription="${basename}.${ext}"

            # If transcription file exists in stack (not in subfolder)
            if [[ -f "$transcription" ]]; then
                # Move it to the subfolder
                mv -v "$transcription" "$subfolder/"
            fi
        done
    done
done
