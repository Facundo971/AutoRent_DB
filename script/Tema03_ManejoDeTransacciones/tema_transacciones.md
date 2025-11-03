Transaciones 

Las transacciones son colecciones de acciones que potencialmente modifican dos o más entidades. Un ejemplo de transacción es una transferencia de fondos entre dos cuentas bancarias. La transacción consiste en debitar la cuenta de origen, acreditar la cuenta de destino y registrar el hecho de que esto ocurrió. Las transacciones no son simplemente el dominio de las bases de datos; en cambio, son problemas que son potencialmente pertinentes para todos sus niveles arquitectónicos. Por lo tanto, corresponde a todos los desarrolladores comprender los fundamentos del control de transacciones. 

1. Introducción al control de transacciones 

Comencemos con algunas definiciones. Bernstein y Newcomer (1997) distinguen entre: 

Transacciones comerciales. Una transacción comercial es una interacción en el mundo real donde se intercambia algo. 

Transacción en línea. Una transacción en línea es la ejecución de un programa que realiza una función administrativa o en tiempo real, a menudo accediendo a fuentes de datos compartidas, generalmente en nombre de un usuario en línea. Este programa de operaciones contiene los pasos implicados en la operación. Esta definición de una transacción en línea deja en claro que hay mucho más en este tema que transacciones de bases de datos. 

Un sistema de procesamiento de transacciones (TP) es el hardware y el software que implementa los programas de transacción. Un monitor TP es una parte de un sistema TP que actúa como una especie de embudo o concentrador para programas de transacciones, conectando múltiples clientes a múltiples programas de servidor. En un sistema distribuido, un monitor TP también optimizará el uso de la red y los recursos de hardware. Ejemplos de monitores de TP incluyen el Sistema de Control de Información de Clientes (CICS) de IBM y el Sistema de Gestión de Información (IMS) de IBM. 

El enfoque de este artículo está en los fundamentos de las transacciones en línea (por ejemplo, el aspecto técnico de las cosas). Los conceptos críticos son: 

ACID

Confirmaciones en dos fases 

Transacciones anidadas 

2. Control de transacciones: las propiedades de ACID 

Un fundamento importante de las transacciones son las cuatro propiedades que deben exhibir: 

Atomicidad. Se produce toda la transacción o no se produce nada en la transacción; no hay punto intermedio. En SQL, los cambios se vuelven permanentes cuando se emite una instrucción COMMIT y se anulan en una instrucción ROLLBACK. Por ejemplo, la transferencia de fondos entre dos cuentas es una transacción. Si transferimos $20 de la cuenta A a la cuenta B, al final de la transacción el saldo de A será $20 más bajo y el saldo de B será $20 más alto (si la transacción se completa) o ninguno de los saldos habrá cambiado (si se cancela la transacción). 

Consistencia. Cuando se inicia la transacción, las entidades están en un estado consistente, y cuando finaliza la transacción, las entidades están una vez más en un estado consistente, aunque diferente. La implicación es que las reglas de integridad referencial y las reglas comerciales aplicables aún se aplican después de que se completa la transacción. 

Aislamiento. Todas las transacciones funcionan como si solo estuvieran operando en las entidades. Por ejemplo, supongamos que una cuenta bancaria contiene $200 y cada uno de nosotros está tratando de retirar $50. Independientemente del orden de las dos transacciones, al final de ellas el saldo de la cuenta será de $100, suponiendo que ambas transacciones funcionen. Esto es cierto incluso si ambas transacciones ocurren simultáneamente. Sin la propiedad de aislamiento, dos retiros simultáneos de $50 podrían resultar en un saldo de $150 (ambas transacciones vieron un saldo de $200 al mismo tiempo, por lo que ambas escribieron un nuevo saldo de $150). El aislamiento a menudo se conoce como serialización. 

Durabilidad. Las entidades se almacenan en un medio persistente, como una base de datos relacional o un archivo, de modo que si el sistema falla, las transacciones siguen siendo permanentes. 

