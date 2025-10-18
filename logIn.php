<?php
ob_start(); // 🔹 Asegura que los encabezados funcionen aunque haya salida previa
session_start();

// 🔹 Datos de conexión
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$connectionOptions = array(
    "Database" => "Tarea2BD",
    "Uid" => "Espi",
    "PWD" => "Espi1234",
    "Encrypt" => true,
    "TrustServerCertificate" => true
);

$error = "";

// 🔹 Cuando el usuario envía el formulario
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];
    $ip = $_SERVER['REMOTE_ADDR']; // Detectar IP automáticamente

    // Conectar
    $conn = sqlsrv_connect($serverName, $connectionOptions);

    if ($conn === false) {
        $error = "❌ Error de conexión a la base de datos.";
    } else {
        // 🔹 Definir variables de salida con tipo explícito
        $outResultCode = 0;
        $outUserId = 0;

        // 🔹 Preparar la consulta con EXEC
        $sql = "EXEC dbo.LoginUser 
                    @inUserName = ?, 
                    @inPassword = ?, 
                    @inIP = ?, 
                    @outResultCode = ?, 
                    @outUserId = ?";

        $params = array(
            array($username, SQLSRV_PARAM_IN),
            array($password, SQLSRV_PARAM_IN),
            array($ip, SQLSRV_PARAM_IN),
            array(&$outResultCode, SQLSRV_PARAM_OUT),
            array(&$outUserId, SQLSRV_PARAM_OUT)
        );

        $stmt = sqlsrv_query($conn, $sql, $params);

        if ($stmt === false) {
            $errors = sqlsrv_errors();
            $error = "⚠️ Error al ejecutar el procedimiento almacenado.<br>";
            foreach ($errors as $e) {
                $error .= "Código: " . $e['code'] . " — " . $e['message'] . "<br>";
            }
        } else {
            // 🔹 Evaluar el código de resultado que devuelve el SP
            if ($outResultCode === 0) {
                // ✅ Guardamos los datos de sesión
                $_SESSION['userId'] = $outUserId;
                $_SESSION['username'] = $username;

                // ✅ Redirigimos al dashboard
                header("Location: dashboard.php");
                exit();
            } elseif ($outResultCode === 50001) {
                $error = "El usuario no existe.";
            } elseif ($outResultCode === 50002) {
                $error = "Contraseña incorrecta.";
            } elseif ($outResultCode === 50003) {
                $error = "Has superado el número de intentos. Intenta más tarde.";
            } else {
                $error = "Error desconocido (Código $outResultCode)";
            }
        }

        sqlsrv_free_stmt($stmt);
        sqlsrv_close($conn);
    }
}

ob_end_flush(); // 🔹 Finaliza el buffer de salida
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="login-container">
    <h2>Iniciar Sesión</h2>

    <form method="POST" action="">
        <input type="text" name="username" placeholder="Usuario" required>
        <input type="password" name="password" placeholder="Contraseña" required>
        <button type="submit">Ingresar</button>
    </form>

    <?php if ($error): ?>
        <p class="error-message"><?= $error ?></p>
    <?php endif; ?>
  </div>
</body>
</html>
