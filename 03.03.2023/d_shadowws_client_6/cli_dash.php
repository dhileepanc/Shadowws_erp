<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  
  $sql = "SELECT COUNT(*) as count FROM project WHERE client = '$user_id'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count = $row['count'];

  $update ="SELECT COUNT(*) as updates FROM project_update WHERE client = '$user_id'";
  $result2 = mysqli_query($db, $update);
  $row2 = mysqli_fetch_array($result2, MYSQLI_ASSOC);
  $updates = $row2['updates'];

  $error ="SELECT COUNT(*) as errors FROM project_error WHERE client = '$user_id'";
  $result3 = mysqli_query($db, $error);
  $row3 = mysqli_fetch_array($result3, MYSQLI_ASSOC);
  $errors = $row3['errors'];

  $sql1 = "SELECT * FROM project where client=$user_id";
  $result1 = mysqli_query($db, $sql1);
  if ($result1) {
    $rows = array();
    while ($row = mysqli_fetch_assoc($result1)) {
      // Get project name from project table using project_id
      $project_id = $row['project_id'];
      $project_name_query = "SELECT COUNT(*) as opentask FROM task WHERE project_id = '$project_id' AND pm_status != 'complete'";
      $project_name_query_result = mysqli_query($db, $project_name_query);
      $project_name_query_result_row = mysqli_fetch_array($project_name_query_result, MYSQLI_ASSOC);
      $count_pending = $project_name_query_result_row['opentask'];
    }
    
  } else {
    echo "Error: " . mysqli_error($db);
  }
 
  echo json_encode(["count" => $count,'updates' => $updates,'errors' => $errors,'opentask' => $count_pending]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
