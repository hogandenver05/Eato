<?php
header('Content-Type: application/json');
require_once 'config.php';
require_once 'vendor/autoload.php';
use \Firebase\JWT\JWT;

$data = json_decode(file_get_contents('php://input'), true);
$username = $data['username'] ?? '';
$password = $data['password'] ?? '';

$stmt = $pdo->prepare("SELECT * FROM users WHERE username = ?");
$stmt->execute([$username]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user && password_verify($password, $user['password'])) {
    $payload = [
        'user_id' => $user['id'],
        'iat' => time(),
        'exp' => time() + 3600
    ];
    $jwt = JWT::encode($payload, $_ENV['JWT_SECRET'], 'HS256');
    echo json_encode(['token' => $jwt]);
} else {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid username or password']);
}
