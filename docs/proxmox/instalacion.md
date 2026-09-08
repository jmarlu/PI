# Instalación física o virtualizada

**Sesiones 7-12.** Antes necesitas H0 (GitHub), inventario y diseño aprobados.
El enunciado y las tres preguntas del inventario están en la
[práctica](../proyecto/practica.md).

## Preparación común

- Anota versión de Proxmox autorizada y su ISO oficial.
- Contrasta arquitectura, CPU, RAM, espacio y red con los
  [requisitos oficiales](https://www.proxmox.com/en/products/proxmox-virtual-environment/requirements).
- Documenta IP/prefijo, nombre, gateway y DNS entregados por el profesor.
- Identifica el disco destino y confirma permiso de borrado.
- Conserva fuera del equipo cualquier dato que deba mantenerse.
- No publiques contraseñas de instalación ni capturas que las incluyan.

Los 8 GB físicos o 6-8 GB virtuales de la práctica son orientaciones para
este laboratorio, **no el mínimo oficial universal**. Debes reservar memoria
para Proxmox, invitados y margen. El uso de ZFS u otros servicios modifica
las necesidades. En un puesto de 16 GB no asignes los 16 GB a Proxmox:
el sistema anfitrión, VirtualBox, navegador, editor y Ansible también consumen RAM.

## Modalidad A: equipo físico autorizado

1. Descarga la ISO desde [Proxmox Downloads](https://www.proxmox.com/en/downloads).
   Contrasta su SHA-256 con el publicado para ese archivo:
   `sha256sum NOMBRE_REAL_DE_LA_ISO.iso`.
2. Prepara el USB mediante la herramienta aprobada, confirmando el dispositivo.
   La escritura borra el USB. No uses un comando de disco copiado sin identificarlo.
3. Arranca desde el USB. Revisa el firmware y la virtualización con el profesor.
4. En el instalador, selecciona **solo el disco autorizado**. Revisa capacidad
   y modelo, no únicamente su orden.
5. Escoge almacenamiento conforme al diseño. En un disco pequeño, evita
   añadir complejidad de ZFS sin haber presupuestado sus recursos.
6. Configura país, zona horaria, credenciales y datos de red asignados.
7. Revisa el resumen, instala y retira el medio de instalación al reiniciar.
8. Accede a la URL mostrada desde el equipo de administración.
9. Comprueba versión, red, espacio y log de tareas.

Documenta las decisiones del instalador, no solo su pantalla final.

## Modalidad B: Proxmox en VirtualBox en tu equipo

**No se utiliza el Proxmox del centro.** Conservas el sistema anfitrión del
equipo del alumno y ejecutas Proxmox en una VM de VirtualBox local.

1. Investiga el hardware real del equipo, el espacio libre y la versión de VirtualBox.
2. Reserva recursos al anfitrión y define CPU, RAM y VDI de la VM Proxmox.
3. Crea la VM de 64 bits; revisa el soporte anidado si vas a usar KVM interno.
4. Configura NAT y solo-anfitrión en VirtualBox, conforme a la guía local.
5. Instala Proxmox en el VDI con la ISO autorizada.
6. Accede desde el navegador del mismo host al panel de tu nodo.
7. Prepara la red de invitados y comprueba tanto administración como salida a repositorios.
8. Crea la plantilla, `srv-aso` y `cli-linux` **dentro de Proxmox**.
   No sustituyas esos invitados por VMs independientes creadas en VirtualBox.

Sigue el [montaje paso a paso en VirtualBox](virtualbox.md), con las opciones
de la VM, direccionamiento y configuración del laboratorio local.

Si la VM Proxmox funciona pero KVM no está disponible dentro, valida LXC
con el profesor. Si VirtualBox no puede arrancar la propia VM, LXC no evita
ese requisito: registra el bloqueo y revisa la viabilidad del equipo.

## Actualización y red base

Haz estos diagnósticos en **la consola de tu nodo**, no en la terminal del sistema anfitrión:

~~~bash
pveversion -v
hostname -f
ip -br addr
ip route
getent hosts NOMBRE_DNS_AUTORIZADO
df -h
~~~

En *Repositories*, revisa con el profesor qué repositorios corresponden
a la versión y suscripción del centro. Usa después *Updates* siguiendo
la ventana autorizada. No mezcles versiones de Debian ni pegues cambios
genéricos que desactiven verificaciones de paquetes.

Antes de cambiar red o reiniciar, ten acceso de consola y un plan de vuelta.
Una IP duplicada puede afectar a otros alumnos.

## Validación H3

El nodo debe arrancar, ser accesible desde el equipo autorizado, resolver
los nombres necesarios y tener espacio suficiente. Revisa tareas fallidas
y registra incidencias con causa, pruebas y solución.

Entrega `docs/03-instalacion-proxmox.md`, con versión, modalidad,
almacenamiento, red, permisos y capturas propias. Nunca incluyas contraseñas.

Sigue con [red y almacenamiento](red-almacenamiento.md) y la
[plantilla Linux](plantillas.md).
