#!/bin/bash

echo "Starting Docker deployment"

set -e

# step one: copy docker environment if missing
if [ ! -f .env ]; then
    echo "Applying docker environment"
    cp .env.docker .env
fi

# step two: build containers
echo "Building containers"
docker-compose build

# step three: start containers
echo "Starting containers"
docker-compose up -d

# step four: generate application key
echo "Generating application key"
docker-compose exec app php artisan key:generate

# Step five: run migrations
echo "Running migrations"
docker-compose exec app php artisan migrate

echo "Docker deployment complete"
echo "Laravel available at http://localhost:8000"
