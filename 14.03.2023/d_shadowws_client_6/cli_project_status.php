<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $user_id = $_GET['user_id'];
  $sql1 = "SELECT * FROM project WHERE client = '$user_id'";
  $result1 = mysqli_query($db, $sql1);

  $projects = array();
  while ($row1 = mysqli_fetch_array($result1, MYSQLI_ASSOC)) {
    $projects[] = $row1;
  }
  // $project_leader = $_GET['team_leader_id'];
  // $team = $_GET['team'];
  // $sql = "SELECT * FROM project WHERE client = '$user_id'";
  // $result = mysqli_query($db, $sql);
  // $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  // $_SESSION['project_name'] = $row['name'];
  // $_SESSION['project_id'] = $row['id'];
  // $_SESSION['deadline'] = $row['e_date'];

  
  // $sql1 = "SELECT * FROM employee WHERE id = '$project_leader'";
  // $result1 = mysqli_query($db, $sql1);
  // $row1 = mysqli_fetch_array($result1, MYSQLI_ASSOC);
  // $_SESSION['project_leader_name'] = $row1['d_name'];

  // $sql2 = "SELECT * FROM employee WHERE id = '$team'";
  // $result2 = mysqli_query($db, $sql2);
  // $row2 = mysqli_fetch_array($result2, MYSQLI_ASSOC);
  // $_SESSION['team'] = $row2['d_name']?: '';

  echo json_encode(['projects' => $projects]);
  

  // echo json_encode(["project_name" => $_SESSION['project_name'],'project_id' => $_SESSION['project_id'],'deadline' => $_SESSION['deadline'],'project_leader_name' => $_SESSION['project_leader_name'],'team' => $_SESSION['team'],'projects' => $projects]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>