<?php
// Set database connection parameters
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "myshadowws_erp";

// Get form data
$title = $_POST['title'];
$type = $_POST['type'];
$date = $_POST['date'];
$user_id = $_GET['user_id'];
$category = "client";

// Create database connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check for connection errors
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Prepare SQL statement to retrieve the location value from project table
$sql_project = "SELECT location FROM project WHERE client=? LIMIT 1"; // limit 1 is set below stmt_project
$stmt_project = $conn->prepare($sql_project);
$stmt_project->bind_param("s", $user_id);
$stmt_project->execute();
$result_project = $stmt_project->get_result();
$row_project = $result_project->fetch_assoc();
$location = $row_project['location'];

// Prepare SQL statement with placeholders
$sql = "INSERT INTO cli_events (title, type, date, user_id, category, location) VALUES (?, ?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssss", $title, $type, $date, $user_id, $category, $location);

if ($stmt->execute()) {
  // Prepare response data
  $response = array('success' => true, 'message' => 'Event added successfully');
} else {
  // Prepare response data
  $response = array('success' => false, 'message' => 'Error adding event');
}

// Set content type to JSON
header('Content-Type: application/json');

// Output only the JSON data
echo json_encode($response);
// Close statement and database connection
$stmt_project->close();
$stmt->close();
$conn->close();
?>