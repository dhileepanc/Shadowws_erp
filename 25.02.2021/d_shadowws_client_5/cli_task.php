<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $project_id = $_GET['project_id'];
  $sql = "SELECT COUNT(*) as opentask FROM task WHERE project_id = '$project_id' AND pm_status != 'complete'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count_open = $row['opentask'];
  
  $sql2 = "SELECT COUNT(*) as com_task FROM task WHERE project_id = '$project_id' AND pm_status = 'complete'";
  $result2 = mysqli_query($db, $sql2);
  $row2 = mysqli_fetch_array($result2, MYSQLI_ASSOC);
  $count_complete = $row2['com_task'];

  $sql3 = "SELECT COUNT(*) as tot_task FROM task WHERE project_id = '$project_id'";
  $result3 = mysqli_query($db, $sql3);
  $row3 = mysqli_fetch_array($result3, MYSQLI_ASSOC);
  $count_total = $row3['tot_task'];
  
  echo json_encode(["opentask" => $count_open, "com_task" => $count_complete,"total_task" => $count_total]);
}
else{
  echo "Error: can't get open task";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
