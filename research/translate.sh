#!/bin/bash

# Script to process text files (excluding overview.txt) and generate summaries
# Usage: Place in directory with .txt files and run

# Constants
readonly MAIN_DIR="$(pwd)"
readonly PROGRESS_FILE="$MAIN_DIR/progress.log"
readonly PROCESSED_FILES="$MAIN_DIR/processed_files.log"
readonly SUMMARY_FILE="$MAIN_DIR/preliminary-research.txt"
readonly CHUNK_LINES=100

# Check if file was already processed
is_processed() {
    grep -Fxq "$1" "$PROCESSED_FILES" 2>/dev/null
}

# Logging helper
log() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$message" | tee -a "$PROGRESS_FILE"
}

# Initialize logs
initialize_logs() {
    touch "$PROGRESS_FILE" "$PROCESSED_FILES" "$SUMMARY_FILE" 2>/dev/null || {
        echo "Cannot create logs in $MAIN_DIR" >&2
        exit 1
    }
}

# Process files
process_files() {
    local dir="$1"
    log "Processing directory: $dir"

    for file in "$dir"/*.txt; do
        [[ -f "$file" ]] || continue
        local filename="$(basename "$file")"

        if [[ "$filename" == "detailed_summary.txt" ]]; then
            log "Skipping detailed_summary.txt"
            continue
        fi

        # Skip overview and processed files
        [[ "$filename" == "overview.txt" ]] && { log "Skipping $filename"; continue; }
        grep -Fxq "$filename" "$PROCESSED_FILES" && { log "Already processed: $filename"; continue; }

        log "Processing file: $filename"

        local temp_dir="$(mktemp -d)"
        log "Created temporary directory: $temp_dir"

        # Split into chunks of 100 lines
        split -l 100 -d --additional-suffix=".txt" "$file" "$temp_dir/${filename}_chunk_"

        # Process chunks
        for chunk in "$temp_dir"/*.txt; do
            chunkname="$(basename "$chunk")"
            log "Summarizing $chunkname"

            echo -e "\n===== Summary of $filename (chunk: $chunkname) =====\n" >> "$SUMMARY_FILE"
            ollama run vanilj/phi-4 "Abeg, translate dis text into Nigerian Pidgin English wey dey sweet for ear and easy to sabi, like how we dey talk for Naija everyday. Make e flow well-well, no be book English o, but dat proper street vibe wey fit our langwej. Summarize am in detail and explain:" < "$chunk" | tee -a "$SUMMARY_FILE"
            echo -e "\n---\n" >> "$SUMMARY_FILE"
        done

        # Cleanup and marking
        rm -rf "$temp_dir"
        log "Removed temp directory: $temp_dir"
        echo "$filename" >> "$PROCESSED_FILES"
        log "Marked as processed: $filename"
    done
}

# Recursive processing
process_subdirectories() {
    local parent_dir="$1"
    for subdir in "$parent_dir"/*/; do
        [[ -d "$subdir" ]] && process_files "$subdir"
    done
}

# Main
main() {
    trap 'log "Script interrupted"; exit 1' INT TERM

    initialize_logs
    process_files "$MAIN_DIR"
    process_subdirectories "$MAIN_DIR"

    log "Script completed"
}

main
