<?php
session_start();

// Si no hay sesión activa, redirigir al login
if (!isset($_SESSION['userId'])) {
    header("Location: logIn.php");
    exit();
}

// Datos de conexión
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$connectionOptions = array(
    "Database" => "Tarea2BD",
    "Uid" => "Espi",
    "PWD" => "Espi1234",
    "Encrypt" => true,
    "TrustServerCertificate" => true,
    "CharacterSet" => "UTF-8"
);

$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn === false) {
    die("❌ Error de conexión a la base de datos.");
}

// Variables
$mensaje = "";
$color = "red";

// Si el formulario se envía
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $idPuesto = $_POST["idPuesto"];
    $documento = trim($_POST["documento"]);
    $nombre = trim($_POST["nombre"]);
    $fechaContratacion = date("Y-m-d"); // fecha actual
    $userId = $_SESSION["userId"];
    $ip = $_SERVER["REMOTE_ADDR"];
    $outResultCode = 0;

    // Llamada al SP
    $sql = "EXEC dbo.InsertEmpleado 
                @inIdPuesto = ?, 
                @inValorDocumentoIdentidad = ?, 
                @inNombre = ?, 
                @inFechaContratacion = ?, 
                @inUserId = ?, 
                @inIP = ?, 
                @outResultCode = ?";

    $params = array(
        array($idPuesto, SQLSRV_PARAM_IN),
        array($documento, SQLSRV_PARAM_IN),
        array($nombre, SQLSRV_PARAM_IN),
        array($fechaContratacion, SQLSRV_PARAM_IN),
        array($userId, SQLSRV_PARAM_IN),
        array($ip, SQLSRV_PARAM_IN),
        array(&$outResultCode, SQLSRV_PARAM_OUT)
    );

    $stmt = sqlsrv_query($conn, $sql, $params);

    if ($stmt === false) {
        $mensaje = "⚠️ Error al ejecutar el procedimiento almacenado.";
    } else {
        switch ($outResultCode) {
            case 0:
                $mensaje = "✅ Empleado insertado correctamente.";
                $color = "green";
                break;
            case 50004:
                $mensaje = "❌ El documento ya existe.";
                break;
            case 50005:
                $mensaje = "❌ El nombre ya existe.";
                break;
            case 50008:
                $mensaje = "❌ El puesto no existe.";
                break;
            case 50009:
                $mensaje = "⚠️ Nombre inválido o vacío.";
                break;
            case 50010:
                $mensaje = "⚠️ Documento inválido o vacío.";
                break;
            default:
                $mensaje = "⚠️ Error desconocido (Código $outResultCode).";
        }
    }

    sqlsrv_free_stmt($stmt);
}

// Cargar lista de puestos para el dropdown
$puestos = [];
$query = "SELECT Id, Nombre FROM Puesto ORDER BY Nombre ASC";
$result = sqlsrv_query($conn, $query);
if ($result) {
    while ($row = sqlsrv_fetch_array($result, SQLSRV_FETCH_ASSOC)) {
        $puestos[] = $row;
    }
}
sqlsrv_close($conn);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Insertar Empleado</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <h2>Registrar nuevo empleado</h2>

    <form method="POST" action="">
        <label for="documento">Documento de Identidad:</label><br>
        <input type="text" name="documento" id="documento" maxlength="20" required><br><br>

        <label for="nombre">Nombre del Empleado:</label><br>
        <input type="text" name="nombre" id="nombre" maxlength="100" required><br><br>

        <label for="idPuesto">Puesto:</label><br>
        <select name="idPuesto" id="idPuesto" required>
            <option value="">Seleccione un puesto</option>
            <?php foreach ($puestos as $p): ?>
                <option value="<?= $p['Id'] ?>"><?= htmlspecialchars($p['Nombre']) ?></option>
            <?php endforeach; ?>
        </select><br><br>

        <button type="submit">Insertar</button>
    </form>

    <?php if (!empty($mensaje)): ?>
        <p style="color: <?= $color ?>; font-weight: bold;"><?= $mensaje ?></p>
    <?php endif; ?>

    <br>
    <a href="dashboard.php">⬅ Volver al Dashboard</a>
</div>
</body>
</html>
