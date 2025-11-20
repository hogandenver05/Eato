#!/bin/bash

echo "Starting Laravel deployment script"

# Stop on first error
set -e

# Step one: check for Composer
if ! command -v composer >/dev/null 2>&1; then
    echo "Composer is not installed"
    exit 1
fi

echo "Composer detected"

# Step two: install dependencies
echo "Installing Composer dependencies"
composer install

# Step three: copy environment file if missing
if [ ! -f .env ]; then
    echo "Creating environment file"
    cp .env.example .env
fi

# Step four: generate application key
echo "Generating application key"
php artisan key:generate

# Step five: run migrations
echo "Running migrations"
php artisan migrate

# Step six: clear caches
echo "Clearing caches"
php artisan optimize:clear

# Step seven: start Laravel development server
echo "Starting server at http://localhost:8000"
php artisan serve
