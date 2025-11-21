# Hugo Documentation Site

This directory contains the Hugo static site for the Eato Meal Tracker documentation and portfolio.

## Structure

- `content/` - Markdown content files
  - `_index.md` - Homepage
  - `project1/` - Project 1 documentation
  - `portfolio/` - Portfolio showcase
- `layouts/` - HTML templates
- `static/` - Static assets (images, CSS, etc.)
- `public/` - Generated site (gitignored, built by Hugo)
- `hugo.toml` - Hugo configuration

## Local Development

### Start Development Server

```bash
cd presentation
hugo server --buildDrafts
```

Visit `http://localhost:1313` to view the site.

### Build Static Site

```bash
hugo --minify
```

This generates the static site in the `public/` directory.

## Deployment

The site is configured to deploy to GitHub Pages at:
`https://hogandenver05.github.io/Eato/`

### Manual Deployment

1. Build the site: `hugo --minify`
2. Copy `public/` contents to GitHub Pages branch or repository

### Automatic Deployment (Recommended)

Use GitHub Actions to automatically build and deploy on push (see `.github/workflows/` in main repository).

## Content

- **Homepage** (`content/_index.md`) - Overview of the Eato project
- **Project 1** (`content/project1/_index.md`) - Original PHP REST API documentation
- **Portfolio** (`content/portfolio/_index.md`) - ASE 230 projects showcase

## Adding New Content

Create new markdown files in the appropriate `content/` subdirectory:

```bash
hugo new section-name/page-name.md
```

Edit the file and add your content in Markdown format.

