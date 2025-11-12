-- Consultas para visualizar el contenido actual de las tablas
SELECT * FROM reserva;
SELECT * FROM metodo_pago;
SELECT * FROM detalle_metodo_pago;
SELECT * FROM auditoria_detalle_metodo_pago;


-- Tabla de auditoría que registra cada operación UPDATE, DELETE o intento de DELETE sobre la tabla detalle_metodo_pago
CREATE TABLE auditoria_detalle_metodo_pago
(
  auditoria_id INT IDENTITY(1,1),                 -- PK autoincremental del registro de auditoría
  id_detalle_metodo_pago INT NOT NULL,            -- id del detalle en la tabla origen (clave que identifica la fila auditada)
  id_reserva INT NOT NULL,                        -- id de la reserva asociada (valor previo)
  id_metodo_pago INT NOT NULL,                    -- id del método de pago usado (valor previo)
  importe DECIMAL(10,2) NOT NULL,                 -- importe registrado en la fila antes del cambio
  fecha_pago DATE NULL,                           -- fecha de pago guardada en la fila antes del cambio
  accion CHAR(1) NOT NULL,                        -- tipo de operación: 'U' = UPDATE, 'D' = DELETE, 'T' = intento de DELETE bloqueado
  usuario_db NVARCHAR(128) NOT NULL,              -- usuario de la sesión que ejecutó la acción (ej. SYSTEM_USER)
  fecha_hora DATETIME NOT NULL DEFAULT GETDATE(), -- momento en que se registró la auditoría (timestamp)
  PRIMARY KEY(auditoria_id)                       -- declaración de clave primaria sobre auditoria_id
);
GO


-- Trigger AFTER para registrar operaciones UPDATE (captura el estado anterior desde la tabla lógica DELETED)
CREATE TRIGGER trg_auditoria_detalle_metodo_pago_upd      -- Define el nombre del trigger
ON detalle_metodo_pago                                    -- Especifica la tabla sobre la que se crea el trigger
AFTER UPDATE                                              -- Indica que el trigger se ejecuta justo después de que termine la operación UPDATE sobre la tabla
AS                                                        -- Inicio del cuerpo del trigger (separador que marca el inicio del cuerpo del trigger)
BEGIN                                                     -- Abre el bloque de instrucciones
  SET NOCOUNT ON;                                         -- Evita que SQL Server devuelva recuentos de filas afectadas

  INSERT INTO auditoria_detalle_metodo_pago               -- Registra en la tabla de auditoría los valores anteriores a la actualización
    (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe, fecha_pago, accion, usuario_db, fecha_hora)

  SELECT                                                  -- Inicio de la selección de los valores a insertar
    d.id_detalle_metodo_pago,                             -- Id del detalle antes del UPDATE (desde la tabla DELETED)
    d.id_reserva,                                         -- Id de la reserva antes del UPDATE (desde la tabla DELETED)
    d.id_metodo_pago,                                     -- Método de pago antes del UPDATE (desde la tabla DELETED)
    d.importe,                                            -- Importe antes del UPDATE (desde la tabla DELETED)
    d.fecha_pago,                                         -- Fecha de pago antes del UPDATE (desde la tabla DELETED)
    'U' AS accion,                                        -- Acción: 'U' indica operación UPDATE
    SYSTEM_USER,                                          -- Usuario que ejecutó la operación
    GETDATE()                                             -- Devuelve la fecha y hora actuales para el registro de auditoría
  FROM deleted d;                                         -- Tabla lógica DELETED que contiene los valores previos al UPDATE
END;                                                      -- Cierra el bloque del trigger
GO                                                        -- Marca de lote para ejecutar el script


-- Trigger AFTER para registrar operaciones DELETE (captura el estado anterior desde la tabla lógica DELETED)
CREATE TRIGGER trg_auditoria_detalle_metodo_pago_del      -- Define el nombre del trigger
ON detalle_metodo_pago                                    -- Especifica la tabla sobre la que se crea el trigger
AFTER DELETE                                              -- Indica que el trigger se ejecuta justo después de que termine la operación DELETE sobre la tabla
AS                                                        -- Inicio del cuerpo del trigger (separador que marca el inicio del cuerpo del trigger)
BEGIN                                                     -- Abre el bloque de instrucciones
  SET NOCOUNT ON;                                         -- Evita que SQL Server devuelva recuentos de filas afectadas

  INSERT INTO auditoria_detalle_metodo_pago               -- Registra en la tabla de auditoría los valores anteriores a la eliminación
    (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe, fecha_pago, accion, usuario_db, fecha_hora)

  SELECT                                                  -- Inicio de la selección de los valores a insertar
    d.id_detalle_metodo_pago,                             -- Id del detalle antes del DELETE (desde la tabla DELETED)
    d.id_reserva,                                         -- Id de la reserva antes del DELETE (desde la tabla DELETED)
    d.id_metodo_pago,                                     -- Método de pago antes del DELETE (desde la tabla DELETED)
    d.importe,                                            -- Importe antes del DELETE (desde la tabla DELETED)
    d.fecha_pago,                                         -- Fecha de pago antes del DELETE (desde la tabla DELETED)
    'D' AS accion,                                        -- Acción: 'D' indica operación DELETE
    SYSTEM_USER,                                          -- Usuario que ejecutó la operación
    GETDATE()                                             -- Devuelve la fecha y hora actuales para el registro de auditoría
  FROM deleted d;                                         -- Tabla lógica DELETED que contiene los valores previos al DELETE
END;                                                      -- Cierra el bloque del trigger
GO  


