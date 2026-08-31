<?php

include "db_connect.php";
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $full_name = $_POST["full_name"] ?? "";
    $email = $_POST["email"] ?? "";
    $username = $_POST["username"] ?? "";
    $password = $_POST["password"] ?? "";
    $role = $_POST["role"] ?? "";
    $phone = $_POST["phone"] ?? "";
    $location = $_POST["location"] ?? "";

    $hashed_password = password_hash($password, PASSWORD_DEFAULT);

    $check_query = "SELECT * FROM users WHERE username = ? OR email = ?";
    $check_stmt = $conn->prepare($check_query);
    $check_stmt->bind_param("ss", $username, $email);
    $check_stmt->execute();
    $result = $check_stmt->get_result();

    if ($result->num_rows > 0) {
        echo json_encode([
            "status" => "error",
            "message" => "Username or Email already exists"
        ]);
    } else {
        $insert_query = "INSERT INTO users (full_name, email, username, password, role, phone, location) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $insert_stmt = $conn->prepare($insert_query);
        $insert_stmt->bind_param("sssssss", $full_name, $email, $username, $hashed_password, $role, $phone, $location);

        if ($insert_stmt->execute()) {
            echo json_encode([
                "status" => "success",
                "message" => "Registration successful"
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Registration failed: " . $conn->error
            ]);
        }

        $insert_stmt->close();
    }

    $check_stmt->close();
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}

$conn->close();
?>