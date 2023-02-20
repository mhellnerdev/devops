<?php

// MySQL connection settings
$servername = "localhost";
$username = "root";
$password = "password";
$dbname = "test_db";

// Number of rows to insert
$num_rows = 10000; // Change this to however many rows you want to insert

// Name of the table to create
$table_name = "rando_data"; // Change this to your desired table name

// Connect to MySQL
$conn = mysqli_connect($servername, $username, $password, $dbname);

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// SQL query to check if table exists
$sql_check_table = "SELECT 1 FROM $table_name LIMIT 1";

// Execute SQL query to check if table exists
if (mysqli_query($conn, $sql_check_table)) {
    echo "Table $table_name already exists.\n";
} else {
    // SQL query to create a new table
    $sql_create_table = "CREATE TABLE $table_name (
                          id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                          col1 VARCHAR(16) NOT NULL,
                          col2 VARCHAR(16) NOT NULL,
                          col3 VARCHAR(16) NOT NULL,
                          col4 VARCHAR(16) NOT NULL,
                          col5 VARCHAR(16) NOT NULL,
                          col6 VARCHAR(16) NOT NULL,
                          col7 VARCHAR(16) NOT NULL,
                          col8 VARCHAR(16) NOT NULL,
                          col9 VARCHAR(16) NOT NULL,
                          col10 VARCHAR(16) NOT NULL
                        )";

    // Execute SQL query to create the table
    if (mysqli_query($conn, $sql_create_table)) {
        echo "Table $table_name created successfully.\n";
    } else {
        die("Error creating table: " . mysqli_error($conn));
    }
}

// Loop to insert data
for ($i = 0; $i < $num_rows; $i++) {

    // Generate random string for each column
    $col1 = generateRandomString(16);
    $col2 = generateRandomString(16);
    $col3 = generateRandomString(16);
    $col4 = generateRandomString(16);
    $col5 = generateRandomString(16);
    $col6 = generateRandomString(16);
    $col7 = generateRandomString(16);
    $col8 = generateRandomString(16);
    $col9 = generateRandomString(16);
    $col10 = generateRandomString(16);

    // Prepare and execute SQL query to insert data
    $stmt = $conn->prepare("INSERT INTO $table_name (col1, col2, col3, col4, col5, col6, col7, col8, col9, col10) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssssssssss", $col1, $col2, $col3, $col4, $col5, $col6, $col7, $col8, $col9, $col10);
    $stmt->execute();

    // Print progress message
    echo "\rAdding data... " . ($i + 1) . "/$num_rows";
    flush();
}

echo "\n";
// Close MySQL connection
mysqli_close($conn);

// Print message
echo "Data added successfully. $num_rows rows were added.\n";

// Function to generate random string
function generateRandomString($length = 16) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $characters_length = strlen($characters);
    $random_string = '';
    for ($i = 0; $i < $length; $i++) {
        $random_string .= $characters[rand(0, $characters_length - 1)];
    }
    return $random_string;
}
