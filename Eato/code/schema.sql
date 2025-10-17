-- Database schema for Eato

CREATE DATABASE IF NOT EXISTS eato;
USE eato;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS foods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    food_name VARCHAR(100) NOT NULL,
    calories INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
