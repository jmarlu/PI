# Almacenamiento, discos y aprovisionamiento

## Un storage no es lo mismo que un disco

En el panel, cada almacenamiento tiene un nombre y una configuración. Esa configuración indica dónde se guardan los datos, qué tecnología se utiliza —por ejemplo, un directorio o LVM-thin— y qué contenidos se admiten. Por eso `local` no significa necesariamente «todo el disco», y `local-lvm` no es una carpeta en la que se pueda copiar cualquier ISO.

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

Antes de elegir dónde guardar algo, comprueba dos cosas: que ese almacenamiento admita el tipo de contenido y que tenga espacio. Por ejemplo, un almacenamiento configurado solo para discos de invitados no aparecerá como destino para subir una ISO.

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

En el siguiente ejemplo, sigue el recorrido desde el disco físico hasta el archivo guardado dentro del servidor:

~~~mermaid
flowchart TD
    H["Disco real del alumno"] --> V["Archivo VDI de Proxmox"]
    V --> P["Pool de Proxmox"]
    P --> D["Disco virtual de srv-aso"]
    D --> F["Sistema de archivos"]
    F --> A["Datos del servicio"]
~~~

Cada nivel utiliza almacenamiento del anterior; las cajas **no** son seis
dispositivos independientes. En la instalación física opcional se elimina el archivo VDI
exterior, pero sigue habiendo dependencias entre disco, pool, volúmenes y datos.

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

## Un archivo tiene que caber en todas las capas {#ejemplo-capacidad}

### Caso resuelto A: queda espacio en el invitado, pero no en el host

Supón estas observaciones y una operación que necesita **8 GiB adicionales
reales**. Para simplificar, no contamos todavía metadatos ni margen:

| Capa | Espacio libre observado | ¿Admite esos 8 GiB adicionales? |
|---|---:|---|
| Disco del anfitrión | 6 GiB | No, si el VDI debe crecer en esa cantidad |
| Pool del nodo | 30 GiB | Sí en este nivel, sin considerar otras reservas |
| Sistema de archivos del invitado | 12 GiB | Sí en este nivel |

El invitado puede informar espacio libre y aun así fallar la operación por
agotamiento del soporte exterior. No se arregla ampliando de 24 a 40 GiB su
capacidad virtual: el equipo físico sigue teniendo el mismo límite.

La hipótesis supone crecimiento real del VDI. Si reutilizas bloques ya
asignados, el crecimiento puede ser diferente; debes medirlo. No afirmes
que todo archivo de 8 GiB aumenta exactamente 8 GiB en cada capa.

### Caso resuelto B: aparecen dos storages sobre el mismo disco

`local` contiene ISO y `local-lvm` contiene discos de invitados. Aunque el
panel muestre dos entradas, podrían estar sobre particiones o volúmenes del
mismo dispositivo.

Para calcular el espacio, averigua cómo se reparte el dispositivo físico entre esas entradas. Para valorar las copias, recuerda que una avería de ese dispositivo puede hacer que se pierdan ambas.

No sumes capacidad total y espacio libre, ni sumes dos vistas de un mismo pool.
Registra por separado “dispositivo”, “backend”, “contenido” y “capacidad
utilizable”.

### Caso resuelto C: ampliar un disco no amplía todo lo que contiene

Aumentar la capacidad virtual presentada por Proxmox modifica una capa.
La partición, volumen lógico y sistema de archivos del invitado pueden requerir
operaciones adicionales compatibles con su diseño.

Primero comprueba qué capa está llena. Luego prepara copia, procedimiento
específico y validación. No se propone aquí una receta de particionado:
ejecutarla sin conocer el layout podría dañar el sistema.

## Elegir el destino de tres objetos

| Objeto que vas a guardar | Decisión razonada |
|---|---|
| ISO de instalación | Storage que admita ISO y tenga espacio real |
| Disco de `srv-aso` | Backend que admita discos de VM y cumpla el diseño |
| Backup del invitado | Destino con contenido de backup habilitado, capacidad, permisos y riesgo físico identificado |

Indicar solo que un archivo se guarda «en local» no permite saber si ese destino es adecuado. Identifica el almacenamiento, sus contenidos permitidos y el disco físico que lo sostiene. Si no aparece en el asistente, comprueba su configuración y disponibilidad antes de suponer que se ha borrado.

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
