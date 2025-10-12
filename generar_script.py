# -*- coding: utf-8 -*-
# Importamos la librería necesaria para leer archivos XML.
import xml.etree.ElementTree as ET
import os

print("Iniciando la generación del script SQL...")

# --- CONFIGURACIÓN ---
# Nombre del archivo XML de entrada que debe estar en la misma carpeta.
archivo_xml_entrada = 'archivoDatos.xml'
# Nombre del archivo SQL que vamos a generar.
archivo_sql_salida = 'CargarDatos.sql'

# Verificamos si el archivo XML existe antes de continuar.
if not os.path.exists(archivo_xml_entrada):
    print(f"ERROR: No se encontró el archivo '{archivo_xml_entrada}'. Asegúrate de que esté en la misma carpeta que este script.")
    exit()

# --- INICIO DEL PROCESO ---
# Parseamos (leemos y entendemos) el archivo XML.
tree = ET.parse(archivo_xml_entrada)
root = tree.getroot()

# Abrimos el archivo de salida en modo escritura ('w').
# 'utf-8' es importante para manejar caracteres como 'ñ' o tildes.
with open(archivo_sql_salida, 'w', encoding='utf-8') as f:

    # Escribimos una cabecera en el archivo SQL para saber que fue autogenerado.
    f.write("-- =================================================================\n")
    f.write("-- Script de carga de datos para Tarea 2\n")
    f.write(f"-- Generado a partir de: {archivo_xml_entrada}\n")
    f.write("-- =================================================================\n\n")

    # --- SECCIÓN 1: CARGA DE CATÁLOGOS CON INSERT DIRECTO ---
    
    # 1.1 Puestos
    f.write("PRINT '--- 1.1 Cargando Puestos...';\n")
    puestos = root.find('Puestos')
    for puesto in puestos.findall('Puesto'):
        nombre = puesto.get('Nombre').replace("'", "''")
        salario = puesto.get('SalarioxHora')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = '{nombre}')\n")
        f.write(f"    INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('{nombre}', {salario});\n")
    f.write("GO\n\n")

    # 1.2 Tipos de Evento
    f.write("PRINT '--- 1.2 Cargando Tipos de Evento...';\n")
    tipos_evento = root.find('TiposEvento')
    # quitar las líneas SET IDENTITY_INSERT TipoEvento ON/OFF
    for tipo in tipos_evento.findall('TipoEvento'):
        evento_id = tipo.get('Id')
        nombre = tipo.get('Nombre').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = {evento_id})\n")
        f.write(f"    INSERT INTO TipoEvento (Id, Nombre) VALUES ({evento_id}, '{nombre}');\n")
    f.write("GO\n\n")

    # 1.3 Tipos de Movimiento
    f.write("PRINT '--- 1.3 Cargando Tipos de Movimiento...';\n")
    tipos_movimiento = root.find('TiposMovimientos')
    for tipo in tipos_movimiento.findall('TipoMovimiento'):
        mov_id = tipo.get('Id')
        nombre = tipo.get('Nombre').replace("'", "''")
        tipo_accion = tipo.get('TipoAccion')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = {mov_id})\n")
        f.write(f"    INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES ({mov_id}, '{nombre}', '{tipo_accion}');\n")
    f.write("GO\n\n")
    
    # 1.4 Usuarios
    f.write("PRINT '--- 1.4 Cargando Usuarios...';\n")
    usuarios = root.find('Usuarios')
    # sustituir bloque actual por:
    for usuario in usuarios.findall('usuario'):
        nombre = usuario.get('Nombre').replace("'", "''")
        password = usuario.get('Pass').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Username = '{nombre}')\n")
        f.write(f"    INSERT INTO Usuario (Username, Password) VALUES ('{nombre}', '{password}');\n")

    f.write("GO\n\n")
    
    # 1.5 Errores
    f.write("PRINT '--- 1.5 Cargando Catálogo de Errores...';\n")
    # Asumimos que la tabla se llama 'Error' y la PK es autoincremental
    errores = root.find('Error')
    for error in errores.findall('errorCodigo'):
        codigo = error.get('Codigo')
        descripcion = error.get('Descripcion').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Error WHERE Codigo = {codigo})\n")
        f.write(f"    INSERT INTO Error (Codigo, Descripcion) VALUES ({codigo}, '{descripcion}');\n")


    # --- SECCIÓN 2: CARGA DE EMPLEADOS USANDO EL PROCEDIMIENTO ALMACENADO ---
    f.write("PRINT '--- 2. Cargando Empleados usando SP...';\n")
    f.write("DECLARE @IdPuesto INT, @IdUsuarioScripts INT, @ResultCode INT;\n")
    f.write("SELECT @IdUsuarioScripts = Id FROM Usuario WHERE Username = 'UsuarioScripts';\n\n")
    
    empleados = root.find('Empleados')
    for empleado in empleados.findall('empleado'):
        puesto_nombre = empleado.get('Puesto').replace("'", "''")
        doc_id = empleado.get('ValorDocumentoIdentidad')
        nombre = empleado.get('Nombre').replace("'", "''")
        fecha = empleado.get('FechaContratacion')
        
        f.write(f"-- Procesando empleado: {nombre}\n")
        f.write(f"SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = '{puesto_nombre}';\n")
        f.write(f"EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '{doc_id}', @inNombre = '{nombre}', @inFechaContratacion = '{fecha}', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;\n\n")
    f.write("GO\n\n")

    # --- SECCIÓN 3: CARGA DE MOVIMIENTOS USANDO EL PROCEDIMIENTO ALMACENADO ---
    f.write("PRINT '--- 3. Cargando Movimientos usando SP (esto actualizará los saldos)...';\n")
    f.write("DECLARE @IdUsuario INT, @ResultCodeMov INT;\n\n")

    movimientos = root.find('Movimientos')
    for mov in movimientos.findall('movimiento'):
        doc_id = mov.get('ValorDocId')
        tipo_mov_id = mov.get('IdTipoMovimiento')
        # La fecha no se usa en el SP, pero el SP usa la fecha actual. Mantenemos los otros datos del XML.
        monto = mov.get('Monto')
        user_name = mov.get('PostByUser').replace("'", "''")
        ip = mov.get('PostInIP')
        
        f.write(f"-- Procesando movimiento para DocId {doc_id} por usuario {user_name}\n")
        f.write(f"SELECT @IdUsuario = Id FROM Usuario WHERE Username = '{user_name}';\n")
        f.write(f"EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '{doc_id}', @inIdTipoMovimiento = {tipo_mov_id}, @inMonto = {monto}, @inUserId = @IdUsuario, @inIP = '{ip}', @outResultCode = @ResultCodeMov OUTPUT;\n\n")
    f.write("GO\n\n")
    
    f.write("PRINT 'Script de carga generado y listo para ejecutar.'\n")

# --- FIN DEL PROCESO ---
print(f"¡Listo! Se ha creado el archivo '{archivo_sql_salida}' en la misma carpeta.")
print("Ahora solo debes abrir ese archivo en SQL Server Management Studio y ejecutarlo.")