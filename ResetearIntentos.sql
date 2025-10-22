USE [Tarea2BD];
GO

-- Elimina intentos fallidos (IdTipoEvento = 2) y bloqueos (IdTipoEvento = 3)
DELETE FROM BitacoraEvento
WHERE IdTipoEvento IN (2, 3);

INSERT INTO BitacoraEvento (IdTipoEvento, Descripcion, IdPostByUser, PostInIP)
VALUES (4, 'Reinicio global de intentos fallidos y bloqueos realizado manualmente por administrador.', NULL, NULL);
