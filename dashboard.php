<?php
// Conexión a la base de datos
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$database = "Tarea2BD";
$username = "Espi";
$password = "Espi1234";

try {
    $conn = new PDO("sqlsrv:server=$serverName;Database=$database", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(Exception $e) {
    die("Error de conexión: " . $e->getMessage());
}

// Capturar filtro
$filter = $_POST['filter'] ?? '';

// Llamar al SP para listar empleados filtrados
$stmt = $conn->prepare("EXEC dbo.ListEmpleadoPorFiltro :inFilter");
$stmt->bindParam(':inFilter', $filter, PDO::PARAM_STR);
$stmt->execute();
$empleados = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Empleados</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f0f0f0; }
        input[type="text"] { padding: 5px; width: 300px; }
        button { padding: 5px 10px; margin-right: 5px; }
    </style>
</head>
<body>
    <h1>Listado de Empleados</h1>

    <!-- Botón para insertar un nuevo empleado -->
    <form action="insertarEmpleado.php" method="get" style="margin-bottom: 15px;">
        <button type="submit">➕ Insertar nuevo empleado</button>
    </form>

    <!-- Filtro -->
    <form method="POST">
        <input type="text" name="filter" placeholder="Ingrese nombre o documento" value="<?= htmlspecialchars($filter) ?>">
        <button type="submit">Filtrar</button>
    </form>

    <!-- Tabla de empleados -->
    <table>
        <thead>
            <tr>
                <th>Documento</th>
                <th>Nombre</th>
                <th>Puesto</th>
                <th>Saldo Vacaciones</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach($empleados as $emp): ?>
                <tr>
                    <td><?= htmlspecialchars($emp['ValorDocumentoIdentidad']) ?></td>
                    <td><?= htmlspecialchars($emp['Nombre']) ?></td>
                    <td><?= htmlspecialchars($emp['Puesto']) ?></td>
                    <td><?= htmlspecialchars($emp['SaldoVacaciones']) ?></td>
                    <td>
                        <!-- Consultar -->
                        <form method="GET" action="consultarEmpleado.php" style="display:inline;">
                            <input type="hidden" name="empleadoId" value="<?= $emp['Id'] ?>">
                            <button type="submit">Consultar</button>
                        </form>

                        <!-- Modificar -->
                        <form method="GET" action="modificarEmpleado.php" style="display:inline;">
                            <input type="hidden" name="empleadoId" value="<?= $emp['Id'] ?>">
                            <button type="submit">Modificar</button>
                        </form>

                        <!-- Borrar -->
                        <a href="borrarEmpleado.php?empleadoId=<?= $emp['Id'] ?>" onclick="return confirm('¿Está seguro que desea eliminar este empleado?');">
                            <button type="button">Borrar</button>
                        </a>

                        <!-- Movimientos -->
                        <form method="GET" action="listarMovimientos.php" style="display:inline;">
                            <input type="hidden" name="empleadoId" value="<?= $emp['Id'] ?>">
                            <button type="submit">Movimientos</button>
                        </form>

                        <form method="GET" action="insertarMovimiento.php" style="display:inline;">
                            <input type="hidden" name="empleadoId" value="<?= $emp['Id'] ?>">
                            <button type="submit">Agregar Movimiento</button>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</body>
</html>
