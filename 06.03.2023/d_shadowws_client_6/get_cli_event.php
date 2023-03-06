<?php
// Set database connection parameters
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "myshadowws_erp";

// Get user ID
$user_id = $_GET['user_id'];

// Create database connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check for connection errors
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Prepare SQL statement to retrieve events data for a specific user
$sql = "SELECT title, type, date FROM cli_events WHERE user_id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $user_id);
$stmt->execute();
$result = $stmt->get_result();

// Create an array to store events data
$events = array();

// Loop through the result set and add each event to the array
while ($row = $result->fetch_assoc()) {
    $event = array(
        'title' => $row['title'],
        'type' => $row['type'],
        'date' => $row['date']
    );
    array_push($events, $event);
}

// Set content type to JSON
header('Content-Type: application/json');

// Output the JSON data
echo json_encode($events);

// Close statement and database connection
$stmt->close();
$conn->close();
?>