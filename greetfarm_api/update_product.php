<?php

include "db_connect.php";

header("Content-Type: application/json");

$product_id=$_POST["product_id"];
$product_name=$_POST["product_name"];
$category=$_POST["category"];
$price=$_POST["price"];
$quantity=$_POST["quantity"];
$harvest_date=$_POST["harvest_date"];

$sql="UPDATE products
SET
product_name=?,
category=?,
price=?,
quantity=?,
harvest_date=?
WHERE product_id=?";

$stmt=$conn->prepare($sql);

$stmt->bind_param(
"ssdisi",
$product_name,
$category,
$price,
$quantity,
$harvest_date,
$product_id
);

if($stmt->execute()){

echo json_encode([
"status"=>"success",
"message"=>"Product Updated"
]);

}else{

echo json_encode([
"status"=>"error",
"message"=>$conn->error
]);

}

$stmt->close();
$conn->close();

?>