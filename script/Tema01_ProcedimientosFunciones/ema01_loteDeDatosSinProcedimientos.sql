-- Inserción de lote de datos directo
INSERT INTO usuario (id_usuario, nombre, apellido, dni, telefono, direccion, email, contrasenia, id_tipo_usuario)
VALUES
(1, 'Bruno', 'Castro', 29458741, '1188665522', 'Moreno 2300', 'bruno.castro@hotmail.com', 'bruno444', 2),
(2, 'María', 'Gómez', 28455987, '1134567890', 'Calle Luna 450', 'maria.gomez@gmail.com', 'pass123', 1),
(3, 'Luis', 'Fernandez', 32987411, '1145678923', 'Av. Belgrano 789', 'luis.f@gmail.com', 'abc123', 2),
(4, 'Sofía', 'Martinez', 31245897, '1156789345', 'San Martín 1020', 'sofia.martinez@yahoo.com', 'sofia2024', 1),
(5, 'Diego', 'Sanchez', 29547821, '1167893456', 'Rivadavia 3500', 'diego.s@hotmail.com', 'diegopass', 2),
(6, 'Carla', 'Lopez', 30877412, '1178904567', 'Mitre 220', 'carla.lopez@gmail.com', 'carla123', 1),
(7, 'Facundo', 'Rodriguez', 33789455, '1165437890', 'Colon 880', 'facu.rodri@gmail.com', 'facu2024', 2),
(8, 'Lucía', 'Torres', 30147895, '1187654321', 'Chile 1234', 'lucia.torres@hotmail.com', 'lucia432', 1),
(9, 'Andrés', 'Ramirez', 28965477, '1122334455', 'Perú 2000', 'andres.r@gmail.com', 'andres55', 1),
(10, 'Valentina', 'Suarez', 31544987, '1133221100', 'Guatemala 510', 'valen.suarez@gmail.com', 'valen2024', 2),
(11, 'Matías', 'Dominguez', 32658741, '1144556677', 'Chacabuco 1420', 'matias.dominguez@hotmail.com', 'mati1234', 1),
(12, 'Julieta', 'Vega', 29874456, '1199887766', 'Estados Unidos 100', 'julivega@gmail.com', 'julieta98', 2),
(13, 'Sebastián', 'Molina', 32014589, '1166123344', 'Lavalle 800', 'seb.molina@yahoo.com', 'sebpass', 1),
(14, 'Camila', 'Peralta', 30366987, '1177332211', 'Corrientes 540', 'cami.peralta@gmail.com', 'cami543', 1),
(15, 'Federico', 'Aguirre', 33214785, '1188445566', 'México 1800', 'fede.aguirre@hotmail.com', 'fede321', 2),
(16, 'Paula', 'Nuñez', 31789452, '1199554411', 'Sarmiento 310', 'paula.n@gmail.com', 'paulan', 1),
(17, 'Tomás', 'Ibarra', 29114785, '1144112233', 'Urquiza 900', 'tomas.ibarra@gmail.com', 'tompass', 1),
(18, 'Rocío', 'Campos', 30588741, '1133992211', 'Belgrano 1001', 'ro.campos@gmail.com', 'rocio2024', 2),
(19, 'Gabriel', 'Lara', 33387412, '1122113344', 'San Juan 670', 'gab.lara@yahoo.com', 'gabriel33', 1),
(20, 'Agustina', 'Rivas', 30078455, '1177112233', 'Defensa 140', 'agus.rivas@gmail.com', 'agus789', 1);

-- Modificación del nro de telefono del primer usuario (Bruno)
UPDATE usuario
SET telefono = 3794153211
WHERE id_usuario = 1

-- Mostramos la modificación del primer usuario (Bruno)
SELECT * 
FROM usuario
WHERE id_usuario = 1
