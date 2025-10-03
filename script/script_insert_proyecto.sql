-- SCRIPT "AutoRent"
-- Tipo de usuario
INSERT INTO tipo_usuario (id_tipo_usuario, descripcion) VALUES (1, 'Cliente');
INSERT INTO tipo_usuario (id_tipo_usuario, descripcion) VALUES (2, 'Administrador');
SELECT * FROM tipo_usuario;

-- Estados de reserva
INSERT INTO estado_reserva (id_estado_reserva, descripcion) VALUES (1, 'Pendiente');
INSERT INTO estado_reserva (id_estado_reserva, descripcion) VALUES (2, 'En Proceso');
INSERT INTO estado_reserva (id_estado_reserva, descripcion) VALUES (3, 'Finalizado');
SELECT * FROM estado_reserva;

-- Estados de coche
INSERT INTO estado_coche (id_estado_coche, descripcion) VALUES (1, 'Disponible');
INSERT INTO estado_coche (id_estado_coche, descripcion) VALUES (2, 'No disponible');
SELECT * FROM estado_coche;

-- Metodos de pago
INSERT INTO metodo_pago (id_metodo_pago, nombre) VALUES (1, 'Efectivo');
INSERT INTO metodo_pago (id_metodo_pago, nombre) VALUES (2, 'Tarjeta de Crédito');
INSERT INTO metodo_pago (id_metodo_pago, nombre) VALUES (3, 'Transferencia');
SELECT * FROM metodo_pago;

-- Marcas
INSERT INTO marca (id_marca, nombre) VALUES (1, 'Toyota');
INSERT INTO marca (id_marca, nombre) VALUES (2, 'Ford');
INSERT INTO marca (id_marca, nombre) VALUES (3, 'Chevrolet');
SELECT * FROM marca;

-- Modelos
INSERT INTO modelo (id_modelo, nombre, id_marca) VALUES (1, 'Corolla', 1); 
INSERT INTO modelo (id_modelo, nombre, id_marca) VALUES (2, 'Mustang', 2);
INSERT INTO modelo (id_modelo, nombre, id_marca) VALUES (3, 'Camaro', 3);
SELECT * FROM modelo;

-- Usuarios
INSERT INTO usuario (id_usuario, nombre, apellido, dni, email, contrasenia, id_tipo_usuario) VALUES 
					(1, 'María', 'González', 12345678, 'maria.gonzalez@mail.com', 'HashSeguro123', 1);
INSERT INTO usuario (id_usuario, nombre, apellido, dni, email, contrasenia, id_tipo_usuario) VALUES
					(2, 'Carlos', 'López', 87654321, 'carlos.lopez@mail.com', 'OtraClave456', 2);
INSERT INTO usuario (id_usuario, nombre, apellido, dni, email, contrasenia, id_tipo_usuario) VALUES
					(3, 'Lucía', 'Martínez', 23456789, 'lucia.martinez@mail.com', 'HashSeguro789', 1);
SELECT * FROM usuario;

-- Coches
INSERT INTO coche (id_coche, precio, nombre, anio_fabricacion, descripcion, imagen, id_modelo, id_estado_coche) VALUES
				  (1, 750.00, 'Toyota Corolla XLE', 2021, 'Sedán compacto y eficiente', 'corolla.jpg', 1, 1);
INSERT INTO coche (id_coche, precio, nombre, anio_fabricacion, descripcion, imagen, id_modelo, id_estado_coche) VALUES 
				  (2, 950.00, 'Ford Mustang GT', 2022, 'Deportivo americano de alto desempeño', 'mustang.jpg', 2, 1);
INSERT INTO coche (id_coche, precio, nombre, anio_fabricacion, descripcion, imagen, id_modelo, id_estado_coche) VALUES 
				  (3, 1200.00, 'Chevrolet Camaro SS', 2023, 'Muscle car icónico con gran potencia', 'camaro.jpg', 3, 1);
SELECT * FROM coche;

-- Reservas
INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche) VALUES
					(1, DATEADD(DAY, 3, CAST(GETDATE() AS DATE)), CAST('16:00' AS TIME), 2250.00, 1, 1, 1);
INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche) VALUES 
					(2, DATEADD(DAY, 2, CAST(GETDATE() AS DATE)), CAST('18:00' AS TIME), 1900.00, 2, 1, 2);
INSERT INTO reserva (id_reserva, fecha_devolucion, hora_devolucion, precio_total, id_usuario, id_estado_reserva, id_coche) VALUES 
					(3, DATEADD(DAY, 5, CAST(GETDATE() AS DATE)), CAST('12:00' AS TIME), 6000.00, 3, 1, 3);
SELECT * FROM reserva;

-- Detalles de método de pago
INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe) VALUES (1, 1, 2, 2250.00);
INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe) VALUES (2, 2, 1, 1900.00);
INSERT INTO detalle_metodo_pago (id_detalle_metodo_pago, id_reserva, id_metodo_pago, importe) VALUES (3, 3, 3, 6000.00);
SELECT * FROM detalle_metodo_pago;