# -*- coding: utf-8 -*-
import xml.etree.ElementTree as ET
import os

archivo_xml_entrada = 'archivoDatos.xml'
archivo_sql_salida = 'CargarDatos.sql'

if not os.path.exists(archivo_xml_entrada):
    print(f"ERROR: No se encontró el archivo '{archivo_xml_entrada}'.")
    exit()

tree = ET.parse(archivo_xml_entrada)
root = tree.getroot()

# Lista para guardar todos los eventos cronológicos
eventos_operacionales = []
# Leer Empleados y guardarlos en la lista de eventos
print("Leyendo empleados")
empleados = root.find('Empleados')
for emp in empleados.findall('empleado'):
    eventos_operacionales.append({
        'timestamp': emp.get('FechaContratacion') + " 00:00:00", 
        'tipo': 'empleado',
        'datos': {
            'puesto': emp.get('Puesto').replace("'", "''"),
            'doc_id': emp.get('ValorDocumentoIdentidad'),
            'nombre': emp.get('Nombre').replace("'", "''"),
            'fecha_contratacion': emp.get('FechaContratacion')
        }
    })

# Leer Movimientos y guardarlos en la lista de eventos
print("Leyendo movimientos")
movimientos = root.find('Movimientos')
for mov in movimientos.findall('movimiento'):
    eventos_operacionales.append({
        'timestamp': mov.get('PostTime'),
        'tipo': 'movimiento',
        'datos': {
            'doc_id': mov.get('ValorDocId'),
            'tipo_mov_id': mov.get('IdTipoMovimiento'),
            'fecha_mov': mov.get('Fecha'),
            'post_time': mov.get('PostTime'),
            'monto': mov.get('Monto'),
            'user_name': mov.get('PostByUser').replace("'", "''"),
            'ip': mov.get('PostInIP')
        }
    })

# Ordenar eventos
print(f"Ordenando eventos cronológicamente")
eventos_operacionales.sort(key=lambda x: x['timestamp'])

