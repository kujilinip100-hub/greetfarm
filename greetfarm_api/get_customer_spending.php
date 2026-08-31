<?php
include "db_connect.php";
header("Content-Type: application/json");

$customer_id = $_GET["customer_id"] ?? "";

// This week (Monday - today)
$week_sql = "SELECT DATE(r.collected_at) as sale_date, p.product_name, MAX(p.image) as image,
SUM(r.quantity) as total_qty, SUM(r.quantity * p.price) as total_amount
FROM reservations r
JOIN products p ON r.product_id = p.product_id
WHERE r.customer_id = ? AND r.status = 'Collected'
AND YEARWEEK(r.collected_at, 1) = YEARWEEK(CURDATE(), 1)
GROUP BY DATE(r.collected_at), p.product_name
ORDER BY sale_date ASC";

$stmt = $conn->prepare($week_sql);
$stmt->bind_param("i", $customer_id);
$stmt->execute();
$this_week = [];
$res = $stmt->get_result();
while ($row = $res->fetch_assoc()) { $this_week[] = $row; }
$stmt->close();

// This month grouped by week
$month_sql = "SELECT WEEK(r.collected_at, 1) as week_num,
MIN(DATE(r.collected_at)) as week_start, MAX(DATE(r.collected_at)) as week_end,
p.product_name, MAX(p.image) as image, SUM(r.quantity) as total_qty, SUM(r.quantity * p.price) as total_amount
FROM reservations r
JOIN products p ON r.product_id = p.product_id
WHERE r.customer_id = ? AND r.status = 'Collected'
AND MONTH(r.collected_at) = MONTH(CURDATE()) AND YEAR(r.collected_at) = YEAR(CURDATE())
GROUP BY week_num, p.product_name
ORDER BY week_num ASC";

$stmt2 = $conn->prepare($month_sql);
$stmt2->bind_param("i", $customer_id);
$stmt2->execute();
$this_month = [];
$res2 = $stmt2->get_result();
while ($row = $res2->fetch_assoc()) { $this_month[] = $row; }
$stmt2->close();

// All-time total per product
$total_sql = "SELECT p.product_name, MAX(p.image) as image, SUM(r.quantity) as total_qty, SUM(r.quantity * p.price) as total_amount
FROM reservations r
JOIN products p ON r.product_id = p.product_id
WHERE r.customer_id = ? AND r.status = 'Collected'
GROUP BY p.product_name
ORDER BY total_amount DESC";

$stmt3 = $conn->prepare($total_sql);
$stmt3->bind_param("i", $customer_id);
$stmt3->execute();
$all_time = [];
$grand_total = 0;
$res3 = $stmt3->get_result();
while ($row = $res3->fetch_assoc()) {
    $all_time[] = $row;
    $grand_total += $row["total_amount"];
}
$stmt3->close();

echo json_encode([
    "status" => "success",
    "this_week" => $this_week,
    "this_month" => $this_month,
    "all_time" => $all_time,
    "grand_total" => $grand_total
]);

$conn->close();
?>