#!/bin/bash

# Function to apply ROT13 transformation
rot13() {
    local file=$1
    cat "$file" | tr "A-Za-z" "N-ZA-Mn-za-m" > temp_file && mv temp_file "$file"
}

# Check if there are any arguments
if [ $# -eq 0 ]; then
    # No arguments, apply ROT13 to all files except shell scripts
    for file in *; do
        if [[ "$file" != *.sh ]]; then
            rot13 "$file"
        fi
    done
else
    # Arguments provided, apply ROT13 only to those files
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            rot13 "$file"
        else
            echo "File not found: $file"
        fi
    done
fi
