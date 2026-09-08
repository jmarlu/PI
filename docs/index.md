# Proyecto Proxmox

**Proyecto Intermodular · 2.º ASIR · Curso 2026-2027**  
Trabajo individual. Una clase semanal de tres horas seguidas.

Construirás un nodo Proxmox, desplegarás un servidor Linux y un cliente,
administrarás un servicio ASO y demostrarás que puedes automatizarlo y recuperarlo.

## Empieza aquí

**Tu primera tarea es crear el repositorio individual en GitHub y publicar
la documentación inicial en Markdown.** No empieces por instalar Proxmox.

1. Completa la [primera sesión: GitHub y Markdown](proyecto/primera-sesion.md).
2. Lee la [práctica completa](proyecto/practica.md), que reúne todos los requisitos.
3. Localiza tu clase en el [calendario de sesiones](clases/index.md).

## El laboratorio que entregarás

| Elemento | Resultado verificable |
|---|---|
| GitHub y Markdown | README, bitácora, memoria y evidencias desde la sesión 1 |
| Inventario | Viabilidad investigada, límites y componentes críticos justificados |
| Proxmox | Un nodo físico autorizado o una VM Proxmox en VirtualBox en tu equipo |
| Red y Linux | Diagrama, plantilla reutilizable, servidor y cliente VM/LXC |
| Servicio ASO | Acceso permitido y denegado comprobados desde el cliente |
| Automatización | Dos scripts Bash **y** un playbook Ansible ejecutados |
| Continuidad | Backup real y restauración comprobada |
| Validación | Rendimiento, seguridad, conclusiones y defensa individual |

No necesitas un segundo ordenador dedicado. En modalidad virtualizada usas
VirtualBox en tu equipo de trabajo, conservando el sistema anfitrión.
**El Proxmox del centro no es un recurso del proyecto.** Los entregables no cambian.

## Antes de usar la aplicación

[Conoce Proxmox y los tres niveles del laboratorio](proxmox/conceptos.md).
Distingue el equipo de administración, tu nodo y los invitados antes
de ejecutar comandos.

[![Interfaz de Proxmox VE, captura oficial](assets/proxmox-panel.png)](proxmox/interfaz.md)

Captura de referencia: Proxmox Server Solutions GmbH. No representa tu instalación.
La versión y los nombres del centro pueden ser distintos.

## Trabajo semanal

Cada clase combina explicación, demostración, práctica, validación y documentación.
Al terminar, publica un cambio significativo y comprueba que aparece en GitHub.
Una incidencia también se documenta, con sus pruebas y el siguiente paso.

Consulta las [explicaciones de cada día](clases/explicaciones.md),
las [descargas](recursos/descargas.md) y la [evaluación y defensa](proyecto/evaluacion.md).
