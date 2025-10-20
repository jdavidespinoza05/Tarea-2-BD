<?php
session_start();

// --- Config DB (usa tu configuración)
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

// Obtener empleadoId (GET al abrir, POST al confirmar)
$empleadoId = isset($_GET['empleadoId']) ? (int)$_GET['empleadoId'] : (isset($_POST['empleadoId']) ? (int)$_POST['empleadoId'] : 0);
if ($empleadoId <= 0) {
    die("Empleado no especificado.");
}

// Comprobar usuario logueado y obtener userId
if (!isset($_SESSION['userId'])) {
    // Si no quieres forzar login, puedes poner un fallback (p.ej. userId = 1).
    die("No autorizado. Inicia sesión para continuar.");
}
$userId = (int)$_SESSION['userId'];
$ip = $_SERVER['REMOTE_ADDR'];

// Si se confirmó el borrado (POST), llamamos al SP
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['confirmar'])) {
    try {
        $sql = "EXEC dbo.DeleteEmpleado_Logico @inIdEmpleado = :inIdEmpleado, @inUserId = :inUserId, @inIP = :inIP";
        $stmt = $conn->prepare($sql);
        $stmt->bindParam(':inIdEmpleado', $empleadoId, PDO::PARAM_INT);
        $stmt->bindParam(':inUserId', $userId, PDO::PARAM_INT);
        $stmt->bindParam(':inIP', $ip, PDO::PARAM_STR);

        $stmt->execute();

        // Leer el SELECT que devuelve el SP (ResultCode)
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $resultCode = isset($row['ResultCode']) ? (int)$row['ResultCode'] : -1;

        if ($resultCode === 0) {
            // Éxito: empleado marcado como inactivo
            echo "<p style='color:green;'>Empleado eliminado correctamente (borrado lógico).</p>";
            echo "<p><a href='dashboard.php'>Volver al dashboard</a></p>";
            exit;
        } else {
            echo "<p style='color:red;'>Error al eliminar el empleado (Código: $resultCode).</p>";
            echo "<p><a href='dashboard.php'>Volver al dashboard</a></p>";
            exit;
        }
    } catch (PDOException $e) {
        echo "<p style='color:red;'>Error en la base de datos: " . htmlspecialchars($e->getMessage()) . "</p>";
        echo "<p><a href='dashboard.php'>Volver al dashboard</a></p>";
        exit;
    }
}

// Si no se confirmó todavía: obtener datos del empleado para mostrar confirmación
try {
    $stmt = $conn->prepare("SELECT ValorDocumentoIdentidad, Nombre FROM Empleado WHERE Id = :idEmpleado");
    $stmt->bindParam(':idEmpleado', $empleadoId, PDO::PARAM_INT);
    $stmt->execute();
    $empleado = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$empleado) {
        die("Empleado no encontrado.");
    }
} catch (PDOException $e) {
    die("Error en la base de datos: " . htmlspecialchars($e->getMessage()));
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Confirmar borrado</title>
</head>
<body>
    <h2>Confirmar borrado de empleado</h2>
    <p>¿Está seguro que desea eliminar (borrado lógico) al siguiente empleado?</p>
    <ul>
        <li><strong>Documento:</strong> <?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?></li>
        <li><strong>Nombre:</strong> <?= htmlspecialchars($empleado['Nombre']) ?></li>
    </ul>

    <form method="POST">
        <input type="hidden" name="empleadoId" value="<?= $empleadoId ?>">
        <button type="submit" name="confirmar">Confirmar borrado</button>
        <button type="button" onclick="window.location.href='dashboard.php'">Cancelar</button>
    </form>
</body>
</html>
