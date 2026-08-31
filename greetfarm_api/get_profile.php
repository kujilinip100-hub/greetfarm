<?php

include "db_connect.php";
header("Content-Type: application/json");

$user_id = $_GET["user_id"] ?? "";

$sql = "SELECT full_name, phone, location FROM users WHERE user_id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode([
        "status" => "success",
        "data" => $result->fetch_assoc()
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "User not found"
    ]);
}

$stmt->close();
$conn->close();

?>