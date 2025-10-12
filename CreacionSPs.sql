USE Tarea2BD;  -- o ControlVacaciones
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE dbo.InsertEmpleado
    @inIdPuesto INT,
    @inValorDocumentoIdentidad NVARCHAR(20),
    @inNombre NVARCHAR(100),
    @inFechaContratacion DATE,
    @inUserId INT,         -- quien realiza la operaciÛn (Id en tabla Usuario)
    @inIP NVARCHAR(50),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0;

        -- Validaciones b·sicas
        IF NOT EXISTS (SELECT 1 FROM Puesto p WHERE p.Id = @inIdPuesto)
        BEGIN
            SET @outResultCode = 50008; -- Error de base de datos / puesto no existe
            RETURN;
        END

        -- Valor documento debe ser numÈrico (solo dÌgitos)
        IF @inValorDocumentoIdentidad IS NULL OR LTRIM(RTRIM(@inValorDocumentoIdentidad)) = ''
        BEGIN
            SET @outResultCode = 50010; -- Valor de documento no alfabÈtico (usado para validar)
            RETURN;
        END
        IF @inValorDocumentoIdentidad LIKE '%[^0-9]%'
        BEGIN
            SET @outResultCode = 50010; -- contiene no dÌgitos
            RETURN;
        END

        -- Nombre debe ser alfabÈtico (permitimos espacios)
        IF @inNombre IS NULL OR LTRIM(RTRIM(@inNombre)) = ''
        BEGIN
            SET @outResultCode = 50009; -- Nombre no alfabÈtico
            RETURN;
        END
        -- Si contiene caracteres que no son letras o espacios, rechazamos
        IF @inNombre LIKE '%[^A-Za-z —Ò¡…Õ”⁄·ÈÌÛ˙¸‹.-]%' -- un filtro razonable; profesor no usÛ regex, hacemos simple
        BEGIN
            SET @outResultCode = 50009;
            RETURN;
        END

        -- Unicidades: documento y nombre
        IF EXISTS (SELECT 1 FROM Empleado e WHERE e.ValorDocumentoIdentidad = @inValorDocumentoIdentidad)
        BEGIN
            SET @outResultCode = 50004; -- ValorDocumentoIdentidad ya existe en inserciÛn
            -- registramos en bitacora (inserciÛn no exitosa)
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (5, CONCAT('Insercion no exitosa: ValorDocumento=', @inValorDocumentoIdentidad, ', Nombre=', @inNombre), @inUserId, @inIP);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Empleado e WHERE e.Nombre = @inNombre)
        BEGIN
            SET @outResultCode = 50005; -- Nombre ya existe en inserciÛn
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (5, CONCAT('Insercion no exitosa: Nombre duplicado=', @inNombre, ', ValorDocumento=', @inValorDocumentoIdentidad), @inUserId, @inIP);
            RETURN;
        END

        DECLARE @LogDescription NVARCHAR(2000) = CONCAT('Insercion Empleado: {ValorDocumento="', @inValorDocumentoIdentidad,
                                                         '", Nombre="', @inNombre, '", IdPuesto="', @inIdPuesto, '"}');

        BEGIN TRANSACTION tInsertEmpleado;

            INSERT INTO Empleado (IdPuesto, ValorDocumentoIdentidad, Nombre, FechaContratacion, SaldoVacaciones, EsActivo)
            VALUES (@inIdPuesto, @inValorDocumentoIdentidad, @inNombre, @inFechaContratacion, 0, 1);

            -- Registro en bitacora: insercion exitosa (TipoEvento = 6)
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (6, @LogDescription, @inUserId, @inIP);

        COMMIT TRANSACTION tInsertEmpleado;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION tInsertEmpleado;

        INSERT INTO DBError (UserName, errorNumber, errorState, errorSeverity, errorLine, procedureName, errorMessage, errorDateTime)
        VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());

        SET @outResultCode = 50008; -- Error de base de datos
    END CATCH

    SET NOCOUNT OFF;
