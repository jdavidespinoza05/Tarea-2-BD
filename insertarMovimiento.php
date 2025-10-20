<?php
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

// Capturar ID de empleado
$empleadoId = $_GET['empleadoId'] ?? null;
if (!$empleadoId) {
    die("Empleado no especificado.");
}

// Obtener datos del empleado
$stmt = $conn->prepare("SELECT Id, ValorDocumentoIdentidad, Nombre, SaldoVacaciones FROM Empleado WHERE Id = :id");
$stmt->bindParam(':id', $empleadoId, PDO::PARAM_INT);
$stmt->execute();
$empleado = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$empleado) {
    die("Empleado no encontrado.");
}

// Obtener tipos de movimiento
$stmtTipos = $conn->query("SELECT Id, Nombre, TipoAccion FROM TipoMovimiento");
$tiposMovimiento = $stmtTipos->fetchAll(PDO::FETCH_ASSOC);

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $tipoMovimientoId = $_POST['tipoMovimiento'] ?? null;
    $monto = $_POST['monto'] ?? null;

    if (!$tipoMovimientoId || !$monto) {
        $error = "Debe seleccionar un tipo de movimiento y un monto.";
    } else {
        $monto = (float) $monto;

        // Obtener TipoAccion (1 o -1)
        $stmtTipo = $conn->prepare("SELECT TipoAccion FROM TipoMovimiento WHERE Id = :id");
        $stmtTipo->bindParam(':id', $tipoMovimientoId, PDO::PARAM_INT);
        $stmtTipo->execute();
        $tipoAccion = $stmtTipo->fetchColumn();

        if ($tipoAccion === false) {
            $error = "Tipo de movimiento inválido.";
        } else {
            $tipoAccion = (float) $tipoAccion;
            $saldoActual = (float) $empleado['SaldoVacaciones'];
            $nuevoSaldo = $saldoActual + ($monto * $tipoAccion);

            if ($nuevoSaldo < 0) {
                $error = "No se puede aplicar el movimiento porque el saldo quedaría negativo.";
            } else {
                // Insertar movimiento
                $stmtInsert = $conn->prepare("
                    INSERT INTO Movimiento 
                    (IdEmpleado, IdTipoMovimiento, Fecha, Monto, NuevoSaldo, IdPostByUser, PostInIp, PostTime)
                    VALUES (:idEmpleado, :idTipoMovimiento, GETDATE(), :monto, :nuevoSaldo, :userId, :ip, GETDATE())
                ");

                // Asumiendo que ya tienes sesión y usuario logueado
                session_start();
                $userId = $_SESSION['userId'] ?? 1; // Default 1 si no hay sesión
                $userIP = $_SERVER['REMOTE_ADDR'];

                $stmtInsert->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
                $stmtInsert->bindParam(':idTipoMovimiento', $tipoMovimientoId, PDO::PARAM_INT);
                $stmtInsert->bindParam(':monto', $monto);
                $stmtInsert->bindParam(':nuevoSaldo', $nuevoSaldo);
                $stmtInsert->bindParam(':userId', $userId, PDO::PARAM_INT);
                $stmtInsert->bindParam(':ip', $userIP, PDO::PARAM_STR);

                $stmtInsert->execute();

                // Actualizar saldo en empleado
                $stmtUpdate = $conn->prepare("UPDATE Empleado SET SaldoVacaciones = :nuevoSaldo WHERE Id = :id");
                $stmtUpdate->bindParam(':nuevoSaldo', $nuevoSaldo);
                $stmtUpdate->bindParam(':id', $empleadoId, PDO::PARAM_INT);
                $stmtUpdate->execute();

                // Redireccionar al listado de movimientos
                header("Location: listarMovimientos.php?empleadoId=$empleadoId");
                exit;
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Insertar Movimiento - <?= htmlspecialchars($empleado['Nombre']) ?></title>
    <style>
        body {
            background-color: #111;
            color: #f2f2f2;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .box {
            background-color: #1c1c1c;
            padding: 30px 40px;
            border-radius: 10px;
            width: 340px;
            box-shadow: 0 0 10px rgba(255,255,255,0.1);
        }
        h1 {
            font-size: 20px;
            text-align: center;
            margin-bottom: 20px;
            color: #fff;
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
        }
        input, select {
            width: 100%;
            padding: 7px;
            margin-top: 5px;
            border: none;
            border-radius: 5px;
            background-color: #2a2a2a;
            color: #fff;
        }
        button {
            margin-top: 15px;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            background-color: #333;
            color: #fff;
            cursor: pointer;
        }
        button:hover {
            background-color: #555;
        }
        .error {
            color: #ff5c5c;
            margin-bottom: 10px;
            text-align: center;
        }
        .actions {
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>Insertar Movimiento</h1>

        <?php if ($error): ?>
            <p class="error"><?= htmlspecialchars($error) ?></p>
        <?php endif; ?>

        <form method="POST">
            <label>Documento:</label>
            <input type="text" value="<?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?>" disabled>

            <label>Nombre:</label>
            <input type="text" value="<?= htmlspecialchars($empleado['Nombre']) ?>" disabled>

            <label>Saldo Vacaciones Actual:</label>
            <input type="text" value="<?= htmlspecialchars($empleado['SaldoVacaciones']) ?>" disabled>

            <label>Tipo de Movimiento:</label>
            <select name="tipoMovimiento" required>
                <option value="">-- Seleccione --</option>
                <?php foreach($tiposMovimiento as $tipo): ?>
                    <option value="<?= $tipo['Id'] ?>"><?= htmlspecialchars($tipo['Nombre']) ?></option>
                <?php endforeach; ?>
            </select>

            <label>Monto:</label>
            <input type="number" step="0.01" name="monto" required>

            <div class="actions">
                <button type="button" onclick="window.location.href='listarMovimientos.php?empleadoId=<?= $empleadoId ?>'">Volver</button>
                <button type="submit">Insertar</button>
            </div>
        </form>
    </div>
</body>
</html>
