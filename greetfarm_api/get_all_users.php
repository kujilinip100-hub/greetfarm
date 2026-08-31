<?php
include "db_connect.php";
header("Content-Type: application/json");

$sql = "SELECT user_id, full_name, email, username, role, phone, location, created_at FROM users ORDER BY user_id DESC";
$result = $conn->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["status"=>"success","data"=>$data]);
$conn->close();
?>