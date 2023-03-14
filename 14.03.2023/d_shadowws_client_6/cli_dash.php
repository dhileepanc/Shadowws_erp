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

$total_pending = 0;

if ($result1) {
    while ($row = mysqli_fetch_assoc($result1)) {
        $project_id = $row['id'];
        $project_name = $row['name'];
        
        $project_name_query = "SELECT COUNT(*) as pendingtask FROM task WHERE project_id = '$project_id' AND pm_status != 'complete'";
        $project_name_query_result = mysqli_query($db, $project_name_query);
        $project_name_query_result_row = mysqli_fetch_array($project_name_query_result, MYSQLI_ASSOC);
        $count_pending = $project_name_query_result_row['pendingtask'];
        
        $total_pending += $count_pending;
    }
} else {
    echo "Error: " . mysqli_error($db);
}
 
        $total_pending += $count_pending;
  echo json_encode(["count" => $count,'updates' => $updates,'errors' => $errors,'pendingtask' => $total_pending]);
}
else{
  echo "Error: user_id not set";
}
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
