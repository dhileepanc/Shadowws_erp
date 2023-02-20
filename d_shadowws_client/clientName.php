<?php 
session_start();
$db = mysqli_connect("localhost", "root", "", "myshadowws_erp");

if (isset($_POST['user_id'])) {
    $user_id = mysqli_real_escape_string($db, $_POST['user_id']);
  
    $sql = "SELECT f_name FROM client WHERE client_id = '$user_id'";
  
    $result = mysqli_query($db, $sql);
    $values = mysqli_fetch_assoc($result);
    $f_name = $values['f_name'];
  
    echo json_encode(array('f_name' => $f_name));
  } else {
    echo json_encode(array('f_name' => ''));
  }
?>
