#!/bin/bash

echo "Starting Docker deployment"

set -e

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker is not installed"
    echo ""
    echo "Please install one of the following:"
    echo "  1. Docker Desktop: https://www.docker.com/products/docker-desktop"
    echo "  2. Colima (lightweight): brew install colima docker docker-compose"
    echo "     Then run: colima start"
    exit 1
fi

# Check if Docker daemon is running
if ! docker info >/dev/null 2>&1; then
    echo "Docker daemon is not running"
    echo ""
    
    # Check if Colima is available
    if command -v colima >/dev/null 2>&1; then
        echo "Colima detected. Attempting to start Colima..."
        colima start || {
            echo "Failed to start Colima. Please run 'colima start' manually"
            exit 1
        }
        echo "Waiting for Docker to be ready..."
        sleep 3
    else
        echo "Please start your Docker runtime:"
        echo "  - Docker Desktop: Open Docker Desktop application"
        echo "  - Colima: Run 'colima start'"
        echo "  - Other: Start your Docker daemon"
        exit 1
    fi
fi

echo "Docker is running"

# step one: copy docker environment (always use .env.docker for Docker setup)
echo "Applying docker environment"
if [ ! -f .env.docker ]; then
    echo "Error: .env.docker file not found"
    exit 1
fi
cp .env.docker .env
echo "Using Docker environment configuration (DB_HOST=db)"

# step two: build containers
echo "Building containers"
docker-compose build

# step three: start containers
echo "Starting containers"
docker-compose up -d

# step four: wait for database to be ready (docker-compose healthcheck handles this, but verify)
echo "Waiting for database to be ready..."
max_attempts=60
attempt=0
while [ $attempt -lt $max_attempts ]; do
    # Test connection from app container to database
    if docker-compose exec -T app php -r "try { \$pdo = new PDO('mysql:host=db;port=3306;dbname=eato', 'root', 'root'); echo 'OK'; } catch (Exception \$e) { exit(1); }" >/dev/null 2>&1; then
        echo "Database is ready and accessible from app container"
        break
    fi
    attempt=$((attempt + 1))
    if [ $((attempt % 5)) -eq 0 ]; then
        echo "Waiting for database... ($attempt/$max_attempts)"
    fi
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo "Error: Database did not become ready in time"
    echo "Checking database logs..."
    docker-compose logs db | tail -20
    exit 1
fi

# step five: clear Laravel config cache to pick up new .env values
echo "Clearing Laravel configuration cache..."
docker-compose exec -T app php artisan config:clear >/dev/null 2>&1

# step six: verify Laravel can connect to database
echo "Verifying Laravel database connection..."
if ! docker-compose exec -T app php artisan db:show >/dev/null 2>&1; then
    echo "Warning: Laravel cannot connect to database yet, waiting a bit more..."
    sleep 5
    docker-compose exec -T app php artisan config:clear >/dev/null 2>&1
    if ! docker-compose exec -T app php artisan db:show >/dev/null 2>&1; then
        echo "Error: Laravel still cannot connect to database"
        echo "Current DB configuration:"
        docker-compose exec -T app php artisan config:show database.connections.mysql | grep -E "(host|port|database|username)"
        docker-compose exec -T app php artisan db:show
        exit 1
    fi
fi
echo "Laravel database connection verified"

# step seven: generate application key
echo "Generating application key"
docker-compose exec app php artisan key:generate --force

# Step eight: run migrations
echo "Running migrations"
docker-compose exec app php artisan migrate

echo "Docker deployment complete"
echo "Laravel available at http://localhost:8000"
