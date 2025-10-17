<?php
// Quick script to verify database connection and sample query
header('Content-Type: application/json');
require_once 'config.php';

try {
    $stmt = $pdo->query("SELECT DATABASE() as db");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode(['status' => 'ok', 'database' => $row['db']]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
