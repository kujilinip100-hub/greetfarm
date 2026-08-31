<?php
include "db_connect.php";
header("Content-Type: application/json");

$user_id = $_POST["user_id"] ?? "";

$sql = "UPDATE notifications SET is_read=1 WHERE user_id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();

echo json_encode(["status"=>"success"]);

$stmt->close();
$conn->close();
?>