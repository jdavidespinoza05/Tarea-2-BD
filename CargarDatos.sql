PRINT 'Cargando Puestos...';
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Cajero') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Cajero', 11.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Camarero') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Camarero', 10.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Cuidador') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Cuidador', 13.50);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Conductor') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Conductor', 15.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Asistente') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Asistente', 11.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Recepcionista') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Recepcionista', 12.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Fontanero') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Fontanero', 13.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Niñera') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Niñera', 12.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Conserje') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Conserje', 11.00);
IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = 'Albañil') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('Albañil', 10.50);
GO

PRINT 'Cargando Tipos de Evento...';
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 1) INSERT INTO TipoEvento (Id, Nombre) VALUES (1, 'Login Exitoso');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 2) INSERT INTO TipoEvento (Id, Nombre) VALUES (2, 'Login No Exitoso');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 3) INSERT INTO TipoEvento (Id, Nombre) VALUES (3, 'Login deshabilitado');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 4) INSERT INTO TipoEvento (Id, Nombre) VALUES (4, 'Logout');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 5) INSERT INTO TipoEvento (Id, Nombre) VALUES (5, 'Insercion no exitosa');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 6) INSERT INTO TipoEvento (Id, Nombre) VALUES (6, 'Insercion exitosa');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 7) INSERT INTO TipoEvento (Id, Nombre) VALUES (7, 'Update no exitoso');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 8) INSERT INTO TipoEvento (Id, Nombre) VALUES (8, 'Update exitoso');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 9) INSERT INTO TipoEvento (Id, Nombre) VALUES (9, 'Intento de borrado');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 10) INSERT INTO TipoEvento (Id, Nombre) VALUES (10, 'Borrado exitoso');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 11) INSERT INTO TipoEvento (Id, Nombre) VALUES (11, 'Consulta con filtro de nombre');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 12) INSERT INTO TipoEvento (Id, Nombre) VALUES (12, 'Consulta con filtro de cedula');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 13) INSERT INTO TipoEvento (Id, Nombre) VALUES (13, 'Intento de insertar movimiento');
IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = 14) INSERT INTO TipoEvento (Id, Nombre) VALUES (14, 'Insertar movimiento exitoso');
GO

PRINT 'Cargando Tipos de Movimiento...';
IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = 1) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (1, 'Cumplir mes', 'Credito');
IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = 2) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (2, 'Bono vacacional', 'Credito');
IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = 3) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (3, 'Reversion Debito', 'Credito');
IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = 4) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (4, 'Disfrute de vacaciones', 'Debito');
IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = 5) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (5, 'Venta de vacaciones', 'Debito');
IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = 6) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES (6, 'Reversion de Credito', 'Debito');
GO

PRINT 'Cargando Usuarios...';
SET IDENTITY_INSERT Usuario ON;
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 1) INSERT INTO Usuario (Id, Username, Password) VALUES (1, 'UsuarioScripts', ')*2LnSr^lk');
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 2) INSERT INTO Usuario (Id, Username, Password) VALUES (2, 'David', '232rr^k');
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 3) INSERT INTO Usuario (Id, Username, Password) VALUES (3, 'Alejandro', 'test');
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 4) INSERT INTO Usuario (Id, Username, Password) VALUES (4, 'Esteban', 'contrasena');
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 5) INSERT INTO Usuario (Id, Username, Password) VALUES (5, 'Daniel', 'himB9Dzd%_');
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 6) INSERT INTO Usuario (Id, Username, Password) VALUES (6, 'Alex', '24himAzzd%_65');
IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = 7) INSERT INTO Usuario (Id, Username, Password) VALUES (7, 'Usuario No Valido', 'NoSoyValido');
SET IDENTITY_INSERT Usuario OFF;
GO

