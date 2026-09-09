# Arquitectura de Proxmox VE

## Una plataforma, varias piezas

Proxmox VE integra virtualización, almacenamiento, red, permisos y tareas de
administración. No es solamente la página que se abre en el puerto 8006.
Distinguir sus componentes permite acotar una avería sin reinstalar el nodo.

| Componente | Responsabilidad | Ejemplo de fallo observable |
|---|---|---|
| Sistema base Debian y kernel de Proxmox | Ejecutar procesos, acceder a dispositivos y proporcionar KVM | El nodo no arranca |
| QEMU/KVM | Ejecutar las máquinas virtuales | Una VM no puede iniciar con aceleración |
| LXC | Ejecutar contenedores Linux aislados | Un CT no puede montar un recurso |
| Servicios de gestión y API | Tramitar operaciones y mantener la configuración | La creación de un invitado termina con error |
| Interfaz web | Mostrar objetos, métricas y tareas | El navegador no alcanza el panel |
| Almacenamiento y bridges | Proporcionar discos y conectividad | Un invitado arranca, pero su servicio no responde |

Los servicios `pveproxy` y `pvedaemon` participan en la gestión; `pmxcfs` presenta
la configuración de Proxmox en `/etc/pve`. Esta información es para comprender
la arquitectura, no una invitación a editar a mano sus archivos. La configuración
de un invitado no contiene por sí sola los datos de su disco. Consulta la
[arquitectura del manual](https://pve.proxmox.com/pve-docs/pve-admin-guide.html)
y la descripción de [pmxcfs](https://pve.proxmox.com/pve-docs/chapter-pmxcfs.html).

## Plano de gestión y carga de trabajo

El **plano de gestión** permite crear, iniciar, detener, copiar o restaurar
invitados. La **carga de trabajo** es lo que hacen esos invitados: en este
proyecto, un servicio ASO y sus pruebas desde un cliente.

Esta separación ayuda a razonar:

- Si el navegador pierde acceso al panel, los invitados podrían seguir funcionando.
- Si `srv-aso` se detiene, el panel puede continuar disponible.
- Si se apaga el único nodo, dejan de ejecutarse todos sus invitados.
- Si el almacenamiento deja de aceptar escrituras, el problema puede afectar
  simultáneamente a varias máquinas aunque su CPU tenga poca carga.

**Acceder al panel no es una prueba de funcionamiento del servicio**, y acceder
al servicio no demuestra que existan copias recuperables.

## Objetos que administra el nodo

`Datacenter` aparece en la interfaz incluso con un solo nodo: es un ámbito de
configuración, no una prueba de que tengas un clúster. Debajo están el nodo,
sus invitados y sus recursos. Un VMID/CTID identifica un invitado; no es su
dirección IP, su nombre de equipo ni un usuario.

Cada invitado reúne varias cosas: configuración, uno o más volúmenes,
interfaces virtuales, opciones de arranque y estado de ejecución. Una ISO de
instalación es un recurso distinto del disco donde queda instalado su sistema.

Ejemplo original del laboratorio:

| Objeto | Identificador de ejemplo | Relación |
|---|---|---|
| Nodo propio | `pve-alumno` | Aloja todos los invitados |
| Plantilla | 900 | Base preparada y apagada |
| Servidor | 101, `srv-aso` | Clon con identidad propia |
| Cliente | 102, `cli-linux` | Segundo invitado para pruebas |

Comprueba los IDs libres antes de reutilizar estos números. Renombrar una VM
en el panel no cambia automáticamente su hostname o su configuración de red.

## Leer una configuración sin modificarla {#ejemplo-configuracion}

El panel y la línea de comandos son formas de consultar los mismos objetos.
En **la consola de tu nodo Proxmox**, con permisos de lectura sobre tus invitados:

~~~bash
qm list
pct list
pvesm status
~~~

`qm` consulta las VMs; `pct` los contenedores; `pvesm` el almacenamiento.
No son comandos que debas instalar dentro de `srv-aso`. Si solo tienes CT,
que `qm list` no muestre máquinas no significa que hayas perdido esos CT.

Después de comprobar que 101 es el ID de **tu VM**, puedes leer su configuración
actual. Sustituye el ID cuando corresponda:

~~~bash
qm config 101 --current 1
~~~

Fragmento inventado para aprender a interpretarlo, no salida obtenida en el aula:

~~~text
name: srv-aso
sockets: 1
cores: 2
memory: 2048
scsi0: local-lvm:vm-101-disk-0,size=24G
net0: virtio=02:00:00:00:01:01,bridge=vmbr1
~~~

| Campo | Lectura correcta | Lo que no demuestra |
|---|---|---|
| `name` | Etiqueta del objeto en Proxmox | Que el hostname interior coincida |
| `sockets` y `cores` | Topología virtual; en este ejemplo sencillo, 1 × 2 | Dos núcleos físicos exclusivos |
| `memory` | Memoria configurada en MiB; 2048 MiB son 2 GiB | Consumo instantáneo ni RAM libre del host |
| `scsi0` | Volumen asociado al primer disco SCSI indicado | Que haya 24 GiB físicos libres |
| `net0` | Adaptador VirtIO conectado a `vmbr1` | IP, DNS o servicio funcional |

`qm config` puede mostrar cambios pendientes si no solicitas la configuración
actual. Incluso una configuración actual no reemplaza las métricas del
invitado: compara **configurado**, **en ejecución** y **medido**.
[Referencia qm](https://pve.proxmox.com/pve-docs/qm.1.html).

Para un contenedor propio consulta `pct config ID_DE_TU_CT --current 1`, sustituyendo el
marcador por su número. No interpretes sus campos como si fueran hardware
QEMU: el modelo de CT es distinto.
[Referencia pct](https://pve.proxmox.com/pve-docs/pct.1.html).
Las consultas pueden mostrar nombres o direcciones que debes revisar antes
de publicar una captura.

## Seguir una operación de principio a fin

Ejemplo: pulsas **Start** en `srv-aso`. Deben distinguirse tres comprobaciones:

1. Proxmox acepta la operación y la tarea termina correctamente.
2. El invitado arranca su sistema, observado en consola.
3. El cliente llega al servicio y completa una operación válida.

Si se cumple el primer punto y falla el segundo, investiga arranque, medio,
disco y firmware de ese invitado. Si se cumplen los dos primeros, pero falla
el tercero, revisa red y servicio. Repetir **Start** no aporta información
cuando el invitado ya está ejecutándose.

Un estado `running` indica que existe una instancia en ejecución; no es un
certificado de salud de su aplicación. Por la misma razón, una tarea `OK` de
creación acredita esa tarea concreta, no todo el proyecto.

## Ciclo de vida y operaciones

La consola permite interactuar con el sistema invitado, mientras que el panel
gestiona el objeto que lo contiene. **Shutdown** solicita un apagado ordenado;
**Stop** es una parada brusca y puede perder escrituras pendientes. No son
equivalentes aunque ambos terminen con la máquina detenida.

El QEMU Guest Agent es software del interior de una VM que permite operaciones
coordinadas con Proxmox. Instalarlo y habilitar su uso son pasos diferentes;
no convierte cualquier aplicación en consistente por arte de magia.
[Operaciones y agente QEMU](https://pve.proxmox.com/pve-docs/chapter-qm.html).

Después de una operación, revisa el registro de tarea completo: objeto destino,
hora, mensajes y estado final. Una notificación de inicio no demuestra éxito.
No elimines bloqueos ni repitas operaciones de disco mientras desconoces si
una tarea de copia o migración sigue activa.

## VirtualBox añade un dominio de fallo

En modalidad virtualizada, la VM de Proxmox depende del equipo del alumno:
su batería/alimentación, suspensión, disco y recursos disponibles. Suspender
el portátil interrumpe el laboratorio aunque ningún invitado se haya apagado.

LXC reduce el coste de los invitados, pero **no resuelve que VirtualBox sea
incapaz de ejecutar la VM de Proxmox**. Primero debe arrancar el nodo; después
se comprueba si dispone de KVM interno o se aprueba el uso de contenedores.

No se incorpora un nodo del centro como alternativa. El proyecto sigue siendo
un nodo individual propio, físico autorizado o virtualizado localmente.

## Razona y comprueba

1. El panel no carga, pero el cliente descarga un archivo del servicio.
   ¿Qué componente investigarías primero? ¿Qué queda demostrado y qué no?
2. Se conserva el archivo de configuración de la VM, pero se pierde su disco.
   ¿Se ha recuperado el servidor? Justifica con los objetos anteriores.
3. Proxmox muestra dos invitados y VirtualBox una sola VM. ¿Es coherente?

Integra las respuestas relevantes en tu memoria y bitácora actuales. No se pide
otro documento ni un nuevo entregable de inventario.

Continúa con [VM y LXC](virtualizacion.md) y la [interfaz](interfaz.md).
