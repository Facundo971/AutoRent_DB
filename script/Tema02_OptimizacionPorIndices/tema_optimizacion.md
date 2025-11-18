# Optimización de consultas a través de índices

Un índice es una estructura de datos asociada con una tabla o una vista que acelera la recuperación de filas de las mismas. Contiene claves generadas a partir de una o varias columnas de la tabla o vista. Dichas claves generalmente están almacenadas en una estructura de árbol-B que permite buscar de forma rápida y eficiente la fila o filas asociadas a los valores de cada clave, en lugar de chequear la tabla entera a través de cada fila para encontrar el registro que coincida, ralentizando la operación, específicamente en tablas con grandes cantidades de registros.    
Una tabla o una vista puede contener los siguientes tipos de índices:
- **Índice Agrupado(Clustered):** Ordena y almacena las filas de datos de la tabla o vista por orden en función de la clave del índice clúster. Solo puede haber un índice clúster por cada tabla, porque las filas de datos solo pueden estar almacenadas de una forma.
- **Índice No agrupado(Non Clustered):** Los índices no agrupados tienen la misma estructura de árbol-B que los índices agrupados, con la diferencia de que:
    - Las filas de datos de la tabla subyacente no se ordenan y almacenan en orden en función de sus claves no agrupadas.
    - El nivel de hoja del índice no contiene datos, sino páginas de índice que incluyen las claves y los punteros hacia las filas reales.
  
También existen índices adicionales de propósito especial, como lo son los índices únicos, hash o espaciales.
  
También existen índices adicionales de propósito especial, como lo son los índices únicos, hash o espaciales.

## Pruebas realizadas

1. Creación de tablas e inserción masiva de datos
   
Para las pruebas realizadas, vamos a crear una tabla alterna sin restricciones, con el fin de testear las optimizaciones, teniendo en cuenta que más adelante necesitaremos crear un índice agrupado que puede entrar en conflicto con nuestra clave primaria. En este caso vamos a usar la tabla detalle_metodo_pago, la cual se espera esté entre las tablas con más inserciones de la base de datos.

```
CREATE TABLE detalle_metodo_pago_test
(
  importe DECIMAL(10,2) NOT NULL,
  fecha_pago DATE NOT NULL 
  id_detalle_metodo_pago INT NOT NULL,
  id_reserva INT NOT NULL,
  id_metodo_pago INT NOT NULL
);
```

Para la inserción se va a trabajar con BULK INSERT para insertar los valores desde una fuente externa, indicandosele los parametros de inserción (omitir la primera fila donde se indican las columnas de la tabla, separar los valores por comas y separar las filas por saltos de línea).

```
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
```

2. Consulta inicial por período sin índices

Se realiza una consulta sin índice por período para futura comparación, y usamos SET STATISTICS IO, TIME ON para medir la cantidad de actividad física y lógica, así como las estadísticas del tiempo de la sentencia.

```
SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
```

3. Consulta con índice agrupado
```
CREATE CLUSTERED INDEX ix_detalle_metodo_pago_test_cluster ON detalle_metodo_pago_test (fecha_pago);

SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('detalle_metodo_pago_test'); -- muestra los índices

SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
```
En este caso con una busqueda de poco más de 10% del lote de un millon de registros, el tiempo de ejecución 
disminuyó a un 29% del tiempo sin índice y las lecturas lógicas disminuyeron a un 14% aproximado del número de lecturas lógicas sin índice.

4. Consulta con índice no agrupado

Creamos un índice no agrupado en fecha_pago, e incluimos columnas que vamos a usar en la consulta
```
CREATE NONCLUSTERED INDEX ix_detalle_metodo_pago_test_noncluster ON detalle_metodo_pago_test (fecha_pago)
	INCLUDE (importe, id_detalle_metodo_pago, id_reserva, id_metodo_pago);

-- realizamos la consulta
SET STATISTICS IO, TIME ON;
SELECT * FROM detalle_metodo_pago_test WHERE fecha_pago BETWEEN '2024-10-31' AND '2025-10-31';
```

La consulta con el índice no agrupado mejoró en gran medida el tiempo de ejecución, y también redujo el costo de la consulta respecto a una busqueda sin índice y la cantidad de lecturas lógicas. También se redujo ligeramente estos parámetros respecto a la busqueda con índice agrupado, pero se vieron mejores resultados para índices no agrupados que incluyan menos columnas, y con busquedas más específicas a estas.

## Conclusiones
Los índices pueden llegar a ser muy útiles cuando se necesita eficiencia a la hora de usar consultas, específicamente cuando estamos manejando grandes cantidades de datos, aunque es necesario saber usarlos para asegurarse de poder sacarle el mejor provecho a las características de cada uno, ya sea ordenamiento, eficiencia en cuanto a memoria, o la manera en la que cada uno de estos accede a los datos.
