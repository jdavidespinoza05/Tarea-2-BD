<?php
session_start();

// 🔹 Verificar si el usuario inició sesión
if (!isset($_SESSION['username'])) {
    header("Location: logIn.php");
    exit();
}

// --- INICIO: Lógica de Mensajes Flash (para mostrar éxito o error) ---
$message_success = '';
$message_error = '';
if (isset($_SESSION['message_success'])) {
    $message_success = $_SESSION['message_success'];
    unset($_SESSION['message_success']);
}
if (isset($_SESSION['message_error'])) {
    $message_error = $_SESSION['message_error'];
    unset($_SESSION['message_error']);
}
// --- FIN: Lógica de Mensajes Flash ---


// 🔹 Datos de conexión
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

if (!$conn) {
    die("❌ Error al conectar con la base de datos:<br>" . print_r(sqlsrv_errors(), true));
}

// --- INICIO: Consulta de Puestos (para el Dropdown del modal) ---
$sql_puestos = "SELECT Id, Nombre FROM Puesto ORDER BY Nombre ASC";
$stmt_puestos = sqlsrv_query($conn, $sql_puestos);
$puestos = [];
if ($stmt_puestos) {
    while ($row_puesto = sqlsrv_fetch_array($stmt_puestos, SQLSRV_FETCH_ASSOC)) {
        $puestos[] = $row_puesto;
    }
} else {
    // Si falla la carga de puestos, lo mostramos como error
    $message_error = "Error fatal: No se pudieron cargar los puestos para el formulario.";
}
// --- FIN: Consulta de Puestos ---


// 🔹 Consultar datos de la tabla Empleado (Tu consulta original)
$sql = "SELECT IdPuesto, ValorDocumentoIdentidad, Nombre, FechaContratacion, SaldoVacaciones, EsActivo FROM dbo.Empleado ORDER BY Nombre ASC";
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
            margin: 0; /* Asegura que no haya márgenes */
        }

        h1 { font-size: 28px; margin-bottom: 10px; }
        h2 { font-size: 18px; margin-bottom: 25px; color: #bbb; }
        table {
            border-collapse: collapse;
            width: 90%;
            max-width: 900px;
            background-color: #2a2a2a;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 15px rgba(255,255,255,0.1);
        }
        th, td { padding: 12px 15px; text-align: left; }
        th { background-color: #333; }
        tr:nth-child(even) { background-color: #252525; }
        tr:hover { background-color: #3a3a3a; }

        /* --- INICIO: Estilos de Botones de Acción (Contenedor) --- */
        .dashboard-actions {
            margin-top: auto; /* empuja los botones hacia abajo */
            width: 100%;
            display: flex;
            justify-content: center;
            gap: 15px; /* Espacio entre botones */
            padding-bottom: 40px;
            padding-top: 20px;
        }

        /* Estilo para el botón de Cerrar Sesión (existente) */
        .logout-btn {
            background-color: #6d6d6dff;
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            margin-top: 0; /* Reseteamos el margen */
        }
        .logout-btn:hover {
            background-color: #616161ff;
        }
        
        /* Estilo para el NUEVO botón de Insertar */
        .action-btn {
            background-color: #007bff; /* Color primario (azul) */
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
        }
        .action-btn:hover {
            background-color: #0056b3;
        }
        /* --- FIN: Estilos de Botones de Acción --- */


        /* --- INICIO: Estilos de Mensajes Flash (Alertas) --- */
        .flash-message {
            width: 90%;
            max-width: 900px;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-size: 16px;
            text-align: center;
            font-weight: 500;
        }
        .success {
            background-color: #28a745; /* Verde */
            color: white;
        }
        .error {
            background-color: #dc3545; /* Rojo */
            color: white;
        }
        /* --- FIN: Estilos de Mensajes Flash --- */


        /* --- INICIO: Estilos del Modal (Ventana emergente) --- */
        .modal {
            display: none; /* Oculto por defecto */
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6); /* Fondo oscuro semitransparente */
        }
        .modal-content {
            background-color: #3a3a3a;
            margin: 10% auto;
            padding: 25px 35px;
            border-radius: 10px;
            width: 80%;
            max-width: 450px;
            position: relative;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        .close-btn {
            color: #aaa;
            position: absolute;
            top: 10px;
            right: 20px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close-btn:hover,
        .close-btn:focus {
            color: #fff;
            text-decoration: none;
        }
        .modal-content h3 {
            margin-top: 0;
            margin-bottom: 20px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-size: 14px;
            color: #ddd;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #555;
            background-color: #2e2e2e;
            color: #fff;
            font-size: 15px;
            box-sizing: border-box; /* Importante para el padding */
        }
        .modal-btn {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin-top: 10px;
        }
        .modal-btn:hover {
            background-color: #0056b3;
        }
        /* --- FIN: Estilos del Modal --- */

    </style>
</head>
<body>

    <h1>Lista de Empleados</h1>
    <h2>Bienvenido, <?php echo htmlspecialchars($_SESSION['username']); ?> </h2>

    <?php if ($message_success): ?>
        <div class="flash-message success"><?= $message_success ?></div>
    <?php endif; ?>
    <?php if ($message_error): ?>
        <div class="flash-message error"><?= $message_error ?></div>
    <?php endif; ?>
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
        
    <div class="dashboard-actions">
        <button id="openModalBtn" class="action-btn">Insertar Empleado</button>
        
        <form method="post" action="logOut.php" style="margin: 0;">
            <button type="submit" class="logout-btn">Cerrar sesión</button>
        </form>
    </div>
    <div id="insertModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" id="closeModalBtn">&times;</span>
            <h3>Registrar Nuevo Empleado</h3>
            
            <form action="insertarEmpleado.php" method="POST">
                <div class="form-group">
                    <label for="documento">Documento de Identidad (solo números):</label>
                    <input type="text" id="documento" name="documento" required pattern="[0-9]+" title="Solo números">
                </div>
                <div class="form-group">
                    <label for="nombre">Nombre Completo:</label>
                    <input type="text" id="nombre" name="nombre" required pattern="[A-Za-zÁÉÍÓÚáéíóúÑñÜü .\-]+" title="Solo letras y espacios (no simbolos)">
                </div>
                <div class="form-group">
                    <label for="idPuesto">Puesto:</label>
                    <select id="idPuesto" name="idPuesto" required>
                        <option value="">-- Seleccione un puesto --</option>
                        <?php foreach ($puestos as $puesto): ?>
                            <option value="<?= $puesto['Id'] ?>">
                                <?= htmlspecialchars($puesto['Nombre']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </div>
                <button type="submit" class="modal-btn">Insertar Empleado</button>
            </form>
        </div>
    </div>
    <script>
        // Obtener los elementos del DOM
        var modal = document.getElementById("insertModal");
        var btn = document.getElementById("openModalBtn");
        var span = document.getElementById("closeModalBtn");

        // Cuando el usuario hace clic en el botón [Insertar Empleado]
        btn.onclick = function() {
            modal.style.display = "block";
        }

        // Cuando el usuario hace clic en la (x)
        span.onclick = function() {
            modal.style.display = "none";
        }

        // Cuando el usuario hace clic fuera del modal
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
    </body>
</html>

<?php
sqlsrv_free_stmt($stmt);
sqlsrv_free_stmt($stmt_puestos); // 🔹 Importante: Liberar la nueva consulta
sqlsrv_close($conn);
?>