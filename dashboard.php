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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: #121212;
            color: #f2f2f2;
            padding: 40px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        h1 {
            margin-bottom: 30px;
            font-weight: 600;
            font-size: 28px;
            color: #eaeaea;
        }

        form {
            margin-bottom: 20px;
        }

        input[type="text"] {
            padding: 10px 14px;
            width: 280px;
            border: 1px solid #2c2c2c;
            border-radius: 6px;
            background-color: #1a1a1a;
            color: #eaeaea;
        }

        input[type="text"]::placeholder {
            color: #777;
        }

        button {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        button:hover {
            opacity: 0.85;
        }

        .btn-insert {
            background-color: #0078ff;
            color: #fff;
        }

        .btn-filter {
            background-color: #333;
            color: #fff;
        }

        table {
            border-collapse: collapse;
            width: 95%; 
            max-width: 1300px;
            background-color: #1a1a1a;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
            border: 3px solid #646464ff; 
        }

        th, td {
            padding: 14px 18px;
            text-align: left;
        }

        th {
            background-color: #101010;
            color: #f5f5f5;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #222;
        }

        tr {
            border-bottom: 1px solid #222;
        }

        tr:nth-child(even) {
            background-color: #141414;
        }

        tr:hover {
            background-color: #1f1f1f;
        }


        .action-btn {
            padding: 7px 12px;
            font-size: 14px;
            margin-right: 6px;
            border-radius: 5px;
            transition: all 0.2s ease;
            border: none;
        }

        .consultar { background-color: #007bff; color: #fff; }
        .modificar { background-color: #28a745; color: #fff; }
        .borrar { background-color: #dc3545; color: #fff; }
        .movimientos { background-color: #17a2b8; color: #fff; }
        .agregar { background-color: #6f42c1; color: #fff; }

        .action-btn:hover {
            transform: scale(1.03);
        }

        td form, td a {
            display: inline-block;
            margin-bottom: 3px;
        }
    </style>
</head>
<body>
    <h1>Listado de Empleados</h1>

    <!-- Botón para insertar un nuevo empleado -->
    <form action="insertarEmpleado.php" method="get">
        <button type="submit" class="btn-insert">Insertar nuevo empleado</button>
    </form>

    <!-- Filtro -->
    <form method="POST">
        <input type="text" name="filter" placeholder="Ingrese nombre o documento" value="<?= htmlspecialchars($filter) ?>">
        <button type="submit" class="btn-filter">Filtrar</button>
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
                            <button type="submit" class="action-btn consultar">Consultar</button>
                        </form>

                        <!-- Modificar -->
                        <form method="GET" action="modificarEmpleado.php" style="display:inline;">
                            <input type="hidden" name="empleadoId" value="<?= $emp['Id'] ?>">
                            <button type="submit" class="action-btn modificar">Modificar</button>
                        </form>

                        <!-- Movimientos -->
                        <form method="GET" action="listarMovimientos.php" style="display:inline;">
                            <input type="hidden" name="empleadoId" value="<?= $emp['Id'] ?>">
                            <button type="submit" class="action-btn movimientos">Movimientos</button>
                        </form>

                        <!-- Borrar -->
                        <a href="borrarEmpleado.php?empleadoId=<?= $emp['Id'] ?>" onclick="return confirm('¿Está seguro que desea eliminar este empleado?');">
                            <button type="button" class="action-btn borrar">Borrar</button>
                        </a>
                        
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</body>
</html>
