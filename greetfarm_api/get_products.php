<?php

include "db_connect.php";
header("Content-Type: application/json");

$farmer_id = $_GET["farmer_id"] ?? "";

$sql = "SELECT * FROM products WHERE farmer_id=? AND (status='Available' OR status IS NULL) ORDER BY product_id DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i",$farmer_id);
$stmt->execute();

$result = $stmt->get_result();

$products = [];

while($row = $result->fetch_assoc()){
    $products[] = $row;
}

echo json_encode($products);

$stmt->close();
$conn->close();

?>