PRINT 'Cargando Catálogo de Errores...';
SET IDENTITY_INSERT Error ON;
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 1) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (1, '50001', 'Username no existe');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 2) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (2, '50002', 'Password no existe');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 3) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (3, '50003', 'Login deshabilitado');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 4) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (4, '50004', 'Empleado con ValorDocumentoIdentidad ya existe en inserción');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 5) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (5, '50005', 'Empleado con mismo nombre ya existe en inserción');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 6) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (6, '50006', 'Empleado con ValorDocumentoIdentidad ya existe en actualizacion');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 7) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (7, '50007', 'Empleado con mismo nombre ya existe en actualización');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 8) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (8, '50008', 'Error de base de datos');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 9) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (9, '50009', 'Nombre de empleado no alfabético');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 10) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (10, '50010', 'Valor de documento de identidad no numérico');
IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = 11) INSERT INTO Error (Id, Codigo, Descripcion) VALUES (11, '50011', 'Monto del movimiento rechazado pues si se aplicar el saldo seria negativo.');
SET IDENTITY_INSERT Error OFF;
GO

PRINT 'Cargando Empleados...';
DECLARE @IdPuesto INT, @IdUsuarioScripts INT, @ResultCode INT;
SELECT @IdUsuarioScripts = Id FROM Usuario WHERE Username = 'UsuarioScripts';

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '56917772') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Fontanero';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '56917772', @inNombre = 'Samantha Pratt', @inFechaContratacion = '2022-01-08', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '26992786') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cajero';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '26992786', @inNombre = 'Jeffrey Watson', @inFechaContratacion = '2023-02-13', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '36042906') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Asistente';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '36042906', @inNombre = 'Carrie Tran', @inFechaContratacion = '2021-10-16', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '99364103') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Recepcionista';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '99364103', @inNombre = 'William Jenkins', @inFechaContratacion = '2024-04-29', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '23357035') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Conductor';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '23357035', @inNombre = 'Nathan Lee', @inFechaContratacion = '2021-07-25', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '44223318') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Asistente';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '44223318', @inNombre = 'Gerald Ponce', @inFechaContratacion = '2022-10-27', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '1463670') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Albañil';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '1463670', @inNombre = 'Matthew Martin', @inFechaContratacion = '2025-08-15', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '25008030') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Fontanero';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '25008030', @inNombre = 'Matthew Rodriguez', @inFechaContratacion = '2025-04-16', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '25381150') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cuidador';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '25381150', @inNombre = 'Crystal Mills', @inFechaContratacion = '2021-05-13', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '6402399') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Recepcionista';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '6402399', @inNombre = 'Shane Robinson', @inFechaContratacion = '2025-03-13', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '90886933') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Camarero';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '90886933', @inNombre = 'Kevin Holmes', @inFechaContratacion = '2017-12-17', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '6575299') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Fontanero';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '6575299', @inNombre = 'Elizabeth Lin', @inFechaContratacion = '2015-11-30', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '21169228') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Asistente';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '21169228', @inNombre = 'Hannah Peterson', @inFechaContratacion = '2022-04-27', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '44454429') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Conserje';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '44454429', @inNombre = 'Antonio Wallace', @inFechaContratacion = '2022-05-10', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '25090046') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cuidador';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '25090046', @inNombre = 'Patricia Richardson', @inFechaContratacion = '2024-06-21', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '17308111') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Albañil';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '17308111', @inNombre = 'Mr. Mark Nguyen', @inFechaContratacion = '2022-11-29', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '74794219') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Conserje';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '74794219', @inNombre = 'Randy Hale', @inFechaContratacion = '2025-03-22', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '21086955') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Cuidador';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '21086955', @inNombre = 'Christopher Coffey', @inFechaContratacion = '2019-09-05', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '28280052') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Recepcionista';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '28280052', @inNombre = 'Dwayne Medina', @inFechaContratacion = '2024-08-04', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '94377996') BEGIN;
    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = 'Camarero';
    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '94377996', @inNombre = 'Aaron Crawford', @inFechaContratacion = '2018-11-24', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;
END;

GO

