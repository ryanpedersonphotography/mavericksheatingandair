#!/bin/bash

# Create a _redirects file for Netlify
echo "# Redirects for WordPress query parameter pages" > _redirects

# Handle WordPress page URLs with query parameters
for file in index.html\?p=*.html; do
  if [ -f "$file" ]; then
    # Extract the page ID
    page_id=$(echo "$file" | sed 's/index.html?p=\(.*\)\.html/\1/')
    
    # Create a new filename without question mark
    new_file="page-${page_id}.html"
    
    # Copy the file to the new name
    cp "$file" "$new_file"
    
    # Add a redirect rule
    echo "/index.html?p=${page_id}.html /page-${page_id}.html 301" >> _redirects
    echo "/index.html?p=${page_id} /page-${page_id}.html 301" >> _redirects
  fi
done

# Handle asset files with version parameters
find ./wp-content ./wp-includes ./wp-json -type f -name "*\?*" 2>/dev/null | while read file; do
  if [ -f "$file" ]; then
    # Create a new filename by replacing ? with -
    new_file=$(echo "$file" | sed 's/?/-/g')
    
    # Create the directory if it doesn't exist
    mkdir -p "$(dirname "$new_file")"
    
    # Copy the file to the new name
    cp "$file" "$new_file"
    
    # Add a redirect rule (relative to the root)
    rel_path="${file#./}"
    new_rel_path="${new_file#./}"
    echo "/${rel_path} /${new_rel_path} 301" >> _redirects
  fi
done

# Add a catch-all redirect for any other query parameters
echo "/* /index.html 200" >> _redirects

echo "Build script completed successfully"