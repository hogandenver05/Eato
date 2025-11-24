#!/bin/bash

# Test script for Hugo site locally
# This allows you to test the site before deploying to GitHub Pages

set -e

echo "🧪 Testing Hugo Site Locally"
echo "============================"
echo ""

# Check if Hugo is installed
if ! command -v hugo &> /dev/null; then
    echo "❌ Hugo is not installed. Please install Hugo first:"
    echo "   brew install hugo"
    exit 1
fi

echo "✅ Hugo found: $(hugo version)"
echo ""

# Check if we're in the presentation directory
if [ ! -f "hugo.toml" ]; then
    echo "❌ Error: hugo.toml not found. Please run this script from the presentation/ directory"
    exit 1
fi

# Check if Laravel API is running (optional)
echo "📡 Checking if Laravel API is running..."
if curl -s http://localhost:8000/api > /dev/null 2>&1; then
    echo "✅ Laravel API is running at http://localhost:8000"
else
    echo "⚠️  Laravel API is not running at http://localhost:8000"
    echo "   Start it with: ./setup.sh (from project root) or docker-compose up -d"
    echo ""
fi

echo ""
echo "🚀 Starting Hugo development server..."
echo ""
echo "   Site will be available at: http://localhost:1313"
echo "   API Client page: http://localhost:1313/api-client/"
echo ""
echo "   Press Ctrl+C to stop the server"
echo ""
echo "============================"
echo ""

# Start Hugo server with local baseURL
# Using --baseURL for local testing (without /Eato/ prefix)
hugo server \
    --baseURL="http://localhost:1313" \
    --bind=0.0.0.0 \
    --port=1313 \
    --buildDrafts \
    --disableFastRender