PRINT 'Cargando Movimientos...';
DECLARE @IdUsuarioMov INT, @ResultCodeMov INT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-01-10', @inPostTime = '2025-01-10 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '43.66.240.64', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 6, @inMonto = 3, @inFecha = '2025-01-11', @inPostTime = '2025-01-11 07:33:38', @inUserId = @IdUsuarioMov, @inIP = '43.66.240.64', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25381150', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-01-19', @inPostTime = '2025-01-19 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '120.60.29.65', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25381150', @inIdTipoMovimiento = 5, @inMonto = 5, @inFecha = '2025-01-20', @inPostTime = '2025-01-20 18:18:08', @inUserId = @IdUsuarioMov, @inIP = '120.60.29.65', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '56917772', @inIdTipoMovimiento = 2, @inMonto = 5, @inFecha = '2025-01-26', @inPostTime = '2025-01-26 00:00:42', @inUserId = @IdUsuarioMov, @inIP = '167.95.180.65', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-01-30', @inPostTime = '2025-01-30 10:54:24', @inUserId = @IdUsuarioMov, @inIP = '151.147.244.214', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-02-04', @inPostTime = '2025-02-04 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '25.162.194.113', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 5, @inMonto = 1, @inFecha = '2025-02-05', @inPostTime = '2025-02-05 05:09:49', @inUserId = @IdUsuarioMov, @inIP = '25.162.194.113', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21086955', @inIdTipoMovimiento = 1, @inMonto = 4, @inFecha = '2025-02-06', @inPostTime = '2025-02-06 14:31:30', @inUserId = @IdUsuarioMov, @inIP = '14.143.235.8', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-02-07', @inPostTime = '2025-02-07 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '22.153.169.249', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 4, @inMonto = 3, @inFecha = '2025-02-08', @inPostTime = '2025-02-08 11:42:01', @inUserId = @IdUsuarioMov, @inIP = '22.153.169.249', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-02-10', @inPostTime = '2025-02-10 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '53.77.99.217', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 4, @inMonto = 5, @inFecha = '2025-02-11', @inPostTime = '2025-02-11 08:36:40', @inUserId = @IdUsuarioMov, @inIP = '53.77.99.217', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-02-14', @inPostTime = '2025-02-14 01:54:55', @inUserId = @IdUsuarioMov, @inIP = '200.32.72.100', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-02-15', @inPostTime = '2025-02-15 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '71.18.82.231', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 5, @inMonto = 5, @inFecha = '2025-02-16', @inPostTime = '2025-02-16 02:47:06', @inUserId = @IdUsuarioMov, @inIP = '71.18.82.231', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21086955', @inIdTipoMovimiento = 4, @inMonto = 1, @inFecha = '2025-02-19', @inPostTime = '2025-02-19 19:15:41', @inUserId = @IdUsuarioMov, @inIP = '44.31.235.134', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-02-27', @inPostTime = '2025-02-27 17:13:28', @inUserId = @IdUsuarioMov, @inIP = '248.85.164.92', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 1, @inMonto = 11, @inFecha = '2025-02-28', @inPostTime = '2025-02-28 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '190.114.70.192', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 5, @inMonto = 3, @inFecha = '2025-03-01', @inPostTime = '2025-03-01 22:06:42', @inUserId = @IdUsuarioMov, @inIP = '190.114.70.192', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-03-09', @inPostTime = '2025-03-09 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '212.122.53.118', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21086955', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-03-09', @inPostTime = '2025-03-09 23:40:43', @inUserId = @IdUsuarioMov, @inIP = '98.11.83.4', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 4, @inMonto = 3, @inFecha = '2025-03-10', @inPostTime = '2025-03-10 03:22:23', @inUserId = @IdUsuarioMov, @inIP = '212.122.53.118', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-03-15', @inPostTime = '2025-03-15 13:12:00', @inUserId = @IdUsuarioMov, @inIP = '106.73.23.109', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-03-26', @inPostTime = '2025-03-26 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '32.33.87.154', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 5, @inMonto = 5, @inFecha = '2025-03-27', @inPostTime = '2025-03-27 13:02:23', @inUserId = @IdUsuarioMov, @inIP = '32.33.87.154', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44223318', @inIdTipoMovimiento = 2, @inMonto = 3, @inFecha = '2025-04-11', @inPostTime = '2025-04-11 07:13:10', @inUserId = @IdUsuarioMov, @inIP = '177.104.198.156', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-04-11', @inPostTime = '2025-04-11 10:30:28', @inUserId = @IdUsuarioMov, @inIP = '150.248.28.40', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '56917772', @inIdTipoMovimiento = 4, @inMonto = 3, @inFecha = '2025-04-13', @inPostTime = '2025-04-13 10:20:01', @inUserId = @IdUsuarioMov, @inIP = '14.127.138.177', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25008030', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-04-16', @inPostTime = '2025-04-16 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '187.204.69.37', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-04-16', @inPostTime = '2025-04-16 00:43:40', @inUserId = @IdUsuarioMov, @inIP = '51.53.162.157', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25008030', @inIdTipoMovimiento = 6, @inMonto = 5, @inFecha = '2025-04-17', @inPostTime = '2025-04-17 05:11:36', @inUserId = @IdUsuarioMov, @inIP = '187.204.69.37', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 5, @inMonto = 3, @inFecha = '2025-04-24', @inPostTime = '2025-04-24 04:54:07', @inUserId = @IdUsuarioMov, @inIP = '56.137.191.192', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21086955', @inIdTipoMovimiento = 4, @inMonto = 1, @inFecha = '2025-04-25', @inPostTime = '2025-04-25 22:03:21', @inUserId = @IdUsuarioMov, @inIP = '247.132.37.150', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-04-29', @inPostTime = '2025-04-29 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '233.126.189.4', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 2, @inMonto = 3, @inFecha = '2025-04-29', @inPostTime = '2025-04-29 19:20:18', @inUserId = @IdUsuarioMov, @inIP = '3.72.224.225', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 4, @inMonto = 5, @inFecha = '2025-04-30', @inPostTime = '2025-04-30 08:14:11', @inUserId = @IdUsuarioMov, @inIP = '233.126.189.4', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25381150', @inIdTipoMovimiento = 2, @inMonto = 2, @inFecha = '2025-05-02', @inPostTime = '2025-05-02 20:39:36', @inUserId = @IdUsuarioMov, @inIP = '191.95.123.55', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 2, @inMonto = 4, @inFecha = '2025-05-05', @inPostTime = '2025-05-05 18:48:50', @inUserId = @IdUsuarioMov, @inIP = '215.185.52.14', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 2, @inMonto = 5, @inFecha = '2025-05-05', @inPostTime = '2025-05-05 21:51:00', @inUserId = @IdUsuarioMov, @inIP = '91.69.28.29', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '99364103', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-05-07', @inPostTime = '2025-05-07 05:24:20', @inUserId = @IdUsuarioMov, @inIP = '93.120.225.198', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-05-08', @inPostTime = '2025-05-08 08:47:26', @inUserId = @IdUsuarioMov, @inIP = '159.122.81.68', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 5, @inMonto = 4, @inFecha = '2025-05-09', @inPostTime = '2025-05-09 20:31:20', @inUserId = @IdUsuarioMov, @inIP = '136.5.233.167', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44223318', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-05-22', @inPostTime = '2025-05-22 16:44:00', @inUserId = @IdUsuarioMov, @inIP = '161.184.151.136', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '36042906', @inIdTipoMovimiento = 1, @inMonto = 2, @inFecha = '2025-06-02', @inPostTime = '2025-06-02 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '107.251.169.29', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25090046', @inIdTipoMovimiento = 3, @inMonto = 3, @inFecha = '2025-06-03', @inPostTime = '2025-06-03 02:02:50', @inUserId = @IdUsuarioMov, @inIP = '96.202.21.227', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 6, @inMonto = 2, @inFecha = '2025-06-03', @inPostTime = '2025-06-03 09:16:54', @inUserId = @IdUsuarioMov, @inIP = '73.14.29.206', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '36042906', @inIdTipoMovimiento = 5, @inMonto = 2, @inFecha = '2025-06-03', @inPostTime = '2025-06-03 15:13:47', @inUserId = @IdUsuarioMov, @inIP = '107.251.169.29', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25008030', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-06-06', @inPostTime = '2025-06-06 22:26:20', @inUserId = @IdUsuarioMov, @inIP = '48.234.245.82', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-06-10', @inPostTime = '2025-06-10 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '97.121.125.85', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '99364103', @inIdTipoMovimiento = 1, @inMonto = 2, @inFecha = '2025-06-10', @inPostTime = '2025-06-10 01:10:19', @inUserId = @IdUsuarioMov, @inIP = '14.174.54.133', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 6, @inMonto = 5, @inFecha = '2025-06-11', @inPostTime = '2025-06-11 13:06:56', @inUserId = @IdUsuarioMov, @inIP = '97.121.125.85', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-06-13', @inPostTime = '2025-06-13 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '102.153.127.242', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 5, @inMonto = 3, @inFecha = '2025-06-14', @inPostTime = '2025-06-14 06:16:36', @inUserId = @IdUsuarioMov, @inIP = '102.153.127.242', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25090046', @inIdTipoMovimiento = 6, @inMonto = 2, @inFecha = '2025-06-17', @inPostTime = '2025-06-17 22:47:16', @inUserId = @IdUsuarioMov, @inIP = '251.179.41.35', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 6, @inMonto = 2, @inFecha = '2025-06-19', @inPostTime = '2025-06-19 23:24:21', @inUserId = @IdUsuarioMov, @inIP = '223.203.62.207', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-06-27', @inPostTime = '2025-06-27 00:41:12', @inUserId = @IdUsuarioMov, @inIP = '33.146.139.18', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '28280052', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-07-05', @inPostTime = '2025-07-05 07:03:36', @inUserId = @IdUsuarioMov, @inIP = '155.188.74.28', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25008030', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-07-21', @inPostTime = '2025-07-21 01:19:48', @inUserId = @IdUsuarioMov, @inIP = '94.183.32.100', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '28280052', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-07-22', @inPostTime = '2025-07-22 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '73.179.216.77', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '28280052', @inIdTipoMovimiento = 5, @inMonto = 2, @inFecha = '2025-07-23', @inPostTime = '2025-07-23 05:24:37', @inUserId = @IdUsuarioMov, @inIP = '73.179.216.77', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 5, @inMonto = 4, @inFecha = '2025-07-25', @inPostTime = '2025-07-25 04:47:46', @inUserId = @IdUsuarioMov, @inIP = '93.113.85.164', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 5, @inMonto = 2, @inFecha = '2025-07-29', @inPostTime = '2025-07-29 21:44:07', @inUserId = @IdUsuarioMov, @inIP = '8.242.126.94', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 6, @inMonto = 1, @inFecha = '2025-08-06', @inPostTime = '2025-08-06 23:15:16', @inUserId = @IdUsuarioMov, @inIP = '172.194.127.98', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-08-10', @inPostTime = '2025-08-10 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '195.245.39.101', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 5, @inMonto = 3, @inFecha = '2025-08-11', @inPostTime = '2025-08-11 01:34:27', @inUserId = @IdUsuarioMov, @inIP = '195.245.39.101', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-08-12', @inPostTime = '2025-08-12 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '95.249.98.184', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 4, @inMonto = 2, @inFecha = '2025-08-13', @inPostTime = '2025-08-13 18:02:39', @inUserId = @IdUsuarioMov, @inIP = '95.249.98.184', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '94377996', @inIdTipoMovimiento = 5, @inMonto = 2, @inFecha = '2025-08-17', @inPostTime = '2025-08-17 17:36:59', @inUserId = @IdUsuarioMov, @inIP = '10.158.143.160', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-08-24', @inPostTime = '2025-08-24 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '188.225.97.77', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '44454429', @inIdTipoMovimiento = 6, @inMonto = 1, @inFecha = '2025-08-25', @inPostTime = '2025-08-25 08:21:10', @inUserId = @IdUsuarioMov, @inIP = '188.225.97.77', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '1463670', @inIdTipoMovimiento = 4, @inMonto = 1, @inFecha = '2025-09-02', @inPostTime = '2025-09-02 03:16:32', @inUserId = @IdUsuarioMov, @inIP = '180.255.95.75', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-09-19', @inPostTime = '2025-09-19 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '194.85.35.137', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alejandro';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6402399', @inIdTipoMovimiento = 6, @inMonto = 1, @inFecha = '2025-09-20', @inPostTime = '2025-09-20 02:09:23', @inUserId = @IdUsuarioMov, @inIP = '194.85.35.137', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 3, @inMonto = 3, @inFecha = '2025-10-09', @inPostTime = '2025-10-09 12:31:11', @inUserId = @IdUsuarioMov, @inIP = '56.217.141.32', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '99364103', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-10-16', @inPostTime = '2025-10-16 02:24:51', @inUserId = @IdUsuarioMov, @inIP = '97.157.120.48', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '23357035', @inIdTipoMovimiento = 1, @inMonto = 4, @inFecha = '2025-10-18', @inPostTime = '2025-10-18 21:32:48', @inUserId = @IdUsuarioMov, @inIP = '78.237.104.161', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '36042906', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-10-23', @inPostTime = '2025-10-23 11:22:07', @inUserId = @IdUsuarioMov, @inIP = '232.99.58.132', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '6575299', @inIdTipoMovimiento = 2, @inMonto = 1, @inFecha = '2025-11-01', @inPostTime = '2025-11-01 01:26:12', @inUserId = @IdUsuarioMov, @inIP = '221.106.143.142', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25090046', @inIdTipoMovimiento = 1, @inMonto = 5, @inFecha = '2025-11-04', @inPostTime = '2025-11-04 21:26:33', @inUserId = @IdUsuarioMov, @inIP = '198.228.99.29', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '25090046', @inIdTipoMovimiento = 1, @inMonto = 2, @inFecha = '2025-11-09', @inPostTime = '2025-11-09 20:39:14', @inUserId = @IdUsuarioMov, @inIP = '171.46.75.52', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'UsuarioScripts';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '21169228', @inIdTipoMovimiento = 1, @inMonto = 2, @inFecha = '2025-11-14', @inPostTime = '2025-11-14 12:20:55', @inUserId = @IdUsuarioMov, @inIP = '53.77.32.73', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Alex';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '56917772', @inIdTipoMovimiento = 2, @inMonto = 2, @inFecha = '2025-11-21', @inPostTime = '2025-11-21 18:32:10', @inUserId = @IdUsuarioMov, @inIP = '134.34.201.165', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 1, @inMonto = 3, @inFecha = '2025-11-26', @inPostTime = '2025-11-26 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '112.174.87.212', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 4, @inMonto = 3, @inFecha = '2025-11-27', @inPostTime = '2025-11-27 17:03:51', @inUserId = @IdUsuarioMov, @inIP = '112.174.87.212', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Daniel';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '26992786', @inIdTipoMovimiento = 1, @inMonto = 4, @inFecha = '2025-11-28', @inPostTime = '2025-11-28 02:27:27', @inUserId = @IdUsuarioMov, @inIP = '28.125.172.87', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 1, @inMonto = 1, @inFecha = '2025-12-01', @inPostTime = '2025-12-01 00:00:00', @inUserId = @IdUsuarioMov, @inIP = '43.163.48.231', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'David';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '90886933', @inIdTipoMovimiento = 4, @inMonto = 1, @inFecha = '2025-12-02', @inPostTime = '2025-12-02 15:03:16', @inUserId = @IdUsuarioMov, @inIP = '43.163.48.231', @outResultCode = @ResultCodeMov OUTPUT;

SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = 'Esteban';
EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '17308111', @inIdTipoMovimiento = 3, @inMonto = 5, @inFecha = '2025-12-27', @inPostTime = '2025-12-27 21:01:05', @inUserId = @IdUsuarioMov, @inIP = '113.8.183.44', @outResultCode = @ResultCodeMov OUTPUT;

GO

PRINT 'Script de carga generado correctamente.'
