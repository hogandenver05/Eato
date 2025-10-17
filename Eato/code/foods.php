<?php
header('Content-Type: application/json');
require_once 'config.php';
require_once 'auth.php';

$user_id = authenticate();
$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $food_name = $data['food_name'] ?? '';
    $calories = is_numeric($data['calories'] ?? 0) ? (int)$data['calories'] : 0;

    if (!$food_name) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing food_name']);
        exit;
    }

    $stmt = $pdo->prepare("INSERT INTO foods (user_id, food_name, calories) VALUES (?, ?, ?)");
    $stmt->execute([$user_id, $food_name, $calories]);

    http_response_code(201);
    echo json_encode([
        'message' => 'Food added successfully',
        'food_id' => $pdo->lastInsertId()
    ]);

} elseif ($method === 'GET') {
    $stmt = $pdo->prepare("SELECT * FROM foods WHERE user_id = ?");
    $stmt->execute([$user_id]);
    $foods = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode(['foods' => $foods]);

} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}
