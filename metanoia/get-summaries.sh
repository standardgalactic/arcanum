#!/usr/bin/env bash
set -Eeuo pipefail

###############################################################################
#  Usage:
#    1) Make it executable:  chmod +x summarize.sh
#    2) Run in the directory that has your no-extension files.
#
#  Description:
#    - Splits each file into 200-line chunks (into a temporary folder).
#    - Calls Ollama to summarize each chunk.
#    - Progress is logged to progress.log.
#    - Each file’s summary is output to "<filename>-overview.txt".
#    - Displays the summary in the terminal (via tee) as it’s generated.
###############################################################################

CHUNK_LINES=200
MODEL_COMMAND=("ollama" "run" "vanilj/phi-4")
PROGRESS_FILE="progress.log"

main_dir="$(pwd)"
touch "$main_dir/$PROGRESS_FILE"

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

cleanup_tempdirs() {
  if [[ -n "${TEMP_DIRS_CREATED:-}" ]]; then
    for tmpd in $TEMP_DIRS_CREATED; do
      [[ -d "$tmpd" ]] && rm -rf "$tmpd"
      log "Cleaned up temporary directory: $tmpd"
    done
  fi
}
trap cleanup_tempdirs EXIT

log "Script started."

process_files_in_directory() {
  local dir="$1"
  log "Processing directory: $dir"

  shopt -s nullglob
  local all_files=("$dir"/*)
  shopt -u nullglob

  [[ ${#all_files[@]} -eq 0 ]] && {
    log "No files found in $dir"
    return
  }

  for file in "${all_files[@]}"; do
    # Skip directories, symlinks, or files with an extension
    [[ -f "$file" && ! -L "$file" ]] || continue

    local file_name="$(basename "$file")"

    # If there's a dot, skip (assuming you only want no-extension files):
    if [[ "$file_name" == *.* ]]; then
      log "Skipping because it has an extension or dot: $file"
      continue
    fi

    if is_processed "$file"; then
      log "Skipping (already processed): $file"
      continue
    fi

    log "Processing file: $file"

    # Make a temp dir for chunks
    local sanitized_name
    sanitized_name="$(echo "$file_name" | tr -d '[:space:]')"
    local temp_dir
    temp_dir="$(mktemp -d "$dir/tmp_${sanitized_name}_XXXXXX")"
    TEMP_DIRS_CREATED="${TEMP_DIRS_CREATED:-} $temp_dir"
    log "Created temporary directory: $temp_dir"

    # Copy or pre-process the file
    local preprocessed_file="$temp_dir/preprocessed.txt"
    cp "$file" "$preprocessed_file"

    # Split into chunks
    split -l "$CHUNK_LINES" -- "$preprocessed_file" "$temp_dir/chunk_"
    log "Split $file into chunks of $CHUNK_LINES lines each."

    # Overview file
    local summary_file="$dir/${file_name}-overview.txt"
    touch "$summary_file"
    log "Summaries will go to $summary_file"

    # Summarize each chunk
    for chunk_file in "$temp_dir"/chunk_*; do
      [[ -f "$chunk_file" ]] || continue
      local chunk_name
      chunk_name="$(basename "$chunk_file")"
      log "Summarizing chunk: $chunk_name"

      {
        echo "Summarize in detail and explain:"
        echo "---------------"
        cat "$chunk_file"
      } | "${MODEL_COMMAND[@]}" 2>>"$main_dir/$PROGRESS_FILE" \
        | tee -a "$summary_file"

      # Blank line after each chunk summary
      echo "" >> "$summary_file"
    done

    mark_processed "$file"
    log "Marked $file as processed."
  done
}

# Process current directory
process_files_in_directory "$main_dir"

# If you want subdirectories, uncomment:
# for subdir in "$main_dir"/*/; do
#   [[ -d "$subdir" ]] && process_files_in_directory "$subdir"
# done

log "Script completed."
