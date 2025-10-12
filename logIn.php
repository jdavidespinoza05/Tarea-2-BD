<?php
session_start();

// Datos de conexión
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$connectionOptions = array(
    "Database" => "Tarea2BD",
    "Uid" => "Espi",
    "PWD" => "Espi1234",
    "Encrypt" => true,
    "TrustServerCertificate" => true
);

// Variable de error inicializada como null
$error = null;

// Solo procesar si el usuario envió el formulario
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $username = $_POST['username'];
    $password = $_POST['password'];

    // Conectar a la base de datos
    $conn = sqlsrv_connect($serverName, $connectionOptions);

    if ($conn === false) {
        $error = "❌ Error de conexión a la base de datos.";
    } else {
        $sql = "SELECT * FROM dbo.Usuario WHERE username = ? AND password = ?";
        $params = array($username, $password);
        $result = sqlsrv_query($conn, $sql, $params);

        if ($result && sqlsrv_has_rows($result)) {
            $_SESSION['username'] = $username;
            header("Location: dashboard.php");
            exit();
        } else {
            $error = "Usuario o contraseña incorrectos.";
        }

        sqlsrv_free_stmt($result);
        sqlsrv_close($conn);
    }
}
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

    <!-- Mensaje de error solo si hubo un fallo -->
    <?php if ($error !== null): ?>
        <p class="error-message"><?= htmlspecialchars($error) ?></p>
    <?php endif; ?>
  </div>
</body>
</html>
