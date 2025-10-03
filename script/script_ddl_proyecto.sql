-- SCRIPT TEMA "Alquiler de Autos"
--Tabla metodo_pago
CREATE TABLE metodo_pago
(
  id_metodo_pago INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  CONSTRAINT pk_metodo_pago PRIMARY KEY (id_metodo_pago)
);

--Tabla estado_reserva
CREATE TABLE estado_reserva
(
  id_estado_reserva INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT pk_estado_reserva PRIMARY KEY (id_estado_reserva),
  CONSTRAINT ck_estado_reserva_descripcion CHECK (descripcion IN ('Pendiente', 'En Proceso', 'Finalizado'))
);

--Tabla marca
CREATE TABLE marca
(
  id_marca INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  CONSTRAINT pk_marca PRIMARY KEY (id_marca)
);

--Tabla estado_coche
CREATE TABLE estado_coche
(
  id_estado_coche INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT pk_estado_coche PRIMARY KEY (id_estado_coche),
  CONSTRAINT ck_estado_coche_descripcion CHECK (descripcion IN ('Disponible', 'No disponible'))
);

--Tabla tipo_usuario
CREATE TABLE tipo_usuario
(
  id_tipo_usuario INT NOT NULL,
  descripcion VARCHAR(50) NOT NULL,
  CONSTRAINT pk_tipo_usuario PRIMARY KEY (id_tipo_usuario),
  CONSTRAINT ck_tipo_usuario_descripcion CHECK (descripcion IN ('Cliente', 'Administrador'))
);

--Tabla usuario
CREATE TABLE usuario
(
  id_usuario INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  dni INT NOT NULL,
  telefono VARCHAR(20) CONSTRAINT df_usuario_telefono DEFAULT '0000000000',
  direccion VARCHAR(100) CONSTRAINT df_usuario_direccion DEFAULT 'Desconocida',
  email VARCHAR(100) NOT NULL,
  contrasenia VARCHAR(20) NOT NULL,
  fecha_registro DATE NOT NULL CONSTRAINT df_usuario_fecha_registro DEFAULT CAST(GETDATE() AS DATE),
  id_tipo_usuario INT NOT NULL,
  CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT fk_usuario_tipo_usuario FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario),
  CONSTRAINT uq_usuario_dni UNIQUE (dni),
  CONSTRAINT uq_usuario_email UNIQUE (email),
  CONSTRAINT ck_usuario_dni CHECK (dni BETWEEN 10000000 AND 99999999),
  CONSTRAINT ck_usuario_telefono CHECK (telefono NOT LIKE '%[^0-9]%' AND LEN(telefono) = 10),
  CONSTRAINT ck_usuario_fecha_registro CHECK (fecha_registro <= CAST(GETDATE() AS DATE))
);

--Tabla modelo
CREATE TABLE modelo
(
  id_modelo INT NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  id_marca INT NOT NULL,
  CONSTRAINT pk_modelo PRIMARY KEY (id_modelo),
  CONSTRAINT fk_modelo_marca FOREIGN KEY (id_marca) REFERENCES marca(id_marca)
);

--Tabla coche
CREATE TABLE coche
(
  id_coche INT NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  anio_fabricacion INT NOT NULL,
  descripcion VARCHAR(255) NOT NULL,
  imagen VARCHAR(255) NOT NULL,
  fecha_registro DATE NOT NULL CONSTRAINT df_coche_fecha_registro DEFAULT CAST(GETDATE() AS DATE),
  id_modelo INT NOT NULL,
  id_estado_coche INT NOT NULL,
  CONSTRAINT pk_coche PRIMARY KEY (id_coche),
  CONSTRAINT fk_coche_modelo FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo),
  CONSTRAINT fk_coche_estado_coche FOREIGN KEY (id_estado_coche) REFERENCES estado_coche(id_estado_coche),
  CONSTRAINT ck_coche_precio CHECK (precio >= 0),
  CONSTRAINT ck_coche_anio_fabricacion CHECK (anio_fabricacion BETWEEN 1886 AND YEAR(GETDATE())),
  CONSTRAINT ck_coche_fecha_registro CHECK (fecha_registro <= CAST(GETDATE() AS DATE))
);

--Tabla reserva
CREATE TABLE reserva
(
  id_reserva INT NOT NULL,
  fecha_retiro DATE NOT NULL CONSTRAINT df_reserva_fecha_retiro DEFAULT CAST(GETDATE() AS DATE),
  fecha_devolucion DATE NOT NULL,
  hora_retiro TIME NOT NULL CONSTRAINT df_reserva_hora_retiro DEFAULT CAST(GETDATE() AS TIME),
  hora_devolucion TIME NOT NULL,
  precio_total DECIMAL(10,2) NOT NULL,
  id_usuario INT NOT NULL,
  id_estado_reserva INT NOT NULL,
  id_coche INT NOT NULL,
  CONSTRAINT pk_reserva PRIMARY KEY (id_reserva),
  CONSTRAINT fk_reserva_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_reserva_estado_reserva FOREIGN KEY (id_estado_reserva) REFERENCES estado_reserva(id_estado_reserva),
  CONSTRAINT fk_reserva_coche FOREIGN KEY (id_coche) REFERENCES coche(id_coche),
  CONSTRAINT ck_reserva_precio CHECK (precio_total >= 0),
  CONSTRAINT ck_reserva_fecha_retiro CHECK (fecha_retiro <= CAST(GETDATE() AS DATE)), 
  CONSTRAINT ck_reserva_hora_retiro CHECK (hora_retiro <= CAST(GETDATE() AS TIME)),
  CONSTRAINT ck_reserva_fechas CHECK (fecha_retiro <= fecha_devolucion)
);

--Tabla detalle_metodo_pago
CREATE TABLE detalle_metodo_pago
(
  importe DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL CONSTRAINT df_detalle_metodo_pago_fecha_pago DEFAULT CAST(GETDATE() AS DATE),
  id_detalle_metodo_pago INT NOT NULL,
  id_reserva INT NOT NULL,
  id_metodo_pago INT NOT NULL,
  CONSTRAINT pk_detalle_metodo_pago PRIMARY KEY (id_detalle_metodo_pago, id_reserva),
  CONSTRAINT fk_detalle_metodo_pago_reserva FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
  CONSTRAINT fk_detalle_metodo_pago_metodo_pago FOREIGN KEY (id_metodo_pago) REFERENCES metodo_pago(id_metodo_pago),
  CONSTRAINT ck_detalle_metodo_pago_importe CHECK (importe >= 0),
  CONSTRAINT ck_detalle_metodo_pago_fecha_pago CHECK (fecha_pago <= CAST(GETDATE() AS DATE)),
);