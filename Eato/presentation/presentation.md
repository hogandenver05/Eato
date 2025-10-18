---
marp: true
---

# Eato Meal Tracker

**ASE 230 Project 1 & 2**

Created by Denver Hogan

---

## Overview

* Full-stack web application for meal tracking
* Backend: PHP REST API with MySQL
* Frontend: HTML/JS test client
* Authentication: JWT tokens
* Deployment: Apache, optional Docker

---

## Features

1. User registration and login
2. Add and list foods
3. Mark and list favorites
4. Automated API tests
5. Basic HTML/JS test client

---

## API Endpoints

### Authentication

| Method | Endpoint      | Description         |
| ------ | ------------- | ------------------- |
| POST   | /register.php | Register a new user |
| POST   | /login.php    | Authenticate a user |

### Foods

| Method | Endpoint   | Description                 |
| ------ | ---------- | --------------------------- |
| POST   | /foods.php | Add a food item             |
| GET    | /foods.php | List foods for current user |

---

## API Endpoints *(cont'd...)*

### Favorites

| Method | Endpoint       | Description             |
| ------ | -------------- | ----------------------- |
| POST   | /favorites.php | Mark a food as favorite |
| GET    | /favorites.php | List favorite foods     |

---

## JWT Authentication

* Secure all endpoints using JWT
* Token returned on login
* Authorization header: `Bearer <token>`

---

## Deployment

* Copy files to `/var/www/html/eato`
* Ensure correct permissions:

```bash
sudo chown -R www-data:www-data /var/www/html/eato
sudo chmod -R 755 /var/www/html/eato
```

* Reload Apache:

```bash
sudo systemctl reload apache2
```

---

## Testing

* Use `test_api.sh` to verify API functionality
* Can also use HTML/JS client for manual testing

---

## Directory Structure

```
Eato/
├── Eato/
│   ├── code/
│   │   ├── auth.php
│   │   ├── config.php
│   │   ├── favorites.php
│   │   ├── foods.php
│   │   ├── login.php
│   │   ├── register.php
|   |   ├── schema.sql
│   │   ├── test_db.php
│   │   ├── test_api.sh
│   │   └── index.html
│   ├── presentation/
│   └── plan/
├── vendor/
├── .env
└── README.md
```

---

## Next Steps / Improvements

* Containerize with Docker
* Deploy Hugo static documentation to GitHub.io
* Expand test client with better UI/UX
* Track macros in addition to calories
