#!/bin/bash

# Counter for the new filenames
counter=1

# Loop through all .png files in the current directory
for file in *.png; do
  # Format the counter with leading zeros
  new_name=$(printf "gish-gallop-%02d.png" $counter)
  
  # Rename the file
  mv "$file" "$new_name"
  
  # Increment the counter
  counter=$((counter + 1))
  
  # Stop after 26 files
  if [ $counter -gt 26 ]; then
    break
  fi
done
