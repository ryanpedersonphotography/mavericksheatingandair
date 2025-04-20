#!/bin/bash

echo "=========================================================="
echo "Mavericks Heating and Air - Local Preview Server"
echo "=========================================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
  echo "Error: Node.js is not installed. Please install Node.js to continue."
  echo "Visit https://nodejs.org/ to download and install Node.js."
  exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
  echo "Error: npm is not installed. Please install npm to continue."
  echo "It usually comes with Node.js installation."
  exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
  echo ""
fi

# Function to run the rename and fix scripts
run_fixes() {
  # Make scripts executable
  chmod +x rename-files.sh
  chmod +x fix-css-references.sh
  
  echo "Running rename-files.sh to fix filenames with question marks..."
  ./rename-files.sh
  
  echo ""
  echo "Running fix-css-references.sh to update HTML references..."
  ./fix-css-references.sh
  
  echo ""
}

# Function to preview the entire site
preview_entire_site() {
  echo "Starting preview server for the entire site..."
  echo "The website will be available at: http://localhost:8080"
  echo "Press Ctrl+C to stop the server."
  echo ""
  
  # Start the server
  npx nodemon server.js
}

# Function to preview a specific subfolder
preview_subfolder() {
  local subfolder=$1
  
  # Remove leading ./ if present
  subfolder=${subfolder#./}
  
  # Check if the subfolder exists
  if [ ! -d "$subfolder" ]; then
    echo "Error: Subfolder '$subfolder' does not exist."
    exit 1
  fi
  
  echo "Creating temporary server configuration for subfolder: $subfolder"
  
  # Create a temporary server file for the subfolder
  cat > server.temp.js << EOL
const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 8080;
const subfolder = '$subfolder';

// Serve static files from the subfolder
app.use(express.static(path.join(__dirname, subfolder)));

// For any request that doesn't match a static file, serve index.html from the subfolder
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, subfolder, 'index.html'));
});

// Start the server
app.listen(port, () => {
  console.log(\`Server running at http://localhost:\${port}\`);
  console.log(\`Serving files from subfolder: \${subfolder}\`);
});
EOL
  
  echo "Starting preview server for subfolder: $subfolder"
  echo "The website will be available at: http://localhost:8080"
  echo "Press Ctrl+C to stop the server."
  echo ""
  
  # Start the server with the temporary configuration
  npx nodemon server.temp.js
}

# Check if we should run the fixes
run_fixes_flag=true
if [ "$1" == "--no-fixes" ] || [ "$2" == "--no-fixes" ] || [ "$3" == "--no-fixes" ]; then
  run_fixes_flag=false
fi

# Run the fixes if needed
if [ "$run_fixes_flag" == "true" ]; then
  run_fixes
fi

# Check if a subfolder was specified
if [ "$1" == "--subfolder" ] && [ -n "$2" ]; then
  # Preview the specified subfolder
  preview_subfolder "$2"
elif [ "$1" == "--subfolder" ] && [ -z "$2" ]; then
  # List available directories for the user to choose from
  echo "Available directories:"
  find . -maxdepth 1 -type d | grep -v "^\.$" | grep -v "^\./" | grep -v "^\.git" | grep -v "netlify" | sort
  echo ""
  
  # Ask the user which subfolder they want to preview
  read -p "Enter the subfolder you want to preview: " SUBFOLDER
  preview_subfolder "$SUBFOLDER"
else
  # Preview the entire site
  preview_entire_site
fi