END;
GO
CREATE OR ALTER PROCEDURE dbo.UpdateEmpleado
    @inIdEmpleado INT,
    @inIdPuesto INT,
    @inValorDocumentoIdentidad NVARCHAR(20),
    @inNombre NVARCHAR(100),
    @inUserId INT,
    @inIP NVARCHAR(50),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0;

        IF NOT EXISTS (SELECT 1 FROM Empleado e WHERE e.Id = @inIdEmpleado)
        BEGIN
            SET @outResultCode = 50008; -- empleado no existe => uso genÈrico
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Puesto p WHERE p.Id = @inIdPuesto)
        BEGIN
            SET @outResultCode = 50008; -- puesto no existe
            RETURN;
        END

        -- Validaciones igual que en Insert
        IF @inValorDocumentoIdentidad IS NULL OR @inValorDocumentoIdentidad LIKE '%[^0-9]%'
        BEGIN
            SET @outResultCode = 50010;
            RETURN;
        END

        IF @inNombre IS NULL OR @inNombre LIKE '%[^A-Za-z —Ò¡…Õ”⁄·ÈÌÛ˙¸‹.-]%'
        BEGIN
            SET @outResultCode = 50009;
            RETURN;
        END

        -- Unicidad: que no exista otro empleado con mismo doc o mismo nombre (excluyendo el actual)
        IF EXISTS (SELECT 1 FROM Empleado e WHERE e.ValorDocumentoIdentidad = @inValorDocumentoIdentidad AND e.Id <> @inIdEmpleado)
        BEGIN
            SET @outResultCode = 50006; -- ValorDocumento ya existe en actualizaciÛn
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (7, CONCAT('Update no exitoso: ValorDocumento duplicado: ', @inValorDocumentoIdentidad), @inUserId, @inIP);
            RETURN;
        END

        IF EXISTS (SELECT 1 FROM Empleado e WHERE e.Nombre = @inNombre AND e.Id <> @inIdEmpleado)
        BEGIN
            SET @outResultCode = 50007; -- Nombre duplicado en actualizaciÛn
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (7, CONCAT('Update no exitoso: Nombre duplicado: ', @inNombre), @inUserId, @inIP);
            RETURN;
        END

        -- Guardamos estado anterior para bitacora
        DECLARE @oldValorDoc NVARCHAR(20), @oldNombre NVARCHAR(100), @oldIdPuesto INT, @oldSaldo DECIMAL(10,2);
        SELECT @oldValorDoc = ValorDocumentoIdentidad, @oldNombre = Nombre, @oldIdPuesto = IdPuesto, @oldSaldo = SaldoVacaciones
        FROM Empleado WHERE Id = @inIdEmpleado;

        DECLARE @LogDescription NVARCHAR(2000) = 
            CONCAT('Update Empleado Antes: {ValorDocumento="', @oldValorDoc, '", Nombre="', @oldNombre, '", IdPuesto="', @oldIdPuesto,
                   '"}, Despues: {ValorDocumento="', @inValorDocumentoIdentidad, '", Nombre="', @inNombre, '", IdPuesto="', @inIdPuesto, '"}, Saldo=', CONVERT(NVARCHAR(30), @oldSaldo));

        BEGIN TRANSACTION tUpdateEmpleado;
            UPDATE Empleado
            SET ValorDocumentoIdentidad = @inValorDocumentoIdentidad,
                Nombre = @inNombre,
                IdPuesto = @inIdPuesto
            WHERE Id = @inIdEmpleado;

            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (8, @LogDescription, @inUserId, @inIP);
        COMMIT TRANSACTION tUpdateEmpleado;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION tUpdateEmpleado;

        INSERT INTO DBError (UserName, errorNumber, errorState, errorSeverity, errorLine, procedureName, errorMessage, errorDateTime)
        VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());

        SET @outResultCode = 50008;
    END CATCH

    SET NOCOUNT OFF;