# Generación script
print("Generando script CargarDatos.sql")
with open(archivo_sql_salida, 'w', encoding='utf-8') as f:
    # Carga de catálogos
    f.write("PRINT 'Catálogos:';\n\n")
    
    f.write("PRINT 'Cargando Puestos...';\n")
    puestos = root.find('Puestos')
    for puesto in puestos.findall('Puesto'):
        nombre = puesto.get('Nombre').replace("'", "''")
        salario = puesto.get('SalarioxHora')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Puesto WHERE Nombre = '{nombre}') INSERT INTO Puesto (Nombre, SalarioxHora) VALUES ('{nombre}', {salario});\n")
    f.write("GO\n\n")

    f.write("PRINT 'Cargando Tipos de Evento';\n")
    tipos_evento = root.find('TiposEvento')
    for tipo in tipos_evento.findall('TipoEvento'):
        evento_id = tipo.get('Id')
        nombre = tipo.get('Nombre').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM TipoEvento WHERE Id = {evento_id}) INSERT INTO TipoEvento (Id, Nombre) VALUES ({evento_id}, '{nombre}');\n")
    f.write("GO\n\n")

    f.write("PRINT 'Cargando Tipos de Movimiento';\n")
    tipos_movimiento = root.find('TiposMovimientos')
    for tipo in tipos_movimiento.findall('TipoMovimiento'):
        mov_id = tipo.get('Id')
        nombre = tipo.get('Nombre').replace("'", "''")
        tipo_accion = tipo.get('TipoAccion')
        f.write(f"IF NOT EXISTS (SELECT 1 FROM TipoMovimiento WHERE Id = {mov_id}) INSERT INTO TipoMovimiento (Id, Nombre, TipoAccion) VALUES ({mov_id}, '{nombre}', '{tipo_accion}');\n")
    f.write("GO\n\n")
    
    f.write("PRINT 'Cargando Usuarios';\n")
    usuarios = root.find('Usuarios')
    f.write("SET IDENTITY_INSERT Usuario ON;\n")
    for usuario in usuarios.findall('usuario'):
        user_id = usuario.get('Id')
        nombre = usuario.get('Nombre').replace("'", "''")
        password = usuario.get('Pass').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Usuario WHERE Id = {user_id}) INSERT INTO Usuario (Id, Username, Password) VALUES ({user_id}, '{nombre}', '{password}');\n")
    f.write("SET IDENTITY_INSERT Usuario OFF;\n")
    f.write("GO\n\n")
    
    f.write("PRINT 'Cargando Catálogo de Errores';\n")
    errores = root.find('Error')
    f.write("SET IDENTITY_INSERT Error ON;\n")
    for error in errores.findall('errorCodigo'):
        error_id = error.get('Id')
        codigo = error.get('Codigo')
        descripcion = error.get('Descripcion').replace("'", "''")
        f.write(f"IF NOT EXISTS (SELECT 1 FROM Error WHERE Id = {error_id}) INSERT INTO Error (Id, Codigo, Descripcion) VALUES ({error_id}, '{codigo}', '{descripcion}');\n")
    f.write("SET IDENTITY_INSERT Error OFF;\n")
    f.write("GO\n\n")

    # Simulación cronológica
    f.write("PRINT 'Simulación de Operaciones (fecha por fecha)';\n\n")
    f.write("DECLARE @IdPuesto INT, @IdUsuarioScripts INT, @ResultCode INT;\n")
    f.write("DECLARE @IdUsuarioMov INT, @ResultCodeMov INT;\n")
    f.write("SELECT @IdUsuarioScripts = Id FROM Usuario WHERE Username = 'UsuarioScripts';\n\n")

    current_date_processed = ""
    # Recorrido de la lista 
    for evento in eventos_operacionales:
        
        # Extraer la fecha para imprimirla
        event_date = evento['timestamp'].split(' ')[0]
        
        # Si la fecha de este evento es diferente a la anterior, se imprime un separador
        if event_date != current_date_processed:
            f.write(f"\nPRINT 'Procesando operaciones para la fecha: {event_date}';\n")
            current_date_processed = event_date

        # Empleados
        if evento['tipo'] == 'empleado':
            datos = evento['datos']
            f.write(f"IF NOT EXISTS (SELECT 1 FROM Empleado WHERE ValorDocumentoIdentidad = '{datos['doc_id']}') BEGIN;\n")
            f.write(f"    SELECT @IdPuesto = Id FROM Puesto WHERE Nombre = '{datos['puesto']}';\n")
            f.write(f"    EXEC dbo.InsertEmpleado @inIdPuesto = @IdPuesto, @inValorDocumentoIdentidad = '{datos['doc_id']}', @inNombre = '{datos['nombre']}', @inFechaContratacion = '{datos['fecha_contratacion']}', @inUserId = @IdUsuarioScripts, @inIP = '127.0.0.1', @outResultCode = @ResultCode OUTPUT;\n")
            f.write("END;\n\n")
        
        # Movimientos
        elif evento['tipo'] == 'movimiento':
            datos = evento['datos']
            f.write(f"SELECT @IdUsuarioMov = Id FROM Usuario WHERE Username = '{datos['user_name']}';\n")
            f.write("IF @IdUsuarioMov IS NOT NULL\n") # Validación usuario real
            f.write(f"    EXEC dbo.InsertMovimiento @inValorDocumentoIdentidad = '{datos['doc_id']}', @inIdTipoMovimiento = {datos['tipo_mov_id']}, @inMonto = {datos['monto']}, @inFecha = '{datos['fecha_mov']}', @inPostTime = '{datos['post_time']}', @inUserId = @IdUsuarioMov, @inIP = '{datos['ip']}', @outResultCode = @ResultCodeMov OUTPUT;\n")
            f.write("ELSE\n")
            f.write(f"    PRINT 'Error: No se pudo insertar el movimiento porque el usuario no existe.';\n\n")

    f.write("GO\n\n")

print(f"Se creó correctamente el archivo.")