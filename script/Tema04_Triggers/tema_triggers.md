# TEMA 4 "Triggers"

Un trigger es un procedimiento almacenado que se ejecuta automáticamente al producirse un evento sobre una tabla o vista. Se usa para reaccionar a cambios en los datos sin que el cliente tenga que invocar explícitamente la lógica.

# Eventos que disparan triggers

Los eventos típicos son operaciones sobre los datos: INSERT, UPDATE y DELETE. Al ocurrir uno de esos eventos, el trigger asociado se activa y puede ejecutar lógica adicional (auditoría, validaciones, actualizaciones relacionadas, envío de notificaciones, etc.).

# Tipos generales de triggers

**Triggers DDL**: Se disparan por cambios en la estructura de la base de datos (por ejemplo CREATE TABLE, ALTER, DROP) o por ciertos eventos a nivel servidor. Se emplean para supervisar y registrar cambios en la estructura de la base de datos, por ejemplo cuando se crean, modifican o eliminan objetos del esquema.

**Triggers DML**: Son los más comunes y se activan por operaciones que alteran datos (INSERT, UPDATE, DELETE) sobre tablas o vistas; se utilizan para mantener trazabilidad, reforzar reglas de integridad y automatizar lógica asociada a las modificaciones.

# Sintaxis básica para crear un trigger en SQL

La instrucción CREATE TRIGGER permite crear un nuevo trigger que se activa automáticamente cada vez que ocurre un evento, como INSERT, DELETE o UPDATE en una tabla.

    CREATE TRIGGER nombre_trigger

    ON nombre_tabla

    AFTER | INSTEAD OF (INSERT, UPDATE, DELETE)

    AS

    BEGIN

      -- cuerpo del trigger

    END;

Un trigger siempre está asociado a una tabla o vista y se define para uno o más eventos.

# Modos de ejecución en SQL Server

**AFTER**: se ejecuta después de que la operación sobre la tabla haya concluido correctamente. Es útil para realizar acciones una vez que los datos ya están modificados en la base de datos.

**INSTEAD OF**: se ejecuta en lugar de la operación original. Permite reemplazar, validar o modificar la operación antes de que ocurra. Es apropiado para impedir borrados directos o implementar reglas complejas.

# Pseudotablas INSERTED y DELETED

En SQL Server existen las pseudotablas INSERTED y DELETED, que solo están disponibles dentro del contexto de un trigger y permiten acceder a las filas afectadas por la operación.

**INSERTED**: contiene las filas nuevas (resultantes de un INSERT, o las nuevas versiones en un UPDATE).

**DELETED**: contiene las filas antiguas (filas eliminadas por un DELETE, o las versiones previas en un UPDATE).

Estas pseudotablas deben tratarse en forma set‑based porque una sola sentencia puede afectar múltiples filas.

("Set‑based" = operar sobre todo el conjunto de filas afectadas a la vez, no fila por fila)

# Conclusión

A partir de las pruebas realizadas, se comprobó que los triggers definidos (AFTER UPDATE, AFTER DELETE e INSTEAD OF DELETE) funcionan correctamente para registrar operaciones sensibles sobre la tabla detalle_metodo_pago. Cada trigger logró capturar el estado previo de los datos, registrar el usuario y la fecha de la operación, y en el caso del trigger INSTEAD OF DELETE, bloquear el borrado físico e informar al usuario. Esto garantiza trazabilidad, integridad y control sobre las modificaciones realizadas en la base de datos.
