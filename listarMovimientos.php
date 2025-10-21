<?php
// listarMovimientos.php

// Verificar que se reciba el empleadoId
if (!isset($_GET['empleadoId']) || empty($_GET['empleadoId'])) {
    die("Empleado no especificado.");
}
$empleadoId = $_GET['empleadoId'];

// Conexión a la base de datos
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$database = "Tarea2BD";
$username = "Espi";
$password = "Espi1234";

try {
    $conn = new PDO("sqlsrv:server=$serverName;Database=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(Exception $e) {
    die("Error de conexión: " . $e->getMessage());
}

// Consultar información del empleado (Esto se mantiene igual)
$stmtEmp = $conn->prepare("SELECT ValorDocumentoIdentidad, Nombre, SaldoVacaciones FROM Empleado WHERE Id = :idEmpleado");
$stmtEmp->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
$stmtEmp->execute();
$empleado = $stmtEmp->fetch(PDO::FETCH_ASSOC);

if (!$empleado) {
    die("Empleado no encontrado.");
}


// Consultar movimientos del empleado usando el SP
try {
    $sqlMovimientos = "EXEC dbo.ListMovimientosPorEmpleadoId @inIdEmpleado = :idEmpleado";
    $stmtMov = $conn->prepare($sqlMovimientos);
    $stmtMov->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
    $stmtMov->execute();
    $movimientos = $stmtMov->fetchAll(PDO::FETCH_ASSOC);
} catch (Exception $e) {
    // Manejar errores si el SP falla
    die("Error al consultar movimientos: " . $e->getMessage());
}

?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Movimientos de <?= htmlspecialchars($empleado['Nombre']) ?></title>
    <style>
        /* ... Tu CSS (sin cambios) ... */
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #1e1e1e;
            color: #ddd;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            margin: 0;
            padding-top: 50px;
        }

        .container {
            background-color: #2a2a2a;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            width: 90%;
            max-width: 1000px;
        }

        h1 {
            color: #f5f5f5;
            margin-bottom: 15px;
            text-align: center;
        }

        p {
            color: #ccc;
            font-size: 15px;
            text-align: center;
            margin-bottom: 25px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #333;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #444;
            color: #eee;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #2f2f2f;
        }

        tr:hover {
            background-color: #3a3a3a;
        }

        .buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 25px;
        }

        button {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-agregar {
            background-color: #0078d7;
            color: white;
        }

        .btn-agregar:hover {
            background-color: #005fa3;
        }

        .btn-volver {
            background-color: #444;
            color: #ccc;
        }

        .btn-volver:hover {
            background-color: #555;
        }

        td[colspan] {
            text-align: center;
            color: #aaa;
            padding: 20px;
        }

        @media (max-width: 700px) {
            table, thead, tbody, th, td, tr { display: block; }
            th { display: none; }
            td { padding: 10px; border-bottom: 1px solid #444; }
            td::before {
                content: attr(data-label);
                font-weight: bold;
                display: block;
                margin-bottom: 4px;
                color: #bbb;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Movimientos del Empleado</h1>
        <p>
            <strong>Documento:</strong> <?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?><br>
            <strong>Nombre:</strong> <?= htmlspecialchars($empleado['Nombre']) ?><br>
            <strong>Saldo Vacaciones:</strong> <?= htmlspecialchars($empleado['SaldoVacaciones']) ?>
        </p>

        <table>
            <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Tipo Movimiento</th>
                    <th>Monto</th>
                    <th>Nuevo Saldo</th>
                    <th>Usuario</th>
                    <th>IP</th>
                    <th>Timestamp</th>
                </tr>
            </thead>
            <tbody>
                <?php if (count($movimientos) === 0): ?>
                    <tr><td colspan="7">No hay movimientos registrados.</td></tr>
                <?php else: ?>
                    <?php foreach($movimientos as $mov): ?>
                        <tr>
                            <td data-label="Fecha"><?= htmlspecialchars($mov['Fecha']) ?></td>
                            <td data-label="Tipo Movimiento"><?= htmlspecialchars($mov['TipoMovimiento']) ?></td>
                            <td data-label="Monto"><?= htmlspecialchars($mov['Monto']) ?></td>
                            <td data-label="Nuevo Saldo"><?= htmlspecialchars($mov['NuevoSaldo']) ?></td>
                            <td data-label="Usuario"><?= htmlspecialchars($mov['Usuario']) ?></td>
                            <td data-label="IP"><?= htmlspecialchars($mov['PostInIp']) ?></td>
                            <td data-label="Timestamp"><?= htmlspecialchars($mov['PostTime']) ?></td>
                        </tr>
                    <?php endforeach; ?>
                <?php endif; ?>
            </tbody>
        </table>

        <div class="buttons">
            <button class="btn-agregar" onclick="window.location.href='insertarMovimiento.php?empleadoId=<?= $empleadoId ?>'">Agregar Movimiento</button>
            <button class="btn-volver" onclick="window.location.href='dashboard.php'">Volver al Dashboard</button>
        </div>
    </div>
</body>
</html>