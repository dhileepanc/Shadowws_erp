<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  $sql = "SELECT COUNT(*) as count FROM project WHERE client = '$user_id'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count = $row['count'];
  echo json_encode(["count" => $count]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>