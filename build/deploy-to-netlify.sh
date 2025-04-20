#!/bin/bash

echo "=========================================================="
echo "Mavericks Heating and Air - Netlify Deployment Preparation"
echo "=========================================================="
echo ""
echo "This script will help you prepare your site for Netlify deployment."
echo ""

# Step 1: Rename files with question marks (both literal and URL-encoded)
echo "STEP 1: Renaming files with question marks"
echo "----------------------------------------"

# Check if there are files with literal question marks
question_mark_files=$(find . -type f -name "*\?*" | wc -l)
# Check if there are files with URL-encoded question marks
encoded_question_mark_files=$(find . -type f -name "*%3F*" | wc -l)
total_files=$((question_mark_files + encoded_question_mark_files))

if [ "$total_files" -gt 0 ]; then
  echo "Found $question_mark_files files with literal question marks (?) in their names."
  echo "Found $encoded_question_mark_files files with URL-encoded question marks (%3F) in their names."
  echo "These files need to be renamed before deploying to Netlify."
  echo ""
  
  # Make rename-files.sh executable
  chmod +x rename-files.sh
  
  echo "Running rename-files.sh to rename files with question marks..."
  ./rename-files.sh
  
  # Check if there are still files with question marks (both literal and URL-encoded)
  remaining_literal=$(find . -type f -name "*\?*" | wc -l)
  remaining_encoded=$(find . -type f -name "*%3F*" | wc -l)
  remaining=$((remaining_literal + remaining_encoded))
  
  if [ "$remaining" -gt 0 ]; then
    echo ""
    echo "ERROR: There are still $remaining files with question marks."
    echo "Please check these files manually:"
    echo "Files with literal question marks:"
    find . -type f -name "*\?*"
    echo "Files with URL-encoded question marks:"
    find . -type f -name "*%3F*"
    echo ""
    echo "Netlify will reject these files. Please fix them before deploying."
    exit 1
  else
    echo ""
    echo "SUCCESS: All files with question marks have been renamed."
  fi
else
  echo "No files with question marks found. Proceeding to next step."
fi

echo ""
echo "STEP 2: Fixing CSS and JavaScript references in HTML files"
echo "-------------------------------------------------------"

# Make fix-css-references.sh executable
chmod +x fix-css-references.sh

echo "Running fix-css-references.sh to update HTML references..."
echo "(This will fix both literal and URL-encoded question marks in references)"
./fix-css-references.sh

echo ""
echo "STEP 3: Deployment"
echo "----------------"
echo "Next steps:"
echo "1. Commit and push these changes to your GitHub repository:"
echo "   git add ."
echo "   git commit -m \"Prepared files for Netlify deployment with URL-encoded fixes\""
echo "   git push"
echo ""
echo "2. Deploy to Netlify by connecting your GitHub repository"
echo ""
echo "Your site should now deploy successfully on Netlify with proper styling!"