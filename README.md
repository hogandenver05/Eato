# 🍎 Eato Meal Tracker

A RESTful API built with **PHP** and **MySQL**, created for **ASE 230 Project 1 & 2**.

This project implements user registration, login, food tracking, and favorites.

---

## Features

* User registration and authentication (JWT)
* Full CRUD for foods (add, list, fetch single, update, delete)
* Manage favorite foods (add, remove, list)
* JSON-based API endpoints
* Automated API testing (`test_api.sh`)
* Basic HTML/JS test client

---

## API Endpoints

### Authentication

| Method | Endpoint     | Description                        |
| ------ | ------------ | ---------------------------------- |
| POST   | register.php | Register a new user                |
| POST   | login.php    | Authenticate a user and return JWT |

### Foods

| Method | Endpoint               | Description                       |
| ------ | ---------------------- | --------------------------------- |
| POST   | foods.php              | Add a new food (requires JWT)     |
| GET    | foods.php              | List all foods for logged-in user |
| GET    | foods.php?food_id=<id> | Fetch a single food by `food_id`  |
| PUT    | foods.php              | Update a food by `food_id`        |
| DELETE | foods.php              | Delete a food by `food_id`        |

### Favorites

| Method | Endpoint      | Description                  |
| ------ | ------------- | ---------------------------- |
| POST   | favorites.php | Mark a food as favorite      |
| GET    | favorites.php | List favorite foods          |
| DELETE | favorites.php | Remove a food from favorites |

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

### Fetch Single Food

```bash
curl -X GET "http://localhost/Eato/Eato/code/foods.php?food_id=1" \
  -H "Authorization: Bearer <TOKEN>"
```

### Update a Food

```bash
curl -X PUT http://localhost/Eato/Eato/code/foods.php \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_id":1,"food_name":"Apple","calories":95}'
```

### Delete a Food

```bash
curl -X DELETE http://localhost/Eato/Eato/code/foods.php \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_id":1}'
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

### Remove Favorite

```bash
curl -X DELETE http://localhost/Eato/Eato/code/favorites.php \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <TOKEN>" \
  -d '{"food_id":1}'
```

---

## Setup Instructions

### 1. Database Setup

Log in to MySQL:

```bash
mysql -u root -p
```

Then run the schema in `Eato/code/schema.sql`.

### 2. Environment Variables

Create a `.env` file in the project root:

```
DB_HOST=localhost
DB_NAME=eato
DB_USER=root
DB_PASS=yourpassword
JWT_SECRET=your_secret_key
```

### 3. Deploy to Apache

```bash
sudo cp -r ./* /var/www/html/Eato
sudo chown -R www-data:www-data /var/www/html/Eato
sudo chmod -R 755 /var/www/html/Eato
sudo systemctl reload apache2
```

### 4. Testing

* Open the HTML/JS client at `http://localhost/Eato/Eato/code/index.html`
* Or run automated tests with `test_api.sh` in `Eato/code`

---

## Next Steps

* Containerize with Docker
* Deploy documentation via Hugo to GitHub Pages
* Enhance test client UI/UX
* Expand features to track macros, not just calories
