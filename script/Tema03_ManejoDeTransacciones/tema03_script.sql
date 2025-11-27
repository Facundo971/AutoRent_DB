--TRANSACCION: Registrar un nuevo coche
BEGIN TRANSACTION;  -- Inicia una transacción explícita. A partir de aquí, todas las operaciones quedan bajo control: se aplican solo si se hace COMMIT, o se revierten si ocurre un ROLLBACK.
BEGIN TRY			-- Comienza un bloque de manejo de errores. Todo lo que esté dentro de este bloque se ejecuta normalmente, pero si ocurre un error, se salta automáticamente al bloque CATCH.
	INSERT INTO coche (id_coche, precio, nombre, anio_fabricacion, descripcion, imagen, id_modelo, id_estado_coche) --- Inserta un nuevo registro en la tabla coche.
		VALUES (4, 880.00, 'Toyota Corolla Hybrid', 2024, 'Sedán híbrido, eficiente y moderno', 'corolla_hybrid.jpg', 1, 1);
	COMMIT TRANSACTION -- Si el INSERT se ejecuta correctamente, se confirma la transacción. Esto hace que el nuevo coche quede guardado de forma definitiva en la base de datos.
END TRY  --- Finaliza el bloque TRY.
	BEGIN CATCH  -- Si ocurre un error dentro del bloque TRY (por ejemplo, si el id_modelo o id_estado_coche no existen), se ejecuta este bloque.
		ROLLBACK TRANSACTION  -- Revierte la transacción completa. Esto significa que ningún cambio se guarda en la base de datos. El coche no se inserta y todo vuelve al estado anterior.
		PRINT 'Error al agregar coches'  -- Muestra un mensaje en la consola de SQL Server indicando que hubo un error.
	END CATCH  --- Finaliza el bloque CATCH.

--TRANSACCION: CREAR UNA RESERVA MAS EL PAGO INICIAL
BEGIN TRANSACTION; -- Se inicia una transacción explícita. Todo lo que sigue queda bajo control de commit/rollback.

BEGIN TRY -- Comienza el bloque TRY: si ocurre un error, se saltará al bloque CATCH.

	-- Inserta una nueva reserva en la tabla 'reserva'
	INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche)
    VALUES (4, DATEADD(DAY, 7, CAST(GETDATE() AS DATE)), -- fecha_devolucion: 7 días después de hoy
            CAST('15:00' AS TIME),                       -- hora_devolucion: 15:00 hs
            6160.00,                                    -- precio_total
            2,                                          -- id_usuario: referencia al usuario con id=2
            2,                                          -- id_estado_reserva: referencia al estado de reserva (ej. "En Proceso")
            4);                                         -- id_coche: referencia al coche con id=4

	-- Inserta el detalle del método de pago asociado a la reserva
	INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe)
    VALUES (4, 4, 2, 6160.00); -- id_detalle_metodo_pago=4, reserva=4, método de pago=2, importe=6160.00

	-- Actualiza el estado del coche reservado
	UPDATE coche
	SET id_estado_coche = 2 -- cambia el estado del coche (ej. de "Disponible" a "No disponible")
	WHERE id_coche = 4;     -- afecta al coche con id=4

	COMMIT transaction; -- Si todo salió bien, se confirma la transacción y los cambios quedan guardados.

END TRY -- Fin del bloque TRY

BEGIN CATCH -- Si ocurre un error en cualquiera de las operaciones anteriores, se ejecuta este bloque.

	ROLLBACK TRANSACTION; -- Revierte toda la transacción, ningún cambio queda guardado.
	PRINT 'Error al realizar reserva'; -- Muestra un mensaje indicando que hubo un error.

END CATCH -- Fin del bloque CATCH


--TRANSACCION: FINALIZAR UNA RESERVA
BEGIN TRANSACTION; -- Se inicia una transacción explícita. Todo lo que sigue queda bajo control de commit/rollback.

BEGIN TRY -- Comienza el bloque TRY: si ocurre un error, se saltará al bloque CATCH.

	-- Actualiza la reserva con id=1, cambiando su estado a 3 ("Finalizado")
	UPDATE reserva
	SET id_estado_reserva = 3
	WHERE id_reserva = 1;

	-- Actualiza el estado del coche asociado a esa reserva
	UPDATE coche
	SET id_estado_coche = 1 -- cambia el estado del coche a 1 ("Disponible")
	WHERE id_coche = (
		SELECT id_coche -- obtiene el coche vinculado a la reserva
		FROM reserva
		WHERE id_reserva = 1
	);

	COMMIT TRANSACTION; -- Si todo salió bien, se confirma la transacción y los cambios quedan guardados.

