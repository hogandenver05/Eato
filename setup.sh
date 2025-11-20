#!/bin/bash

echo "Starting Docker deployment"

set -e

# Step one: copy docker environment file
if [ ! -f .env ]; then
    echo "Applying docker environment"
    cp .env.docker .env
fi

# Step two: generate key
echo "Generating application key"
docker compose run --rm app php artisan key:generate

# Step three: build and start containers
echo "Building containers"
docker compose build

echo "Starting containers"
docker compose up -d

# Step four: run migrations
echo "Running migrations"
docker compose exec app php artisan migrate

echo "Docker deployment complete"
echo "Laravel available at http://localhost:8000"
