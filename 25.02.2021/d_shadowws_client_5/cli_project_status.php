<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  
  $sql = "SELECT * FROM project WHERE client = '$user_id'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $_SESSION['project_name'] = $row['name'];
  $_SESSION['project_id'] = $row['id'];
  echo json_encode(["project_name" => $_SESSION['project_name'],'project_id' => $_SESSION['project_id']]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>