<?php
session_start();
if (!isset($_SESSION['username'])) {
    header("Location: login.html");
    exit;
}
?>
<h2>Bienvenido, <?= $_SESSION['username'] ?></h2>
<p>Has iniciado sesión correctamente.</p>
<a href="logout.php">Cerrar sesión</a>