END;
GO
CREATE OR ALTER PROCEDURE dbo.DeleteEmpleado_Logico
    @inIdEmpleado INT,
    @inUserId INT,
    @inIP NVARCHAR(50),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0;

        IF NOT EXISTS (SELECT 1 FROM Empleado e WHERE e.Id = @inIdEmpleado)
        BEGIN
            SET @outResultCode = 50008;
            RETURN;
        END

        DECLARE @valDoc NVARCHAR(20), @name NVARCHAR(100), @puesto INT, @saldo DECIMAL(10,2);
        SELECT @valDoc = ValorDocumentoIdentidad, @name = Nombre, @puesto = IdPuesto, @saldo = SaldoVacaciones FROM Empleado WHERE Id = @inIdEmpleado;

        DECLARE @Desc NVARCHAR(1000) = CONCAT('Borrado Empleado ValorDocumento=', @valDoc, ', Nombre=', @name, ', Saldo=', CONVERT(NVARCHAR(30), @saldo));

        BEGIN TRANSACTION tDeleteEmpleado;
            UPDATE Empleado SET EsActivo = 0 WHERE Id = @inIdEmpleado;

            -- Registro en bitacora: borrado exitoso (TipoEvento = 10)
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (10, @Desc, @inUserId, @inIP);
        COMMIT TRANSACTION tDeleteEmpleado;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION tDeleteEmpleado;

        INSERT INTO DBError (UserName, errorNumber, errorState, errorSeverity, errorLine, procedureName, errorMessage, errorDateTime)
        VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());

        SET @outResultCode = 50008;
    END CATCH
END;
GO
CREATE OR ALTER PROCEDURE dbo.ListEmpleadoPorFiltro
    @inFilter NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @f NVARCHAR(200) = LTRIM(RTRIM(ISNULL(@inFilter, '')));

    IF @f = ''
    BEGIN
        SELECT e.Id, e.ValorDocumentoIdentidad, e.Nombre, p.Nombre AS Puesto, e.SaldoVacaciones, e.EsActivo
        FROM Empleado e
        LEFT JOIN Puesto p ON p.Id = e.IdPuesto
        WHERE e.EsActivo = 1
        ORDER BY e.Nombre;
        RETURN;
    END

    -- Si solo contiene dÌgitos: buscar por ValorDocumentoIdentidad
    IF @f NOT LIKE '%[^0-9]%'  -- es numÈrico
    BEGIN
        SELECT e.Id, e.ValorDocumentoIdentidad, e.Nombre, p.Nombre AS Puesto, e.SaldoVacaciones, e.EsActivo
        FROM Empleado e
        LEFT JOIN Puesto p ON p.Id = e.IdPuesto
        WHERE e.ValorDocumentoIdentidad LIKE '%' + @f + '%'
          AND e.EsActivo = 1
        ORDER BY e.Nombre;
        RETURN;
    END

    -- Si contiene solo letras y espacios (asumimos b˙squeda por nombre)
    IF @f NOT LIKE '%[^A-Za-z —Ò¡…Õ”⁄·ÈÌÛ˙¸‹.-]%'
    BEGIN
        SELECT e.Id, e.ValorDocumentoIdentidad, e.Nombre, p.Nombre AS Puesto, e.SaldoVacaciones, e.EsActivo
        FROM Empleado e
        LEFT JOIN Puesto p ON p.Id = e.IdPuesto
        WHERE e.Nombre LIKE '%' + @f + '%'
          AND e.EsActivo = 1
        ORDER BY e.Nombre;
        RETURN;
    END

    -- Caso general: buscar por nombre (fallback)
    SELECT e.Id, e.ValorDocumentoIdentidad, e.Nombre, p.Nombre AS Puesto, e.SaldoVacaciones, e.EsActivo
    FROM Empleado e
    LEFT JOIN Puesto p ON p.Id = e.IdPuesto
    WHERE (e.Nombre LIKE '%' + @f + '%' OR e.ValorDocumentoIdentidad LIKE '%' + @f + '%')
      AND e.EsActivo = 1
    ORDER BY e.Nombre;
