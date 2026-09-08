# Almacenamiento, discos y aprovisionamiento

## Un storage no es lo mismo que un disco

Proxmox usa un identificador de almacenamiento para referirse a un backend y
a los contenidos que admite. El nombre `local` no significa “todo el disco”
y `local-lvm` no es una carpeta donde copiar ISO.

En una instalación típica con ext4/LVM, `local` usa un directorio y
`local-lvm` un pool LVM-thin para discos de invitados. Otra instalación puede
tener nombres y distribución diferentes. Debes inspeccionar la tuya, no
copiar una captura como inventario.
[Modelo de almacenamiento](https://pve.proxmox.com/pve-docs/chapter-pvesm.html).

| Contenido | Para qué sirve | No confundir con |
|---|---|---|
| ISO | Instalar un sistema desde un medio | Disco de una VM instalada |
| Plantilla de CT | Crear el sistema inicial de un contenedor | Plantilla VM convertida en Proxmox |
| Disco de VM / rootfs de CT | Mantener sistema y datos del invitado | Archivo de backup |
| Backup | Recuperar un invitado dentro de su alcance | Snapshot local |

Seleccionar un storage depende tanto del espacio disponible como del tipo de
contenido permitido. Una ISO no aparece como destino válido en un backend que
solo admite volúmenes de invitados.

## Directorio, LVM-thin y ZFS

Un **directorio** almacena archivos sobre un sistema de archivos. Permite
contenidos como ISO y backups según su configuración. Los discos de VM pueden
representarse mediante archivos, cuyo formato influye en sus capacidades.

**LVM-thin** administra volúmenes de bloques con asignación bajo demanda.
Debes vigilar datos **y metadatos** del pool. Que dentro del invitado quede
espacio libre no demuestra que el pool pueda aceptar escrituras.
[Backend LVM-thin](https://pve.proxmox.com/pve-docs/pvesm.1.html).

**ZFS** integra almacenamiento y sistema de archivos, comprobaciones de
integridad y funciones como snapshots. No proporciona redundancia si solo
tiene un disco y no sustituye una copia independiente. Exige valorar RAM,
diseño de discos y operación; no es una mejora automática en un ordenador
limitado.
[ZFS en Proxmox](https://pve.proxmox.com/pve-docs/chapter-sysadmin.html).

En este curso importa justificar una elección viable y recuperable.
No se exige Ceph ni añadir una arquitectura distribuida a un nodo individual.

## Formatos y capas del disco virtual

Un archivo `VDI` de VirtualBox contiene el disco de la VM **Proxmox**. Dentro
de ese disco puede haber un volumen LVM-thin que actúe como disco de
`srv-aso`. Dentro del volumen, el invitado mantiene su sistema de archivos.

`raw` y `qcow2` son formatos de disco usados en distintos contextos de QEMU.
No todos los backends ofrecen los mismos formatos ni las mismas capacidades
de snapshot/clonación. No deduzcas soporte solamente de la extensión.

Ejemplo original:

~~~text
SSD del equipo del alumno
  archivo VDI de la VM Proxmox
    sistema y pool de Proxmox
      volumen del disco de srv-aso
        sistema de archivos y datos del servicio
~~~

Mover un documento dentro del invitado no cambia esa cadena de dependencias.
Perder el SSD exterior puede hacer perder todos sus niveles simultáneamente.

## Thin provisioning: capacidad prometida y real

El aprovisionamiento fino permite que la capacidad lógica asignada supere el
espacio físico consumido en ese momento. Es una técnica de asignación, no una
forma de crear almacenamiento.

Supón un pool de 80 GiB con dos discos virtuales de 50 GiB. Si cada uno consume
15 GiB, el uso inicial puede ser viable. Si ambos crecen a 45 GiB, ya requieren
más capacidad que la disponible, sin contar otros consumos.

En VirtualBox dinámico se añade otro límite: el espacio real del anfitrión.
Por eso vigilar solo el indicador de disco de `srv-aso` es insuficiente.

Borrar archivos dentro de una VM no implica que todas las capas recuperen
inmediatamente su espacio. Discard/TRIM necesita soporte y configuración
coherentes a lo largo del recorrido. No lo uses como sustituto de una reserva
de capacidad.

## Qué vigilar antes de copiar o clonar

| Comprobación | Motivo |
|---|---|
| Libre en el anfitrión | El VDI exterior puede necesitar crecer |
| Libre en storage/pool | El clon o la copia añade escrituras |
| Uso de metadatos thin | Puede limitar operaciones aunque quede espacio de datos |
| Tamaño y política de copias | Las versiones antiguas también ocupan |
| Estado de la tarea | Una copia iniciada puede terminar fallando |
| Dependencia de la base | Un clon enlazado no es independiente |

Los snapshots conservan información para mantener estados anteriores.
Si continúan las escrituras, también puede crecer su consumo. Mantenerlos
indefinidamente en un disco pequeño no es una política de backup.

## Decisión para tu inventario

En la memoria existente explica dónde se ubican plantilla, invitados, ISO y
copias; cuánto pueden crecer; y qué se pierde si falla el dispositivo real.
No basta con enumerar `local` y `local-lvm`.

**Caso:** el invitado indica 20 GiB libres y una escritura falla. Formula dos
hipótesis situadas fuera de su sistema de archivos y explica cómo las
contrastarías sin borrar datos.

Continúa con [plantillas y clones](clonado-teoria.md) y
[recuperación](operacion-recuperacion.md).

