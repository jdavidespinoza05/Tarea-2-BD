-- =================================================================
-- Script de carga de datos para Tarea 2
-- Generado a partir de: archivoDatos.xml
-- =================================================================

PRINT '--- 1.1 Cargando Puestos...';
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Cajero', 11.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Camarero', 10.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Cuidador', 13.50);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Conductor', 15.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Asistente', 11.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Recepcionista', 12.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Fontanero', 13.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Niñera', 12.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Conserje', 11.00);
INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Albañil', 10.50);
GO

PRINT '--- 1.2 Cargando Tipos de Evento...';
SET IDENTITY_INSERT TipoEvento ON;
INSERT INTO TipoEvento (Id, Nombre) VALUES (1, 'Login Exitoso');
INSERT INTO TipoEvento (Id, Nombre) VALUES (2, 'Login No Exitoso');
INSERT INTO TipoEvento (Id, Nombre) VALUES (3, 'Login deshabilitado');
INSERT INTO TipoEvento (Id, Nombre) VALUES (4, 'Logout');
INSERT INTO TipoEvento (Id, Nombre) VALUES (5, 'Insercion no exitosa');
INSERT INTO TipoEvento (Id, Nombre) VALUES (6, 'Insercion exitosa');
INSERT INTO TipoEvento (Id, Nombre) VALUES (7, 'Update no exitoso');
INSERT INTO TipoEvento (Id, Nombre) VALUES (8, 'Update exitoso');
INSERT INTO TipoEvento (Id, Nombre) VALUES (9, 'Intento de borrado');
INSERT INTO TipoEvento (Id, Nombre) VALUES (10, 'Borrado exitoso');
INSERT INTO TipoEvento (Id, Nombre) VALUES (11, 'Consulta con filtro de nombre');
INSERT INTO TipoEvento (Id, Nombre) VALUES (12, 'Consulta con filtro de cedula');
INSERT INTO TipoEvento (Id, Nombre) VALUES (13, 'Intento de insertar movimiento');
INSERT INTO TipoEvento (Id, Nombre) VALUES (14, 'Insertar movimiento exitoso');
SET IDENTITY_INSERT TipoEvento OFF;
GO

PRINT '--- 1.3 Cargando Tipos de Movimiento...';
SET IDENTITY_INSERT TipoMovimiento ON;
INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (1, 'Cumplir mes', 'Credito');
INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (2, 'Bono vacacional', 'Credito');
INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (3, 'Reversion Debito', 'Credito');
INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (4, 'Disfrute de vacaciones', 'Debito');
INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (5, 'Venta de vacaciones', 'Debito');
INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (6, 'Reversion de Credito', 'Debito');
SET IDENTITY_INSERT TipoMovimiento OFF;
GO

PRINT '--- 1.4 Cargando Usuarios...';
SET IDENTITY_INSERT Usuario ON;
INSERT INTO Usuario (Id, Username, Password) VALUES (1, 'UsuarioScripts', ')*2LnSr^lk');
INSERT INTO Usuario (Id, Username, Password) VALUES (2, 'David', '232rr^k');
INSERT INTO Usuario (Id, Username, Password) VALUES (3, 'Alejandro', 'test');
INSERT INTO Usuario (Id, Username, Password) VALUES (4, 'Esteban', 'contrasena');
INSERT INTO Usuario (Id, Username, Password) VALUES (5, 'Daniel', 'himB9Dzd%_');
INSERT INTO Usuario (Id, Username, Password) VALUES (6, 'Alex', '24himAzzd%_65');
INSERT INTO Usuario (Id, Username, Password) VALUES (7, 'Usuario No Valido', 'NoSoyValido');
SET IDENTITY_INSERT Usuario OFF;
GO

PRINT '--- 1.5 Cargando Catálogo de Errores...';
INSERT INTO Error (Codigo, Descripcion) VALUES ('50001', 'Username no existe');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50002', 'Password no existe');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50003', 'Login deshabilitado');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50004', 'Empleado con ValorDocumentoIdentidad ya existe en inserción');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50005', 'Empleado con mismo nombre ya existe en inserción');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50006', 'Empleado con ValorDocumentoIdentidad ya existe en actualizacion');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50007', 'Empleado con mismo nombre ya existe en actualización');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50008', 'Error de base de datos');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50009', 'Nombre de empleado no alfabético');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50010', 'Valor de documento de identidad no alfabético');
INSERT INTO Error (Codigo, Descripcion) VALUES ('50011', 'Monto del movimiento rechazado pues si se aplicar el saldo seria negativo.');
GO

