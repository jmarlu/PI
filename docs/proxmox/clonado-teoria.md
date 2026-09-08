# Plantillas, clones e identidad

## De instalación a base reutilizable

Instalar un sistema produce una máquina. Preparar una plantilla produce una
base desde la que puedan nacer máquinas distintas sin heredar defectos,
secretos o identidades incompatibles.

Una base útil tiene versión conocida, paquetes necesarios, acceso
administrativo previsto y ausencia de datos personales. Debes saber qué queda
fijado en ella y qué se configurará en cada despliegue.

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

## Cloud-init y Ansible resuelven momentos diferentes

Cloud-init proporciona inicialización de instancias a partir de datos como
usuario, clave pública, nombre y red, cuando la imagen está preparada para
ello. Proxmox puede facilitar esos datos mediante su integración.
[Cloud-init en Proxmox](https://pve.proxmox.com/pve-docs/cloud-init.html).

Ansible converge la configuración descrita por el proyecto y permite
reaplicarla durante la vida del servidor. No necesitas elegir solo uno:
una base puede inicializarse y después ser configurada con Ansible.

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

Un nombre como `linux-base-v1` ayuda, pero no sustituye una ficha:
distribución, versión, fecha, paquetes, recursos, preparación, limitaciones y
prueba de clonación. Si corriges la base, registra por qué existe `v2` y qué
cambió.

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

