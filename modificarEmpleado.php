<?php
session_start();

// Conexión a la base de datos
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

// Inicializar error
$error = "";

// Cuando se envía el formulario de actualización
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $valorDocumento = $_POST['valorDocumento'] ?? '';
    $nombre = $_POST['nombre'] ?? '';
    $idPuesto = $_POST['idPuesto'] ?? '';

    $stmt = $conn->prepare("
        DECLARE @outResultCode INT;
        EXEC dbo.UpdateEmpleado
            @inIdEmpleado = :idEmpleado,
            @inIdPuesto = :idPuesto,
            @inValorDocumentoIdentidad = :valorDocumento,
            @inNombre = :nombre,
            @inUserId = :userId,
            @inIP = :ip,
            @outResultCode = @outResultCode OUTPUT;
        SELECT @outResultCode as outResultCode;
    ");

    $stmt->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
    $stmt->bindParam(':idPuesto', $idPuesto, PDO::PARAM_INT);
    $stmt->bindParam(':valorDocumento', $valorDocumento, PDO::PARAM_STR);
    $stmt->bindParam(':nombre', $nombre, PDO::PARAM_STR);
    $stmt->bindParam(':userId', $_SESSION['userId'], PDO::PARAM_INT);
    $stmt->bindParam(':ip', $_SERVER['REMOTE_ADDR'], PDO::PARAM_STR);

    try {
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $outResultCode = $result['outResultCode'] ?? 0;

        if ($outResultCode != 0) {
            $error = "Error al actualizar el empleado (Código: $outResultCode)";
        } else {
            header("Location: dashboard.php");
            exit();
        }
    } catch(Exception $e) {
        $error = "Error en la base de datos: " . $e->getMessage();
    }
}

// Traer datos del empleado
$stmt = $conn->prepare("SELECT * FROM Empleado WHERE Id = :idEmpleado");
$stmt->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
$stmt->execute();
$empleado = $stmt->fetch(PDO::FETCH_ASSOC);
if (!$empleado) die("Empleado no encontrado.");

// Traer lista de puestos
$puestosStmt = $conn->query("SELECT Id, Nombre FROM Puesto");
$puestos = $puestosStmt->fetchAll(PDO::FETCH_ASSOC);
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Modificar Empleado</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #1e1e1e;
            color: #ddd;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #2a2a2a;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
            width: 400px;
            text-align: center;
        }

        h2 {
            color: #f5f5f5;
            margin-bottom: 20px;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        label {
            text-align: left;
            color: #aaa;
            font-size: 14px;
        }

        input, select {
            padding: 8px;
            border: 1px solid #444;
            border-radius: 6px;
            background-color: #1b1b1b;
            color: #fff;
        }

        button {
            background-color: #0078d7;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }

        button:hover {
            background-color: #005fa3;
        }

        a {
            color: #bbb;
            text-decoration: none;
            display: block;
            margin-top: 10px;
            font-size: 14px;
        }

        a:hover {
            color: #fff;
        }

        .error {
            color: #ff5c5c;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Modificar Empleado</h2>

        <?php if ($error): ?>
            <p class="error"><?= htmlspecialchars($error) ?></p>
        <?php endif; ?>

        <form method="POST">
            <label>Documento:</label>
            <input type="text" name="valorDocumento" value="<?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?>" required>

            <label>Nombre:</label>
            <input type="text" name="nombre" value="<?= htmlspecialchars($empleado['Nombre']) ?>" required>

            <label>Puesto:</label>
            <select name="idPuesto" required>
                <?php foreach($puestos as $p): ?>
                    <option value="<?= $p['Id'] ?>" <?= $p['Id'] == $empleado['IdPuesto'] ? 'selected' : '' ?>>
                        <?= htmlspecialchars($p['Nombre']) ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <button type="submit">Confirmar</button>
            <a href="dashboard.php">Cancelar</a>
        </form>
    </div>
</body>
</html>
