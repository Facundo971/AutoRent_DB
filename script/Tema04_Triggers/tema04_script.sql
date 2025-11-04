--Tabla auditoria
CREATE TABLE auditoria_detalle_metodo_pago
(
  auditoria_id INT IDENTITY(1,1),                 -- PK autoincremental del registro de auditoría
  id_detalle_metodo_pago INT NOT NULL,            -- id del detalle en la tabla origen (clave que identifica la fila auditada)
  id_reserva INT NOT NULL,                        -- id de la reserva asociada (valor previo)
  id_metodo_pago INT NOT NULL,                    -- id del método de pago usado (valor previo)
  importe DECIMAL(10,2) NOT NULL,                 -- importe registrado en la fila antes del cambio
  fecha_pago DATE NULL,                           -- fecha de pago guardada en la fila antes del cambio
  accion CHAR(1) NOT NULL,                        -- tipo de operación: 'U' = UPDATE, 'D' = DELETE, 'T' = intento de DELETE bloqueado
  usuario_db NVARCHAR(128) NOT NULL,              -- usuario de la sesión que ejecutó la acción
  fecha_hora DATETIME NOT NULL DEFAULT GETDATE(), -- momento en que se registró la auditoría
  PRIMARY KEY(auditoria_id)                       -- declaración de clave primaria sobre auditoria_id
);
GO


-- Trigger AFTER para registrar UPDATE y DELETE (graba el estado previo desde DELETED)
CREATE TRIGGER trg_auditoria_detalle_metodo_pago_upd_del  -- Define el nombre del trigger
ON detalle_metodo_pago                                    -- Especifica la tabla sobre la que se crea el trigger
AFTER UPDATE, DELETE                                      -- Indica que el trigger se ejecuta justo después de que termine una operación UPDATE o DELETE sobre la tabla
AS                                                        -- Inicio del cuerpo del trigger (separador que marca el inicio del cuerpo del trigger)
BEGIN                                                     -- Abre el bloque de instrucciones
  SET NOCOUNT ON;                                         -- Evita que SQL Server devuelva recuentos de filas afectadas

  INSERT INTO auditoria_detalle_metodo_pago               -- Inserta los registros de auditoría en la tabla destino
    (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe, fecha_pago, accion, usuario_db, fecha_hora)

  SELECT                                                  -- Inicio de la selección de los valores a insertar
    d.id_detalle_metodo_pago,                             -- Id del detalle tal como estaba antes de la operación (desde DELETED)
    d.id_reserva,                                         -- Id de la reserva tal como estaba antes de la operación (desde DELETED)
    d.id_metodo_pago,                                     -- Id del método de pago tal como estaba antes (desde DELETED)
    d.importe,                                            -- Importe antes del cambio (desde DELETED)
    d.fecha_pago,                                         -- Fecha de pago antes del cambio (desde DELETED)
    /* CASE WHEN EXISTS
        Comprueba si la misma fila aparece en la pseudotabla inserted.
        Si existe en inserted y en deleted → la operación fue un UPDATE (marcamos 'U').
        Si no existe en inserted pero sí en deleted → fue un DELETE (marcamos 'D').
        Resultado: una columna llamada accion con valor 'U' o 'D' según el caso.
    */
    CASE WHEN EXISTS(                                     
         SELECT 1 FROM inserted i                         
         WHERE i.id_detalle_metodo_pago = d.id_detalle_metodo_pago
           AND i.id_reserva = d.id_reserva)               
         THEN 'U'
         ELSE 'D' END AS accion,
    SYSTEM_USER,                                          -- Usuario de la sesión que ejecutó la operación
    GETDATE()                                             -- Devuelve la fecha y hora actuales para el registro de auditoría
  FROM deleted d;
END;                                                      -- Cierra el bloque del trigger
GO                                                        -- Marca de lote para ejecutar el script


-- Trigger INSTEAD OF DELETE para bloquear borrados físicos y registrar el intento
CREATE TRIGGER trg_block_delete_detalle_metodo_pago   -- Define el nombre del trigger
ON detalle_metodo_pago                                -- Indica la tabla sobre la que se crea el trigger
INSTEAD OF DELETE                                     -- Intercepta la operación DELETE y ejecuta este bloque en su lugar
AS
BEGIN                                                 -- Inicia el bloque de instrucciones del trigger
  SET NOCOUNT ON;                                     -- Evita mensajes de recuento de filas afectados

  -- Registrar intento de borrado en la tabla de auditoría (acción 'T' = intento)
  INSERT INTO auditoria_detalle_metodo_pago           -- Inserta un registro por cada fila que se intentó borrar
    (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe, fecha_pago, accion, usuario_db, fecha_hora)
  SELECT
    d.id_detalle_metodo_pago,                         -- id del detalle tal como estaba antes del intento de delete
    d.id_reserva,                                     -- id de la reserva asociada antes del intento
    d.id_metodo_pago,                                 -- id del método de pago antes del intento
    d.importe,                                        -- importe antes del intento
    d.fecha_pago,                                     -- fecha_pago antes del intento
    'T' AS accion,                                    -- Marca la fila como intento de delete (T = intento)
    SYSTEM_USER,                                      -- Usuario de la sesión que ejecutó el delete
    GETDATE()                                         -- Devuelve la fecha y hora actuales del intento de borrado
  FROM deleted d;                                    

  -- Informa al usuario
  RAISERROR('El borrado de registros en detalle_metodo_pago está restringido. Operación no permitida.', 10, 1) WITH NOWAIT;
  RETURN;
END;
GO


-- Caso de prueba: UPDATE (Genera registro con accion = 'U')
UPDATE detalle_metodo_pago
SET importe = 2260.00                                      -- Cambia el importe del detalle de pago
WHERE id_detalle_metodo_pago = 1 AND id_reserva = 1;       -- Afecta la fila de prueba insertada

-- Verificar auditoría: consultar la tabla de auditoría para ver el registro generado por el trigger
SELECT 
    * 
FROM auditoria_detalle_metodo_pago
WHERE id_detalle_metodo_pago = 1
ORDER BY fecha_hora DESC;
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
ORDER BY fecha_hora DESC;
GO
