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

# Step five: verify database settings
echo "Checking database connection"

php artisan db:show >/dev/null 2>&1 || {
    echo "Database connection failed"
    exit 1
}

echo "Database connection successful"

# Step six: run migrations
echo "Running migrations"
php artisan migrate

# Step seven: clear caches
echo "Clearing caches"
php artisan optimize:clear

# Step eight: start Laravel development server
echo "Starting server at http://localhost:8000"
php artisan serve
