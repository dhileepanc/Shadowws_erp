<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  
  $sql = "SELECT COUNT(*) as count FROM project WHERE client = '$user_id' AND pm_status='complete' AND admin_status ='confirm'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count = $row['count'];

  $sql1 = "SELECT * FROM project WHERE client = '$user_id'";
  $result1 = mysqli_query($db, $sql1);
  $row1 = mysqli_fetch_array($result1, MYSQLI_ASSOC);
  $_SESSION['project_name'] = $row1['name'];
  $_SESSION['project_id'] = $row1['id'];
  $_SESSION['team_leader_id'] = $row1['tl_id'];

  echo json_encode(["count" => $count,"project_name" => $_SESSION['project_name'],'project_id' => $_SESSION['project_id'],'team_leader_id' => $_SESSION['team_leader_id']]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>