#!/bin/bash

output_file="overview.txt"
previous_summary=""

# Summarize all txt files
for file in *.txt; do
    if [ "$file" == "$output_file" ]; then
        echo "Skipping output file: $file" >> "$output_file"
        continue # Skip the summaries file itself
    fi

    if [ ! -s "$file" ]; then
        echo "Skipping empty file: $file" >> "$output_file"
        continue # Skip summarizing if the file is empty
    fi

    echo "Checking $file" | tee -a "$output_file"
    echo "=== Summary for $file ===" | tee -a "$output_file"

    # Prepare the input for the summarizer
    if [ -n "$previous_summary" ]; then
        echo "Summarizing previous summary and current file: $file" | tee -a "$output_file"
        echo -e "Summarizing previous summary:\n$previous_summary" > temp_input.txt
        cat "$file" >> temp_input.txt
    else
        echo "Summarizing current file: $file" | tee -a "$output_file"
        cat "$file" > temp_input.txt
    fi

    # Run the summarizer
    current_summary=$(ollama run vanilj/phi-4 "Summarize in detail and explain:" < temp_input.txt)
    echo "$current_summary" | tee -a "$output_file"

    # Update the previous summary
    previous_summary=$(echo -e "The previous section said this:\n$current_summary")

    echo -e "\n" | tee -a "$output_file" # Add a blank line between summaries
done

# Cleanup
rm -f temp_input.txt
