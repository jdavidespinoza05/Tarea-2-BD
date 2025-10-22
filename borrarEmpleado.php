<?php
session_start();

$serverName = "mssql-203149-0.cloudclusters.net,10020";
$database   = "Tarea2BD";
$username   = "Espi";
$password   = "Espi1234";

// Conexión PDO
try {
    $conn = new PDO("sqlsrv:server=$serverName;Database=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (Exception $e) {
    die("Error de conexión: " . $e->getMessage());
}

// Obtener empleadoId
$empleadoId = isset($_GET['empleadoId']) ? (int)$_GET['empleadoId'] : (isset($_POST['empleadoId']) ? (int)$_POST['empleadoId'] : 0);
if ($empleadoId <= 0) die("Empleado no especificado.");

// Verificar sesión
if (!isset($_SESSION['userId'])) die("No autorizado. Inicia sesión para continuar.");

$userId = (int)$_SESSION['userId'];
$ip = $_SERVER['REMOTE_ADDR'];

// Confirmación de borrado
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['confirmar'])) {
    try {
        $sql = "EXEC dbo.DeleteEmpleado_Logico @inIdEmpleado = :inIdEmpleado, @inUserId = :inUserId, @inIP = :inIP";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':inIdEmpleado', $empleadoId, PDO::PARAM_INT);
        $stmt->bindParam(':inUserId', $userId, PDO::PARAM_INT);
        $stmt->bindParam(':inIP', $ip, PDO::PARAM_STR);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $resultCode = isset($row['ResultCode']) ? (int)$row['ResultCode'] : -1;

        $mensaje = ($resultCode === 0)
            ? ["Empleado eliminado correctamente (borrado lógico).", "success"]
            : ["Error al eliminar el empleado (Código: $resultCode).", "error"];
    } catch (PDOException $e) {
        $mensaje = ["Error en la base de datos: " . htmlspecialchars($e->getMessage()), "error"];
    }
}
else {
    // Obtener datos del empleado
    $stmt = $conn->prepare("SELECT ValorDocumentoIdentidad, Nombre FROM Empleado WHERE Id = :idEmpleado");
    $stmt->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
    $stmt->execute();
    $empleado = $stmt->fetch(PDO::FETCH_ASSOC);
    if (!$empleado) die("Empleado no encontrado.");
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Eliminar Empleado</title>
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
            margin-bottom: 10px;
        }

        p {
            color: #ccc;
            font-size: 15px;
            margin-bottom: 20px;
        }

        ul {
            list-style: none;
            padding: 0;
            text-align: left;
            margin-bottom: 25px;
        }

        li {
            margin-bottom: 8px;
            color: #bbb;
        }

        form {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        button {
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
        }

        button[name="confirmar"] {
            background-color: #d9534f;
            color: white;
        }

        button[name="confirmar"]:hover {
            background-color: #b52b27;
        }

        button[type="button"] {
            background-color: #444;
            color: #ccc;
        }

        button[type="button"]:hover {
            background-color: #555;
        }

        .mensaje {
            margin-top: 20px;
            font-size: 14px;
        }

        .success {
            color: #4CAF50;
        }

        .error {
            color: #ff5c5c;
        }

        a {
            color: #bbb;
            text-decoration: none;
            margin-top: 10px;
            display: inline-block;
        }

        a:hover {
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <?php if (isset($mensaje)): ?>
            <h2><?= $mensaje[1] === "success" ? "Éxito" : "Error" ?></h2>
            <p class="mensaje <?= $mensaje[1] ?>"><?= htmlspecialchars($mensaje[0]) ?></p>
            <a href="dashboard.php">Volver al Dashboard</a>
        <?php else: ?>
            <h2>Confirmar Borrado</h2>
            <p>¿Estás seguro de eliminar (borrado lógico) al siguiente empleado?</p>
            <ul>
                <li><strong>Documento:</strong> <?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?></li>
                <li><strong>Nombre:</strong> <?= htmlspecialchars($empleado['Nombre']) ?></li>
            </ul>

            <form method="POST">
                <input type="hidden" name="empleadoId" value="<?= $empleadoId ?>">
                <button type="submit" name="confirmar">Confirmar Borrado</button>
                <button type="button" onclick="window.location.href='dashboard.php'">Cancelar</button>
            </form>
        <?php endif; ?>
    </div>
</body>
</html>
