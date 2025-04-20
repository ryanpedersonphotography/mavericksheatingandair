#!/bin/bash

echo "Starting Netlify build process..."

# Create a _redirects file for Netlify
echo "# Redirects for WordPress query parameter pages" > _redirects

# Step 1: Handle WordPress page URLs with query parameters
echo "Step 1: Renaming WordPress page files..."
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

# Step 2: Handle asset files with question marks and URL-encoded question marks
echo "Step 2: Renaming asset files with question marks..."
# Handle files with literal question marks
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

# Handle files with URL-encoded question marks (%3F)
find ./wp-content ./wp-includes ./wp-json -type f -name "*%3F*" 2>/dev/null | while read file; do
  if [ -f "$file" ]; then
    # Create a new filename by replacing %3F with -
    new_file=$(echo "$file" | sed 's/%3F/-/g')
    
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

# Step 3: Fix CSS and JavaScript references in HTML files
echo "Step 3: Fixing CSS and JavaScript references in HTML files..."
# Find all HTML files
html_files=$(find . -type f -name "*.html")

# Counter for modified files
modified_count=0

for file in $html_files; do
  # Create a temporary file
  temp_file="${file}.tmp"
  
  # Replace URL-encoded question marks (%3F) in CSS/JS references
  # This replaces patterns like href="style.min.css%3Fver=3.3.0.css" with href="style.min.css-ver=3.3.0.css"
  sed 's/\(href="[^"]*\)%3F\([^"]*"\)/\1-\2/g' "$file" > "$temp_file"
  
  # Also replace regular question marks in case they exist
  sed -i 's/\(href="[^"]*\)?\([^"]*"\)/\1-\2/g' "$temp_file"
  
  # Replace URL-encoded question marks in src attributes
  sed -i 's/\(src="[^"]*\)%3F\([^"]*"\)/\1-\2/g' "$temp_file"
  
  # Also replace regular question marks in src attributes
  sed -i 's/\(src="[^"]*\)?\([^"]*"\)/\1-\2/g' "$temp_file"
  
  # Check if the file was modified
  if ! cmp -s "$file" "$temp_file"; then
    mv "$temp_file" "$file"
    modified_count=$((modified_count + 1))
  else
    rm "$temp_file"
  fi
done

echo "Modified $modified_count HTML files to fix CSS/JS references."

# Add a catch-all redirect for any other query parameters
echo "/* /index.html 200" >> _redirects

echo "Build script completed successfully"