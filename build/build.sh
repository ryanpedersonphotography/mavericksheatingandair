#!/bin/bash

echo "=========================================================="
echo "Mavericks Heating and Air - Build Process"
echo "=========================================================="
echo ""

# Check if a subfolder was provided as an argument
if [ -n "$1" ]; then
  SUBFOLDER=$1
  echo "Building for subfolder: $SUBFOLDER"
  echo ""
  
  # Check if the subfolder exists
  if [ ! -d "$SUBFOLDER" ]; then
    echo "Error: Subfolder '$SUBFOLDER' does not exist."
    exit 1
  fi
else
  echo "Building the entire site"
  echo ""
fi

# Step 1: Install dependencies
echo "Step 1: Installing dependencies..."
npm install
echo ""

# Step 2: Run the rename script to fix filenames
echo "Step 2: Fixing filenames with question marks..."
chmod +x rename-files.sh
./rename-files.sh
echo ""

# Step 3: Fix CSS and JavaScript references
echo "Step 3: Fixing CSS and JavaScript references..."
chmod +x fix-css-references.sh
./fix-css-references.sh
echo ""

# Step 4: Configure for subfolder if specified
if [ -n "$SUBFOLDER" ]; then
  echo "Step 4: Configuring for subfolder deployment..."
  chmod +x deploy-subfolder.sh
  ./deploy-subfolder.sh "$SUBFOLDER"
  
  # Rename the configuration files
  echo "Renaming configuration files for subfolder deployment..."
  mv netlify.subfolder.toml netlify.toml
  mv server.subfolder.js server.js
  mv netlify/functions/server.subfolder.js netlify/functions/server.js
  echo ""
else
  echo "Step 4: Configuring for full site deployment..."
  # Make sure netlify-build.sh is executable
  chmod +x netlify-build.sh
  echo ""
fi

# Step 5: Create a build directory
echo "Step 5: Creating build directory..."
if [ -d "build" ]; then
  rm -rf build
fi
mkdir -p build

# Copy files to build directory
if [ -n "$SUBFOLDER" ]; then
  # Copy only the subfolder contents and necessary files
  echo "Copying subfolder contents to build directory..."
  cp -r "$SUBFOLDER"/* build/
  cp package.json build/
  cp server.js build/
  cp netlify.toml build/
  mkdir -p build/netlify/functions
  cp -r netlify/functions/* build/netlify/functions/
else
  # Copy all files except node_modules and .git
  echo "Copying all files to build directory..."
  rsync -av --exclude 'node_modules' --exclude '.git' --exclude 'build' . build/
fi

echo ""
echo "Build completed successfully!"
echo "The built files are in the 'build' directory."
echo ""
echo "To preview the built site:"
echo "  cd build && npx serve"
echo ""
echo "To deploy to Netlify:"
echo "1. Push your changes to GitHub:"
echo "   git add ."
echo "   git commit -m \"Prepared site for deployment\""
echo "   git push"
echo ""
echo "2. Connect your GitHub repository to Netlify"
echo ""
echo "Or deploy the build directory directly using Netlify CLI:"
echo "  cd build && npx netlify deploy"