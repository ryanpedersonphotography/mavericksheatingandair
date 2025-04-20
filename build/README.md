# Mavericks Heating and Air Website

## Netlify Deployment Instructions

This repository contains a static HTML website exported from WordPress. To deploy it on Netlify, follow these instructions:

## Building and Previewing the Website

### Using npm Scripts (Recommended)

We've added convenient npm scripts to make building and previewing easier:

1. **Build the entire site:**

   ```bash
   npm run build
   ```

2. **Build a specific subfolder:**

   ```bash
   npm run build:subfolder your-subfolder-name
   ```

3. **Preview the entire site:**

   ```bash
   npm run preview
   ```

4. **Preview a specific subfolder:**

   ```bash
   npm run preview:subfolder
   ```
   
   This will prompt you to select a subfolder.

5. **Deploy to Netlify:**

   ```bash
   npm run deploy
   ```
   
   For production deployment:
   
   ```bash
   npm run deploy:prod
   ```

### Using Shell Scripts Directly

If you prefer to use the shell scripts directly:

#### Building the Website

1. **Make the script executable:**

   ```bash
   chmod +x build.sh
   ```

2. **Run the build script:**

   ```bash
   ./build.sh
   ```

   This will:
   - Install necessary dependencies
   - Fix any files with question marks in their names
   - Fix CSS and JavaScript references
   - Create a `build` directory with the optimized site

3. **Build a specific subfolder:**

   If you want to build just a specific subfolder:

   ```bash
   ./build.sh your-subfolder-name
   ```

4. **Preview the built site:**

   After building, you can preview the built site with:

   ```bash
   cd build && npx serve
   ```

#### Previewing the Website Locally

Before deploying to Netlify, you can preview the website locally to ensure everything looks correct:

1. **Make the preview script executable:**

   ```bash
   chmod +x preview.sh
   ```

2. **Run the preview script:**

   ```bash
   ./preview.sh
   ```

   This will:
   - Install necessary dependencies
   - Fix any files with question marks in their names
   - Start a local server at http://localhost:8080
   - Display your website exactly as it will appear on Netlify

3. **Preview a specific subfolder:**

   If you want to preview just a specific subfolder:

   ```bash
   ./preview.sh --subfolder your-subfolder-name
   ```

   Or let the script prompt you for a subfolder:

   ```bash
   ./preview.sh --subfolder
   ```

4. **Skip the file fixes:**

   If you've already run the fixes and just want to preview:

   ```bash
   ./preview.sh --no-fixes
   ```

5. **Stop the preview server:**

   Press `Ctrl+C` in the terminal to stop the server when you're done.

## Deploying the Entire Website

### Quick Start: Use the Deployment Helper Script

We've created a helper script that will guide you through the entire deployment process:

1. **Make the script executable:**

   ```bash
   chmod +x deploy-to-netlify.sh
   ```

2. **Run the deployment helper script:**

   ```bash
   ./deploy-to-netlify.sh
   ```

   This script will:
   - Check for files with question marks in their names (both literal `?` and URL-encoded `%3F`)
   - Run the rename script to fix these files
   - Fix CSS and JavaScript references in HTML files (handling both literal and URL-encoded question marks)
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
   - Rename asset files with literal question marks (`?`) in their names
   - Rename asset files with URL-encoded question marks (`%3F`) in their names
   - Replace question marks with hyphens in all cases

3. **Verify that all files with question marks have been renamed:**

   ```bash
   # Check for literal question marks
   find . -name "*\?*" -type f
   
   # Check for URL-encoded question marks
   find . -name "*%3F*" -type f
   ```

   These commands should return no results if all files have been renamed successfully.

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
   - Update references to CSS and JS files with both literal question marks (`?`) and URL-encoded question marks (`%3F`)
   - Replace question marks with hyphens in the references

#### Step 3: Commit and Deploy

1. **Commit and push the changes to your repository:**

   ```bash
   git add .
   git commit -m "Prepared files for Netlify deployment with URL-encoded fixes"
   git push
   ```

2. **Deploy to Netlify by connecting your GitHub repository**

## Deploying a Specific Subfolder

If you want to deploy only a specific subfolder of your project to Netlify, we've created a special script for that:

### Using the Subfolder Deployment Script

1. **Make the script executable:**

   ```bash
   chmod +x deploy-subfolder.sh
   ```

2. **Run the subfolder deployment script:**

   ```bash
   ./deploy-subfolder.sh
   ```

   Or specify the subfolder directly:

   ```bash
   ./deploy-subfolder.sh your-subfolder-name
   ```

   This script will:
   - Configure a Node.js Express server to serve files from your specified subfolder
   - Create Netlify serverless functions to handle server-side rendering
   - Generate all necessary configuration files for subfolder deployment
   - Provide instructions for committing and deploying

3. **Follow the instructions provided by the script** to rename the configuration files and deploy to Netlify

### How Subfolder Deployment Works

The subfolder deployment uses:

1. **Express.js Server**: A Node.js server that serves static files from your specified subfolder
2. **Netlify Functions**: Serverless functions that run the Express server in a serverless environment
3. **Custom Configuration**: A modified netlify.toml file that configures Netlify to use the serverless functions

This approach allows you to deploy just a portion of your project while maintaining the correct file structure and routing.

### Important Note About URL-Encoded Question Marks

When WordPress sites are exported to static HTML, question marks in URLs are often URL-encoded as `%3F`. For example:
- Original CSS reference: `style.min.css?ver=3.3.0.css`
- URL-encoded reference: `style.min.css%3Fver=3.3.0.css`

Our scripts handle both formats to ensure all references are properly updated.

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