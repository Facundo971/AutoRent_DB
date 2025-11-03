# TEMA 4 "Triggers"

Un trigger es un procedimiento almacenado que se ejecuta automáticamente al producirse un evento sobre una tabla o vista. Se usa para reaccionar a cambios en los datos sin que el cliente tenga que invocar explícitamente la lógica.

# Eventos que disparan triggers

Los eventos típicos son operaciones sobre los datos: INSERT, UPDATE y DELETE. Al ocurrir uno de esos eventos, el trigger asociado se activa y puede ejecutar lógica adicional (auditoría, validaciones, actualizaciones relacionadas, envío de notificaciones, etc.).

# Tipos generales de triggers

**Triggers DDL**:Se disparan por cambios en la estructura de la base de datos (por ejemplo CREATE TABLE, ALTER, DROP) o por ciertos eventos a nivel servidor. Se emplean para supervisar y registrar cambios en la estructura de la base de datos, por ejemplo cuando se crean, modifican o eliminan objetos del esquema.

**Triggers DML**:Son los más comunes y se activan por operaciones que alteran datos (INSERT, UPDATE, DELETE) sobre tablas o vistas; se utilizan para mantener trazabilidad, reforzar reglas de integridad y automatizar lógica asociada a las modificaciones.

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
