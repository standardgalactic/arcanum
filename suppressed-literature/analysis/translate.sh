#!/usr/bin/env bash
set -Eeuo pipefail

SUMMARY_COMMAND=("ollama" "run" "vanilj/phi-4")
PROGRESS_FILE="progress.log"
OUTPUT_FILE="spanish-translation.text"

main_dir="$(pwd)"
touch "$main_dir/$PROGRESS_FILE"
: > "$main_dir/$OUTPUT_FILE"  # Clear output file at start

log() {
    local message="[${USER:-$(whoami)}@$(hostname)] [$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$message"
    echo "$message" >> "$main_dir/$PROGRESS_FILE"
}

is_processed() {
    local file_path="$1"
    grep -Fxq "$file_path" "$main_dir/$PROGRESS_FILE"
}

mark_processed() {
    local file_path="$1"
    echo "$file_path" >> "$main_dir/$PROGRESS_FILE"
}

log "Script started."

shopt -s nullglob
files=("$main_dir"/*.txt)
shopt -u nullglob

IFS=$'\n' sorted_files=($(printf "%s\n" "${files[@]}" | sort))

for file in "${sorted_files[@]}"; do
    [[ -f "$file" && ! -L "$file" ]] || continue

    if [[ "$file" == *overview.txt ]]; then
        log "Skipping summary file: $file"
        continue
    fi

    if ! is_processed "$file"; then
        file_name="$(basename "$file")"
        log "Processing $file"
  echo "===== Translation of: $file_name ====="
        {
          
            echo
            echo "Translate the following to Spanish:"
            cat "$file"
            echo
            echo
        } | "${SUMMARY_COMMAND[@]}" 2>>"$main_dir/$PROGRESS_FILE" | tee -a "$main_dir/$OUTPUT_FILE"

        mark_processed "$file"
        log "Finished processing $file_name"
    else
        log "Skipping already processed file: $file"
    fi
done

log "Script completed."
