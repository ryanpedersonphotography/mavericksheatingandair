#!/bin/bash

# Rename WordPress page files in the root directory
for file in index.html\?p=*.html; do
  if [ -f "$file" ]; then
    # Extract the page ID
    page_id=$(echo "$file" | sed 's/index.html?p=\(.*\)\.html/\1/')
    
    # Create a new filename without question mark
    new_file="page-${page_id}.html"
    
    echo "Renaming $file to $new_file"
    
    # Copy the file to the new name
    cp "$file" "$new_file"
  fi
done

# Handle asset files with version parameters
find ./wp-content ./wp-includes ./wp-json -type f -name "*\?*" | while read file; do
  # Create a new filename by replacing ? with -
  new_file=$(echo "$file" | sed 's/?/-/g')
  
  echo "Renaming $file to $new_file"
  
  # Create the directory if it doesn't exist
  mkdir -p "$(dirname "$new_file")"
  
  # Copy the file to the new name
  cp "$file" "$new_file"
done

echo "File renaming completed successfully"