<?php
session_start();

// Datos de conexión a CloudCluster
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$connectionOptions = array(
    "Database" => "Tarea2BD",
    "Uid" => "Espi",
    "PWD" => "Espi1234",
    "Encrypt" => true,
    "TrustServerCertificate" => true
);

// Conectar a la base de datos
$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Tomar datos del formulario
$username = $_POST['username'];
$password = $_POST['password'];

// Consultar la base de datos usando el schema correcto y tabla dbo.Usuario
$sql = "SELECT * FROM dbo.Usuario WHERE username = ? AND password = ?";
$params = array($username, $password);

$result = sqlsrv_query($conn, $sql, $params);

if ($result === false) {
    die(print_r(sqlsrv_errors(), true));
}

// Verificar si hay resultados
if (sqlsrv_has_rows($result)) {
    $_SESSION['username'] = $username;
    header("Location: dashboard.php");
    exit();
} else {
    echo "Usuario o contraseña incorrectos.";
}

sqlsrv_free_stmt($result);
sqlsrv_close($conn);
?>
