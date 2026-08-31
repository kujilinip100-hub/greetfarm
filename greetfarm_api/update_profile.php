<?php

include "db_connect.php";
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $user_id = $_POST["user_id"] ?? "";
    $full_name = $_POST["full_name"] ?? "";
    $phone = $_POST["phone"] ?? "";
    $location = $_POST["location"] ?? "";

    $sql = "UPDATE users SET full_name=?, phone=?, location=? WHERE user_id=?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssi", $full_name, $phone, $location, $user_id);

    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Profile updated"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }

    $stmt->close();

} else {
    echo json_encode(["status" => "error", "message" => "Invalid request"]);
}

$conn->close();

?>