# Plantillas, clones e identidad

## De instalación a base reutilizable

Después de instalar Linux tienes un sistema que puedes utilizar. Para convertirlo en una plantilla, necesitas prepararlo como base de otros sistemas: dejar la configuración común y revisar qué datos deben cambiar en cada clon. Así evitarás distribuir contraseñas personales o crear máquinas con la misma IP.

Documenta la versión de Linux, los paquetes instalados y el acceso de administración de la base. Comprueba que no contiene datos personales. Indica también qué configuración heredarán los clones y qué se asignará a cada uno al crearlo.

En Proxmox una **plantilla de VM** procede de una VM preparada y convertida.
En LXC se parte normalmente de un archivo de plantilla de contenedor.
Son mecanismos diferentes aunque ambos eviten instalar todo desde cero.
[Plantillas y clones de VM](https://pve.proxmox.com/pve-docs/chapter-qm.html)
y [plantillas de CT](https://pve.proxmox.com/pve-docs/chapter-pct.html).

## Clon completo y clon enlazado

| Propiedad | Completo | Enlazado |
|---|---|---|
| Base de disco | Se copia para el nuevo invitado | Se mantiene dependencia de la base |
| Espacio y tiempo iniciales | Habitualmente mayores | Habitualmente menores |
| Dependencias | Disco del clon independiente de la base | Base y backend siguen siendo necesarios |
| Elección didáctica | Fácil de razonar al recuperar | Útil para estudiar dependencias y ahorro |
| Riesgo común | Olvidar presupuestar espacio | Confundir ahorro con copia independiente |

El soporte depende del almacenamiento y del origen. Un clon completo tampoco
es automáticamente un backup: si base y clon están en el mismo disco físico,
ambos comparten ese riesgo.

**Ejemplo:** crear cinco clones enlazados para ahorrar espacio no soluciona la
pérdida del disco que contiene la base. Para justificar una recuperación debes
identificar qué objetos necesita cada clon.

## Visualizar la dependencia de la base

Los dibujos representan **qué datos necesita el disco del clon para operar**,
no el proceso de creación.

**Clon completo, una vez finalizada la copia:**

~~~mermaid
flowchart TD
    V["VM clonada"] --> D["Disco propio del clon"]
    D --> P["Almacenamiento que lo contiene"]
~~~

**Clon enlazado, cuando el backend lo soporta:**

~~~mermaid
flowchart TD
    V["VM clonada"] --> C["Cambios propios del clon"]
    V --> B["Base de la plantilla"]
    C --> P["Almacenamiento necesario"]
    B --> P
~~~

La dependencia del clon enlazado permite ahorrar copia inicial. No significa
que puedas editar libremente su disco base como una carpeta compartida.
Gestiona base y clones mediante operaciones soportadas por Proxmox y no
elimines volúmenes manualmente.

Ejemplo conceptual: una base contiene 6 GiB de bloques útiles y cada clon
añade 1 GiB de cambios. Dos clones enlazados comparten la base y añaden sus
cambios: `6 + 1 + 1 = 8 GiB` en este modelo simplificado. Dos copias completas
que conservan la base requerirían `6 + 7 + 7 = 20 GiB` en el mismo modelo.

**No es una predicción exacta de consumo:** formato, thin provisioning,
metadatos, snapshots, compresión y bloques modificados cambian el resultado.
El ejemplo solo explica por qué compartir una base ahorra espacio a cambio
de dependencia. Mide el backend real antes de aceptar el presupuesto.

## Las identidades que pueden duplicarse

Un clon no debe reutilizar sin revisión todo lo que encontró en la base:

- Nombre del sistema y dirección IP.
- Identificador de máquina y, cuando proceda, identificadores de aplicación.
- Claves privadas de host SSH.
- Credenciales, tokens y archivos personales.
- Identificadores o datos exclusivos del servicio.

Proxmox puede generar una MAC nueva, pero eso no garantiza que la IP estática
configurada dentro del invitado cambie. Renombrar la VM en el árbol tampoco
renombra necesariamente el sistema operativo.

La limpieza debe seguir el mecanismo de la distribución y comprobarse en un
clon de ensayo. Borrar indiscriminadamente archivos de identidad de una
máquina en uso puede dejarla inaccesible; no se propone como receta general.

## Dos clones con identidad propia {#ejemplo-identidad}

Quieres desplegar servidor y cliente desde una misma plantilla.

| Dato | Servidor de ejemplo | Cliente de ejemplo |
|---|---|---|
| ID en Proxmox | 101 | 102 |
| Nombre del objeto | `srv-aso` | `cli-linux` |
| Hostname interior | `srv-aso` | `cli-linux` |
| IP en la red local | `192.168.56.20/24` | `192.168.56.30/24` |
| Clave pública de host SSH | Huella propia del servidor | Huella propia del cliente |

Los IDs e IP son orientativos: comprueba disponibilidad y autorización.
La tabla distingue **etiqueta**, **identidad del sistema** e **identidad de red**.

**Error resuelto:** ambos clones aparecen con nombres distintos en el panel,
pero responden con la misma IP de la base.

1. Los nombres visibles solo demuestran que cambió la etiqueta del objeto.
2. Revisa cada clon por consola, evitando conectarlos simultáneamente con
   una IP duplicada.
3. Corrige su configuración o el mecanismo de inicialización de la plantilla.
4. Repite la creación de un clon de ensayo para demostrar que la base es
   reutilizable, no que has reparado una única instancia.

Si corregiste la plantilla, los clones existentes no reciben automáticamente
ese arreglo. Debes aplicarles un procedimiento propio o recrearlos cuando
esté autorizado y sus datos se hayan protegido.

## Cloud-init y Ansible resuelven momentos diferentes

Cloud-init proporciona inicialización de instancias a partir de datos como
usuario, clave pública, nombre y red, cuando la imagen está preparada para
ello. Proxmox puede facilitar esos datos mediante su integración.
[Cloud-init en Proxmox](https://pve.proxmox.com/pve-docs/cloud-init.html).

Ansible aplica la configuración descrita en el playbook y permite volver a comprobarla y corregirla durante la vida del servidor. Puede utilizarse después de cloud-init: este prepara el primer arranque y Ansible configura y mantiene el servicio.

| Momento | Ejemplo de responsabilidad |
|---|---|
| Preparar la base | Instalar lo común y retirar datos privados |
| Primer arranque | Establecer una identidad nueva y acceso administrativo |
| Configurar el servicio | Aplicar paquetes, archivos y estados con Ansible |
| Mantener | Reaplicar cambios y comprobar desviaciones |

En este curso cloud-init es una ampliación, no un requisito añadido.
La limpieza y el comportamiento del primer arranque dependen de la imagen;
consulta [cloud-init clean](https://docs.cloud-init.io/en/latest/reference/cli.html#clean)
y no presupongas que todas las identidades se regeneran de la misma forma.

## Versiona la base, no sus secretos

Utiliza un nombre como `linux-base-v1` para reconocer la versión de la plantilla y acompáñalo de su documentación: distribución, versión, fecha, paquetes, recursos y preparación. Incluye la prueba de clonación y las limitaciones encontradas. Si creas una segunda versión, explica qué has corregido y por qué.

Actualizar una plantilla no actualiza automáticamente los clones existentes.
Cada clon tiene su ciclo de mantenimiento; Ansible permite gestionar su
configuración de forma repetible.

## Criterio de aceptación

Crea un clon de ensayo, comprueba que arranca y verifica su identidad antes
de conectarlo donde pueda causar una IP duplicada. Después valida acceso
administrativo y operación básica, sin usar contraseñas publicadas.

Responde en `docs/04-plantilla-linux.md`:

1. ¿Qué contiene la base y qué se asigna a cada clon?
2. ¿Qué dependencia tendría un clon enlazado que no tenga uno completo?
3. ¿Cómo has demostrado que dos clones no comparten identidad de red?
4. ¿Qué harías con clones existentes después de corregir la plantilla?

Aplica estas ideas en el [procedimiento de plantilla, servidor y cliente](plantillas.md).
