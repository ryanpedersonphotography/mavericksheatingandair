# Mavericks Heating and Air Website

## Netlify Deployment Instructions

This repository contains a static HTML website exported from WordPress. To deploy it on Netlify, follow these instructions:

### Preparation

1. **Run the rename script locally before deploying:**

   ```bash
   ./rename-files.sh
   ```

   This script will:
   - Rename WordPress page files with question marks in their names (e.g., `index.html?p=215.html` to `page-215.html`)
   - Rename asset files with version parameters in wp-content, wp-includes, and wp-json directories

2. **Commit the renamed files to your repository**

### Netlify Configuration

The repository includes the following configuration files:

- **package.json**: A minimal package.json file to satisfy Netlify's dependency caching mechanism
- **netlify.toml**: Configuration file that tells Netlify how to handle your static site
- **netlify-build.sh**: Build script that runs during Netlify deployment to handle any remaining files with question marks
- **_redirects**: Fallback redirects file that handles WordPress page URLs with query parameters

### Deployment Steps

1. Log in to your Netlify account
2. Click "Add new site" > "Import an existing project"
3. Connect to your Git provider and select this repository
4. Configure the build settings:
   - Build command: (leave as configured in netlify.toml)
   - Publish directory: (leave as configured in netlify.toml)
5. Click "Deploy site"

### Troubleshooting

If you encounter issues with files containing question marks:

1. Make sure you've run the `rename-files.sh` script locally
2. Commit and push all the renamed files
3. Check the Netlify build logs for any errors
4. Verify that the _redirects file is properly deployed

## Local Development

To view the site locally, simply open the `index.html` file in your browser.