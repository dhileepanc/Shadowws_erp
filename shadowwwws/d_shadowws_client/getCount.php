<?php 
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");

$user_id = mysqli_real_escape_string($db, $_SESSION['user_id']);

$sql = "SELECT COUNT(*) AS total FROM project WHERE client = '$user_id'";

$result = mysqli_query($db, $sql);
$values = mysqli_fetch_assoc($result);
$num_rows = $values['total'];

echo $num_rows;
?>
