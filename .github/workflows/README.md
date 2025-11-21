# GitHub Actions Workflows

## Hugo Deployment to GitHub Pages

The `gh-pages.yml` workflow automatically builds and deploys the Hugo documentation site to GitHub Pages whenever changes are pushed to the `main` branch in the `presentation/` directory.

### How It Works

1. **Trigger**: Runs on pushes to `main` branch when files in `presentation/` change
2. **Build**: Sets up Hugo, builds the site with minification
3. **Deploy**: Uploads the built site to GitHub Pages

### Setup Requirements

1. Enable GitHub Pages in repository settings:
   - Go to Settings → Pages
   - Source: Select "GitHub Actions"

2. The workflow will automatically deploy to:
   - `https://hogandenver05.github.io/Eato/`

### Manual Trigger

You can also manually trigger the workflow:
- Go to Actions tab
- Select "Deploy Hugo Site to GitHub Pages"
- Click "Run workflow"

