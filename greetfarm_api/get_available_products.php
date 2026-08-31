<?php

include "db_connect.php";
header("Content-Type: application/json");

$sql = "SELECT products.*, users.full_name AS farmer_name
FROM products
JOIN users ON products.farmer_id = users.user_id
WHERE (products.status='Available' OR products.status IS NULL) AND products.quantity > 0
ORDER BY products.product_id DESC";

$result = $conn->query($sql);

$products = [];

while($row = $result->fetch_assoc()){
    $products[] = $row;
}

echo json_encode($products);

$conn->close();

?>