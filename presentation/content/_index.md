---
title: "Eato Meal Tracker"
date: 2025-11-21
draft: false
---

# 🍎 Eato Meal Tracker

A RESTful API built with **Laravel** and **MySQL**, created for **ASE 230 Project 1 & 2**.

## Overview

This project implements user registration, login, food tracking, and favorites using Laravel Sanctum for authentication.

## Features

- ✅ User registration and authentication (Laravel Sanctum)
- ✅ Full CRUD for foods (add, list, fetch single, update, delete)
- ✅ Manage favorite foods (add, remove, list)
- ✅ JSON-based API endpoints
- ✅ Docker containerization for easy deployment
- ✅ Automated deployment scripts

## Quick Links

- [Portfolio](/portfolio/) - ASE 230 Projects showcase
- [GitHub Repository](https://github.com/hogandenver05/Eato)

## Project Evolution

### Project 1: PHP REST API

The original implementation using **PHP** and **MySQL** with JWT authentication.

**Original API Endpoints:**
- `POST register.php` - Register a new user
- `POST login.php` - Authenticate and return JWT
- `POST foods.php` - Add a new food (requires JWT)
- `GET foods.php` - List all foods for logged-in user
- `GET foods.php?food_id=<id>` - Fetch a single food
- `PUT foods.php` - Update a food by ID
- `DELETE foods.php` - Delete a food by ID
- `POST favorites.php` - Mark a food as favorite
- `GET favorites.php` - List favorite foods
- `DELETE favorites.php` - Remove a food from favorites

**Technologies:** PHP, MySQL, JWT, Apache

### Project 2: Laravel REST API (Current)

Re-implementation using **Laravel** framework with modern tooling and Docker containerization.

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

## Technologies

- **Backend:** Laravel 12, PHP 8.2
- **Database:** MySQL 8.0
- **Authentication:** Laravel Sanctum
- **Deployment:** Docker, Docker Compose
- **Documentation:** Hugo

