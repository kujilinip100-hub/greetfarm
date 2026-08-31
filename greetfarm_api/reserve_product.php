<?php

include "db_connect.php";

header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $customer_id = $_POST["customer_id"];
    $product_id = $_POST["product_id"];
    $quantity = $_POST["quantity"];
    $collection_point = $_POST["collection_point"];

    $check_sql = "SELECT quantity, farmer_id, product_name FROM products WHERE product_id=?";
    $check_stmt = $conn->prepare($check_sql);
    $check_stmt->bind_param("i", $product_id);
    $check_stmt->execute();
    $check_result = $check_stmt->get_result();
    $product_row = $check_result->fetch_assoc();
    $check_stmt->close();

    if (!$product_row) {
        echo json_encode(["status" => "error", "message" => "Product not found"]);
        $conn->close();
        exit();
    }

    $available_quantity = $product_row["quantity"];

    if ($quantity <= 0) {
        echo json_encode(["status" => "error", "message" => "Invalid quantity"]);
        $conn->close();
        exit();
    }

    if ($quantity > $available_quantity) {
        echo json_encode(["status" => "error", "message" => "Only $available_quantity Kg available"]);
        $conn->close();
        exit();
    }

    $status = "Pending";

    $sql = "INSERT INTO reservations (customer_id, product_id, quantity, collection_point, status) VALUES (?,?,?,?,?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("iidss", $customer_id, $product_id, $quantity, $collection_point, $status);

    if ($stmt->execute()) {

        // Capture the Order ID before running the UPDATE query.
        $new_order_id = $conn->insert_id;

        $new_quantity = $available_quantity - $quantity;
        $new_status = ($new_quantity <= 0) ? "Sold Out" : "Available";

        $update_sql = "UPDATE products SET quantity=?, status=? WHERE product_id=?";
        $update_stmt = $conn->prepare($update_sql);
        $update_stmt->bind_param("dsi", $new_quantity, $new_status, $product_id);
        $update_stmt->execute();
        $update_stmt->close();

        // Send a notification to the farmer.
        $farmer_id = $product_row["farmer_id"];
        $notif_message = "New order received for " . $product_row["product_name"] . " (" . $quantity . " Kg)";
        $notif_stmt = $conn->prepare("INSERT INTO notifications (user_id, message) VALUES (?, ?)");
        $notif_stmt->bind_param("is", $farmer_id, $notif_message);
        $notif_stmt->execute();
        $notif_stmt->close();

        echo json_encode([
            "status" => "success",
            "message" => "Reservation Successful",
            "order_id" => $new_order_id
        ]);

    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }

    $stmt->close();

} else {
    echo json_encode(["status" => "error", "message" => "Invalid Request"]);
}

$conn->close();

?>