<?php

include "db_connect.php";

header("Content-Type: application/json");

$farmer_id = $_GET["farmer_id"] ?? "";

$sql = "SELECT
r.reservation_id,
r.customer_id,
u.full_name AS customer_name,
r.product_id,
p.product_name,
r.quantity,
r.collection_point,
r.status

FROM reservations r

JOIN users u
ON r.customer_id = u.user_id

JOIN products p
ON r.product_id = p.product_id

WHERE p.farmer_id = ?

ORDER BY r.reservation_id DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $farmer_id);
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