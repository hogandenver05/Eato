# 🍎 Eato Meal Tracker

A RESTful API built with **Laravel** and **MySQL**, created for **ASE 230 Project 1 & 2**.

This project implements user registration, login, food tracking, and favorites using Laravel Sanctum for authentication.

---

## Features

* User registration and authentication (Laravel Sanctum)
* Full CRUD for foods (add, list, fetch single, update, delete)
* Manage favorite foods (add, remove, list)
* JSON-based API endpoints
* Docker containerization for easy deployment
* Automated deployment scripts

---

## API Endpoints

All API endpoints are prefixed with `/api`. Base URL: `http://localhost:8000/api`

### Authentication

| Method | Endpoint           | Description                                    |
| ------ | ------------------ | ---------------------------------------------- |
| POST   | `/api/register`    | Register a new user                            |
| POST   | `/api/login`       | Authenticate a user and return Sanctum token   |
| POST   | `/api/logout`      | Logout and revoke current token (requires auth) |

### Foods

| Method | Endpoint              | Description                       |
| ------ | --------------------- | --------------------------------- |
| POST   | `/api/foods`          | Add a new food (requires auth)    |
| GET    | `/api/foods`          | List all foods for logged-in user |
| GET    | `/api/foods/{id}`     | Fetch a single food by ID         |
| PUT    | `/api/foods/{id}`     | Update a food by ID               |
| DELETE | `/api/foods/{id}`     | Delete a food by ID               |

### Favorites

| Method | Endpoint                | Description                  |
| ------ | ----------------------- | ---------------------------- |
| POST   | `/api/favorites`        | Mark a food as favorite      |
| GET    | `/api/favorites`        | List favorite foods          |
| DELETE | `/api/favorites/{id}`   | Remove a food from favorites |

---

## Example Usage

### Register a User

```bash
curl -X POST http://localhost:8000/api/register \
  -H "Content-Type: application/json" \
  -d '{"username":"alice","password":"secret123"}'
```

### Login and Retrieve Token

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"alice","password":"secret123"}'
```

Response:
```json
{
  "message": "Login successful",
  "token": "1|abc123def456..."
}
```

### Add a Food

```bash
curl -X POST http://localhost:8000/api/foods \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_name":"Banana","calories":105}'
```

### Fetch Single Food

```bash
curl -X GET http://localhost:8000/api/foods/1 \
  -H "Authorization: Bearer <TOKEN>"
```

### Update a Food

```bash
curl -X PUT http://localhost:8000/api/foods/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_name":"Apple","calories":95}'
```

### Delete a Food

```bash
curl -X DELETE http://localhost:8000/api/foods/1 \
  -H "Authorization: Bearer <TOKEN>"
```

### Favorite a Food

```bash
curl -X POST http://localhost:8000/api/favorites \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_id":1}'
```

### List Favorites

```bash
curl -X GET http://localhost:8000/api/favorites \
  -H "Authorization: Bearer <TOKEN>"
```

### Remove Favorite

```bash
curl -X DELETE http://localhost:8000/api/favorites/1 \
  -H "Authorization: Bearer <TOKEN>"
```

---

## Setup Instructions

### Option 1: Docker Deployment (Recommended)

The easiest way to get started is using Docker. This will automatically set up the database and Laravel application.

#### Prerequisites

- Docker and Docker Compose installed
  - [Docker Desktop](https://www.docker.com/products/docker-desktop) (macOS/Windows)
  - Or [Colima](https://github.com/abiosoft/colima) (lightweight alternative): `brew install colima docker docker-compose`

#### Quick Start

1. **Run the setup script:**

```bash
./setup.sh
```

This script will:
- Check for Docker installation
- Build Docker containers
- Start MySQL and Laravel services
- Wait for database to be ready
- Run migrations
- Generate application key

2. **Access the API:**

The API will be available at `http://localhost:8000/api`

#### Manual Docker Commands

If you prefer to run commands manually:

```bash
# Copy Docker environment file
cp .env.docker .env

# Build and start containers
docker-compose up -d

# Wait for database, then run migrations
docker-compose exec app php artisan migrate

# Generate application key
docker-compose exec app php artisan key:generate
```

#### Stop Containers

```bash
docker-compose down
```

#### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f db
```

### Option 2: Local Development (Without Docker)

#### Prerequisites

- PHP 8.2+
- Composer
- MySQL 8.0+

#### Setup Steps

1. **Install dependencies:**

```bash
composer install
```

2. **Configure environment:**

```bash
cp .env.example .env
php artisan key:generate
```

Edit `.env` with your database credentials:

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=eato
DB_USERNAME=root
DB_PASSWORD=yourpassword
```

3. **Run migrations:**

```bash
php artisan migrate
```

4. **Start the development server:**

```bash
php artisan serve
```

Or use the automated script:

```bash
./run.sh
```

The API will be available at `http://localhost:8000/api`

---

## Testing

Run the test suite:

```bash
# With Docker
docker-compose exec app php artisan test

# Local development
php artisan test
```

---

## Project Structure

- `app/Http/Controllers/` - API controllers
- `app/Models/` - Eloquent models
- `routes/api.php` - API route definitions
- `database/migrations/` - Database migrations
- `docker-compose.yml` - Docker services configuration
- `Dockerfile` - Laravel application container
- `setup.sh` - Docker deployment script
- `run.sh` - Local development deployment script

---

## Next Steps

* Deploy documentation via Hugo to GitHub Pages
* Enhance test client UI/UX
* Expand features to track macros, not just calories
