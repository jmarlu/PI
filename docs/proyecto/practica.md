# Práctica del Proyecto Intermodular

**Nodo Proxmox individual con VM/LXC y servicio ASO**

**Ciclo:** 2.º de ASIR<br>
**Módulo:** Proyecto Intermodular<br>
**Curso:** 2026-2027<br>
**Trabajo:** individual<br>
**Entorno habitual:** Proxmox en VirtualBox, en tu equipo de trabajo<br>
**Producto final:** laboratorio Proxmox funcional, documentado y probado

La práctica está organizada por fases. Empieza por la guía general y abre
la fase en la que estés trabajando: cada una reúne sus tareas y evidencias.
La memoria, la lista de revisión y la rúbrica están en
[Memoria, entrega y defensa](entrega.md).

## Qué vas a construir {#1-reto}

Vas a montar y administrar tu propio laboratorio Proxmox en una máquina
virtual de VirtualBox, en tu equipo de trabajo. Este será el montaje
habitual de la clase, porque no hay ordenadores dedicados para todo el grupo.
El Proxmox del centro no forma parte de los recursos del proyecto.

El laboratorio debe incluir:

- Un repositorio individual en GitHub, creado en la primera sesión.
- Un nodo Proxmox funcionando.
- Diagrama de red.
- Inventario de hardware.
- Plantilla Linux.
- Dos VMs o contenedores.
- Un servicio de ASO.
- Scripts Bash y Ansible.
- Copias y restauración.
- Pruebas de rendimiento y seguridad.
- Documentación y memoria técnica en Markdown alojadas en GitHub desde el inicio.

**Primera actividad obligatoria:** crear tu repositorio de GitHub y
publicar la documentación inicial en Markdown antes de empezar el
inventario o instalar Proxmox. Sigue la
[guía de la primera sesión](primera-sesion.md).

## Apoyo teórico: comprender los comandos

Consulta [Comandos del proyecto: teoría y uso](comandos.md) durante cada fase.
Incluye VirtualBox (modalidad virtual), Proxmox, Linux, SSH, permisos, copias
y automatización. Antes de ejecutar una orden identifica la máquina, explica
sus opciones y comprueba el resultado. Registra los comandos relevantes en tu
memoria con salidas interpretadas, sin secretos. Se aprende durante el proyecto;
no se añade una entrega independiente ni se exige memorizar todas las opciones.

## Prepara el entorno de VirtualBox {#2-modalidades-permitidas}

Crea tu VM Proxmox en VirtualBox sin borrar LliureX u otro sistema anfitrión.
Dentro de Proxmox prepararás después el servidor y el cliente. La
[guía de montaje local](../proxmox/virtualbox.md) explica los pasos y cómo
comprobar la virtualización anidada.

Configuración orientativa de la VM Proxmox:

| Recurso | Valor recomendado |
|---|---:|
| vCPU | 2; hasta 4 solo si el host mantiene margen suficiente |
| RAM | 6-8 GB |
| Disco | 80 GB |
| Red | NAT para salida y solo-anfitrión para gestión/laboratorio; según diseño autorizado |
| Virtualización | VT-x/AMD-V del host; exponer virtualización anidada en VirtualBox si se usarán VMs KVM internas |

Reserva RAM y disco para el sistema anfitrión, VirtualBox, navegador,
editor y Ansible además de la VM Proxmox. Dentro de esa VM, reserva recursos
para Proxmox, servidor, cliente y margen. Un disco VDI dinámico no garantiza
que haya espacio físico para llenarlo.

Si VirtualBox puede ejecutar Proxmox pero no exponer KVM anidado, podrás usar
LXC si el profesor valida su funcionamiento y el servicio. Sin soporte
para arrancar la propia VM exterior, LXC no resuelve el bloqueo: hay que
revisar el equipo y VirtualBox, sin recurrir al Proxmox del centro.

### Instalación en un ordenador dedicado: opcional

