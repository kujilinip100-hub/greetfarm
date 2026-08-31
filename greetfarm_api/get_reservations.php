<?php

header("Content-Type: application/json");
include("db_connect.php");

$sql = "SELECT
reservations.reservation_id,
reservations.customer_id,
users.full_name AS customer_name,
reservations.product_id,
reservations.quantity,
reservations.collection_point,
reservations.status,

products.product_name,
products.image

FROM reservations

INNER JOIN products
ON reservations.product_id = products.product_id

INNER JOIN users
ON reservations.customer_id = users.user_id

ORDER BY reservations.reservation_id DESC";

$result = mysqli_query($conn, $sql);

$data = [];

while($row = mysqli_fetch_assoc($result)){
    $data[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => $data
]);

?>