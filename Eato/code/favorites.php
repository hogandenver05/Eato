<?php
header('Content-Type: application/json');
require_once 'config.php';
require_once 'auth.php';

$user_id = authenticate();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $food_id = $data['food_id'] ?? null;

    if (!$food_id) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing food_id']);
        exit;
    }

    // Prevent duplicate favorites
    $check = $pdo->prepare("SELECT * FROM favorites WHERE user_id = ? AND food_id = ?");
    $check->execute([$user_id, $food_id]);
    if ($check->fetch()) {
        http_response_code(409);
        echo json_encode(['error' => 'Already marked as favorite']);
        exit;
    }

    $stmt = $pdo->prepare("INSERT INTO favorites (user_id, food_id) VALUES (?, ?)");
    $stmt->execute([$user_id, $food_id]);

    http_response_code(201);
    echo json_encode(['message' => 'Food marked as favorite']);
} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}
