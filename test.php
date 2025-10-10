<?php
$serverName = "mssql-203149-0.cloudclusters.net,10020";
$connectionOptions = array(
    "Database" => "Tarea2BD",
    "Uid" => "Espi",
    "PWD" => "Espi1234",
    "Encrypt" => true,
    "TrustServerCertificate" => true
);

$conn = sqlsrv_connect($serverName, $connectionOptions);

if ($conn) {
    echo "✅ Conexión exitosa a CloudCluster!";
} else {
    echo "❌ Error de conexión.<br>";
    die(print_r(sqlsrv_errors(), true));
}
?>
