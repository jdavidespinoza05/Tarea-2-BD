<?php
session_start();

// datos de tu base de datos en la nube
$host = 'mssql-203149-0.cloudclusters.net';
$db   = 'Tarea2BD';
$user = 'Espi';
$pass = 'Espi1234';

// conectar a la base de datos
$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die("Error de conexión: " . $conn->connect_error);
}

// tomar datos del formulario
$username = $_POST['username'];
$password = $_POST['password'];

// consultar la base de datos
$sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $_SESSION['username'] = $username;
    header("Location: dashboard.php");
} else {
    echo "Usuario o contraseña incorrectos.";
}

$conn->close();
?>
