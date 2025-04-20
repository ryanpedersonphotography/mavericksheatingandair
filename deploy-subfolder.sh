#!/bin/bash

echo "=========================================================="
echo "Mavericks Heating and Air - Subfolder Netlify Deployment"
echo "=========================================================="
echo ""

# Check if a subfolder was provided as an argument
if [ -z "$1" ]; then
  # List available directories for the user to choose from
  echo "Available directories:"
  find . -maxdepth 1 -type d | grep -v "^\.$" | grep -v "^\./" | grep -v "^\.git" | grep -v "netlify" | sort
  echo ""
  
  # Ask the user which subfolder they want to deploy
  read -p "Enter the subfolder you want to deploy to Netlify: " SUBFOLDER
else
  SUBFOLDER=$1
fi

# Remove leading ./ if present
SUBFOLDER=${SUBFOLDER#./}

# Check if the subfolder exists
if [ ! -d "$SUBFOLDER" ]; then
  echo "Error: Subfolder '$SUBFOLDER' does not exist."
  exit 1
fi

echo ""
echo "Preparing to deploy subfolder: $SUBFOLDER"
echo ""

# Create a netlify.subfolder.toml file specifically for this subfolder
cat > netlify.subfolder.toml << EOL
[build]
  command = "npm install && bash ./netlify-build.sh"
  publish = "$SUBFOLDER"
  functions = "netlify/functions"

# Configure server-side rendering using Netlify functions
[[redirects]]
  from = "/*"
  to = "/.netlify/functions/server"
  status = 200
  force = false
  conditions = {Role = ["admin"]}

# Fallback to static files for non-admin users
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# Set cache headers for static assets
[[headers]]
  for = "/*"
  [headers.values]
    Cache-Control = "public, max-age=0, must-revalidate"

[[headers]]
  for = "/wp-content/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/wp-includes/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"
EOL

# Update the server.js file to serve files from the subfolder
cat > server.subfolder.js << EOL
const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 8080;
const subfolder = '$SUBFOLDER';

// Serve static files from the subfolder
app.use(express.static(path.join(__dirname, subfolder)));

// For any request that doesn't match a static file, serve index.html from the subfolder
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, subfolder, 'index.html'));
});

// Only start the server if running directly (not when imported by Netlify functions)
if (require.main === module) {
  app.listen(port, () => {
    console.log(\`Server running at http://localhost:\${port}\`);
    console.log(\`Serving files from subfolder: \${subfolder}\`);
  });
}

// Export the app for serverless functions
module.exports = app;
EOL

# Update the netlify function to use the subfolder server
mkdir -p netlify/functions
cat > netlify/functions/server.subfolder.js << EOL
const serverless = require('serverless-http');
const app = require('../../server.subfolder');

// Wrap the Express app with serverless-http
module.exports.handler = serverless(app);
EOL

echo "Configuration files created for subfolder deployment:"
echo "1. netlify.subfolder.toml - Netlify configuration for subfolder"
echo "2. server.subfolder.js - Express server configured for subfolder"
echo "3. netlify/functions/server.subfolder.js - Serverless function for subfolder"
echo ""
echo "To deploy this subfolder to Netlify:"
echo ""
echo "1. Rename the configuration files:"
echo "   mv netlify.subfolder.toml netlify.toml"
echo "   mv server.subfolder.js server.js"
echo "   mv netlify/functions/server.subfolder.js netlify/functions/server.js"
echo ""
echo "2. Run the deployment helper script:"
echo "   ./deploy-to-netlify.sh"
echo ""
echo "3. Commit and push these changes to your GitHub repository:"
echo "   git add ."
echo "   git commit -m \"Configured for subfolder deployment: $SUBFOLDER\""
echo "   git push"
echo ""
echo "4. Deploy to Netlify by connecting your GitHub repository"
echo ""
echo "Your subfolder will be deployed to Netlify with proper server configuration!"