-- Trigger INSTEAD OF DELETE para bloquear borrados físicos y registrar el intento
CREATE TRIGGER trg_block_delete_detalle_metodo_pago   -- Define el nombre del trigger
ON detalle_metodo_pago                                -- Indica la tabla sobre la que se crea el trigger
INSTEAD OF DELETE                                     -- Intercepta la operación DELETE y ejecuta este bloque en su lugar
AS
BEGIN                                                 -- Inicia el bloque de instrucciones del trigger
  SET NOCOUNT ON;                                     -- Evita mensajes de recuento de filas afectados

  -- Registrar intento de borrado en la tabla de auditoría (acción 'T' = intento)
  INSERT INTO auditoria_detalle_metodo_pago
    (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe, fecha_pago, accion, usuario_db, fecha_hora)
  SELECT
    d.id_detalle_metodo_pago,                         -- Id del detalle antes del intento de DELETE (desde la tabla DELETED)
    d.id_reserva,                                     -- Id de la reserva antes del intento de DELETE (desde la tabla DELETED)
    d.id_metodo_pago,                                 -- Método de pago antes del intento de DELETE (desde DELETED)
    d.importe,                                        -- Importe antes del intento de DELETE (desde DELETED)
    d.fecha_pago,                                     -- Fecha de pago antes del intento de DELETE (desde DELETED)
    'T' AS accion,                                    -- Acción: 'T' indica intento de eliminación bloqueado
    SYSTEM_USER,                                      -- Usuario de la sesión que ejecutó el delete
    GETDATE()                                         -- Devuelve la fecha y hora actuales del intento de borrado
  FROM deleted d;                                     -- Tabla lógica DELETED que contiene los valores previos al DELETE                                  

  -- Informa al usuario que la operación está restringida
  RAISERROR('El borrado de registros en detalle_metodo_pago está restringido. Operación no permitida.', 10, 1) WITH NOWAIT;
  RETURN;
END;
GO


-- Caso de prueba: UPDATE (Genera registro con accion = 'U')
UPDATE detalle_metodo_pago
SET importe = 6260.00                                      -- Cambia el importe del detalle de pago
WHERE id_detalle_metodo_pago = 1 AND id_reserva = 1;       -- Afecta la fila de prueba insertada

-- Verificar auditoría: consultar la tabla de auditoría para ver el registro generado por el trigger
SELECT 
    * 
FROM auditoria_detalle_metodo_pago
WHERE id_detalle_metodo_pago = 1
GO


-- Caso de prueba: DELETE (queda bloqueado. Se registrará intento con accion = 'T')
DELETE FROM detalle_metodo_pago
WHERE id_detalle_metodo_pago = 1 AND id_reserva = 1; -- Intento de borrado físico (será interceptado por INSTEAD OF DELETE)

SELECT * FROM detalle_metodo_pago WHERE id_detalle_metodo_pago = 1;
-- Verificar auditoría para ver el intento: la auditoría debe contener el registro con accion = 'T'
SELECT 
    * 
FROM auditoria_detalle_metodo_pago
WHERE id_detalle_metodo_pago = 1
GO


-- Caso de prueba: DELETE (se ejecuta físicamente. Se registrará acción con accion = 'D')
-- Deshabilitar trigger INSTEAD OF DELETE
DISABLE TRIGGER trg_block_delete_detalle_metodo_pago ON detalle_metodo_pago;

-- DELETE físico que deberá generar registro 'D' desde el trigger AFTER
DELETE FROM detalle_metodo_pago
WHERE id_detalle_metodo_pago = 3 AND id_reserva = 3;

-- Volver a habilitar el trigger INSTEAD OF DELETE
ENABLE TRIGGER trg_block_delete_detalle_metodo_pago ON detalle_metodo_pago;

-- Verificar auditoría (debe aparecer un registro con accion = 'D')
SELECT 
    * 
FROM auditoria_detalle_metodo_pago
WHERE id_detalle_metodo_pago = 3 AND id_reserva = 3;


/*
-- Eliminar triggers si existen
IF OBJECT_ID('trg_block_delete_detalle_metodo_pago', 'TR') IS NOT NULL
  DROP TRIGGER trg_block_delete_detalle_metodo_pago;
GO

IF OBJECT_ID('trg_auditoria_detalle_metodo_pago_upd', 'TR') IS NOT NULL
  DROP TRIGGER trg_auditoria_detalle_metodo_pago_upd;
GO

IF OBJECT_ID('trg_auditoria_detalle_metodo_pago_del', 'TR') IS NOT NULL
  DROP TRIGGER trg_auditoria_detalle_metodo_pago_del;
GO

-- Eliminar tabla de auditoría si existe
IF OBJECT_ID('auditoria_detalle_metodo_pago', 'U') IS NOT NULL
  DROP TABLE auditoria_detalle_metodo_pago;
GO
*/

/* Lote de datos
-- Detalles de método de pago
INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe) VALUES (1, 1, 2, 2250.00);
INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe) VALUES (2, 2, 1, 1900.00);
INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe) VALUES (3, 3, 3, 6000.00);

-- Metodos de pago
INSERT INTO metodo_pago (id_metodo_pago, nombre) VALUES (1, 'Efectivo');
INSERT INTO metodo_pago (id_metodo_pago, nombre) VALUES (2, 'Tarjeta de Crédito');
INSERT INTO metodo_pago (id_metodo_pago, nombre) VALUES (3, 'Transferencia');

-- Reservas
INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche) VALUES
					(1, DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), CAST('16:00' AS TIME), 2250.00, 1, 1, 1);
INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche) VALUES 
					(2, DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), CAST('18:00' AS TIME), 1900.00, 2, 1, 2);
INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche) VALUES 
					(3, DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), CAST('12:00' AS TIME), 6000.00, 3, 1, 3);
*/
