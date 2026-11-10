# Fase 1. Inventario y viabilidad

[Guía de la práctica](practica.md) · **Al terminar:** inventario, tres respuestas justificadas y dictamen.

**Sesiones de clase:** 2–3. Consulta el [calendario](../clases/index.md).

Antes de instalar, investiga tu equipo y responde a las **tres preguntas
obligatorias** de este apartado. Escribe las respuestas en
`docs/01-inventario-hardware.md`, dentro de tu repositorio GitHub.
Cada respuesta debe incluir **datos del equipo, fuentes consultadas y
una justificación propia**. Un listado de componentes o unas capturas
sin interpretar no completan esta fase.

## Pregunta 1. ¿Puedo instalar Proxmox en este equipo?

Investiga el hardware de tu equipo y los recursos que asignarás a la VM
de VirtualBox. Contrasta sus características
con los requisitos oficiales de la versión de Proxmox que vas a utilizar.

| Componente o requisito | Dato de mi equipo y evidencia | Requisito consultado y fuente | Cumple, no cumple o pendiente |
|---|---|---|---|
| CPU, arquitectura y núcleos/hilos | | | |
| Soporte de virtualización y configuración | | | |
| RAM | | | |
| Almacenamiento | | | |
| Red | | | |
| Plataforma, firmware y arranque | | | |

Responde por separado:

- ¿Puedo **instalar y arrancar Proxmox**? Justifica sí, no o con condiciones.
- ¿Puedo **ejecutar el proyecto completo**, con servidor ASO y cliente en
  VM/LXC? Justifica sí, no o con condiciones.

No basta con afirmar que el procesador soporta virtualización o que
dispones de cierta cantidad de RAM. Explica qué datos lo demuestran,
qué configuración necesitas y qué comprobaciones quedan pendientes.
Consulta los [requisitos oficiales de Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/requirements)
y distingue requisitos de evaluación, recomendaciones y necesidades
de tu laboratorio.

## Pregunta 2. ¿Qué limitaciones tendré al instalar Proxmox en un hardware tan limitado?

Analiza RAM, CPU, almacenamiento y red en relación con el trabajo
previsto. Explica cuántas cargas podrás mantener simultáneamente, qué
límites tendrán las VMs/LXC y qué problemas pueden aparecer al clonar,
realizar copias o utilizar el servicio desde el cliente.

Prepara un reparto inicial de recursos:

| Elemento | CPU/vCPU | RAM prevista | Disco previsto | Justificación |
|---|---|---|---|---|
| Proxmox y sus servicios | | | | |
| srv-aso | | | | |
| cli-linux | | | | |
| Plantilla, ISOs y copias locales | No aplica | No aplica | | |
| Margen de operación | | | | |

Calcula el saldo de RAM y disco después de reservar recursos para el
hipervisor, invitados y margen. Indica unidades y supuestos; explica
el reparto de CPU y las tareas simultáneas. Las vCPU no equivalen a
núcleos físicos exclusivos. No presentes la swap como RAM adicional
ni la capacidad virtual aprovisionada como espacio físico garantizado.

| Limitación o dato pendiente | Evidencia o estimación | Consecuencia para el proyecto | Medida y límite que permanece |
|---|---|---|---|
| | | | |

Propón medidas para las limitaciones que hayas encontrado. Por ejemplo,
puedes reducir las cargas simultáneas, valorar LXC si el servicio lo permite
o ajustar la RAM de las máquinas. Explica qué resuelve cada medida y qué
problema seguiría pendiente. Puedes proponer una ampliación de hardware,
pero no necesitas comprar componentes.

Si el montaje no es viable, revisa con el profesor qué equipo o configuración
local autorizada puedes utilizar. El Proxmox del centro no forma parte del
proyecto. Separa los problemas que ya has observado de los que todavía
necesitas comprobar.

## Pregunta 3. ¿Qué componentes son más críticos en mi servidor y por qué?

