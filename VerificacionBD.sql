USE Tarea2BD
GO

--Mostrar las tablas creadas
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

--Ver los datos de todas las tablas por separado
SELECT * FROM Puesto;
SELECT * FROM TipoEvento;
SELECT * FROM TipoMovimiento;
SELECT * FROM Usuario;
SELECT * FROM Empleado;
SELECT * FROM Movimiento;

--Confirmar que es la cantidad de registros del XML
SELECT 'Puesto' AS Tabla, COUNT(*) AS Registros FROM Puesto
UNION ALL
SELECT 'TipoEvento', COUNT(*) FROM TipoEvento
UNION ALL
SELECT 'TipoMovimiento', COUNT(*) FROM TipoMovimiento
UNION ALL
SELECT 'Usuario', COUNT(*) FROM Usuario
UNION ALL
SELECT 'Error', COUNT(*) FROM Error
UNION ALL
SELECT 'Empleado', COUNT(*) FROM Empleado
UNION ALL
SELECT 'Movimiento', COUNT(*) FROM Movimiento;

--Registros de errores o eventos
SELECT TOP 10 * FROM DBError ORDER BY Id DESC;
SELECT TOP 10 * FROM BitacoraEvento ORDER BY Id DESC;
