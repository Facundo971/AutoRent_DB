-- TEMA: Procedimientos y Funciones Almacenadas


-- PROCEDIMIENTOS ALMACENADOS (CRUD)

-- a) Insertar una marca
CREATE PROCEDURE sp_InsertarMarca
  @nombre VARCHAR(50)
AS
BEGIN
  INSERT INTO marca (id_marca, nombre)
  VALUES ((SELECT ISNULL(MAX(id_marca),0)+1 FROM marca), @nombre);
END;
GO

-- b) Modificar una marca
CREATE PROCEDURE sp_ModificarMarca
  @id_marca INT,
  @nuevoNombre VARCHAR(50)
AS
BEGIN
  UPDATE marca
  SET nombre = @nuevoNombre
  WHERE id_marca = @id_marca;
END;
GO

-- c) Eliminar una marca
CREATE PROCEDURE sp_EliminarMarca
  @id_marca INT
AS
BEGIN
  DELETE FROM marca
  WHERE id_marca = @id_marca;
END;
GO


-- INSERCIÓN DE DATOS (LOTE DIRECTO)

INSERT INTO marca (id_marca, nombre) VALUES (1, 'Toyota');
INSERT INTO marca (id_marca, nombre) VALUES (2, 'Ford');
INSERT INTO marca (id_marca, nombre) VALUES (3, 'Chevrolet');
INSERT INTO marca (id_marca, nombre) VALUES (4, 'Honda');


-- INSERCIÓN / MODIFICACIÓN / BORRADO USANDO PROCEDIMIENTOS

-- Insertar nuevas marcas con SP
EXEC sp_InsertarMarca 'Nissan';
EXEC sp_InsertarMarca 'Peugeot';

-- Modificar nombre de una marca
EXEC sp_ModificarMarca 2, 'Ford Motor Company';

-- Eliminar una marca existente
EXEC sp_EliminarMarca 3; -- cambiar por el id de la marca que se quiere eliminar



-- PROCEDIMIENTOS PARA OTRA TABLA (EJ: USUARIO)
CREATE PROCEDURE sp_InsertarUsuario
  @nombre VARCHAR(50),
  @apellido VARCHAR(50),
  @dni INT,
  @telefono VARCHAR(20),
  @direccion VARCHAR(100),
  @email VARCHAR(100),
  @contrasenia VARCHAR(20),
  @id_tipo_usuario INT
AS
BEGIN
  INSERT INTO usuario (id_usuario, nombre, apellido, dni, telefono, direccion, email, contrasenia, id_tipo_usuario)
  VALUES ((SELECT ISNULL(MAX(id_usuario),0)+1 FROM usuario),
          @nombre, @apellido, @dni, @telefono, @direccion, @email, @contrasenia, @id_tipo_usuario);
END;
GO


-- INSERCIÓN DE USUARIOS DIRECTA Y CON PROCEDIMIENTO

-- Lote directo
INSERT INTO usuario (id_usuario, nombre, apellido, dni, telefono, direccion, email, contrasenia, id_tipo_usuario)
VALUES (1, 'Juan', 'Pérez', 30111222, '1123456789', 'Av. Siempre Viva 123', 'juanp@gmail.com', '1234', 1);

-- Mediante procedimiento
EXEC sp_InsertarUsuario 'Ana', 'Gómez', 30555666, '1133334444', 'Belgrano 2020', 'ana.gomez@gmail.com', 'pass123', 1;
EXEC sp_InsertarUsuario 'Carlos', 'López', 28999111, '1145678901', 'Mitre 450', 'carlos.lopez@gmail.com', 'admin2024', 2;



-- FUNCIONES ALMACENADAS

-- a) Función escalar: cantidad de días entre fechas
CREATE FUNCTION fn_CantidadDiasReserva
(
  @fecha_retiro DATE,
  @fecha_devolucion DATE
)
RETURNS INT
AS
BEGIN
  RETURN DATEDIFF(DAY, @fecha_retiro, @fecha_devolucion);
END;
GO

-- b) Función escalar: total estimado de reserva
CREATE FUNCTION fn_TotalReserva
(
  @precio_diario DECIMAL(10,2),
  @fecha_retiro DATE,
  @fecha_devolucion DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
  DECLARE @dias INT = DATEDIFF(DAY, @fecha_retiro, @fecha_devolucion);
  RETURN @precio_diario * @dias;
END;
GO

-- c) Función de tabla: listar coches disponibles
CREATE FUNCTION fn_CochesDisponibles()
RETURNS TABLE
AS
RETURN
(
  SELECT c.id_coche, c.nombre, c.precio, m.nombre AS marca
  FROM coche c
  INNER JOIN modelo mo ON c.id_modelo = mo.id_modelo
  INNER JOIN marca m ON mo.id_marca = m.id_marca
  INNER JOIN estado_coche ec ON c.id_estado_coche = ec.id_estado_coche
  WHERE ec.descripcion = 'Disponible'
);
GO


-- USO DE FUNCIONES

-- Calcular cantidad de días de una reserva
SELECT dbo.fn_CantidadDiasReserva('2025-11-01', '2025-11-05') AS Dias;

-- Calcular total estimado de una reserva
SELECT dbo.fn_TotalReserva(5000, '2025-11-01', '2025-11-05') AS TotalEstimado;

-- Mostrar coches disponibles
SELECT * FROM dbo.fn_CochesDisponibles();