PRINT '--- 2. Cargando Empleados usando SP...';
DECLARE @IdPuesto INT, @IdUsuarioScripts INT, @ResultCode INT;
SELECT @IdUsuarioScripts = Id FROM Usuario WHERE Username = 'UsuarioScripts';

-- Procesando empleado: Samantha Pratt
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Fontanero';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '56917772', @inNombre = 'Samantha Pratt', @inFechaContratacion = '2022-01-08', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Jeffrey Watson
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cajero';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '26992786', @inNombre = 'Jeffrey Watson', @inFechaContratacion = '2023-02-13', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Carrie Tran
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Asistente';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '36042906', @inNombre = 'Carrie Tran', @inFechaContratacion = '2021-10-16', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: William Jenkins
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Recepcionista';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '99364103', @inNombre = 'William Jenkins', @inFechaContratacion = '2024-04-29', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Nathan Lee
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Conductor';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '23357035', @inNombre = 'Nathan Lee', @inFechaContratacion = '2021-07-25', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Gerald Ponce
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Asistente';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '44223318', @inNombre = 'Gerald Ponce', @inFechaContratacion = '2022-10-27', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Matthew Martin
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Albañil';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '1463670', @inNombre = 'Matthew Martin', @inFechaContratacion = '2025-08-15', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Matthew Rodriguez
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Fontanero';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '25008030', @inNombre = 'Matthew Rodriguez', @inFechaContratacion = '2025-08-03', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Crystal Mills
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cuidador';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '25381150', @inNombre = 'Crystal Mills', @inFechaContratacion = '2021-05-13', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Shane Robinson
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Recepcionista';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '6402399', @inNombre = 'Shane Robinson', @inFechaContratacion = '2025-03-13', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Kevin Holmes
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Camarero';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '90886933', @inNombre = 'Kevin Holmes', @inFechaContratacion = '2017-12-17', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Elizabeth Lin
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Fontanero';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '6575299', @inNombre = 'Elizabeth Lin', @inFechaContratacion = '2015-11-30', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Hannah Peterson
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Asistente';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '21169228', @inNombre = 'Hannah Peterson', @inFechaContratacion = '2022-04-27', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Antonio Wallace
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Conserje';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '44454429', @inNombre = 'Antonio Wallace', @inFechaContratacion = '2022-05-10', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Patricia Richardson
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cuidador';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '25090046', @inNombre = 'Patricia Richardson', @inFechaContratacion = '2024-06-21', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Mr. Mark Nguyen
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Albañil';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '17308111', @inNombre = 'Mr. Mark Nguyen', @inFechaContratacion = '2022-11-29', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Randy Hale
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Conserje';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '74794219', @inNombre = 'Randy Hale', @inFechaContratacion = '2025-03-22', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Christopher Coffey
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cuidador';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '21086955', @inNombre = 'Christopher Coffey', @inFechaContratacion = '2019-09-05', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Dwayne Medina
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Recepcionista';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '28280052', @inNombre = 'Dwayne Medina', @inFechaContratacion = '2024-08-04', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

-- Procesando empleado: Aaron Crawford
SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Camarero';
EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '94377996', @inNombre = 'Aaron Crawford', @inFechaContratacion = '2018-11-24', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;

GO

PRINT '--- 3. Cargando Movimientos usando SP (esto actualizará los saldos)...';
DECLARE @IdUsuario INT, @ResultCodeMov INT;

