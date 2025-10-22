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

// Obtener empleadoId
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
    <style>
        body {
            background-color: #1e1e1e;
            font-family: "Segoe UI", Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #fff;
        }

        .container {
            background-color: #2a2a2a;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0,0,0,0.3);
            width: 360px;
            text-align: center;
        }

        h2 {
            margin-bottom: 25px;
            color: #f5f5f5;
            font-weight: 600;
        }

        .empleado-info {
            background-color: #1b1b1b;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #444;
            text-align: left;
            margin-bottom: 20px;
        }

        .empleado-info p {
            margin: 10px 0;
            font-size: 15px;
            color: #ddd;
        }

        .empleado-info p strong {
            color: #fff;
        }

        .btn-back {
            display: inline-block;
            background-color: #0078d7;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
            font-size: 14px;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .btn-back:hover {
            background-color: #005fa3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Detalles del Empleado</h2>

        <div class="empleado-info">
            <p><strong>Documento:</strong> <?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?></p>
            <p><strong>Nombre:</strong> <?= htmlspecialchars($empleado['Nombre']) ?></p>
            <p><strong>Puesto:</strong> <?= htmlspecialchars($empleado['Puesto']) ?></p>
            <p><strong>Saldo Vacaciones:</strong> <?= htmlspecialchars($empleado['SaldoVacaciones']) ?></p>
        </div>

        <a href="dashboard.php" class="btn-back">Volver al Dashboard</a>
    </div>
</body>
</html>
