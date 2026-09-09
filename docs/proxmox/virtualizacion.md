# Máquinas virtuales, LXC y virtualización anidada

## Qué se virtualiza

Una VM recibe una representación de CPU, memoria, disco, firmware y red. Su
sistema operativo ejecuta un kernel propio. En Proxmox, KVM aporta la
virtualización acelerada de CPU y QEMU participa en el modelo de máquina y
dispositivos.

Un contenedor LXC ejecuta procesos aislados mediante capacidades del kernel
Linux del nodo. Los espacios de nombres separan vistas de recursos y los
cgroups permiten controlar consumos. No arranca otro kernel independiente.
[Máquinas virtuales](https://pve.proxmox.com/pve-docs/chapter-qm.html) y
[contenedores Proxmox](https://pve.proxmox.com/pve-docs/chapter-pct.html).

| Necesidad | VM | Contenedor |
|---|---|---|
| Sistema con kernel distinto | Aporta su propio kernel | Depende del kernel del nodo |
| Menor gasto base para Linux | Incluye un sistema completo | Suele reducir ese gasto |
| Acceso especial a dispositivos | Exige configuración compatible | Puede chocar con aislamiento y permisos |
| Separación del kernel | Sí | No |
| Mantenimiento | Actualizas nodo e invitado | Actualizas nodo y espacio de usuario del CT |
| Copias | Debes conocer discos incluidos | Debes conocer rootfs y montajes incluidos |

Ninguna columna significa “seguro automáticamente”. La seguridad también
depende de actualizaciones, configuración, privilegios y exposición de red.

## Ver dónde está el kernel

Esquemas conceptuales de **una carga**, con dependencias hacia abajo.
No son capturas del panel ni representan el cableado de red.

**Ruta VM:**

~~~mermaid
flowchart TD
    A["Aplicación en la VM"] --> B["Kernel propio del invitado"]
    B --> C["Hardware virtual · QEMU/KVM"]
    C --> D["Kernel del nodo Proxmox"]
~~~

**Ruta LXC:**

~~~mermaid
flowchart TD
    A["Aplicación dentro del CT"] --> B["Entorno aislado de procesos"]
    B --> C["Kernel compartido del nodo"]
~~~

Al actualizar el kernel de una VM, actualizas el de ese invitado. Un CT no
puede arrancar un kernel propio para reemplazar el del nodo: aunque su
distribución sea distinta, ejecuta procesos sobre el kernel compartido.

En modalidad virtual, debajo de **ambos** dibujos sigue existiendo la VM
Proxmox de VirtualBox y el equipo real. El ahorro de LXC está en la capa de
los invitados internos; no elimina la VM exterior.

## Dispositivos emulados y paravirtualizados

Un dispositivo emulado busca que el invitado reconozca un modelo conocido.
VirtIO ofrece una interfaz pensada para virtualización y necesita soporte en
el invitado. La elección de controlador de disco y adaptador de red influye en
rendimiento, compatibilidad e instalación.

En una base Linux compatible, VirtIO suele ser una opción razonable para el
laboratorio. No cambies a la vez firmware, controlador de arranque y disco de
una VM ya instalada sin copia ni plan de recuperación: puedes crear un problema
de arranque que no tiene relación con los datos del servicio.

El tipo de CPU virtual determina características visibles para el invitado.
`host` expone características de la CPU disponible al nodo; facilita aprovechar
ese procesador, pero reduce la portabilidad entre equipos diferentes. No añade
instrucciones que VirtualBox no haya expuesto a Proxmox.

## Dos niveles de virtualización

En nuestro montaje:

1. El procesador real ejecuta el sistema anfitrión y VirtualBox.
2. VirtualBox ejecuta la VM que contiene Proxmox.
3. Proxmox ejecuta las VMs internas mediante KVM, **si recibe ese soporte**.

Que el procesador incluya VT-x/AMD-V no basta. Intervienen firmware, sistema
anfitrión, versión de VirtualBox y configuración de la VM externa. La opción
de virtualización anidada permite exponer extensiones al hipervisor invitado
cuando el entorno lo soporta.
[VirtualBox: virtualización anidada](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/AdvancedTopics.html)
y [KVM anidado](https://docs.kernel.org/virt/kvm/x86/running-nested-guests.html).

**Ejemplo de razonamiento:** si Proxmox arranca, pero una VM interna avisa de que
KVM no está disponible, no concluyas que falta RAM. Separa la prueba de
extensiones de la prueba de capacidad. Conserva el mensaje y contrasta la
configuración de VirtualBox antes de cambiar el tipo de invitado.

Ejecutar mediante emulación de software no equivale a haber validado KVM
anidado y puede resultar demasiado lento para la práctica. No lo presentes
como una solución de rendimiento sin medirlo y obtener aprobación.

## Contenedores no privilegiados

En un CT no privilegiado, los identificadores de usuario se mapean de modo que
el root del contenedor no sea directamente el root del nodo. Esto reduce
riesgos, pero puede complicar permisos sobre recursos externos o funciones que
necesiten capacidades adicionales.

El contenedor privilegiado no debe ser el arreglo automático ante “operación
no permitida”. Primero identifica la función requerida, comprueba soporte y
documenta la decisión. Una VM puede ser más apropiada para una carga concreta.

Un CT comparte el kernel de **tu nodo Proxmox** aunque ese nodo sea, a su vez,
una VM de VirtualBox. El CT no necesita KVM para ejecutar otro kernel, pero el
nodo externo sigue necesitando poder funcionar.

## Tres decisiones explicadas {#casos-eleccion}

### Caso 1: Linux ligero con un servicio compatible

El nodo ya funciona y el servicio no necesita otro kernel ni dispositivos
especiales. Hay poca memoria disponible.

**Razonamiento:** un CT no privilegiado puede reducir el gasto base y permitir
la coexistencia con el cliente. Antes de aprobarlo, prueba el servicio y la
recuperación con sus montajes reales. “Consume menos” no garantiza compatibilidad
ni cubre datos externos que queden fuera del backup.

### Caso 2: necesitas un kernel independiente

Quieres ensayar una modificación del kernel sin cambiar el del nodo.

**Razonamiento:** una VM separa ese kernel. Un CT no obtiene un kernel propio
por asignarle más memoria o cambiar su nombre. En el montaje VirtualBox tendrás
que comprobar además la disponibilidad de KVM interno y el presupuesto completo.

### Caso 3: Proxmox arranca, pero la VM interna no

La CPU del equipo declara soporte de virtualización, pero KVM no está disponible
en la VM Proxmox.

**Razonamiento:** la capacidad del procesador es solo un eslabón. Se comprueba
qué expone VirtualBox al nodo y el arranque real de una VM de ensayo. Si no
puede validarse KVM interno, se estudia LXC para un servicio compatible.
No es correcto presentar la captura de `lscpu` del anfitrión como demostración
de KVM funcional dentro de Proxmox.

Elige por requisitos y pruebas. No asumas que activar `nesting` en un CT
habilita VT-x/AMD-V en VirtualBox: son opciones de **capas diferentes**.

## Cómo justificar la elección

Redacta una decisión basada en tu inventario, no en una preferencia genérica:

> Mi equipo permite ejecutar Proxmox en VirtualBox. He comprobado [...].
> El servicio necesita [...]. Elijo [...] porque [...].
> Pierdo o limito [...]. Lo validaré mediante [...].

Contrasta al menos tres factores: compatibilidad del servicio, presupuesto de
RAM/CPU/disco y aislamiento/recuperación. Una elección de LXC bien justificada
es válida; una VM que deja sin memoria al anfitrión no es mejor por su nombre.

## Preguntas de aplicación

- ¿Por qué reducir RAM no puede hacer aparecer unas extensiones KVM ausentes?
- ¿Una actualización del kernel dentro de un CT cambia el kernel del nodo?
- ¿Qué cambia en tu decisión si el servicio exige un módulo de kernel especial?
- ¿Qué evidencias distinguen “Proxmox instalado” de “laboratorio viable”?

Relaciona las respuestas con las tres preguntas del inventario en la
[práctica principal](../proyecto/practica.md), sin crear otra entrega.
