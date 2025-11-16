#MANEJO DE TRANSACCIONES#

El manejo de transacciones es un proceso fundamental en sistemas de gestión de bases de datos (SGBD) que asegura la integridad y consistencia de los datos durante las operaciones de procesamiento.

#Definición y Proceso#

El manejo de transacciones se refiere a la gestión de un conjunto de operaciones que se ejecutan como una unidad lógica de trabajo. En un SGBD, una transacción puede incluir múltiples operaciones de lectura y escritura que deben completarse en su totalidad o no ejecutarse en absoluto. Esto se conoce como atomicidad, una de las propiedades clave de las transacciones. 

#Propiedades ACID#

Las transacciones deben cumplir con las propiedades ACID, que son esenciales para garantizar la integridad de los datos:
*Atomicidad*: Asegura que todas las operaciones dentro de una transacción se completen exitosamente; si alguna falla, se revierte todo el proceso.

*Consistencia*: Garantiza que una transacción lleve a la base de datos de un estado válido a otro estado válido.

*Aislamiento*: Asegura que las transacciones concurrentes no interfieran entre sí, manteniendo la integridad de los datos.

*Durabilidad*: Una vez que una transacción se ha confirmado, sus cambios son permanentes, incluso en caso de fallos del sistema. 

#Estructura de las transacciones#
 La estructura de una transacción usualmente viene dada según el modelo de la transacción, estas pueden ser planas (simples) o anidadas.

*Transacciones planas*: Consisten en una secuencia de operaciones
primitivas encerradas entre las palabras clave BEGIN y END. Por
ejemplo: 

BEGIN TRANSACTION NombreTransaccion

    -- Operaciones de la transacción
    -- Ejemplo: inserciones, actualizaciones, eliminaciones

COMMIT TRANSACTION NombreTransaccion

*Transacciones Anidadas*: Consiste en tener transacciones que dependen de otras, estas transacciones están incluidas dentro de otras de un nivel superior y se las conoce como subtransacciones. La transacción de nivel superior puede producir hijos (subtransacciones) que hagan más fácil la programación del sistema y mejoras del desempeño.

En las transacciones anidadas las operaciones de una transacción pueden ser así mismo otras transacciones. Por ejemplo:

BEGIN TRANSACTION Principal

    -- Operaciones de la transacción principal

    BEGIN TRANSACTION Interna
        -- Operaciones de la transacción interna
    COMMIT TRANSACTION Interna

    -- Más operaciones de la transacción principal

COMMIT TRANSACTION Principal
 
Cabe aclarar que En SQL Server las transacciones anidadas como tal no existen. Cada vez que se ejecuta un BEGIN TRANSACTION, lo que realmente ocurre es que se incrementa un contador interno (@@TRANCOUNT), pero no se crean transacciones independientes. Los COMMIT TRANSACTION simplemente van reduciendo ese contador, y solo cuando llega a cero se confirma la transacción en la base de datos. Por eso, aunque se intente simular una transacción dentro de otra, en caso de error un ROLLBACK TRANSACTION revierte todo lo ejecutado, sin respetar los commits intermedios.
La herramienta más cercana a una transacción anidada en SQL Server es el uso de savepoints mediante SAVE TRANSACTION. Un savepoint permite marcar un punto dentro de la transacción y, si ocurre un error, hacer ROLLBACK TRANSACTION NombreSavepoint para volver a ese estado parcial. De esta manera se puede conservar lo que se ejecutó antes del savepoint y deshacer solo lo que vino después.

BEGIN TRANSACTION Principal

    -- Operaciones de la transacción principal

    SAVEPOINT Interna
        -- Operaciones de la transacción interna
        -- Si algo falla aquí, se puede hacer:
        -- ROLLBACK TO Interna
        -- y volver al estado justo antes de estas operaciones

    -- Más operaciones de la transacción principal

COMMIT TRANSACTION Principal

#Conclusión#

A partir de las pruebas realizadas, se comprobó que las transacciones implementadas (simples, con manejo de errores y con savepoints) funcionan correctamente para garantizar la atomicidad y consistencia de las operaciones en el sistema de alquiler de autos. Las transacciones simples permitieron confirmar o revertir bloques completos de acciones, mientras que el uso de bloques TRY/CATCH aseguró un control adecuado ante fallos. Por su parte, los savepoints demostraron ser el mecanismo más cercano a las transacciones anidadas, ya que posibilitan revertir parcialmente ciertas operaciones sin perder las anteriores. En conjunto, estas técnicas aseguran integridad, confiabilidad y control sobre los procesos críticos de inserción, actualización y reserva dentro de la base de datos.