Si dispones de un equipo propio que puedas dedicar al proyecto, puedes
proponer instalar Proxmox directamente en él. Requiere autorización del
profesor y permiso expreso para borrar su disco. No se cuenta con que el
centro pueda proporcionar un ordenador adicional a cada alumno.

Esta opción mantiene las mismas fases, evidencias y criterios de evaluación;
no es una ampliación obligatoria ni supone una entrega extra. Consulta el
[procedimiento opcional](../proxmox/instalacion.md#modalidad-a-equipo-fisico-autorizado).

## Trabaja dentro de tu laboratorio {#3-normas-de-seguridad}

- No hagas pruebas sobre redes, equipos o servicios que no sean los
  autorizados.
- No uses datos personales reales.
- No publiques contraseñas, claves privadas ni tokens.
- No modifiques la red corporativa del centro.
- No escanees equipos de otros compañeros.
- No instales Proxmox en hardware que no tengas permiso para borrar.
- Todas las IPs, usuarios y credenciales deben seguir las indicaciones
  del profesor.

## Organiza tu repositorio {#4-estructura-obligatoria-de-la-entrega}

Crea un repositorio individual en GitHub llamado
`pi-proxmox-apellido-nombre` (o con el identificador indicado por el
profesor). La carpeta de tu equipo será su copia de trabajo local.
Utiliza esta estructura:

```text
pi-proxmox-apellido-nombre/
├── README.md
├── .gitignore
├── docs/
│   ├── 00-ficha-inicial.md
│   ├── 00-bitacora.md
│   ├── 01-inventario-hardware.md
│   ├── 02-diagrama-red.md
│   ├── 03-instalacion-proxmox.md
│   ├── 04-plantilla-linux.md
│   ├── 05-vms-lxc.md
│   ├── 06-servicio-aso.md
│   ├── 07-automatizacion.md
│   ├── 08-copias-restauracion.md
│   ├── 09-rendimiento-seguridad.md
│   └── 10-memoria-tecnica.md
├── scripts/
│   ├── inventario.sh
│   └── backup_servicio.sh
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
└── evidencias/
    ├── README.md
    └── capturas-o-salidas/
```

Debes usar obligatoriamente `scripts/` y `ansible/`. Los scripts Bash y
el playbook Ansible son evidencias distintas y no se sustituyen entre sí.

El `README.md` será la entrada al proyecto: objetivo, identificador del
alumno, modalidad, estado y enlaces relativos a todos los documentos.
El repositorio puede ser privado, dando acceso al profesor. Entrega su
URL en Aules y comprueba que el profesor puede abrirlo. Una carpeta local
o un PDF aislado no sustituyen la documentación Markdown en GitHub.

## Cómo trabajaremos en clase {#5-como-se-trabajara-en-clase}

Tendrás una sesión semanal de 3 horas seguidas. Cada clase seguirá la
misma dinámica:

| Momento | Qué hará el profesor | Qué harás tú |
|---|---|---|
| Inicio | Explica el objetivo del día y la evidencia que se entregará | Abres tu memoria, repositorio y entorno |
| Explicación | Presenta los conceptos y decisiones técnicas necesarias | Tomas notas breves y preparas comandos |
| Demostración | Ejecuta un ejemplo completo o parcial | Comparas con tu caso y detectas diferencias |
| Práctica | Supervisa mientras trabajas | Lo haces en tu nodo, VM o contenedor |
| Validación | Indica las pruebas mínimas | Ejecutas pruebas y corriges errores |
| Cierre | Revisa evidencias e incidencias | Actualizas Markdown y bitácora, haces commit y push y verificas los cambios en GitHub |

No debes esperar a la memoria final para documentar. Cada sesión debe
terminar con documentación actualizada y **al menos un commit significativo
publicado en GitHub**. Si no has completado la tarea, documenta la
incidencia, las pruebas realizadas y el siguiente paso. No se puntúa el
número de commits, sino el contenido, la continuidad y la autoría.

## Recorrido por fases

Una fase es una parte del proyecto; una sesión es una clase de tres horas.
Por eso una misma fase puede ocupar varias sesiones. Consulta el
[calendario de clase](../clases/index.md) para ver el trabajo de cada día.
Si una prueba falla, registra el problema y resuélvelo antes de cerrar esa fase.

| Fase | Sesiones de clase | Qué vas a preparar | Resultado que documentas |
|---|---|---|---|
| <span id="6-fase-0-github-markdown-y-ficha-inicial"></span>0 | 1 | [GitHub, Markdown y ficha inicial](fase-0-inicio.md) | README, ficha, bitácora y memoria iniciados |
| <span id="7-fase-1-inventario-investigado-y-viabilidad"></span>1 | 2–3 | [Inventario y viabilidad](fase-1-inventario.md) | Inventario, tres respuestas justificadas y dictamen |
| <span id="8-fase-2-diseno-de-red"></span>2 | 4–6 | [Diseño de red](fase-2-red.md) | Diagrama y tabla de direccionamiento |
| <span id="9-fase-3-instalacion-de-proxmox"></span>3 | 7–9 | [Instalación de Proxmox](fase-3-instalacion.md) | Nodo accesible y pruebas de instalación |
| <span id="10-fase-4-configuracion-base-del-nodo"></span>4 | 10–12 | [Configuración base del nodo](fase-4-configuracion.md) | Red, almacenamiento, accesos y recursos revisados |
| <span id="11-fase-5-plantilla-linux"></span>5 | 13–16 | [Plantilla Linux](fase-5-plantilla.md) | Plantilla reutilizable y prueba de clonado |
| <span id="12-fase-6-despliegue-de-dos-vms-o-contenedores"></span>6 | 17–20 | [Servidor y cliente](fase-6-despliegue.md) | Dos VM o LXC con conectividad comprobada |
| <span id="13-fase-7-servicio-aso"></span>7 | 21–25 | [Servicio ASO](fase-7-servicio.md) | Servicio probado desde el cliente y permisos comprobados |
| <span id="14-fase-8-automatizacion"></span>8 | 26–28 | [Automatización con Bash y Ansible](fase-8-automatizacion.md) | Dos scripts y un playbook ejecutados |
| <span id="15-fase-9-copias-y-restauracion"></span>9 | 29–30 | [Copias y restauración](fase-9-copias.md) | Copias reales y recuperación verificada |
| <span id="16-fase-10-pruebas-de-rendimiento"></span>10 | 31 | [Pruebas de rendimiento](fase-10-rendimiento.md) | Medidas, interpretación y mejoras justificadas |
| <span id="17-fase-11-pruebas-de-seguridad"></span>11 | 32 | [Pruebas de seguridad](fase-11-seguridad.md) | Puertos, permisos, riesgos y medidas documentados |

## Memoria, entrega y defensa

La memoria se escribe desde la primera sesión. Revisa estos apartados
durante el proyecto y vuelve a ellos antes de entregar:

- <span id="18-memoria-tecnica-en-markdown"></span>[Cómo escribir la memoria técnica](entrega.md#18-memoria-tecnica-en-markdown).
- <span id="19-checklist-final"></span>[Lista de revisión antes de entregar](entrega.md#19-checklist-final).
- <span id="20-criterios-de-calificacion"></span>[Rúbrica del proyecto](entrega.md#20-criterios-de-calificacion).
- <span id="21-defensa-final"></span>[Preparar la defensa](entrega.md#21-defensa-final).
- <span id="22-entrega"></span>[Entrega en Aules](entrega.md#22-entrega).

<span id="restauracion-obligatoria"></span>La [prueba de restauración](fase-9-copias.md#restauracion-obligatoria)
se realiza en la fase 9, antes de cerrar la memoria.
