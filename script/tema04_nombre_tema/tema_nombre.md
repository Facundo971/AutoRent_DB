# TEMA 4 "Triggers"

Un trigger es un procedimiento almacenado que se ejecuta automáticamente al producirse un evento sobre una tabla o vista. Se usa para reaccionar a cambios en los datos sin que el cliente tenga que invocar explícitamente la lógica.

# Eventos que disparan triggers

Los eventos típicos son operaciones sobre los datos: INSERT, UPDATE y DELETE. Al ocurrir uno de esos eventos, el trigger asociado se activa y puede ejecutar lógica adicional (auditoría, validaciones, actualizaciones relacionadas, envío de notificaciones, etc.).

### Caso de estudio

