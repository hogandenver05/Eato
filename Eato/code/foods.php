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
    $food_id = $_GET['food_id'] ?? null;

    if ($food_id) {
        $stmt = $pdo->prepare("SELECT * FROM foods WHERE food_id = ? AND user_id = ?");
        $stmt->execute([$food_id, $user_id]);
        $food = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($food) {
            echo json_encode($food);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Food not found']);
        }
    } else {
        $stmt = $pdo->prepare("SELECT * FROM foods WHERE user_id = ?");
        $stmt->execute([$user_id]);
        $foods = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['foods' => $foods]);
    }

} elseif ($method === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $food_id = $data['food_id'] ?? null;
    $food_name = $data['food_name'] ?? null;
    $calories = isset($data['calories']) && is_numeric($data['calories']) ? (int)$data['calories'] : null;

    if (!$food_id) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing food_id']);
        exit;
    }

    $stmt = $pdo->prepare("SELECT * FROM foods WHERE food_id = ? AND user_id = ?");
    $stmt->execute([$food_id, $user_id]);
    if (!$stmt->fetch()) {
        http_response_code(404);
        echo json_encode(['error' => 'Food not found']);
        exit;
    }

    $fields = [];
    $params = [];
    if ($food_name) {
        $fields[] = "food_name = ?";
        $params[] = $food_name;
    }
    if (!is_null($calories)) {
        $fields[] = "calories = ?";
        $params[] = $calories;
    }

    if ($fields) {
        $params[] = $food_id;
        $params[] = $user_id;
        $sql = "UPDATE foods SET ".implode(',', $fields)." WHERE food_id = ? AND user_id = ?";
        $pdo->prepare($sql)->execute($params);
    }

    echo json_encode(['message' => 'Food updated successfully']);

} elseif ($method === 'DELETE') {
    $data = json_decode(file_get_contents('php://input'), true);
    $food_id = $data['food_id'] ?? null;

    if (!$food_id) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing food_id']);
        exit;
    }

    try {
        $stmt = $pdo->prepare("DELETE FROM foods WHERE food_id = ? AND user_id = ?");
        $stmt->execute([$food_id, $user_id]);
        echo json_encode(['message' => 'Food deleted successfully']);
    } catch (PDOException $e) {
        if ($e->getCode() == 23000) {
            http_response_code(409);
            echo json_encode(['error' => 'Cannot delete food while it is marked as a favorite']);
        } else {
            http_response_code(500);
            echo json_encode(['error' => 'Database error']);
        }
    }

} else {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
}