-- Procesando movimiento para DocId 56917772 por usuario Alex
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '56917772', @inIdTipoMovimiento = 2, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '134.34.201.165', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 56917772 por usuario UsuarioScripts
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '56917772', @inIdTipoMovimiento = 4, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '14.127.138.177', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 56917772 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '56917772', @inIdTipoMovimiento = 2, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '167.95.180.65', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 26992786 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 6, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '97.121.125.85', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 26992786 por usuario Usuario No Valido
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Usuario No Valido';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 6, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '43.66.240.64', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 36042906 por usuario Alejandro
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '36042906', @inIdTipoMovimiento = 5, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '107.251.169.29', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 99364103 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '99364103', @inIdTipoMovimiento = 1, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '14.174.54.133', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 99364103 por usuario UsuarioScripts
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '99364103', @inIdTipoMovimiento = 1, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '93.120.225.198', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 99364103 por usuario Usuario No Valido
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Usuario No Valido';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '99364103', @inIdTipoMovimiento = 2, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '97.157.120.48', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 23357035 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 1, @inMonto = 4, @inUserId = @IdUsuario, @inIP = '78.237.104.161', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 23357035 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 5, @inMonto = 4, @inUserId = @IdUsuario, @inIP = '136.5.233.167', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 23357035 por usuario UsuarioScripts
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 5, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '8.242.126.94', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 44223318 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44223318', @inIdTipoMovimiento = 2, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '177.104.198.156', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 44223318 por usuario Alex
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44223318', @inIdTipoMovimiento = 2, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '161.184.151.136', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 1463670 por usuario Usuario No Valido
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Usuario No Valido';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '1463670', @inIdTipoMovimiento = 4, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '180.255.95.75', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 1463670 por usuario Alejandro
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '1463670', @inIdTipoMovimiento = 2, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '209.33.102.178', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 25008030 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25008030', @inIdTipoMovimiento = 6, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '187.204.69.37', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 25008030 por usuario Alex
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25008030', @inIdTipoMovimiento = 1, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '48.234.245.82', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 25381150 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25381150', @inIdTipoMovimiento = 2, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '191.95.123.55', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 25381150 por usuario Alex
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25381150', @inIdTipoMovimiento = 5, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '120.60.29.65', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 6402399 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 5, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '32.33.87.154', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 6402399 por usuario Alejandro
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 6, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '194.85.35.137', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 6402399 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 3, @inMonto = 4, @inUserId = @IdUsuario, @inIP = '76.7.98.161', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 90886933 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 4, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '43.163.48.231', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 90886933 por usuario UsuarioScripts
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 1, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '51.53.162.157', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 6575299 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 3, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '56.217.141.32', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 6575299 por usuario Alejandro
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 1, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '151.147.244.214', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 6575299 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 2, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '221.106.143.142', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 21169228 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 2, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '106.73.23.109', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 21169228 por usuario UsuarioScripts
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 1, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '53.77.32.73', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 44454429 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 5, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '102.153.127.242', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 44454429 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 1, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '200.32.72.100', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 25090046 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25090046', @inIdTipoMovimiento = 1, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '198.228.99.29', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 17308111 por usuario Esteban
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 2, @inMonto = 4, @inUserId = @IdUsuario, @inIP = '215.185.52.14', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 17308111 por usuario Alex
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 4, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '22.153.169.249', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 17308111 por usuario Alejandro
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 1, @inMonto = 3, @inUserId = @IdUsuario, @inIP = '150.248.28.40', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 74794219 por usuario UsuarioScripts
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '74794219', @inIdTipoMovimiento = 1, @inMonto = 5, @inUserId = @IdUsuario, @inIP = '192.228.93.183', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 74794219 por usuario Alejandro
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '74794219', @inIdTipoMovimiento = 1, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '210.239.208.137', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 21086955 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21086955', @inIdTipoMovimiento = 1, @inMonto = 4, @inUserId = @IdUsuario, @inIP = '14.143.235.8', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 28280052 por usuario Alex
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '28280052', @inIdTipoMovimiento = 5, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '73.179.216.77', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 94377996 por usuario David
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 5, @inMonto = 2, @inUserId = @IdUsuario, @inIP = '10.158.143.160', @outResultCode = @ResultCodeMov OUTPUT;

-- Procesando movimiento para DocId 94377996 por usuario Daniel
SELECT @IdUsuario = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 1, @inMonto = 1, @inUserId = @IdUsuario, @inIP = '33.146.139.18', @outResultCode = @ResultCodeMov OUTPUT;

GO

PRINT 'Script de carga generado y listo para ejecutar.'
