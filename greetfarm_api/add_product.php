<?php

include "cors.php";
include "db_connect.php";

header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $farmer_id = $_POST["farmer_id"] ?? "";
    $product_name = $_POST["product_name"] ?? "";
    $category = $_POST["category"] ?? "";
    $price = $_POST["price"] ?? "";
    $quantity = $_POST["quantity"] ?? "";
    $harvest_date = $_POST["harvest_date"] ?? "";
    $image = $_POST["image"] ?? "";
    $distance_km = $_POST["distance_km"] ?? 5;
    $status = "Available";

    $sql = "INSERT INTO products
    (farmer_id, product_name, category, price, quantity, harvest_date, image, status, distance_km)
    VALUES (?,?,?,?,?,?,?,?,?)";

    $stmt = $conn->prepare($sql);

    $stmt->bind_param(
        "issdisssi",
        $farmer_id,
        $product_name,
        $category,
        $price,
        $quantity,
        $harvest_date,
        $image,
        $status,
        $distance_km
    );

    if($stmt->execute()){

        echo json_encode([
            "status"=>"success",
            "message"=>"Product Added Successfully"
        ]);

    }else{

        echo json_encode([
            "status"=>"error",
            "message"=>$conn->error
        ]);

    }

    $stmt->close();

}else{

    echo json_encode([
        "status"=>"error",
        "message"=>"Invalid Request"
    ]);

}

$conn->close();

?>