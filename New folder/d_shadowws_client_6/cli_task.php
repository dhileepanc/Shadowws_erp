<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "GET") {
  $project_id = $_GET['project_id'];

  $sql = "SELECT COUNT(*) as opentask FROM task WHERE project_id = '$project_id' AND pm_status != 'complete'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count_open = $row['opentask'];
  
  $project_id = $_GET['project_id'];
  $sql2 = "SELECT COUNT(*) as com_task FROM task WHERE project_id = '$project_id' AND pm_status = 'complete'";
  $result2 = mysqli_query($db, $sql2);
  $row2 = mysqli_fetch_array($result2, MYSQLI_ASSOC);
  $count_complete = $row2['com_task'];

  $sql3 = "SELECT COUNT(*) as tot_task FROM task WHERE project_id = '$project_id'";
  $result3 = mysqli_query($db, $sql3);
  $row3 = mysqli_fetch_array($result3, MYSQLI_ASSOC);
  $count_total = $row3['tot_task'];

  $progress = $count_total > 0 ? round($count_complete / $count_total * 100, 2) : 0;

  $sql4 = "SELECT COALESCE(d_name, ' ') AS d_name FROM employee WHERE id = (SELECT COALESCE(tl_id, null) FROM project WHERE id = '$project_id')";

$result4 = mysqli_query($db, $sql4);
$row4 = mysqli_fetch_array($result4, MYSQLI_ASSOC);
$project_leader_name = $row4['d_name'];


$sql5 = "SELECT COALESCE(d_name, '') AS d_name FROM employee WHERE id = (SELECT emp_id FROM project WHERE id = '$project_id')";
$result5 = mysqli_query($db, $sql5);
$row5 = mysqli_fetch_array($result5, MYSQLI_ASSOC);
$team_name = $row5['d_name'];

  // echo json_encode(["opentask" => $count_open, "com_task" => $count_complete,"total_task" => $count_total,"progress" => $progress,"project_leader_name" => $project_leader_name]);
  echo json_encode(["opentask" => $count_open, "com_task" => $count_complete,"total_task" => $count_total,"progress" => $progress,"project_leader_name" => $project_leader_name,"team_name" => $team_name]);
}
else{
  echo "Error: can't get open task";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
