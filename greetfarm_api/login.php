<?php

include "db_connect.php";
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $username = $_POST["username"] ?? "";
    $password = $_POST["password"] ?? "";

    $query = "SELECT * FROM users WHERE username = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // password_verify() use , register hash  password- compare
        if (password_verify($password, $user["password"])) {
            echo json_encode([
                "status" => "success",
                "message" => "Login successful",
                "role" => $user["role"],       
                "user_id" => $user["user_id"],
                "full_name" => $user["full_name"],
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Incorrect password"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Username not found"
        ]);
    }

    $stmt->close();
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid request method"
    ]);
}

$conn->close();
?>