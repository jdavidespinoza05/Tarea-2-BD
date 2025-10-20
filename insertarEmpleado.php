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
    $fechaContratacion = date("Y-m-d");
    $userId = $_SESSION["userId"];
    $ip = $_SERVER["REMOTE_ADDR"];
    $outResultCode = 0;

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
        $mensaje = "Error al ejecutar el procedimiento almacenado.";
    } else {
        switch ($outResultCode) {
            case 0:
                $mensaje = "Empleado insertado correctamente.";
                $color = "green";
                break;
            case 50004:
                $mensaje = "El documento ya existe.";
                break;
            case 50005:
                $mensaje = "El nombre ya existe.";
                break;
            case 50008:
                $mensaje = "El puesto no existe.";
                break;
            case 50009:
                $mensaje = "Nombre inválido o vacío.";
                break;
            case 50010:
                $mensaje = "Documento inválido o vacío.";
                break;
            default:
                $mensaje = "Error desconocido (Código $outResultCode).";
        }
    }

    sqlsrv_free_stmt($stmt);
}

// Cargar lista de puestos
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
    <style>
        body {
            background-color: #f6f6f6;
            font-family: "Segoe UI", Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
            width: 360px;
            text-align: center;
        }
        h2 {
            margin-bottom: 20px;
            color: #333;
            font-weight: 600;
        }
        label {
            display: block;
            text-align: left;
            margin-bottom: 6px;
            font-size: 14px;
            color: #444;
        }
        input, select {
            width: 100%;
            padding: 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            margin-bottom: 16px;
            font-size: 14px;
        }
        input:focus, select:focus {
            outline: none;
            border-color: #0078d7;
        }
        button {
            background-color: #222;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
            width: 100%;
        }
        button:hover {
            background-color: #444;
        }
        a {
            display: inline-block;
            margin-top: 16px;
            color: #0078d7;
            text-decoration: none;
            font-size: 13px;
        }
        a:hover {
            text-decoration: underline;
        }
        .mensaje {
            font-weight: bold;
            margin-top: 12px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Registrar nuevo empleado</h2>

    <form method="POST" action="">
        <label for="documento">Documento de Identidad</label>
        <input type="text" name="documento" id="documento" maxlength="20" required>

        <label for="nombre">Nombre del Empleado</label>
        <input type="text" name="nombre" id="nombre" maxlength="100" required>

        <label for="idPuesto">Puesto</label>
        <select name="idPuesto" id="idPuesto" required>
            <option value="">Seleccione un puesto</option>
            <?php foreach ($puestos as $p): ?>
                <option value="<?= $p['Id'] ?>"><?= htmlspecialchars($p['Nombre']) ?></option>
            <?php endforeach; ?>
        </select>

        <button type="submit">Insertar</button>
    </form>

    <?php if (!empty($mensaje)): ?>
        <p class="mensaje" style="color: <?= $color ?>;"><?= $mensaje ?></p>
    <?php endif; ?>

    <a href="dashboard.php">⬅ Volver al Dashboard</a>
</div>
</body>
</html>