3. Control de transacciones: confirmaciones de dos fases (2PC) 

Como su nombre indica, hay dos fases en el protocolo 2PC: la fase de intento en la que cada sistema prueba su parte de la transacción y la fase de confirmación en la que se les dice a los sistemas que persistan en la transacción. El protocolo 2PC requiere la existencia de un administrador de transacciones para coordinar la transacción. El administrador de transacciones asignará un ID de transacción único a la transacción para identificarla. Luego, el administrador de transacciones envía los diversos pasos de transacción a cada sistema de registro para que puedan intentarlos, cada sistema responde al administrador de transacciones con el resultado del intento. Si un intento de paso tiene éxito, en este punto el sistema de registro debe bloquear las entidades apropiadas y conservar los cambios potenciales de alguna manera (para garantizar la durabilidad) hasta la fase de confirmación. Una vez que el administrador de transacciones recibe una respuesta de todos los sistemas de registro de que los pasos se realizaron correctamente, o una vez que recibe una respuesta de que un paso falló, envía una solicitud de confirmación o anulación a todos los sistemas involucrados. 

4. Control de transacciones: transacciones anidadas 

Hasta ahora he discutido transacciones planas, transacciones cuyos pasos son actividades individuales. Una transacción anidada es una transacción en la que algunos de sus pasos son otras transacciones, denominadas subtransacciones. Las transacciones anidadas tienen varias características importantes: 

Cuando un programa inicia una nueva transacción, si ya está dentro de una transacción existente, se inicia una subtransacción, de lo contrario, se inicia una nueva transacción de nivel superior. 

No es necesario que haya un límite en la profundidad del anidamiento de transacciones. 

Cuando se anula una subtransacción, se deshacen todos sus pasos, incluidas todas sus subtransacciones. Sin embargo, esto no provoca la anulación de la transacción principal, sino que la transacción principal simplemente se notifica de la anulación. 

Cuando se ejecuta una subtransacción, las entidades que se actualizan no son visibles para otras transacciones o subtransacciones (según la propiedad de aislamiento). 

Cuando se confirma una subtransacción, las entidades actualizadas se hacen visibles para otras transacciones y subtransacciones. 

5. Control de transacciones: implementación de transacciones 

Aunque a menudo se piensa en las transacciones como un problema de base de datos, la realidad podría estar más lejos de la verdad. Desde la introducción de monitores de TP como CICS y Tuxedo en las décadas de 1970 y 1980, hasta los agentes de solicitud de objetos (ORB) basados en CORBA de principios de la década de 1990 y los servidores de aplicaciones EJB de principios de la década de 2000, la transacción ha sido claramente mucho más que un problema de base de datos. Esta sección explora tres enfoques para implementar transacciones que involucran tanto tecnología de objetos como relacional. Este material está dirigido a desarrolladores de aplicaciones, así como a ingenieros de datos ágiles que necesitan explorar estrategias que quizás no hayan encontrado en la literatura tradicional orientada a datos. Estas opciones de implementación son: 

Transacciones de base de datos 

Transacciones de objetos 

Transacciones de objetos distribuidos 

Incluir pasos no transaccionales 

5.1 Transacciones de base de datos 

La forma más sencilla de que una aplicación implemente transacciones es usar las características proporcionadas por la base de datos. Las transacciones se pueden iniciar, intentar y luego confirmar o abortar a través del código SQL. Mejor aún, las API de base de datos como Java Database Connectivity (JDBC) y Open Database Connectivity (ODBC) proporcionan clases que admiten la funcionalidad transaccional básica. 

  

5.2 Transacciones de objetos 

En el momento de escribir este artículo, el soporte para el control de transacciones es uno de los problemas más apremiantes en la comunidad de servicios web y el soporte completo para transacciones anidadas está en marcha dentro de la comunidad EJB. Como puede ver en la figura 1, las bases de datos no son las únicas cosas que pueden estar involucradas en las transacciones. El hecho es que los objetos, servicios, componentes, aplicaciones heredadas y fuentes de datos no relacionales se pueden incluir en las transacciones. 

