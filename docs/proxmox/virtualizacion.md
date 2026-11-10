# Máquinas virtuales, LXC y virtualización anidada

## Qué se virtualiza

Una máquina virtual dispone de CPU, memoria, disco y red virtuales que utiliza como si fueran los componentes de un equipo. Dentro de ella se instala un sistema operativo con su propio kernel. En Proxmox, KVM utiliza el soporte de virtualización del procesador y QEMU proporciona el modelo de máquina y sus dispositivos.

Un contenedor LXC ejecuta sus programas utilizando el kernel de Linux del nodo Proxmox. El aislamiento permite que vea su propio entorno de procesos y recursos; los mecanismos llamados cgroups ayudan a limitar su consumo. A diferencia de una VM, el contenedor no arranca un kernel independiente. Puedes ampliar la comparación en la documentación de [máquinas virtuales](https://pve.proxmox.com/pve-docs/chapter-qm.html) y [contenedores](https://pve.proxmox.com/pve-docs/chapter-pct.html).

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

Los diagramas muestran qué utiliza una aplicación para funcionar en cada modalidad. Sigue las flechas desde la aplicación hasta el kernel. Representan dependencias de software, no conexiones de red.

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

Para ejecutar una VM dentro del Proxmox instalado en VirtualBox, el soporte de virtualización debe llegar hasta ese Proxmox. Hay que comprobar que el procesador lo ofrece, que está habilitado en BIOS/UEFI y que la versión y la configuración de VirtualBox permiten exponerlo a la VM. Esa opción se denomina virtualización anidada. Consulta las referencias de [VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/AdvancedTopics.html) y [KVM](https://docs.kernel.org/virt/kvm/x86/running-nested-guests.html).

**Ejemplo:** Proxmox arranca dentro de VirtualBox, pero al iniciar una VM interna aparece un aviso de que KVM no está disponible. Guarda el mensaje y revisa el soporte y la configuración de virtualización anidada. Ese aviso no demuestra que falte RAM: la memoria disponible es otra comprobación.

En el anfitrión, con la VM apagada, puedes activarla con
`VBoxManage modifyvm "pve-apellido" --nested-hw-virt on`. Después, dentro de
la VM Proxmox, `grep -Ec '(vmx|svm)' /proc/cpuinfo` comprueba si se ven las
extensiones: `0` indica que no se ven y un valor positivo requiere todavía
probar el arranque de una VM interna. La
[guía de VirtualBox](virtualbox.md#3-comprobar-la-virtualizacion-anidada)
explica el procedimiento y los posibles conflictos con KVM en Linux/LliureX
o con Hyper-V en Windows.

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

**Razonamiento:** primero comprueba qué soporte de virtualización recibe Proxmox desde VirtualBox y prueba el arranque de una VM. La salida de `lscpu` del anfitrión solo describe ese anfitrión; no demuestra que KVM funcione dentro de Proxmox. Si no se consigue utilizar KVM, se puede valorar LXC para un servicio compatible.

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
