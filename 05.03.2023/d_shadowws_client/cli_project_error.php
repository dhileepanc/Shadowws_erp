<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];

  $sql = "SELECT id,error_title,error_date,error_updater_name,project_id FROM project_error where client=$user_id";
  $result = mysqli_query($db, $sql);
  if ($result) {
    $rows = array();
    while ($row = mysqli_fetch_assoc($result)) {
      // Get project name from project table using project_id
      $project_id = $row['project_id'];
      $project_name_query = "SELECT name,project_id FROM project WHERE id=$project_id AND client=$user_id";
      $project_name_result = mysqli_query($db, $project_name_query);
      if ($project_name_result) {
        $project_name_row = mysqli_fetch_assoc($project_name_result);
        
      $row['project_name'] = $project_name_row['name'];
      
      } else {
        $row['project_name'] = '';
        
      }
      
      $rows[] = $row;
    }
    
    echo json_encode($rows);
  } else {
    echo "Error: " . mysqli_error($db);
  }

} else {
  echo "Error: can't get errors";
}

error_reporting(E_ALL);
ini_set('display_errors', 1);

?>