Figure 1. Transactions can involve more than just databases. 

 

La ventaja de agregar comportamientos implementados por objetos (y de manera similar servicios, componentes, etc.) a las transacciones es que se vuelven mucho más robustas. ¿Te imaginas usar un editor de código, un procesador de textos o un programa de dibujo sin una función de deshacer? Si no es así, creo que es razonable esperar tanto la invocación del comportamiento como las transformaciones de datos como pasos de una transacción. Desafortunadamente, esta estrategia viene con una desventaja significativa: una mayor complejidad. Para que esto funcione, sus objetos de negocio deben ser conscientes de las transacciones. Cualquier comportamiento que se pueda invocar como paso en una transacción requiere admitir operaciones de intento, confirmación y anulación/reversión. Agregar soporte para transacciones basadas en objetos no es un esfuerzo trivial. 

5.3 Transacciones de objetos distribuidos 

Al igual que es posible tener transacciones de datos distribuidas, también es posible tener transacciones de objetos distribuidas. Para ser más precisos, como puede ver en la Figura 1, se trata solo de transacciones distribuidas, ya no se trata solo de bases de datos, sino de bases de datos más objetos más servicios más componentes más"¦ y así sucesivamente. 

5.4 Inclusión de pasos no transaccionales 

A veces se encuentra que necesita incluir una fuente no transaccional dentro de una transacción. Un ejemplo perfecto es una actualización de la información contenida en un directorio LDAP o la invocación de un servicio web, ninguno de los cuales en el momento de escribir este artículo admite transacciones. El problema es que tan pronto como un paso dentro de una transacción no es transaccional, la transacción ya no es una transacción. Tienes cuatro estrategias básicas disponibles para lidiar con esta situación: 

Elimine el paso no transaccional de la transacción. En la práctica, esto rara vez es una opción, pero si es una estrategia viable, considere hacerlo. 

Implemente commit. Esta estrategia, que podría considerarse como la estrategia de "esperar que la transacción principal no se aborte", le permite incluir un paso no transaccional dentro de su transacción. Deberá simular el protocolo de intento, confirmación y anulación utilizado por el administrador de transacciones. Los comportamientos de intento y anulación son simplemente esbozos que no hacen otra cosa que implementar la lógica de protocolo requerida. El único comportamiento que implemente, la confirmación, invocará la funcionalidad no transaccional que desee. Un sabor diferente de este enfoque, que nunca he visto usado en la práctica, pondría la lógica en la fase de intento en lugar de la fase de confirmación. 

Implementar intento y anulación. Esta es una extensión de la técnica anterior mediante la cual básicamente implementa la lógica "hacer" y "deshacer", pero no la confirmación. En este caso, el trabajo se realiza en la fase de intento; Se supone que el resto de la transacción funcionará, pero si no es así, aún admite la capacidad de revertir el trabajo. Esta es una "casi transacción" porque no evita los problemas con las colisiones descritos anteriormente. 

Hazlo transaccional. Con este enfoque, implementa completamente los comportamientos de intento, confirmación y anulación necesarios. La implicación es que deberá implementar toda la lógica para bloquear los recursos afectados y recuperarse de cualquier colisión. Un ejemplo de este enfoque está soportado por la arquitectura de conector J2EE (JCA), en particular por la interfaz LocalTransaction. 

¿Qué enfoque debería adoptar? Prefiero las estrategias #1 y #4: cuando se trata de transacciones, quiero hacerlo bien o no hacerlo en absoluto. El problema con la implementación de la lógica transaccional completa es que puede ser mucho trabajo. Consideraré la estrategia de intento y aborto cuando sea posible vivir con los resultados de una colisión, y la estrategia # 2 como último recurso. Un problema importante es que la estrategia # 4 es la única que pasa la prueba ACID. 

 