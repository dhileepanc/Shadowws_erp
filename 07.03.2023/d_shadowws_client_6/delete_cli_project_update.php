<?php
// Get the data from the HTTP POST request
$id = $_GET['id'];


// Connect to the MySQL database
$conn = mysqli_connect('localhost', 'root', '', 'myshadowws_erp');
if (!$conn) {
    die('Could not connect: ' . mysqli_error());
}

// Escape the data to prevent SQL injection attacks
$id = mysqli_real_escape_string($conn, $id);

// Delete the data from the database
$sql = "DELETE FROM project_update WHERE id = '$id'";
if (!mysqli_query($conn, $sql)) {
    die('Error: ' . mysqli_error($conn));
}

echo "Data deleted successfully";

mysqli_close($conn);

?>