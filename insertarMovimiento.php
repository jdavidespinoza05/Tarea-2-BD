<?php
// Establecer zona horaria de Costa Rica
date_default_timezone_set('America/Costa_Rica');

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
$stmtTipos = $conn->query("SELECT Id, Nombre FROM TipoMovimiento");
$tiposMovimiento = $stmtTipos->fetchAll(PDO::FETCH_ASSOC);

$error = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $tipoMovimientoId = $_POST['tipoMovimiento'] ?? null;
    $monto = $_POST['monto'] ?? null;

    if (!$tipoMovimientoId || !$monto) {
        $error = "Debe seleccionar un tipo de movimiento y un monto.";
    } else {
        try {
            session_start();
            $userId = $_SESSION['userId'] ?? 1;
            $userIP = $_SERVER['REMOTE_ADDR'];

            // Fechas locales de Costa Rica
            $fecha = date('Y-m-d');          // tipo DATE
            $postTime = date('Y-m-d H:i:s'); // tipo DATETIME

            // Llamada al SP con parámetros correctos
            $stmt = $conn->prepare("
                DECLARE @resultCode INT;
                EXEC dbo.InsertMovimiento 
                    @inValorDocumentoIdentidad = :valorDoc,
                    @inIdTipoMovimiento = :idTipoMovimiento,
                    @inMonto = :monto,
                    @inFecha = :fecha,
                    @inPostTime = :postTime,
                    @inUserId = :userId,
                    @inIP = :userIP,
                    @outResultCode = @resultCode OUTPUT;
                SELECT @resultCode AS resultCode;
            ");

            $stmt->bindParam(':valorDoc', $empleado['ValorDocumentoIdentidad'], PDO::PARAM_STR);
            $stmt->bindParam(':idTipoMovimiento', $tipoMovimientoId, PDO::PARAM_INT);
            $stmt->bindParam(':monto', $monto);
            $stmt->bindParam(':fecha', $fecha);
            $stmt->bindParam(':postTime', $postTime);
            $stmt->bindParam(':userId', $userId, PDO::PARAM_INT);
            $stmt->bindParam(':userIP', $userIP, PDO::PARAM_STR);

            $stmt->execute();

            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($result && $result['resultCode'] != 0) {
                throw new Exception("Error en el procedimiento: código " . $result['resultCode']);
            }

            header("Location: listarMovimientos.php?empleadoId=$empleadoId");
            exit;
        } catch (Exception $e) {
            $error = "Error al insertar movimiento: " . $e->getMessage();
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
            background-color: #1e1e1e;
            color: #f2f2f2;
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .box {
            background-color: #2a2a2a;
            padding: 30px 40px;
            border-radius: 10px;
            width: 340px;
            border: 1px solid #2c2c2c;
        }
        h1 {
            font-size: 22px;
            text-align: center;
            margin-bottom: 25px;
            color: #fff;
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
            font-size: 14px;
        }
        input, select {
            width: 100%;
            padding: 8px 10px;
            margin-top: 5px;
            border: 1px solid #333;
            border-radius: 5px;
            background-color: #242424;
            color: #fff;
            font-size: 14px;
            box-sizing: border-box;
        }
        select {
            appearance: none;
            text-align: left;
        }
        input:disabled {
            color: #aaa;
            background-color: #1e1e1e;
        }
        button {
            margin-top: 18px;
            padding: 9px 15px;
            border: none;
            border-radius: 5px;
            background-color: #333;
            color: #fff;
            cursor: pointer;
            font-weight: bold;
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
            gap: 10px;
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
