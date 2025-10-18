# Eato Meal Tracker

A RESTful API built with **PHP** and **MySQL**, created for **ASE 230 Project 1**.

This project implements user registration, login, food tracking, and favorites.

---

## Features

* User registration and authentication (JWT)
* Add, list, and favorite foods
* JSON-based API endpoints
* Automated API testing
* Basic HTML/JS test client

---

## API Endpoints

### Authentication

| Method | Endpoint     | Description                        |
|--------|--------------|------------------------------------|
| POST   | register.php | Register a new user                |
| POST   | login.php    | Authenticate a user and return JWT |

### Foods

| Method | Endpoint  | Description                       |
|--------|-----------|-----------------------------------|
| POST   | foods.php | Add a new food (requires JWT)     |
| GET    | foods.php | List all foods for logged-in user |

### Favorites

| Method | Endpoint      | Description           |
|--------|---------------|-----------------------|
| POST   | favorites.php | Mark food as favorite |
| GET    | favorites.php | List favorite foods   |

---

## Example Usage

### Register a User

```bash
curl -X POST http://localhost/Eato/Eato/code/register.php \
  -H "Content-Type: application/json" \
  -d '{"username":"alice","password":"secret123"}'
```

### Login and Retrieve Token

```bash
curl -X POST http://localhost/Eato/Eato/code/login.php \
  -H "Content-Type: application/json" \
  -d '{"username":"alice","password":"secret123"}'
```

### Add a Food

```bash
curl -X POST http://localhost/Eato/Eato/code/foods.php \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_name":"Banana","calories":105}'
```

### List Foods

```bash
curl -X GET http://localhost/Eato/Eato/code/foods.php \
  -H "Authorization: Bearer <TOKEN>"
```

### Favorite a Food

```bash
curl -X POST http://localhost/Eato/Eato/code/favorites.php \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_id":1}'
```

### List Favorites

```bash
curl -X GET http://localhost/Eato/Eato/code/favorites.php \
  -H "Authorization: Bearer <TOKEN>"
```

---

## Setup Instructions

### 1. Database Setup

Log in to mysql

```bash
mysql -u root -p
```

... and paste in the database schema located in `Eato/code`

### 2. Environment

Create `.env` in the root folder:

```
DB_HOST=localhost
DB_NAME=eato
DB_USER=root
DB_PASS=yourpassword
JWT_SECRET=your_secret_key
```

### 3. Copy Files to Apache

From the root folder:
```bash
sudo cp -r ./* /var/www/html/Eato
sudo chown -R www-data:www-data /var/www/html/Eato
sudo chmod -R 755 /var/www/html/Eato
sudo systemctl reload apache2
```

### 4. Test

* Open HTML/JS test client: `http://localhost/Eato/Eato/code/index.html`
* Or use `test_api.sh` located in `Eato/code` to run automated endpoint tests

---

## Next Steps (Project 2)

* Laravel reimplementation of API
* Docker containerization
* Hugo documentation
* GitHub Pages deployment
