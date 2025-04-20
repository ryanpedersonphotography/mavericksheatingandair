#!/bin/bash

echo "=========================================================="
echo "Fixing CSS and JavaScript references in HTML files"
echo "=========================================================="
echo ""

# Find all HTML files
html_files=$(find . -type f -name "*.html")

# Counter for modified files
modified_count=0

for file in $html_files; do
  echo "Processing $file..."
  
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
    echo "  Modified: References updated"
  else
    rm "$temp_file"
    echo "  Skipped: No changes needed"
  fi
done

echo ""
echo "Completed! Modified $modified_count HTML files."
echo ""
echo "Next steps:"
echo "1. Commit and push these changes to your GitHub repository:"
echo "   git add ."
echo "   git commit -m \"Fixed CSS and JavaScript references with URL-encoded question marks\""
echo "   git push"
echo ""
echo "2. Your site should now display correctly on Netlify with proper styling!"