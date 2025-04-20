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

# Handle all files with literal question marks in their names
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

# Handle all files with URL-encoded question marks (%3F) in their names
echo "Renaming all files with URL-encoded question marks (%3F)..."
find . -type f -name "*%3F*" | while read file; do
  if [ -f "$file" ]; then
    # Create a new filename by replacing %3F with -
    new_file=$(echo "$file" | sed 's/%3F/-/g')
    
    echo "Renaming $file to $new_file"
    
    # Create the directory if it doesn't exist
    mkdir -p "$(dirname "$new_file")"
    
    # Copy the file to the new name
    cp "$file" "$new_file"
    
    # Remove the original file
    rm "$file"
  fi
done

# Verify no files with question marks remain (both literal and URL-encoded)
remaining_literal=$(find . -type f -name "*\?*" | wc -l)
remaining_encoded=$(find . -type f -name "*%3F*" | wc -l)
remaining=$((remaining_literal + remaining_encoded))

if [ "$remaining" -eq 0 ]; then
  echo "Success: All files with question marks have been renamed."
else
  echo "Warning: $remaining files with question marks still remain. Please check manually."
  echo "Files with literal question marks:"
  find . -type f -name "*\?*"
  echo "Files with URL-encoded question marks:"
  find . -type f -name "*%3F*"
fi

echo "File renaming completed successfully"