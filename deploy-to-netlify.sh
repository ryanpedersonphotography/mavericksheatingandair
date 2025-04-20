#!/bin/bash

echo "=========================================================="
echo "Mavericks Heating and Air - Netlify Deployment Preparation"
echo "=========================================================="
echo ""
echo "This script will help you prepare your site for Netlify deployment."
echo ""

# Step 1: Rename files with question marks
echo "STEP 1: Renaming files with question marks"
echo "----------------------------------------"

# Check if there are files with question marks
question_mark_files=$(find . -type f -name "*\?*" | wc -l)

if [ "$question_mark_files" -gt 0 ]; then
  echo "Found $question_mark_files files with question marks in their names."
  echo "These files need to be renamed before deploying to Netlify."
  echo ""
  
  # Make rename-files.sh executable
  chmod +x rename-files.sh
  
  echo "Running rename-files.sh to rename files with question marks..."
  ./rename-files.sh
  
  # Check if there are still files with question marks
  remaining=$(find . -type f -name "*\?*" | wc -l)
  
  if [ "$remaining" -gt 0 ]; then
    echo ""
    echo "ERROR: There are still $remaining files with question marks."
    echo "Please check these files manually:"
    find . -type f -name "*\?*"
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
./fix-css-references.sh

echo ""
echo "STEP 3: Deployment"
echo "----------------"
echo "Next steps:"
echo "1. Commit and push these changes to your GitHub repository:"
echo "   git add ."
echo "   git commit -m \"Prepared files for Netlify deployment\""
echo "   git push"
echo ""
echo "2. Deploy to Netlify by connecting your GitHub repository"
echo ""
echo "Your site should now deploy successfully on Netlify with proper styling!"