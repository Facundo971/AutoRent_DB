# Optimización de consultas a través de índices

Un índice es una estructura de datos asociada con una tabla o una vista que acelera la recuperación de filas de las mismas. Contiene claves generadas a partir de una o varias columnas de la tabla o vista. Dichas claves generalmente están almacenadas en una estructura de árbol-B que permite buscar de forma rápida y eficiente la fila o filas asociadas a los valores de cada clave, en lugar de chequear la tabla entera a través de cada fila para encontrar el registro que coincida, ralentizando la operación, específicamente en tablas con grandes cantidades de registros.    
&emsp;Una tabla o una vista puede contener los siguientes tipos de índices:
- **Índice Agrupado(Clustered):** Ordena y almacena las filas de datos de la tabla o vista por orden en función de la clave del índice clúster. Solo puede haber un índice clúster por cada tabla, porque las filas de datos solo pueden estar almacenadas de una forma.
- **Índice Desagrupado(Non Clustered):** Los índices no clúster tienen una estructura separada de las filas de datos. Un índice no clúster contiene los valores de clave de índice no clúster y cada entrada de valor de clave tiene un puntero a la fila de datos que contiene el valor clave.
  
&emsp;También existen índices adicionales de propósito especial, como lo son los índices únicos, hash o espaciales.
