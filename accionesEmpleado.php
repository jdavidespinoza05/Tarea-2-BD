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
} catch (Exception $e) {
    die("Error de conexión: " . $e->getMessage());
}

// Capturar acción y empleado
$accion = isset($_POST['accion']) ? $_POST['accion'] : '';
$empleadoId = isset($_POST['empleadoId']) ? intval($_POST['empleadoId']) : 0;

if ($empleadoId <= 0) {
    die("Empleado no especificado.");
}

// Dependiendo de la acción
switch ($accion) {
    case 'modificar':
        // Redirigir al form de modificar
        header("Location: modificarEmpleado.php?id=$empleadoId");
        exit();

    case 'borrar':
        // Borrado lógico usando SP DeleteEmpleado_Logico
        $userId = $_SESSION['userId'];
        $ip = $_SERVER['REMOTE_ADDR'];
        try {
            $stmt = $conn->prepare("EXEC dbo.DeleteEmpleado_Logico 
                @inIdEmpleado = :inIdEmpleado,
                @inUserId = :inUserId,
                @inIP = :inIP
            ");
            $stmt->bindParam(':inIdEmpleado', $empleadoId, PDO::PARAM_INT);
            $stmt->bindParam(':inUserId', $userId, PDO::PARAM_INT);
            $stmt->bindParam(':inIP', $ip, PDO::PARAM_STR);
            $stmt->execute();
            $result = $stmt->fetch(PDO::FETCH_ASSOC);
            $resultCode = $result['ResultCode'] ?? 0;

            if ($resultCode == 0) {
                $msg = "Empleado eliminado correctamente.";
            } else {
                $msg = "Error al eliminar empleado (Código: $resultCode)";
            }
        } catch (Exception $e) {
            $msg = "Error en la base de datos: " . $e->getMessage();
        }
        // Redirigir al dashboard mostrando mensaje
        $_SESSION['msg'] = $msg;
        header("Location: dashboard.php");
        exit();

    case 'consultar':
        // Redirigir a consulta en archivo separado
        header("Location: consultarEmpleado.php?id=$empleadoId");
        exit();

    case 'listarMovimientos':
        // Redirigir a movimientos (si tienes página de movimientos)
        header("Location: movimientosEmpleado.php?id=$empleadoId");
        exit();

    case 'insertarMovimiento':
        // Redirigir a insertar movimiento
        header("Location: insertarMovimiento.php?id=$empleadoId");
        exit();

    default:
        die("Acción no válida.");
}
