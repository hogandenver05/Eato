# Hugo Documentation Site

This directory contains the Hugo static site for the **Eato Meal Tracker** documentation. This is part of the [Eato Meal Tracker project](../README.md).

## Structure

- `content/` - Markdown content files
  - `_index.md` - Homepage with project overview
  - `api-client/` - Interactive API client page
- `layouts/` - HTML templates
  - `api-client/` - Custom layout for API client page
- `static/` - Static assets
  - `js/` - JavaScript files (API client)
  - `css/` - Stylesheets (API client styling)
- `public/` - Generated site (gitignored, built by Hugo)
- `hugo.toml` - Hugo configuration

## Local Development

### Quick Test (Recommended)

Use the test script to start the development server with proper local configuration:

```bash
cd presentation
./test-local.sh
```

This will:
- Check if Hugo is installed
- Check if the Laravel API is running
- Start the Hugo server at `http://localhost:1313`
- Use the correct baseURL for local testing

### Manual Start

```bash
cd presentation
hugo server --baseURL="http://localhost:1313" --buildDrafts
```

Visit `http://localhost:1313` to view the site.

### Testing the API Client

1. **Start the Laravel API** (from project root):
   ```bash
   ./setup.sh
   # or
   docker-compose up -d
   ```

2. **Start the Hugo server** (from presentation directory):
   ```bash
   ./test-local.sh
   ```

3. **Open in browser**:
   - Homepage: http://localhost:1313
   - API Client: http://localhost:1313/api-client/

4. **Test the API Client**:
   - Register a new user
   - Login to get a token
   - Add foods, manage favorites
   - Check API responses in the response section

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

- **Homepage** (`content/_index.md`) - Overview of the Eato project, API endpoints, and project evolution
- **API Client** (`content/api-client/_index.md`) - Interactive web client for testing API endpoints

## API Client

The API Client is an interactive web interface that allows users to test all Laravel API endpoints directly from the browser. It includes:

- **Authentication**: Register, login, and logout with token management
- **Foods Management**: Full CRUD operations (create, read, update, delete)
- **Favorites Management**: Add and remove favorite foods
- **Response Display**: Formatted JSON responses with error handling

The API client connects to `http://localhost:8000/api` when running locally, so make sure the Laravel API is running before using it.

**Live Demo**: [https://hogandenver05.github.io/Eato/api-client/](https://hogandenver05.github.io/Eato/api-client/)

## Adding New Content

Create new markdown files in the appropriate `content/` subdirectory:

```bash
hugo new section-name/page-name.md
```

Edit the file and add your content in Markdown format.

