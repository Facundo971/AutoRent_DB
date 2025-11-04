use AutoRent;
GO

-- Creamos una tabla aparte para testear las optimizaciones, ya que vamos a ocupar índices agrupados más adelante,
-- lo cual no va a permitir que existan pk previas a la creación.
CREATE TABLE detalle_metodo_pago_test
(
  importe DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL CONSTRAINT df_detalle_metodo_pago_fecha_pago_test DEFAULT CAST(GETDATE() AS DATE),
  id_detalle_metodo_pago INT NOT NULL,
  id_reserva INT NOT NULL,
  id_metodo_pago INT NOT NULL,
  CONSTRAINT ck_detalle_metodo_pago_importe_test CHECK (importe >= 0),
  CONSTRAINT ck_detalle_metodo_pago_fecha_pago_test CHECK (fecha_pago <= CAST(GETDATE() AS DATE)),
);

-- 1. Insercion masiva de registros
-- Vamos a usar BULK INSERT para insertar los valores desde una fuente externa, en este caso un .txt, al cual
-- se le indicaron las columnas de la tabla en su primera fila, y a partir de la segunda fila tiene todos los 
-- valores a insertar, separados por comas y terminando su fila con un salto de línea.
BULK INSERT
	detalle_metodo_pago_test
FROM
	'C:\Users\Desktop\bulk_test.txt' -- ubicación del archivo
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
)
SELECT * FROM detalle_metodo_pago_test;


-- 2. Busqueda por período
SELECT TOP 1 * FROM detalle_metodo_pago_test ORDER BY fecha_pago desc;

SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';


-- 3. Busqueda por período con índice agrupado
CREATE CLUSTERED INDEX ix_detalle_metodo_pago_test_cluster ON detalle_metodo_pago_test (fecha_pago);

SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
-- En este caso con una busqueda de poco más de 10% del lote de un millon de registros, el tiempo de ejecución 
-- disminuyó a un 29% del tiempo sin índice y las lecturas lógicas disminuyeron a un 14% aproximado del número de 
-- lecturas lógicas sin índice. 

-- Al ya estar creado un índice agrupado podemos añadir una clave primaria a la tabla, la cual va a añadirse como 
-- un índice no agrupado.
ALTER TABLE detalle_metodo_pago_test ADD CONSTRAINT pk_detalle_metodo_pago_test PRIMARY KEY (id_detalle_metodo_pago, id_reserva);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('detalle_metodo_pago_test');
ALTER TABLE detalle_metodo_pago_test DROP CONSTRAINT pk_detalle_metodo_pago_test;


-- 4. Busqueda por período con índice no agrupado
DROP INDEX ix_detalle_metodo_pago_test_cluster ON detalle_metodo_pago_test;

CREATE NONCLUSTERED INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test (fecha_pago);

SET STATISTICS IO, TIME ON;
-- Creando un índice no cluster y añadiendo una clave primaria compuesta que funcione como índice cluster el
-- tiempo de busqueda disminuye respecto al query sin índice, pero es mayor al tiempo con índice agrupado, y la 
-- cantidad de lecturas supera a ambos, esto es porque creamos un índice no cluster para fecha_pago, además de
-- los íd de la clave primaria cluster a la cual el índice no cluster apunta, pero existen columnas las cuales
-- no tienen un índice como lo son importe e id_metodo_pago a la cual estamos llamando en la consulta.
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';

-- Al hacer una consulta con las columnas al cual los índices no agrupados tienen acceso el tiempo de ejecución y
-- las lecturas lógicas disminuyen considerablemente.
SELECT id_detalle_metodo_pago, id_reserva, fecha_pago FROM detalle_metodo_pago_test 
	WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';

DROP INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test;
CREATE NONCLUSTERED INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test (fecha_pago)
	INCLUDE (importe, id_metodo_pago);

SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
-- Haciendo una consulta con todas las columnas después de incluir las faltantes en el índice no agrupado el tiempo
-- y la cantidad de lecturas también disminuyen considerablemente.



