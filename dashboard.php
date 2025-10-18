<?php
session_start();

// 🔹 Verificar si el usuario inició sesión
if (!isset($_SESSION['username'])) {
    header("Location: logIn.php");
    exit();
}

// 🔹 Datos de conexión (los mismos que usás en logIn.php)
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
    die("❌ Error al conectar con la base de datos:<br>" . print_r(sqlsrv_errors(), true));
}

// 🔹 Consultar datos de la tabla Empleado
$sql = "SELECT IdPuesto, ValorDocumentoIdentidad, Nombre, FechaContratacion, SaldoVacaciones, EsActivo FROM dbo.Empleado";
$stmt = sqlsrv_query($conn, $sql);

if ($stmt === false) {
    die("⚠️ Error al ejecutar la consulta:<br>" . print_r(sqlsrv_errors(), true));
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Empleados</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif; 
            background-color: #2e2e2eff; 
            color: #fff; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            justify-content: flex-start; 
            min-height: 100vh; 
            padding: 20px 0 0 0; 
            box-sizing: border-box;
        }

        h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        h2 {
            font-size: 18px;
            margin-bottom: 25px;
            color: #bbb;
        }
        table {
            border-collapse: collapse;
            width: 90%;
            max-width: 900px;
            background-color: #2a2a2a;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(255,255,255,0.1);
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
        }
        th {
            background-color: #333;
        }
        tr:nth-child(even) {
            background-color: #252525;
        }
        tr:hover {
            background-color: #3a3a3a;
        }
        .logout-btn {
            background-color: #6d6d6dff;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            margin-top: 20px;
            cursor: pointer;
            font-size: 15px;
            
        }
        .logout-btn:hover {
            background-color: #616161ff;
        }
        .logout-container {
            margin-top: auto; /* empuja el botón hacia abajo */
            width: 100%;
            display: flex;
            justify-content: center; /* centra horizontalmente el botón */
            padding-bottom: 40px; /* espacio entre botón y el fondo */
        }

    </style>
</head>
<body>

    <h1>Lista de Empleados</h1>
    <h2>Bienvenido, <?php echo htmlspecialchars($_SESSION['username']); ?> </h2>

    <table>
        <thead>
            <tr>
                <th>Id Puesto</th>
                <th>Documento Identidad</th>
                <th>Nombre</th>
                <th>Fecha Contratación</th>
                <th>Saldo Vacaciones</th>
                <th>Activo</th>
            </tr>
        </thead>
        <tbody>
            <?php while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)): ?>
                <tr>
                    <td><?= htmlspecialchars($row['IdPuesto']) ?></td>
                    <td><?= htmlspecialchars($row['ValorDocumentoIdentidad']) ?></td>
                    <td><?= htmlspecialchars($row['Nombre']) ?></td>
                    <td>
                        <?php
                        $fecha = $row['FechaContratacion'];
                        echo ($fecha instanceof DateTime) ? $fecha->format('Y-m-d') : '—';
                        ?>
                    </td>
                    <td><?= htmlspecialchars($row['SaldoVacaciones'] ?? '0.00') ?></td>
                    <td><?= $row['EsActivo'] ? 'Sí' : 'No' ?></td>
                </tr>
            <?php endwhile; ?>
        </tbody>
    </table>            
    <div class="logout-container">
        <form method="post" action="logOut.php">
            <button type="submit" class="logout-btn">Cerrar sesión</button>
        </form>
    </div>
</body>
</html>

<?php
sqlsrv_free_stmt($stmt);
sqlsrv_close($conn);
?>