END TRY -- Fin del bloque TRY

BEGIN CATCH -- Si ocurre un error en cualquiera de las operaciones anteriores, se ejecuta este bloque.

	ROLLBACK TRANSACTION; -- Revierte toda la transacción, ningún cambio queda guardado.
	PRINT 'error al finalizar reserva'; -- Muestra un mensaje indicando que hubo un error.

END CATCH -- Fin del bloque CATCH


-- En SQL Server no existen transacciones anidadas reales; lo más equivalente es trabajar con una sola transacción y savepoints, 
-- que permiten un control más granular sobre qué parte se revierte en caso de error.

-- TRANSACCIÓN ANIDADA: Insertar usuario + reserva + actualizar coche
BEGIN TRANSACTION; -- Se inicia una transacción explícita. Todo lo que sigue queda bajo control de commit/rollback.

BEGIN TRY -- Comienza el bloque TRY: si ocurre un error, se saltará al bloque CATCH.

    -- Paso 1: Insertar un nuevo usuario en la tabla 'usuario'
    INSERT INTO usuario (id_usuario, nombre, apellido, dni, telefono, direccion, email, contrasenia, id_tipo_usuario)
    VALUES ((SELECT ISNULL(MAX(id_usuario),0)+1 FROM usuario), -- genera un nuevo id_usuario tomando el máximo actual +1
            'Mario', 'González', 32222333, '1176543210', 'Av. Corrientes 1000',
            'mario.gonzalez@gmail.com', 'mario2025', 1); -- inserta los datos del nuevo usuario

    -- Guardar punto de control dentro de la transacción
    SAVE TRANSACTION PuntoUsuario; -- crea un savepoint llamado 'PuntoUsuario' para poder volver aquí si algo falla después

    -- Paso 2: Insertar una reserva asociada al usuario recién creado
    INSERT INTO reserva (id_reserva, fecha_retiro, fecha_devolucion, hora_retiro, hora_devolucion,
                         precio_total, id_usuario, id_estado_reserva, id_coche)
    VALUES ((SELECT ISNULL(MAX(id_reserva),0)+1 FROM reserva), -- genera un nuevo id_reserva
            CAST(GETDATE() AS DATE),                           -- fecha de retiro: hoy
            DATEADD(DAY, 5, CAST(GETDATE() AS DATE)),          -- fecha de devolución: 5 días después
            CAST('10:00' AS TIME),                             -- hora de retiro: 10:00
            CAST('10:00' AS TIME),                             -- hora de devolución: 10:00
            15000,                                             -- precio total
            (SELECT MAX(id_usuario) FROM usuario),             -- id_usuario: el último insertado
            1,                                                 -- id_estado_reserva: estado inicial ("Pendiente")
            99);                                               -- id_coche: intencionalmente inválido (no existe), provocará error

    -- Paso 3: Actualizar estado de un coche
    UPDATE coche
    SET id_estado_coche = 2 -- cambia el estado del coche (ej. "No disponible")
    WHERE id_coche = 1;     -- afecta al coche con id=1

    COMMIT TRANSACTION; -- Si todo salió bien, se confirma la transacción y los cambios quedan guardados.
    PRINT 'Transacción completada correctamente'; -- Mensaje de éxito

END TRY -- Fin del bloque TRY

BEGIN CATCH -- Si ocurre un error en cualquiera de las operaciones anteriores, se ejecuta este bloque.

    PRINT 'Error detectado: ' + ERROR_MESSAGE(); -- Muestra el mensaje de error capturado

    -- Manejo según el estado de la transacción
    IF XACT_STATE() = -1
        ROLLBACK TRANSACTION; -- Si la transacción está en estado irrecuperable, se revierte todo
    ELSE
        ROLLBACK TRANSACTION PuntoUsuario; -- Si la transacción sigue activa, se revierte hasta el savepoint: el usuario queda insertado

    PRINT 'Rollback ejecutado'; -- Mensaje indicando que se hizo rollback

END CATCH; -- Fin del bloque CATCH
