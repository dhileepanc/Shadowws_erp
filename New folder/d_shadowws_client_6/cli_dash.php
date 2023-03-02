<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  
  $sql = "SELECT COUNT(*) as count FROM project WHERE client = '$user_id'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count = $row['count'];

  // $sql1 = "SELECT * FROM project WHERE client = '$user_id'";
  // $result1 = mysqli_query($db, $sql1);
  // $row1 = mysqli_fetch_array($result1, MYSQLI_ASSOC);
  // $_SESSION['project_name'] = $row1['name'];
  // $_SESSION['project_id'] = $row1['id'];
  // $_SESSION['team_leader_id'] = $row1['tl_id'];
  // $_SESSION['team'] = $row1['emp_id'] ?: '';

 

  $update ="SELECT COUNT(*) as updates FROM project_update WHERE client = '$user_id'";
  $result2 = mysqli_query($db, $update);
  $row2 = mysqli_fetch_array($result2, MYSQLI_ASSOC);
  $updates = $row2['updates'];

  $error ="SELECT COUNT(*) as errors FROM project_error WHERE client = '$user_id'";
  $result3 = mysqli_query($db, $error);
  $row3 = mysqli_fetch_array($result3, MYSQLI_ASSOC);
  $errors = $row3['errors'];

  //same as open task on cli_task.php
  // $project_id=$_SESSION['project_id'];
  // $pendingtask ="SELECT COUNT(*) as pendingtasks FROM task WHERE project_id = '$project_id' AND pm_status != 'complete'";
  // $result4 = mysqli_query($db, $pendingtask);
  // $row4 = mysqli_fetch_array($result4, MYSQLI_ASSOC);
  // $pendingtasks = $row4['pendingtasks'];

  // echo json_encode(["count" => $count,"project_name" => $_SESSION['project_name'],'project_id' => $_SESSION['project_id'],'team_leader_id' => $_SESSION['team_leader_id'],'team' => $_SESSION['team'],'updates' => $updates,'errors' => $errors,'pendingtasks' => $pendingtasks]);
  echo json_encode(["count" => $count,'updates' => $updates,'errors' => $errors]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
