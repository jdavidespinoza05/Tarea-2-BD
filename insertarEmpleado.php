<?php
session_start();

// 1. Verificar que el usuario tenga sesión activa
if (!isset($_SESSION['userId']) || !isset($_SESSION['username'])) {
    // Si no, lo mandamos al login
    header("Location: login.php");
    exit();
}

// 2. Verificar que los datos lleguen por método POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // 3. Incluir conexión a la BD
    $serverName = "mssql-203149-0.cloudclusters.net,10020";
    $connectionOptions = array(
        "Database" => "Tarea2BD",
        "Uid" => "Espi",
        "PWD" => "Espi1234",
        "Encrypt" => true,
        "TrustServerCertificate" => true
    );
    $conn = sqlsrv_connect($serverName, $connectionOptions);

    if (!$conn) {
        // Si falla la conexión, guardar error en sesión y redirigir
        $_SESSION['message_error'] = "Error de conexión a la BD al intentar insertar.";
        header("Location: dashboard.php");
        exit();
    }

    // 4. Recolectar datos del formulario (POST) y de la Sesión
    $inIdPuesto = $_POST['idPuesto'];
    $inValorDocumentoIdentidad = $_POST['documento'];
    $inNombre = $_POST['nombre'];
    
    // Datos requeridos por el SP que no vienen del formulario
    $inFechaContratacion = (new DateTime())->format('Y-m-d'); // Fecha de hoy
    $inUserId = $_SESSION['userId'];
    $inIP = $_SERVER['REMOTE_ADDR'];
    $outResultCode = 0; // Variable de salida

    // 5. Preparar y ejecutar el SP
    $sql = "EXEC dbo.InsertEmpleado 
                @inIdPuesto = ?, 
                @inValorDocumentoIdentidad = ?, 
                @inNombre = ?, 
                @inFechaContratacion = ?, 
                @inUserId = ?, 
                @inIP = ?, 
                @outResultCode = ?";

    $params = array(
        array($inIdPuesto, SQLSRV_PARAM_IN),
        array($inValorDocumentoIdentidad, SQLSRV_PARAM_IN),
        array($inNombre, SQLSRV_PARAM_IN),
        array($inFechaContratacion, SQLSRV_PARAM_IN),
        array($inUserId, SQLSRV_PARAM_IN),
        array($inIP, SQLSRV_PARAM_IN),
        array(&$outResultCode, SQLSRV_PARAM_OUT) // Parámetro de salida
    );

    $stmt = sqlsrv_query($conn, $sql, $params);

    // 6. Interpretar el resultado y crear mensaje flash
    if ($stmt) {
        if ($outResultCode == 0) {
            // Éxito
            $_SESSION['message_success'] = "¡Empleado '" . htmlspecialchars($inNombre) . "' insertado con éxito!";
        } else {
            // Error controlado por el SP
            $error_msg = "Error desconocido (Código $outResultCode).";
            
            // Mapeamos los códigos de error que definiste en tu SP
            if ($outResultCode == 50008) $error_msg = "Error: El puesto seleccionado no existe.";
            if ($outResultCode == 50010) $error_msg = "Error: El documento de identidad debe ser solo números y no estar vacío.";
            if ($outResultCode == 50009) $error_msg = "Error: El nombre contiene caracteres no válidos o está vacío.";
            if ($outResultCode == 50004) $error_msg = "Error: El documento de identidad '" . htmlspecialchars($inValorDocumentoIdentidad) . "' ya existe.";
            if ($outResultCode == 50005) $error_msg = "Error: El nombre '" . htmlspecialchars($inNombre) . "' ya existe.";
            
            $_SESSION['message_error'] = $error_msg;
        }
    } else {
        // Error grave de SQL (ej. SP no existe, permisos, etc.)
        $_SESSION['message_error'] = "Error fatal al ejecutar el SP: " . print_r(sqlsrv_errors(), true);
    }

    // 7. Limpiar y redirigir de vuelta al dashboard
    sqlsrv_free_stmt($stmt);
    sqlsrv_close($conn);

} else {
    // Si alguien intenta acceder a este archivo directamente
    $_SESSION['message_error'] = "Acceso no válido. Utilice el formulario.";
}

// Redirigir siempre de vuelta al dashboard
header("Location: dashboard.php");
exit();
?>