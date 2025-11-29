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
* Interactive web API client for testing

---

## Quick Start

### Prerequisites
- Docker and Docker Compose installed

1. **Clone the Repo**
   ```bash
   git clone https://github.com/hogandenver05/Eato.git
   cd Eato
   ```

2. **Start the API:**
   ```bash
   ./setup.sh
   ```

3. **Use the Interactive API Client:**
   Visit [https://hogandenver05.github.io/Eato/api-client/](https://hogandenver05.github.io/Eato/api-client/) to test all API endpoints in your browser. Alternatively, see the [Local Development](#local-development) section below for manual setup and running locally.

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

## Project Structure

- `app/Http/Controllers/` - API controllers
- `app/Models/` - Eloquent models
- `routes/api.php` - API route definitions
- `database/migrations/` - Database migrations
- `docker-compose.yml` - Docker services configuration
- `Dockerfile` - Laravel application container
- `setup.sh` - Docker deployment script
- `run.sh` - Local development deployment script

## Local Development

### Prerequisites

- PHP 8.2+
- Composer
- MySQL 8.0+

### Setup Steps

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
./run.sh
```

The API will be available at `http://localhost:8000/api`

### Testing

Run the test suite:

```bash
# With Docker
docker-compose exec app php artisan test

# Local development
php artisan test
```
