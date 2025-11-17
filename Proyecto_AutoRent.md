# Sistema de Alquiler de Autos - AutoRent
    
**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Carrera**: Licenciatura en Sistemas de Información

**Fecha**: 29-09-2025

**Profesores**: Darío Villegas, Juan Jose Cuzziol, Walter Vallejos, Numa Badaracco.

**Grupo Número**: 16.

**Integrantes**:
 - Encinas Gastón Francisco.
 - Fernández González Facundo Antonio.
 - Fernández Axel Joel.
 - Méndez Nazareno.

**Año**: 2025

# Índice

1. [CAPÍTULO I: INTRODUCCIÓN](#capítulo-i-introducción)
    1.    [Caso de estudio](#caso-de-estudio)
    2.    [Definición o planteamiento del problema](#definición-o-planteamiento-del-problema)
    3.    [Objetivos del Trabajo Práctico](#objetivos-del-trabajo-práctico)
2. [CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL](#capítulo-ii-marco-conceptual-o-referencial)
3. [CAPÍTULO III: METODOLOGÍA SEGUIDA](#capítulo-iii-metodología-seguida)
    1. [Desarrollo del Trabajo Práctico](#a-cómo-se-realizó-el-trabajo-práctico)
    2. [Herramientas Usadas](#b-herramientas-instrumentos-y-procedimientos)
4. [CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS](#capítulo-iv-desarrollo-del-tema--presentación-de-resultados)
5. [CAPÍTULO V: CONCLUSIONES](#capítulo-v-conclusiones)
6. [CAPÍTULO VI: BIBLIOGRAFÍA DE CONSULTA](#bibliografía-de-consulta)


## CAPÍTULO I: INTRODUCCIÓN

### Caso de estudio

El trabajo práctico aborda el diseño e implementación de una base de datos relacional para una plataforma de gestión de alquiler de autos denominada **AutoRent**, orientada a empresas turísticas en la ciudad de Corrientes y alrededores. 

El foco está puesto en la estructuración lógica y física de los datos necesarios para administrar reservas, clientes, vehículos, métodos de pago y reportes, garantizando integridad, eficiencia y escalabilidad.

### Definición o planteamiento del problema

Actualmente, muchas empresas de alquiler de autos en Corrientes operan con registros manuales o sistemas fragmentados, lo que genera problemas como: 

- Inconsistencias en la disponibilidad de vehículos. 

- Dificultades para consultar historiales de clientes y alquileres. 

- Pérdida de información relevante. 

- Falta de trazabilidad en el mantenimiento y uso de los autos. 

Por lo tanto, el problema que se plantea es: 

¿Cómo diseñar una base de datos relacional que permita modelar de forma eficiente y segura los procesos de reserva, administración de vehículos, gestión de clientes y generación de reportes para una empresa de alquiler de autos? 

### Objetivos del Trabajo Práctico

**Objetivo General** 

Diseñar e implementar una base de datos relacional que respalde el funcionamiento integral de la plataforma **AutoRent**, permitiendo almacenar, consultar y administrar la información clave del negocio de alquiler de autos. 

**Objetivos Específicos** 

- Modelar entidades y relaciones que representen clientes, vehículos, método de pago, y reservas. 

- Definir claves primarias, foráneas y restricciones de integridad para garantizar consistencia de los datos.

- Implementar procedimientos almacenados y triggers para automatizar tareas como actualización de disponibilidad o vencimiento de contratos. 

- Diseñar consultas SQL que permitan generar reportes financieros, históricos de alquiler y estadísticas de uso. 

- Evaluar el rendimiento de la base de datos ante operaciones concurrentes y proponer mejoras de indexación. 

- Documentar el modelo entidad-relación y el diccionario de datos para facilitar futuras ampliaciones del sistema. 


## CAPÍTULO II: MARCO CONCEPTUAL O REFERENCIAL

La presente investigación se enmarca en el uso de las Tecnologías de la Información y la Comunicación (TICs) aplicadas al sector turístico regional, con especial énfasis en el diseño de sistemas de gestión basados en bases de datos relacionales. En un contexto de creciente digitalización, las empresas de alquiler de autos enfrentan el desafío de modernizar sus procesos para mejorar la eficiencia operativa, la trazabilidad de sus recursos y la experiencia del cliente. 

Desde una perspectiva de desarrollo regional, la incorporación de soluciones tecnológicas como **AutoRent** contribuye a fortalecer las cadenas productivas locales, mejorar la competitividad del sector turístico y promover un crecimiento sustentable. 

La disponibilidad de información confiable y estructurada permite tomar decisiones estratégicas basadas en datos, lo cual es clave para el desarrollo económico de ciudades como Corrientes. 

El diseño de la base de datos se apoya en conceptos fundamentales de la informática y la ingeniería de software, entre los cuales se destacan: 

- Bases de datos relacionales: modelo que organiza la información en tablas relacionadas mediante claves primarias y foráneas, facilitando la integridad y consistencia de los datos. 

- Modelado entidad-relación (E-R): técnica que permite representar gráficamente las entidades del sistema, sus atributos y las relaciones entre ellas, como clientes, vehículos, métodos de pagos, y reservas. 

- Normalización: proceso que busca eliminar redundancias y dependencias no deseadas, mejorando la eficiencia del almacenamiento y la calidad de los datos. 

- Seguridad y respaldo de datos: prácticas orientadas a proteger la información contra accesos no autorizados, pérdidas o alteraciones, asegurando la continuidad del servicio. 

Para la implementación técnica se utilizará SQL Server Management Studio (SSMS), una herramienta de administración que permite diseñar, consultar y mantener bases de datos en el motor Microsoft SQL Server. Esta elección se fundamenta en su robustez, escalabilidad y soporte para procedimientos almacenados, triggers, vistas y funciones, elementos clave para la gestión eficiente de sistemas transaccionales como el de alquiler de autos. 


## CAPÍTULO III: METODOLOGÍA SEGUIDA 

#### a) Cómo se realizó el Trabajo Práctico
El desarrollo del trabajo práctico se realizó siguiendo una metodología estructurada, orientada al diseño e implementación de una base de datos relacional para el sistema ***AutoRent***. El proceso se dividió en etapas secuenciales que permitieron abordar el problema desde su conceptualización hasta su implementación técnica, garantizando un flujo de trabajo ordenado y coherente

**Etapas principales:**

• Definición del problema y objetivos: Se identificaron las limitaciones en la gestión manual del alquiler de autos en Corrientes y se estableció como objetivo el diseño de una base de datos que permita digitalizar y centralizar la información clave del negocio. Además, se buscó mejorar la eficiencia operativa y reducir los errores derivados de los registros manuales.

• Relevamiento de requisitos: Se analizaron las necesidades de información del sistema, incluyendo entidades como clientes, vehículos, métodos de pagos y reservas. Se definieron los atributos relevantes y las relaciones entre ellos, asegurando que la estructura contemplara tanto los procesos actuales como posibles ampliaciones futuras.

• Modelado conceptual: Se elaboró el diagrama entidad-relación (E-R) para representar las entidades, sus atributos y relaciones. Se incluyeron cardinalidades, claves primarias y foráneas, y se documentó el diccionario de datos. Este paso permitió validar la lógica del sistema antes de avanzar hacia la implementación. 

• Normalización: Se aplicaron las reglas de normalización hasta la tercera forma normal (3FN) para garantizar la integridad y evitar redundancias. Con ello se logró una base sólida que facilita el mantenimiento y asegura la consistencia de la información a largo plazo.

• Implementación física: Se utilizó SQL Server Management Studio para crear las tablas, definir restricciones, cargar datos de prueba y ejecutar consultas SQL. Se implementaron procedimientos almacenados y triggers para automatizar tareas como la actualización de disponibilidad y el registro de contratos, optimizando así la operatividad del sistema. 

• Validación y pruebas: Se realizaron pruebas de integridad referencial, consultas de verificación y simulaciones de uso para evaluar el rendimiento y la consistencia de la base de datos. Estas pruebas permitieron detectar posibles ajustes y confirmar que el sistema respondiera adecuadamente a los escenarios planteados. 

Este enfoque permitió una construcción progresiva y controlada del sistema de información, asegurando que la base de datos cumpla con los requisitos funcionales y técnicos del proyecto, al mismo tiempo que sienta las bases para futuras mejoras y escalabilidad.

 #### b) Herramientas (Instrumentos y procedimientos)

Para la recolección, análisis y tratamiento de la información se utilizaron los siguientes instrumentos y procedimientos: 

**• Revisión bibliográfica y documental:** Se consultaron textos académicos sobre bases de datos relacionales, normalización, modelado E-R y gestión de transacciones. También se revisaron guías metodológicas de la asignatura y estándares de documentación. 

**• Internet y fuentes digitales:** Se utilizaron recursos como la documentación oficial de SQL Server, artículos especializados en diseño de bases de datos y materiales sobre TICs aplicadas al turismo. 

**• Herramientas de software:** 

• ERDPlus: Para el diseño del modelo conceptual y el modelo relacional. 

• SQL Server Management Studio: Para la creación, mantenimiento y prueba de la base de datos. 

• Excel y Word: Para la elaboración del diccionario de datos, documentación técnica y presentación del trabajo.


## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 

### Diagrama relacional
![diagrama_relacional](https://github.com/Facundo971/AutoRent_DB/blob/main/doc/image_relational.png)

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.

## Desarrollo TEMA 1 "Procedimientos y funciones almacenadas"

[Acceder a la carpeta script → tema 1](https://github.com/Facundo971/AutoRent_DB/tree/main/script/Tema01_ProcedimientosFunciones)

## Desarrollo TEMA 2 "Optimización de consultas a través de índices"

[Acceder a la carpeta script → tema 2](https://github.com/Facundo971/AutoRent_DB/tree/main/script/Tema02_OptimizacionPorIndices)

## Desarrollo TEMA 3 "Manejo de transacciones y transacciones anidadas"

[Acceder a la carpeta script → tema 3](https://github.com/Facundo971/AutoRent_DB/tree/main/script/Tema03_ManejoDeTransacciones)

## Desarrollo TEMA 4 "Triggers"

[Acceder a la carpeta script → tema 4](https://github.com/Facundo971/AutoRent_DB/tree/main/script/Tema04_Triggers)


## CAPÍTULO V: CONCLUSIONES

A partir del desarrollo del trabajo, se concluye que el diseño e implementación de la base de datos para el sistema ***AutoRent*** permitió resolver las principales limitaciones detectadas en la gestión manual del servicio de alquiler de autos en Corrientes. 

La estructura relacional propuesta, basada en un modelo entidad-relación normalizado, logró representar de manera eficiente las entidades clave del negocio, garantizando integridad referencial, consistencia de datos y escalabilidad. 

La implementación en SQL Server Management Studio permitió validar el modelo mediante la creación de tablas, relaciones, restricciones y procedimientos almacenados, demostrando que el sistema puede operar de forma segura y automatizada. Las consultas SQL diseñadas permitieron generar reportes útiles para la toma de decisiones, como historiales de alquiler, disponibilidad de vehículos y estadísticas de uso. 

Se puede afirmar que los objetivos generales y específicos del trabajo fueron alcanzados, ya que se logró: 

• Representar fielmente la lógica del negocio en una base de datos relacional. 

• Optimizar el almacenamiento y recuperación de información. 

• Automatizar procesos clave mediante funciones del motor SQL. 

• Documentar el diseño de forma clara y reutilizable. 

En síntesis, el trabajo realizado no solo resuelve las ineficiencias del sistema actual, sino que sienta las bases para una solución tecnológica robusta, adaptable y alineada con las necesidades del sector turístico regional. 


## BIBLIOGRAFÍA DE CONSULTA

[1] Unidad 2, Unidad 3 y Unidad 5: Diseño de Bases de Datos, Modelo Relacional 
y SQL Avanzado, Aula Virtual UNNE, [En línea]. Disponible en: [https://elibro.net/es/ereader/unne/121283 ](https://elibro.net/es/ereader/unne/70030?page=1)

[2] J. C. Pérez, Bases de Datos Relacionales: Fundamentos y Aplicaciones, 
Editorial Alfaomega, 2018. 

[3] P. Parada, Reference Guide: IEEE Style, Oficina de Tesis del Departamento de Ingeniería Eléctrica y Computación, Universidad de Illinois, 2008.

[4] Microsoft Learn, "CREATE TRIGGER (Transact-SQL)", [En línea]. Disponible en: https://learn.microsoft.com/sql/t-sql/statements/create-trigger-transact-sql

[5] Microsoft Learn, "Uso de las tablas inserted y deleted", [En línea]. Disponible en: https://learn.microsoft.com/sql/relational-databases/triggers/use-the-inserted-and-deleted-tables

[6] SQLShack, "Triggers in SQL Server", [En línea]. Disponible en: https://www.sqlshack.com/triggers-in-sql-server/

[7] SQLShack, "Magic Tables in SQL Server", [En línea]. Disponible en: https://www.sqlshack.com/magic-tables-in-sql-server/

[8] Educative.io, "BEFORE vs AFTER triggers", [En línea]. Disponible en: https://www.educative.io/answers/difference-between-a-before-trigger-and-an-after-trigger
