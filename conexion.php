<?php
// conexion.php

$serverName = "TU_SERVIDOR"; // Ejemplo: "localhost" o "DESKTOP-1234\SQLEXPRESS"
$database = "TU_BASE_DE_DATOS";
$username = "TU_USUARIO_SQL";
$password = "TU_CONTRASEÑA_SQL";

try {
    $conexion = new PDO("sqlsrv:Server=$serverName;Database=$database", $username, $password);
    $conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Error al conectar con la base de datos: " . $e->getMessage());
}
?>
