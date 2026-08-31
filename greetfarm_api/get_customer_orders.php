<?php

include "db_connect.php";
header("Content-Type: application/json");

$customer_id = $_GET["customer_id"] ?? "";

$sql = "SELECT
r.reservation_id,
r.product_id,
p.product_name,
p.image,
r.quantity,
r.collection_point,
r.status

FROM reservations r
JOIN products p ON r.product_id = p.product_id

WHERE r.customer_id = ?
ORDER BY r.reservation_id DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $customer_id);
$stmt->execute();

$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $data
]);

$stmt->close();
$conn->close();

?>