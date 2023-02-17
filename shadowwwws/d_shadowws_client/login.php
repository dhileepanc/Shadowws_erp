<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");

if($_SERVER["REQUEST_METHOD"] == "POST") {
  $u_name = mysqli_real_escape_string($db, $_POST['u_name']);
  $password = mysqli_real_escape_string($db, $_POST['password']);

  $sql = "SELECT * FROM client WHERE u_name = '$u_name' and password = '$password'";
  $result = mysqli_query($db, $sql);
  $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
  $count = mysqli_num_rows($result);
  error_reporting(E_ALL);
  ini_set('display_errors', 1);
  if($count == 1) {
    $_SESSION['id'] = $row['id'];
    $_SESSION['u_name'] = $u_name;
    
    echo json_encode("Success");
  } else {
    echo json_encode("Error");
  }
}
?>

