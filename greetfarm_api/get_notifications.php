<?php
include "db_connect.php";
header("Content-Type: application/json");

$user_id = $_GET["user_id"] ?? "";

$sql = "SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 20";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["status"=>"success","data"=>$data]);

$stmt->close();
$conn->close();
?>