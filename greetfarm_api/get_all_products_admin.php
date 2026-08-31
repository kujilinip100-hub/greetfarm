<?php
include "db_connect.php";
header("Content-Type: application/json");

$sql = "SELECT products.*, users.full_name AS farmer_name
        FROM products
        JOIN users ON products.farmer_id = users.user_id
        ORDER BY products.product_id DESC";
$result = $conn->query($sql);

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode(["status"=>"success","data"=>$data]);
$conn->close();
?>