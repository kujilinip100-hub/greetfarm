<?php
include "db_connect.php";
header("Content-Type: application/json");

$user_id = $_POST["user_id"] ?? "";

$sql = "DELETE FROM users WHERE user_id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);

if ($stmt->execute()) {
    echo json_encode(["status"=>"success","message"=>"User removed"]);
} else {
    echo json_encode(["status"=>"error","message"=>$conn->error]);
}

$stmt->close();
$conn->close();
?>