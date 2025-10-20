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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f5f5;
            color: #1c1c1c;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .container {
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        h2 {
            font-weight: 600;
            margin-bottom: 25px;
            font-size: 26px;
        }

        .empleado-info {
            background-color: #fff;
            padding: 20px 25px;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            text-align: left;
        }

        .empleado-info p {
            margin-bottom: 15px;
            font-size: 16px;
        }

        .empleado-info p strong {
            color: #1c1c1c;
        }

        .btn-back {
            display: inline-block;
            padding: 8px 16px;
            background-color: #1c1c1c;
            color: #fff;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .btn-back:hover {
            opacity: 0.85;
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
