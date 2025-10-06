GO
USE Tarea2BD;
GO

CREATE TABLE Puesto (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    SalarioxHora MONEY NOT NULL
);

CREATE TABLE Empleado (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdPuesto INT NOT NULL FOREIGN KEY REFERENCES Puesto(Id),
    ValorDocumentoIdentidad NVARCHAR(20) NOT NULL UNIQUE,
    Nombre NVARCHAR(100) NOT NULL,
    FechaContratacion DATE NOT NULL,
    SaldoVacaciones DECIMAL(10,2) DEFAULT 0,
    EsActivo BIT DEFAULT 1
);

CREATE TABLE TipoMovimiento (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    TipoAccion NVARCHAR(20) NOT NULL
);

CREATE TABLE Movimiento (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NOT NULL FOREIGN KEY REFERENCES Empleado(Id),
    IdTipoMovimiento INT NOT NULL FOREIGN KEY REFERENCES TipoMovimiento(Id),
    Fecha DATE NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    NuevoSaldo DECIMAL(10,2) NOT NULL,
    IdPostByUser INT NOT NULL,
    PostInIP NVARCHAR(50),
    PostTime DATETIME DEFAULT GETDATE()
);

CREATE TABLE Usuario (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(100) NOT NULL
);

CREATE TABLE TipoEvento (
    Id INT PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL
);

CREATE TABLE BitacoraEvento (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdTipoEvento INT NOT NULL FOREIGN KEY REFERENCES TipoEvento(Id),
    Descripcion NVARCHAR(MAX),
    IdPostByUser INT,
    PostInIP NVARCHAR(50),
    PostTime DATETIME DEFAULT GETDATE()
);

CREATE TABLE DBError (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserName NVARCHAR(50),
    ErrorNumber INT,
    ErrorState INT,
    ErrorSeverity INT,
    ErrorLine INT,
    ProcedureName NVARCHAR(100),
    ErrorMessage NVARCHAR(MAX),
    ErrorDateTime DATETIME DEFAULT GETDATE()
);

CREATE TABLE Error (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Codigo INT NOT NULL UNIQUE,
    Descripcion NVARCHAR(200) NOT NULL
);
GO