Clasifica **al menos tres componentes por orden de prioridad** para
tu servidor y su servicio. Considera RAM, almacenamiento, CPU, red y,
cuando proceda, placa, alimentación y refrigeración.

| Prioridad y componente | Función en mi servidor | Efecto si es insuficiente | Efecto si falla | Evidencia y justificación de la prioridad |
|---|---|---|---|---|
| 1. | | | | |
| 2. | | | | |
| 3. | | | | |

Distingue **el componente que limita el rendimiento** de **aquel cuyo
fallo tendría mayor impacto**. Relaciona cada prioridad con rendimiento,
disponibilidad e integridad de los datos. No existe una clasificación
universal: debes defenderla para tu equipo y tu carga de trabajo.

Termina indicando **qué componente mejorarías primero y por qué lo
priorizas frente a otro**. La propuesta debe estar justificada; no se
requiere comprar ni sustituir componentes durante esta fase.

## Investigación y evidencias

Consulta al menos tres fuentes técnicas primarias: requisitos Proxmox,
ficha o manual del fabricante y otra documentación pertinente. Para
cada fuente registra URL, modelo/versión, fecha de consulta y qué
afirmación de tus respuestas respalda. Una respuesta de IA no sustituye
estas fuentes.

Puedes obtener datos con `lscpu`, `free -h`,
`lsblk -o NAME,TYPE,SIZE,MODEL,ROTA,TRAN`, `df -h`, `ip -br addr`,
`lspci -nnk` y `systemd-detect-virt`, o utilizar el script docente.
Anota si observas el sistema actual, un Linux de inspección o una VM.
Interpreta las salidas útiles y revisa identificadores o datos privados
antes de publicarlos. No se requieren pruebas destructivas.

En el montaje habitual con VirtualBox, estudia tanto tu equipo anfitrión como
la VM creada en VirtualBox. Recoge versión de VirtualBox, CPU y RAM reales,
espacio libre del disco físico, configuración VDI, recursos reservados al
host y asignados al nodo, adaptadores de red y virtualización anidada.
Distingue equipo anfitrión, nodo Proxmox virtualizado e invitados internos.
No deduzcas el estado físico solo de los dispositivos visibles en la VM.
Documenta restricciones de acceso y solicita ayuda para comprobarlas.
Consulta también el [manual oficial de VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/AdvancedTopics.html).
Aunque Proxmox esté en una VM, la viabilidad depende del hardware local.

## Entrega y evaluación de la fase

Organiza tu Markdown con inventario inicial, las tres preguntas como
apartados, fuentes y enlaces a evidencias. Cierra con un dictamen:
**apto**, **apto con condiciones** o **no apto para la propuesta actual**.
El profesor puede pedirte que expliques una respuesta, qué cambiaría
con menos RAM o qué ocurriría si fallara un componente.

| Criterio | Puntos sobre 10 |
|---|---:|
| Pregunta 1: compatibilidad contrastada y diferencia entre instalar y ejecutar el proyecto | 3 |
| Pregunta 2: limitaciones concretas, cálculos y medidas justificadas | 3 |
| Pregunta 3: componentes priorizados, consecuencias y justificación para el servidor | 3 |
| Fuentes, evidencias, claridad del Markdown y defensa de las respuestas | 1 |

Esta rúbrica se integra en el bloque de requisitos, inventario, alcance
y sostenibilidad, sin añadir un porcentaje global. Se trabaja en la
sesión 2 y se revisa al inicio de la 3. En la sesión 3 utiliza el dictamen
para concretar necesidad, alcance, requisitos y riesgos en la ficha y la
memoria antes de pasar al diseño. Publica los cambios y la bitácora en GitHub. El reparto de recursos se afinará en la sesión 5.

---

[Anterior](fase-0-inicio.md) · [Fase 2: Diseño de red](fase-2-red.md)