END;
GO
CREATE OR ALTER PROCEDURE dbo.InsertMovimiento
    @inValorDocumentoIdentidad NVARCHAR(20),  -- identificador visible en UI
    @inIdTipoMovimiento INT,
    @inMonto DECIMAL(10,2),
    @inUserId INT,
    @inIP NVARCHAR(50),
    @outResultCode INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0;

        -- Validaciones: empleado existe
        DECLARE @IdEmpleado INT;
        SELECT @IdEmpleado = Id FROM Empleado WHERE ValorDocumentoIdentidad = @inValorDocumentoIdentidad AND EsActivo = 1;
        IF @IdEmpleado IS NULL
        BEGIN
            SET @outResultCode = 50008; -- empleado no existe / error genÈrico
            -- registrar intento
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (13, CONCAT('Intento insertar movimiento: empleado no existe ValorDocumento=', @inValorDocumentoIdentidad, ', Monto=', CONVERT(NVARCHAR(50), @inMonto)), @inUserId, @inIP);
            RETURN;
        END

        -- Validar tipo de movimiento
        DECLARE @tipoAccion NVARCHAR(20);
        SELECT @tipoAccion = TipoAccion FROM TipoMovimiento WHERE Id = @inIdTipoMovimiento;
        IF @tipoAccion IS NULL
        BEGIN
            SET @outResultCode = 50008; -- tipoMovimiento no existe
            RETURN;
        END

        DECLARE @saldoActual DECIMAL(10,2);
        SELECT @saldoActual = SaldoVacaciones FROM Empleado WHERE Id = @IdEmpleado;

        DECLARE @nuevoSaldo DECIMAL(10,2);

        IF UPPER(@tipoAccion) = 'CREDITO'
            SET @nuevoSaldo = ISNULL(@saldoActual,0) + @inMonto;
        ELSE
            SET @nuevoSaldo = ISNULL(@saldoActual,0) - @inMonto;

        -- ValidaciÛn saldo no negativo
        IF @nuevoSaldo < 0
        BEGIN
            SET @outResultCode = 50011; -- monto rechazado porque saldo resultaria negativo
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (13, CONCAT('Intento de insertar movimiento que deja saldo negativo. ValorDocumento=', @inValorDocumentoIdentidad, ', Monto=', CONVERT(NVARCHAR(30), @inMonto), ', SaldoActual=', CONVERT(NVARCHAR(30), @saldoActual)), @inUserId, @inIP);
            RETURN;
        END

        DECLARE @LogDesc NVARCHAR(2000) = CONCAT('InsertMovimiento: ValorDocumento=', @inValorDocumentoIdentidad, ', IdTipoMovimiento=', @inIdTipoMovimiento, ', Monto=', CONVERT(NVARCHAR(30), @inMonto), ', NuevoSaldo=', CONVERT(NVARCHAR(30), @nuevoSaldo));

        BEGIN TRANSACTION tInsertMovimiento;
            -- actualiza saldo
            UPDATE Empleado SET SaldoVacaciones = @nuevoSaldo WHERE Id = @IdEmpleado;

            -- inserta movimiento
            INSERT INTO Movimiento (IdEmpleado, IdTipoMovimiento, Fecha, Monto, NuevoSaldo, IdPostByUser, PostInIP, PostTime)
            VALUES (@IdEmpleado, @inIdTipoMovimiento, CAST(GETDATE() AS DATE), @inMonto, @nuevoSaldo, @inUserId, @inIP, GETDATE());

            -- insertar bitacora de evento: Insertar movimiento exitoso (tipo 14)
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (14, @LogDesc, @inUserId, @inIP);

        COMMIT TRANSACTION tInsertMovimiento;

        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION tInsertMovimiento;

        INSERT INTO DBError (UserName, errorNumber, errorState, errorSeverity, errorLine, procedureName, errorMessage, errorDateTime)
        VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());

        SET @outResultCode = 50008;
    END CATCH
