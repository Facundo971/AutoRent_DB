-- TEMA: Procedimientos y Funciones Almacenadas


-- PROCEDIMIENTOS ALMACENADOS (CRUD)

-- a) Crea el procedimiento Insertar Marca
CREATE PROCEDURE sp_InsertarMarca
  @nombre VARCHAR(50)                                -- Parámetro de entrada: nombre de la marca
AS
BEGIN
  INSERT INTO marca (id_marca, nombre)               -- Inserta una nueva marca en la tabla "marca"
  VALUES ((SELECT ISNULL(MAX(id_marca),0)+1 FROM marca), @nombre);       -- id_marca se calcula buscando el máximo id_marca y sumándole 1 (auto-increment manual)
END;
GO                                                   -- Finaliza el procedimiento

-- b) Crea el procedimiento Modificar marca
CREATE PROCEDURE sp_ModificarMarca
  @id_marca INT,                -- ID de la marca a modificar
  @nuevoNombre VARCHAR(50)      -- Nuevo nombre para la marca
AS
BEGIN
  UPDATE marca                  -- Actualiza la tabla marca cambiando el nombre
  SET nombre = @nuevoNombre
  WHERE id_marca = @id_marca;   -- Solo modifica la marca con este ID
END;
GO

-- c) Crea el procedimiento Eliminar marca
CREATE PROCEDURE sp_EliminarMarca
  @id_marca INT                 -- ID de la marca a eliminar
AS
BEGIN
  DELETE FROM marca             -- Borra el registro correspondiente al ID enviado
  WHERE id_marca = @id_marca;   -- Busca la marca a eliminar por el ID
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
  @nombre VARCHAR(50),              -- nombre del usuario
  @apellido VARCHAR(50),            -- apellido del usuario
  @dni INT,                         -- dni del usuario
  @telefono VARCHAR(20),            -- telefono del usuario
  @direccion VARCHAR(100),          -- dirección del usuario
  @email VARCHAR(100),              -- email del usuario
  @contrasenia VARCHAR(20),         -- contraseña del usuario
  @id_tipo_usuario INT              -- id del usuario (Cliente o administrador)
AS
BEGIN
  INSERT INTO usuario (id_usuario, nombre, apellido, dni, telefono, direccion, email, contrasenia, id_tipo_usuario)  
  VALUES ((SELECT ISNULL(MAX(id_usuario),0)+1 FROM usuario),   -- Inserta un nuevo usuario generando ID automáticamente
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

-- a) Crea una función escalar que recibe dos fechas
CREATE FUNCTION fn_CantidadDiasReserva
(
  @fecha_retiro DATE,           -- Fecha de retiro
  @fecha_devolucion DATE        -- Fecha de devolución
)
RETURNS INT                     -- Devuelve un número entero
AS
BEGIN
  RETURN DATEDIFF(DAY, @fecha_retiro, @fecha_devolucion);    -- Devuelve la diferencia en días entre las dos fechas
END;
GO


-- b) Función escalar: total estimado de reserva
CREATE FUNCTION fn_TotalReserva
(
  @precio_diario DECIMAL(10,2),      -- Precio por día (10 = número total de dígitos) y (2 = número de dígitos a la derecha del punto decimal)
  @fecha_retiro DATE,                -- Fecha de retiro
  @fecha_devolucion DATE             -- Fecha de devolución
)
RETURNS DECIMAL(10,2)                -- Devuelve el total como número decimal
AS
BEGIN
  DECLARE @dias INT = DATEDIFF(DAY, @fecha_retiro, @fecha_devolucion);    -- Calcula la cantidad de días
  RETURN @precio_diario * @dias;         -- Devuelve el precio por día multiplicado por la cantidad de días
END;
GO


CREATE FUNCTION fn_CochesDisponibles()
RETURNS TABLE                       -- Devuelve una tabla completa
AS
RETURN
(
  -- Devuelve una tabla con coches disponibles
  SELECT 
    c.id_coche,                    -- ID del coche
    c.nombre,                      -- Nombre del coche
    c.precio,                      -- Precio diario
    m.nombre AS marca              -- Nombre de la marca
  FROM coche c
  INNER JOIN modelo mo ON c.id_modelo = mo.id_modelo   -- Relación coche -> modelo
  INNER JOIN marca m ON mo.id_marca = m.id_marca  -- Relación modelo -> marca
  INNER JOIN estado_coche ec ON c.id_estado_coche = ec.id_estado_coche    -- Relación coche -> estado_coche
  WHERE ec.descripcion = 'Disponible'    -- Filtro: solo coches disponibles
);
GO



-- USO DE FUNCIONES

-- Calcular cantidad de días de una reserva
SELECT dbo.fn_CantidadDiasReserva('2025-11-01', '2025-11-05') AS Dias;

-- Calcular total estimado de una reserva
SELECT dbo.fn_TotalReserva(5000, '2025-11-01', '2025-11-05') AS TotalEstimado;

-- Mostrar coches disponibles
SELECT * FROM dbo.fn_CochesDisponibles();


