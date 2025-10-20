<?php
session_start();

// Conexión
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$database = "Tarea2BD";
$username = "Espi";
$password = "Espi1234";

try {
    $conn = new PDO("sqlsrv:server=$serverName;Database=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(Exception $e) {
    die("Error en la base de datos: " . $e->getMessage());
}

// Obtener empleadoId desde GET
$empleadoId = $_GET['empleadoId'] ?? null;
if (!$empleadoId) die("Empleado no especificado.");

// Traer los datos del empleado
$stmt = $conn->prepare("SELECT e.Id, e.Nombre, e.ValorDocumentoIdentidad, p.Nombre AS Puesto, e.SaldoVacaciones
                        FROM Empleado e
                        JOIN Puesto p ON e.IdPuesto = p.Id
                        WHERE e.Id = :id");
$stmt->bindParam(':id', $empleadoId, PDO::PARAM_INT);
$stmt->execute();
$empleado = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$empleado) die("Empleado no encontrado.");
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Consultar Empleado</title>
</head>
<body>
    <h2>Detalles del Empleado</h2>

    <p><strong>Documento:</strong> <?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?></p>
    <p><strong>Nombre:</strong> <?= htmlspecialchars($empleado['Nombre']) ?></p>
    <p><strong>Puesto:</strong> <?= htmlspecialchars($empleado['Puesto']) ?></p>
    <p><strong>Saldo Vacaciones:</strong> <?= htmlspecialchars($empleado['SaldoVacaciones']) ?></p>

    <a href="dashboard.php">Volver al Dashboard</a>
</body>
</html>
