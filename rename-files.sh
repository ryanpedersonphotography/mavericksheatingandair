#!/bin/bash

echo "Starting file renaming process..."

# Rename WordPress page files in the root directory
echo "Renaming WordPress page files in the root directory..."
for file in index.html\?p=*.html; do
  if [ -f "$file" ]; then
    # Extract the page ID
    page_id=$(echo "$file" | sed 's/index.html?p=\(.*\)\.html/\1/')
    
    # Create a new filename without question mark
    new_file="page-${page_id}.html"
    
    echo "Renaming $file to $new_file"
    
    # Copy the file to the new name
    cp "$file" "$new_file"
    
    # Remove the original file
    rm "$file"
  fi
done

# Handle all files with question marks in their names
echo "Renaming all files with question marks..."
find . -type f -name "*\?*" | while read file; do
  if [ -f "$file" ]; then
    # Create a new filename by replacing ? with -
    new_file=$(echo "$file" | sed 's/?/-/g')
    
    echo "Renaming $file to $new_file"
    
    # Create the directory if it doesn't exist
    mkdir -p "$(dirname "$new_file")"
    
    # Copy the file to the new name
    cp "$file" "$new_file"
    
    # Remove the original file
    rm "$file"
  fi
done

# Verify no files with question marks remain
remaining=$(find . -type f -name "*\?*" | wc -l)
if [ "$remaining" -eq 0 ]; then
  echo "Success: All files with question marks have been renamed."
else
  echo "Warning: $remaining files with question marks still remain. Please check manually."
  find . -type f -name "*\?*"
fi

echo "File renaming completed successfully"