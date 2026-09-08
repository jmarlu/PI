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

