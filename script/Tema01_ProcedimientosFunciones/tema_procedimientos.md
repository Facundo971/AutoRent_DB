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

### Estructura de un Procedimiento Almacenado (Stored Procedure)

    CREATE PROCEDURE NombreDelProcedimiento       -- Crea y asigna un nombre al procedimiento
        @Parametro1 TipoDato,                     -- Lista de parámetros de entrada
        @Parametro2 TipoDato = ValorPorDefecto,   -- (pueden tener valores por defecto)
        @ParametroSalida TipoDato OUTPUT          -- Parámetros de salida (opcionales)
    AS
      BEGIN                                       -- Inicio del bloque
    
        DECLARE @VariableInterna TipoDato;        -- Declaración de variables internas

        INSERT INTO Tabla (...columnas...)        -- Lógica del procedimiento
        VALUES (...valores...);                   -- Aquí se implementan INSERT, UPDATE, DELETE, SELECT u otras operaciones
    
        SET @ParametroSalida = ...;               -- Asignación de valores a parámetros OUTPUT (si existen)
    
      END;                                        -- Fin del bloque
    GO                                            -- Finaliza la creación del objeto
    
    EXEC NombreDelProcedimiento                   -- Ejecución del procedimiento
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
  - **De tabla :** devuelven una tabla.
    
### Estructura de una Función almacenada (devuelve un valor)

    CREATE FUNCTION NombreDeLaFuncion             -- Crea y asigna un nombre a la función
    (
        @Parametro1 TipoDato,                     -- Parámetros de entrada
        @Parametro2 TipoDato
    )
    RETURNS TipoDato                              -- Tipo de dato que devuelve
    AS
      BEGIN                                       -- Inicio del bloque
    
        DECLARE @Resultado TipoDato;              -- Variable que almacenará el retorno
     
        SELECT @Resultado = ...;                  -- Lógica de la función (Cálculos, SELECT, etc.)
    
        RETURN @Resultado;                        -- Devuelve el resultado
    
      END;                                        -- Fin de la función
    GO                                            -- Finaliza creación

    SELECT dbo.NombreDeLaFuncion(@Parametro1, @Parametro2)   -- Ejecución de la función
---

### Comparación de eficiencia

| Criterio de Comparación                                 | SQL Directo                                            | Procedimiento Almacenado (SP)                           | Función Almacenada                                                 |
| ------------------------------------------------------- | ------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------------ |
| **Velocidad de ejecución**                              | Más lenta (el motor recompila con mayor frecuencia)  | Más rápida (se compila y guarda en caché)             | Rápida, pero depende del uso (más eficiente en cálculos)        |
| **Uso recomendado**                                     | Consultas simples o pruebas rápidas                    | Operaciones CRUD, procesos repetitivos, lógica compleja | Cálculos, validaciones, obtener valores o tablas derivadas         |
| **Reutilización**                                       | Baja (se copia y pega)                               | Alta (se invoca desde app o desde otros SP)           | Muy alta (se puede usar dentro de SELECT, WHERE, JOIN)           |
| **Seguridad**                                           | Expuesto a inyección SQL si se arma en la aplicación | Alto nivel (parámetros, control de permisos)          | Alto, pero no aptas para modificar datos                        |
| **Costos de mantenimiento**                             | Alto (código duplicado en la aplicación)             | Bajo (centralizado en la base)                        | Medio (muchas funciones pequeñas pueden dispersar lógica)       |
| **Capacidad de modificar datos (INSERT/UPDATE/DELETE)** | Sí                                                   | Sí                                                    | No (las funciones no permiten modificar datos)                   |
| **Consumo de recursos**                                 | Depende de la consulta                              | Optimizado (plan de ejecución guardado)               | Puede ser costosa si se llama muchas veces en grandes consultas |
| **Control de errores**                                  | Limitado                                             | Muy bueno (TRY/CATCH, transacciones)                  | Muy limitado                                                     |
| **Flexibilidad**                                        | Alta pero desordenada                               | Alta y organizada                                     | Media (restricciones del motor)                                 |
| **Impacto en el tráfico entre aplicación y servidor**   | Alto (envía consultas completas)                     | Bajo (solo se envía el nombre y parámetros)           | Bajo, similar a SP pero con limitaciones                        |

### Conclusión
- Para operaciones repetitivas o críticas, los procedimientos almacenados son más eficientes. 
- Para cálculos o expresiones reutilizables, las funciones son ideales. 
- Usar ambos mejora la seguridad, rendimiento y mantenibilidad del sistema.

