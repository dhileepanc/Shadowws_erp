<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");

if (isset($_SESSION['user_id'])) {
  $user_id = ( $_SESSION['user_id']);

  $sql = "SELECT COUNT(*) AS total FROM project WHERE client = '$user_id'";

  $result = mysqli_query($db, $sql);
  $values = mysqli_fetch_assoc($result);
  $num_rows = $values['total'];

  echo $num_rows;
  echo json_encode($num_rows);
} else {
  echo "Error: user_id not set";
}
