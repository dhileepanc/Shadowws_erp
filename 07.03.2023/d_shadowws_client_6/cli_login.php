<?php
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");
if($_SERVER["REQUEST_METHOD"] == "POST") {
  $u_name = mysqli_real_escape_string($db, $_POST['u_name']);
  $password = mysqli_real_escape_string($db, $_POST['password']);
  if(!empty($u_name) && !empty($password)) {
    $sql = "SELECT * FROM client WHERE u_name = '$u_name' and password = '$password'";
    $result = mysqli_query($db, $sql);
    $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
    $count = mysqli_num_rows($result);
    if($count == 1) {
      $_SESSION['user_id'] = $row['id'];
      $_SESSION['client_name'] = $row['f_name'];
      $_SESSION['client_email'] = $row['email'];

     

      echo json_encode(['user_id' => $_SESSION['user_id'],'client_name' => $_SESSION['client_name'],'client_email' =>$_SESSION['client_email']]);    
    } else {
      echo json_encode(['error' => 'Invalid username or password']);
    }
  } else {
    echo json_encode(['error' => 'Please enter both username and password']);
  }
}
?>