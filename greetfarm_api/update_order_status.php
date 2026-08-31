<?php

include "db_connect.php";
header("Content-Type: application/json");

$reservation_id = $_POST["reservation_id"] ?? "";
$status = $_POST["status"] ?? "";

if ($status == "Collected") {
    $sql = "UPDATE reservations SET status=?, collected_at=NOW() WHERE reservation_id=?";
} else {
    $sql = "UPDATE reservations SET status=? WHERE reservation_id=?";
}

$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $status, $reservation_id);

if ($stmt->execute()) {

    // Order details vaangi, correct persons-ku notification anuppuvom
    $info_sql = "SELECT r.customer_id, p.product_name, p.farmer_id
                 FROM reservations r
                 JOIN products p ON r.product_id = p.product_id
                 WHERE r.reservation_id=?";
    $info_stmt = $conn->prepare($info_sql);
    $info_stmt->bind_param("i", $reservation_id);
    $info_stmt->execute();
    $info = $info_stmt->get_result()->fetch_assoc();
    $info_stmt->close();

    if ($info) {
        $notif_user_id = null;
        $notif_message = "";

        if ($status == "Ready") {
            $notif_user_id = $info["customer_id"];
            $notif_message = "Your order for " . $info["product_name"] . " is ready for collection!";
        } elseif ($status == "Collected") {
            $notif_user_id = $info["farmer_id"];
            $notif_message = $info["product_name"] . " has been collected by the customer.";
        }

        if ($notif_user_id) {
            $notif_stmt = $conn->prepare("INSERT INTO notifications (user_id, message) VALUES (?, ?)");
            $notif_stmt->bind_param("is", $notif_user_id, $notif_message);
            $notif_stmt->execute();
            $notif_stmt->close();
        }
    }

    echo json_encode(["status" => "success", "message" => "Order status updated"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$stmt->close();
$conn->close();

?>