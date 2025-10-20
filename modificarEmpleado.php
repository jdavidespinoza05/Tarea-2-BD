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

    $outResultCode = 0; // variable de salida

    // Ejecutar SP UpdateEmpleado
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

// Traer datos del empleado para mostrar en el formulario
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
</head>
<body>
    <h2>Modificar Empleado</h2>

    <?php if ($error): ?>
        <p style="color:red;"><?= htmlspecialchars($error) ?></p>
    <?php endif; ?>

    <form method="POST">
        <label>Documento:</label><br>
        <input type="text" name="valorDocumento" value="<?= htmlspecialchars($empleado['ValorDocumentoIdentidad']) ?>" required><br><br>

        <label>Nombre:</label><br>
        <input type="text" name="nombre" value="<?= htmlspecialchars($empleado['Nombre']) ?>" required><br><br>

        <label>Puesto:</label><br>
        <select name="idPuesto" required>
            <?php foreach($puestos as $p): ?>
                <option value="<?= $p['Id'] ?>" <?= $p['Id'] == $empleado['IdPuesto'] ? 'selected' : '' ?>>
                    <?= htmlspecialchars($p['Nombre']) ?>
                </option>
            <?php endforeach; ?>
        </select><br><br>

        <button type="submit">Confirmar</button>
        <a href="dashboard.php">Cancelar</a>
    </form>
</body>
</html>
