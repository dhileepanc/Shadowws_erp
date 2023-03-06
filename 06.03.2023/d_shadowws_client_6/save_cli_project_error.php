<?php
// Get the data from the HTTP POST request
$project_id = $_POST['project_id'];
$error_date = $_POST['error_date'];
$error_updater_name = $_POST['error_updater_name'];
$error_title = $_POST['error_title'];
$desp = $_POST['desp'];
$user_id = $_GET['user_id'];

// Connect to the MySQL database
$conn = mysqli_connect('localhost', 'root', '', 'myshadowws_erp');
if (!$conn) {
    die('Could not connect: ' . mysqli_error());
}

// Escape the data to prevent SQL injection attacks
$project_id = mysqli_real_escape_string($conn, $project_id);
$error_date = mysqli_real_escape_string($conn, $error_date);
$error_updater_name = mysqli_real_escape_string($conn, $error_updater_name);
$error_title = mysqli_real_escape_string($conn, $error_title);
$desp = mysqli_real_escape_string($conn, $desp);
$user_id = mysqli_real_escape_string($conn, $user_id);

// Insert the data into the database
$sql = "INSERT INTO project_error (project_id, error_date, error_updater_name, error_title, desp, client) VALUES ('$project_id', '$error_date', '$error_updater_name', '$error_title', '$desp', '$user_id')";
if (!mysqli_query($conn, $sql)) {
    die('Error: ' . mysqli_error($conn));
}

echo "Data inserted successfully";

mysqli_close($conn);
?>