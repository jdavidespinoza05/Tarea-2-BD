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
            background-color: #1e1e1e;
            font-family: "Segoe UI", Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            background-color: #2a2a2a;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0, 0, 0, 0.2);
            width: 360px;
            text-align: center;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h2 {
            margin-bottom: 25px;
            color: #f5f5f5;
            font-weight: 600;
        }

        form {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        label {
            align-self: flex-start;
            margin-bottom: 6px;
            font-size: 14px;
            color: #aaa;
        }

        input, select {
            width: 90%;
            padding: 8px 10px;
            border-radius: 6px;
            background-color: #1b1b1b;
            color: #fff;
            border: 1px solid #444;
            margin-bottom: 16px;
            font-size: 14px;
            text-align: left; /* Alinea el texto a la izquierda */
            box-sizing: border-box;
        }

        /* Ajuste especial para el select */
        select {
            appearance: none; /* Quita estilo nativo (en la mayoría de navegadores) */
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8'%3E%3Cpath fill='%23fff' d='M6 8L0 0h12z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 10px center;
            background-size: 10px;
            padding-right: 28px; /* Deja espacio para la flecha */
        }

        button {
            background-color: #0078d7;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 10px 20px;
            font-size: 14px;
            cursor: pointer;
            width: 90%;
        }

        button:hover {
            background-color: #005fa3;
        }

        a {
            color: #bbb;
            text-decoration: none;
            display: block;
            margin-top: 14px;
            font-size: 14px;
        }

        a:hover {
            color: #fff;
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

    <a href="dashboard.php">Volver al Dashboard</a>
</div>
</body>
</html>
