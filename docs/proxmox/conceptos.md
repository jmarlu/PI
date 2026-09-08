# Qué es Proxmox y qué vas a construir

Proxmox VE administra máquinas virtuales KVM y contenedores LXC desde una
interfaz web. El nodo es el sistema que los aloja; no es una de las máquinas
invitadas. Consulta la [presentación oficial](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview).

## Cuatro lugares que no debes confundir

| Lugar | Para qué lo usas | Qué no debes hacer |
|---|---|---|
| Equipo de administración, normalmente LliureX | Navegador, Git, editor y Ansible | Borrarlo para instalar sin permiso |
| VirtualBox en ese mismo equipo | Crear la VM que alojará tu Proxmox | Crear fuera de Proxmox el servidor y el cliente del proyecto |
| Tu nodo Proxmox | Crear y administrar tu plantilla, servidor y cliente | Instalar Samba aquí |
| Invitados `srv-aso` y `cli-linux` | Servicio Linux y pruebas | Confundir su consola con la del nodo |

En la modalidad física, tu Proxmox se instala directamente en el equipo autorizado.
En la virtualizada, el host ejecuta VirtualBox, y Proxmox es una VM suya:

~~~mermaid
flowchart TD
    A["Tu equipo: sistema anfitrión, navegador, Git y Ansible"] --> P["VirtualBox instalado en ese equipo"]
    P --> N["Tu nodo Proxmox · una VM de VirtualBox"]
    A --> N
    N --> S["srv-aso · VM o LXC"]
    N --> C["cli-linux · VM o LXC"]
    C -->|"Pruebas del servicio"| S
~~~

Este diagrama explica las capas, no la red física. En la modalidad física
Proxmox se instala directamente en el equipo dedicado y no se usa VirtualBox.
El servidor Proxmox del centro queda fuera de ambas modalidades.

## VM o LXC

| Decisión | VM | LXC |
|---|---|---|
| Sistema | Kernel propio y hardware virtual | Comparte el kernel del nodo |
| Consumo | Más recursos para un sistema completo | Habitualmente menor para Linux ligero |
| Compatibilidad | Adecuada para sistemas con kernel propio | Cargas compatibles con el kernel Linux anfitrión |
| En un Proxmox virtualizado | KVM requiere extensiones expuestas y configuración anidada | No requiere KVM, pero sí soporte y permisos del entorno |
| Proyecto | Válida con recursos suficientes | Válida si el profesor aprueba el servicio y las limitaciones |

La virtualización anidada depende del anfitrión y del invitado; verla en
la ficha comercial de la CPU no prueba que esté disponible en tu VM.
Configuras esa capa en tu VirtualBox con supervisión. No descargues módulos
ni cambies el sistema anfitrión sin comprobar las consecuencias. [Referencia: KVM anidado](https://docs.kernel.org/virt/kvm/x86/running-nested-guests.html).

## Nodo individual, no alta disponibilidad

Si tu único nodo falla, sus invitados dejan de prestar servicio.
Un backup permite recuperar; no proporciona continuidad instantánea.
Un segundo contenedor en el mismo disco tampoco constituye redundancia
frente al fallo físico del nodo.

Tu objetivo es un laboratorio administrable y reproducible. No necesitas
montar un clúster, Ceph ni un sistema de producción para completar la práctica.

## Recorrido de teoría

Estos temas explican las decisiones que después aplicarás en el taller.
Trabaja las preguntas dentro de tu memoria y bitácora existentes; no son
nuevos entregables ni una segunda práctica de inventario.

| Tema | Pregunta central |
|---|---|
| [Arquitectura](arquitectura.md) | ¿Qué administra el panel y qué ejecuta el servicio? |
| [VM, LXC y anidación](virtualizacion.md) | ¿Qué virtualizo y qué soporte necesita cada alternativa? |
| [CPU y memoria](recursos.md) | ¿Cabe el laboratorio completo sin agotar el anfitrión? |
| [Redes virtuales](redes-teoria.md) | ¿Qué recorrido sigue cada conexión? |
| [Almacenamiento](almacenamiento-teoria.md) | ¿Dónde están los datos y qué capacidad es realmente libre? |
| [Plantillas y clones](clonado-teoria.md) | ¿Cómo creo sistemas distintos desde una base común? |
| [Operación y recuperación](operacion-recuperacion.md) | ¿Cómo limito riesgos y demuestro que puedo recuperar? |

No basta con memorizar definiciones. Para cada decisión distingue lo que
afirma la documentación oficial, lo que has configurado y lo que has medido.
Una captura del panel puede apoyar una afirmación, pero necesita contexto:
máquina, fecha, prueba y conclusión.

## Comprueba que lo entiendes

Explica dónde están el navegador, Samba y Ansible en tu caso.
Después responde: si `srv-aso` se apaga, ¿debería seguir accesible el panel
del nodo? ¿Y si se apaga el nodo? Guarda la conclusión junto a tu diagrama.

Continúa con la [interfaz](interfaz.md) y, tras validar el diseño, con la
[instalación](instalacion.md).