END;
GO
CREATE OR ALTER PROCEDURE dbo.LoginUser
    @inUserName NVARCHAR(50),
    @inPassword NVARCHAR(100),
    @inIP NVARCHAR(50),
    @outResultCode INT OUTPUT,
    @outUserId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @outResultCode = 0;
        SET @outUserId = NULL;

        -- Si existe una entrada de 'Login deshabilitado' (TipoEvento = 3) para este username+IP en los ultimos 10 minutos,
        -- rechazamos el login (seg˙n requerimiento se deshabilita por 10 minutos si hay muchos intentos en 5 minutos).
        IF EXISTS (
            SELECT 1 FROM BitacoraEvento b
            JOIN Usuario u ON u.Id = b.IdPostByUser
            WHERE b.IdTipoEvento = 3
              AND b.PostInIP = @inIP
              AND u.Username = @inUserName
              AND b.PostTime >= DATEADD(MINUTE, -10, GETDATE())
        )
        BEGIN
            SET @outResultCode = 50003; -- Login deshabilitado
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (3, 'Login deshabilitado (solicitado por politicas).', NULL, @inIP);
            RETURN;
        END

        -- Existe usuario?
        DECLARE @uid INT, @pwd NVARCHAR(100);
        SELECT @uid = Id, @pwd = Password FROM Usuario WHERE Username = @inUserName;

        IF @uid IS NULL
        BEGIN
            SET @outResultCode = 50001; -- Username no existe
            -- Contar intentos no exitosos en los ultimos 5 minutos desde la misma IP para este username (si hay logs)
            DECLARE @attempts INT = (
                SELECT COUNT(1) FROM BitacoraEvento b
                LEFT JOIN Usuario u ON u.Id = b.IdPostByUser
                WHERE b.IdTipoEvento = 2
                  AND b.PostInIP = @inIP
                  AND u.Username = @inUserName
                  AND b.PostTime >= DATEADD(MINUTE, -5, GETDATE())
            );
            SET @attempts = ISNULL(@attempts, 0) + 1;
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (2, CONCAT('Login no exitoso. IntentoNo=', @attempts), NULL, @inIP);

            IF @attempts >= 5
            BEGIN
                -- registrar login deshabilitado
                INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
                VALUES (3, 'Login deshabilitado por exceso de intentos.', NULL, @inIP);
            END

            RETURN;
        END

        -- Password coincide?
        IF @pwd <> @inPassword
        BEGIN
            SET @outResultCode = 50002; -- Password no existe / invalida
            -- Contar intentos en 5 min
            DECLARE @attempts2 INT = (
                SELECT COUNT(1) FROM BitacoraEvento b
                WHERE b.IdTipoEvento = 2 AND b.PostInIP = @inIP AND b.PostTime >= DATEADD(MINUTE, -5, GETDATE())
                AND EXISTS (SELECT 1 FROM Usuario u WHERE u.Id = b.IdPostByUser AND u.Username = @inUserName)
            );
            SET @attempts2 = ISNULL(@attempts2, 0) + 1;
            INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
            VALUES (2, CONCAT('Login no exitoso. IntentoNo=', @attempts2), @uid, @inIP);

            IF @attempts2 >= 5
            BEGIN
                INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
                VALUES (3, 'Login deshabilitado por exceso de intentos.', @uid, @inIP);
            END

            RETURN;
        END

        -- Login exitoso
        INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
        VALUES (1, 'Login Exitoso', @uid, @inIP);

        SET @outUserId = @uid;
        SET @outResultCode = 0;
    END TRY
    BEGIN CATCH
        INSERT INTO DBError (UserName, errorNumber, errorState, errorSeverity, errorLine, procedureName, errorMessage, errorDateTime)
        VALUES (SUSER_SNAME(), ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE(), GETDATE());
        SET @outResultCode = 50008;
    END CATCH
END;
GO
