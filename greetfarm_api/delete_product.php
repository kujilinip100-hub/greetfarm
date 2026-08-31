<?php

include "db_connect.php";

header("Content-Type: application/json");

$product_id = $_POST["product_id"];

$sql = "DELETE FROM products WHERE product_id=?";

$stmt = $conn->prepare($sql);

$stmt->bind_param("i", $product_id);

if($stmt->execute()){

    echo json_encode([
        "status"=>"success",
        "message"=>"Product Deleted Successfully"
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