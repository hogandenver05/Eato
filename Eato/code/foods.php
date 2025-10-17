<?php
header('Content-Type: application/json');
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $user_id = $data['user_id'] ?? null;
    $food_name = $data['food_name'] ?? '';
    $calories = $data['calories'] ?? 0;

    if (!$user_id || !$food_name) {
        echo json_encode(['error' => 'Missing required fields']);
        exit;
    }

    $stmt = $pdo->prepare("INSERT INTO foods (user_id, food_name, calories) VALUES (?, ?, ?)");
    $stmt->execute([$user_id, $food_name, $calories]);
    echo json_encode(['message' => 'Food added successfully', 'food_id' => $pdo->lastInsertId()]);
}
