# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import os

print("El script se está generando...")

archivo_xml_entrada = 'archivoDatos.xml'
archivo_sql_salida = 'CargarDatos.sql'

if not os.path.exists(archivo_xml_entrada):
    print(f"ERROR: No se encontró el archivo '{archivo_xml_entrada}'.")
    exit()

tree = ET.parse(archivo_xml_entrada)
root = tree.getroot()

with open(archivo_sql_salida, 'w', encoding='utf-8') as f:
    #CARGA DE CATÁLOGOS
    f.write("PRINT 'Cargando Puestos...';\n")
    puestos = root.find('Puestos')
    for puesto in puestos.findall('Puesto'):
        nombre = puesto.get('Nombre').replace("'", "''")
        salario = puesto.get('SalarioxHora')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = '{nombre}') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('{nombre}', {salario});\n")
    f.write("GO\n\n")

    f.write("PRINT 'Cargando Tipos de Evento...';\n")
    tipos_evento = root.find('TiposEvento')
    for tipo in tipos_evento.findall('TipoEvento'):
        evento_id = tipo.get('Id')
        nombre = tipo.get('Nombre').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = {evento_id}) INSERT INTO TipoEvento (Id, Nombre) VALUES ({evento_id}, '{nombre}');\n")
    f.write("GO\n\n")

    f.write("PRINT 'Cargando Tipos de Movimiento...';\n")
    tipos_movimiento = root.find('TiposMovimientos')
    for tipo in tipos_movimiento.findall('TipoMovimiento'):
        mov_id = tipo.get('Id')
        nombre = tipo.get('Nombre').replace("'", "''")
        tipo_accion = tipo.get('TipoAccion')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = {mov_id}) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES ({mov_id}, '{nombre}', '{tipo_accion}');\n")
    f.write("GO\n\n")
    
    f.write("PRINT 'Cargando Usuarios...';\n")
    usuarios = root.find('Usuarios')
    f.write("SET IDENTITY_INSERT Usuario ON;\n")
    for usuario in usuarios.findall('usuario'):
        user_id = usuario.get('Id')
        nombre = usuario.get('Nombre').replace("'", "''")
        password = usuario.get('Pass').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = {user_id}) INSERT INTO Usuario (Id, Username, Password) VALUES ({user_id}, '{nombre}', '{password}');\n")
    f.write("SET IDENTITY_INSERT Usuario OFF;\n")
    f.write("GO\n\n")
    
    f.write("PRINT 'Cargando Catálogo de Errores...';\n")
    errores = root.find('Error')
    f.write("SET IDENTITY_INSERT Error ON;\n")
    for error in errores.findall('errorCodigo'):
        error_id = error.get('Id')
        codigo = error.get('Codigo')
        descripcion = error.get('Descripcion').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = {error_id}) INSERT INTO Error (Id, Codigo, Descripcion) VALUES ({error_id}, '{codigo}', '{descripcion}');\n")
    f.write("SET IDENTITY_INSERT Error OFF;\n")
    f.write("GO\n\n")

    # CARGA DE EMPLEADOS
    f.write("PRINT 'Cargando Empleados...';\n")
    f.write("DECLARE @IdPuesto INT, @IdUsuarioScripts INT, @ResultCode INT;\n")
    f.write("SELECT @IdUsuarioScripts = Id FROM Usuario WHERE Username = 'UsuarioScripts';\n\n")
    empleados = root.find('Empleados')
    for empleado in empleados.findall('empleado'):
        puesto_nombre = empleado.get('Puesto').replace("'", "''")
        doc_id = empleado.get('ValorDocumentoIdentidad')
        nombre = empleado.get('Nombre').replace("'", "''")
        fecha = empleado.get('FechaContratacion')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '{doc_id}') BEGIN;\n")
        f.write(f"    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = '{puesto_nombre}';\n")
        f.write(f"    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '{doc_id}', @inNombre = '{nombre}', @inFechaContratacion = '{fecha}', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;\n")
        f.write("END;\n\n")
    f.write("GO\n\n")

    # CARGA DE MOVIMIENTOS
    f.write("PRINT 'Cargando Movimientos...';\n")
    f.write("DECLARE @IdUsuarioMov INT, @ResultCodeMov INT;\n\n")
    movimientos = root.find('Movimientos')
    for mov in movimientos.findall('movimiento'):
        doc_id = mov.get('ValorDocId')
        tipo_mov_id = mov.get('IdTipoMovimiento')
        fecha = mov.get('Fecha')
        post_time = mov.get('PostTime')
        monto = mov.get('Monto')
        user_name = mov.get('PostByUser').replace("'", "''")
        ip = mov.get('PostInIP')
        
        f.write(f"SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = '{user_name}';\n")
        f.write(f"EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '{doc_id}', @inIdTipoMovimiento = {tipo_mov_id}, @inMonto = {monto}, @inFecha = '{fecha}', @inPostTime = '{post_time}', @inUserId = @IdUsuarioMov, @inIP = '{ip}', @outResultCode = @ResultCodeMov OUTPUT;\n\n")
    f.write("GO\n\n")
    
    f.write("PRINT 'Script de carga generado correctamente.'\n")

print(f"Listo, se ha creó correctamente el archivo '{archivo_sql_salida}'.")