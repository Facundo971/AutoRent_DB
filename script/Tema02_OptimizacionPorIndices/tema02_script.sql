use AutoRent;
GO


-- Creamos una tabla aparte para testear las optimizaciones, ya que vamos a ocupar índices agrupados más adelante,
-- lo cual va a entrar en conflicto con la clave primaria de la tabla original.
CREATE TABLE detalle_metodo_pago_test
(
  importe DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL,
  id_detalle_metodo_pago INT NOT NULL,
  id_reserva INT NOT NULL,
  id_metodo_pago INT NOT NULL
);


----------------------------------------------------------------------------------------------
-- 1. Insercion masiva de registros
-- Vamos a usar BULK INSERT para insertar los valores desde una fuente externa, en este caso un .txt, al cual
-- se le indicaron las columnas de la tabla en su primera fila, y a partir de la segunda fila tiene todos los 
-- valores a insertar, separados por comas y terminando su fila con un salto de línea.
BULK INSERT
	detalle_metodo_pago_test
FROM
	'C:\Users\Desktop\bulk_test.txt' -- ubicación del archivo
WITH(
	FIELDTERMINATOR = ',', -- separador de campos
	ROWTERMINATOR = '\n', -- separador de filas
	FIRSTROW = 2 -- fila desde la que se empieza la inserción de datos
)

SELECT * FROM detalle_metodo_pago_test;


----------------------------------------------------------------------------------------------
-- 2. Busqueda por período
SELECT TOP 1 * FROM detalle_metodo_pago_test ORDER BY fecha_pago desc;

-- Activamos estadísticas de lecturas físicas y lógicas, así como de tiempo, y hacemos la busqueda.
SET STATISTICS IO, TIME ON; 
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';


----------------------------------------------------------------------------------------------
-- 3. Busqueda por período con índice agrupado
CREATE CLUSTERED INDEX ix_detalle_metodo_pago_test_cluster ON detalle_metodo_pago_test (fecha_pago);
SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('detalle_metodo_pago_test'); -- muestra los índices

SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
-- En este caso con una busqueda de poco más de 10% del lote de un millon de registros, el tiempo de ejecución 
-- disminuyó a un 29% del tiempo sin índice y las lecturas lógicas disminuyeron a un 14% aproximado del número de 
-- lecturas lógicas sin índice. 

-- Al ya estar creado un índice agrupado podemos añadir una clave primaria a la tabla, la cual va a añadirse como 
-- un índice no agrupado.
-- ALTER TABLE detalle_metodo_pago_test ADD CONSTRAINT pk_detalle_metodo_pago_test PRIMARY KEY (id_detalle_metodo_pago, id_reserva);
-- ALTER TABLE detalle_metodo_pago_test DROP CONSTRAINT pk_detalle_metodo_pago_test;

-- Borramos el índice agrupado
DROP INDEX ix_detalle_metodo_pago_test_cluster ON detalle_metodo_pago_test;


----------------------------------------------------------------------------------------------
-- 4. Busqueda por período con índice no agrupado

-- Primera busqueda con índice no agrupado sin inclusiones
CREATE NONCLUSTERED INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test (fecha_pago); 

SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
-- Al hacer una consulta con columnas a las cuales el índice no tiene acceso, se termina haciendo un recorrido de 
-- tabla, con lo cual el tiempo de ejecución y las lecturas lógicas se ven afectados.

DROP INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test; -- borramos el índice no agrupado.

-- Segunda busqueda agregando columnas faltantes
CREATE NONCLUSTERED INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test (fecha_pago)
	INCLUDE (importe, id_detalle_metodo_pago, id_reserva, id_metodo_pago);

SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
-- Al hacer la busqueda con las columnas faltantes el tiempo y las lecturas disminuyeron bastante, incluso siendo
-- menores a la busqueda por índice agrupado en este caso.


-- Borramos la tabla de prueba
DROP TABLE detalle_metodo_pago_test;
