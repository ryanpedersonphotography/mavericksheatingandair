# Mavericks Heating and Air Website

## Netlify Deployment Instructions

This repository contains a static HTML website exported from WordPress. To deploy it on Netlify, follow these instructions:

### Quick Start: Use the Deployment Helper Script

We've created a helper script that will guide you through the entire process:

1. **Make the script executable:**

   ```bash
   chmod +x deploy-to-netlify.sh
   ```

2. **Run the deployment helper script:**

   ```bash
   ./deploy-to-netlify.sh
   ```

   This script will:
   - Check for files with question marks in their names
   - Run the rename script to fix these files
   - Fix CSS and JavaScript references in HTML files
   - Verify that all problematic files have been fixed
   - Provide instructions for committing and deploying

### Manual Process: Step-by-Step Deployment

If you prefer to do this manually:

#### Step 1: Rename Files with Question Marks

Netlify will reject any files with question marks in their names:

1. **Make the rename script executable:**

   ```bash
   chmod +x rename-files.sh
   ```

2. **Run the rename script:**

   ```bash
   ./rename-files.sh
   ```

   This script will:
   - Rename WordPress page files with question marks in their names (e.g., `index.html?p=215.html` to `page-215.html`)
   - Rename asset files with version parameters in wp-content, wp-includes, and wp-json directories

3. **Verify that all files with question marks have been renamed:**

   ```bash
   find . -name "*\?*" -type f
   ```

   This command should return no results if all files have been renamed successfully.

#### Step 2: Fix CSS and JavaScript References

After renaming the files, you need to update the HTML files to reference the renamed CSS and JS files:

1. **Make the CSS fix script executable:**

   ```bash
   chmod +x fix-css-references.sh
   ```

2. **Run the CSS fix script:**

   ```bash
   ./fix-css-references.sh
   ```

   This script will:
   - Find all HTML files in the project
   - Update references to CSS and JS files with question marks
   - Replace question marks with hyphens in the references

#### Step 3: Commit and Deploy

1. **Commit and push the changes to your repository:**

   ```bash
   git add .
   git commit -m "Prepared files for Netlify deployment"
   git push
   ```

2. **Deploy to Netlify by connecting your GitHub repository**

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