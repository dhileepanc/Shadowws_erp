<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  $sql = DB_QUERY_ALL("SELECT * FROM project WHERE client = '$user_id'");
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count = mysqli_num_rows($result);
  if($count == 1) {
    $_SESSION['user_id'] = $row['id'];
    $_SESSION['project_name'] = $row['name'];
    echo json_encode(['project_name' => $_SESSION['project_name']]);   
  } else {
    echo json_encode(['error' => 'cant get task']);
  }
} 
 
?>