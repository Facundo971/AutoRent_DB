# Procedimientos y funciones almacenadas

---

## Procedimientos almacenados

### ¿Qué son?

Son un conjunto de instrucciones **SQL** que se almacenan en la base de datos como un solo objeto y se ejecutan como una unidad.

### ¿Para qué sirven?

- Realizar operaciones complejas y automatizar tareas.  
- Reducir el tráfico de red al ejecutar el código en el servidor en lugar de enviarlo desde el cliente.  
- Mejorar el rendimiento porque el plan de ejecución se almacena la primera vez y se reutiliza en ejecuciones posteriores.  
- Aumentar la seguridad, ya que se pueden conceder permisos de ejecución sobre el procedimiento en lugar de permitir acceso directo a las tablas.  
- Reutilizar código.

### Características

- Pueden aceptar parámetros de entrada y salida.  
- Pueden ejecutar declaraciones `SELECT`, `INSERT`, `UPDATE`, `DELETE` y usar lógica de control de flujo como `IF` y `WHILE`.  
- Pueden devolver uno o varios conjuntos de resultados.

---

## Funciones almacenadas

### ¿Qué son?

Son objetos que toman parámetros y devuelven un valor.

### ¿Para qué sirven?

- Realizar cálculos específicos, como una función para calcular el IVA o una comisión.  
- Simplificar la lógica de una consulta al encapsularla en una función reutilizable.  
- Añadir parámetros a objetos similares a vistas, para filtrar resultados.

### Características

- No pueden realizar operaciones de modificación de datos como `INSERT`, `UPDATE`, o `DELETE`.  
- Se utilizan principalmente en expresiones, por ejemplo, en la cláusula `SELECT` o `WHERE`.  
- Se pueden crear diferentes tipos de funciones en SQL Server:
  - **Escalares:** devuelven un valor único.  
  - **Con valores de tabla de múltiples instrucciones.**  
  - **De tabla en línea:** devuelven una tabla.

---
