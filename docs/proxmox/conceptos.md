# Qué es Proxmox y qué vas a construir

Proxmox VE permite administrar máquinas virtuales KVM y contenedores LXC desde un panel web. El sistema que ejecuta Proxmox y aloja esas máquinas se llama **nodo**. Puede estar instalado directamente en un ordenador o dentro de una VM de VirtualBox. En el segundo caso, Proxmox es un invitado de VirtualBox y, a la vez, el anfitrión del servidor y del cliente que crearás dentro de él. Consulta la [presentación oficial](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview).

## Para qué virtualizamos un servidor

Supón que necesitas un servidor para prestar el servicio y un cliente para
probarlo. Si instalas todo en un único sistema, comparten configuración,
paquetes y ciclo de reinicio. Además, una prueba hecha desde el propio servidor
puede no recorrer la misma red que utilizaría un cliente.

Con Proxmox puedes crear un servidor y un cliente separados, asignarles recursos distintos y administrar sus arranques y copias. Aunque se comporten como dos sistemas, utilizan el mismo ordenador físico. Por eso un fallo del disco o del equipo que comparten puede afectar a ambos.

Una VM tampoco es solo una ventana de consola. Sigue ejecutándose aunque
cierres esa ventana o el navegador, siempre que su nodo siga funcionando.
El navegador administra; no suministra la CPU de la VM.

## Un laboratorio completo, explicado {#ejemplo-completo}

Ejemplo didáctico compatible con el esquema de la guía de VirtualBox:
un puesto con 16 GiB de RAM aloja una VM Proxmox de 8 GiB. Los otros 8 GiB quedan
para el anfitrión y su margen. **No son mínimos oficiales ni recursos medidos.**

| Objeto | Qué contiene | Quién lo administra |
|---|---|---|
| Equipo del alumno | LliureX, navegador, Git y VirtualBox | Su sistema anfitrión y las herramientas autorizadas |
| VM exterior `pve-alumno` | Proxmox y el almacenamiento de sus invitados | VirtualBox |
| Plantilla 900 | Base preparada para clonar | Proxmox |
| Invitado 101, `srv-aso` | El servicio ASO | Proxmox para su hardware virtual; Ansible para su configuración |
| Invitado 102, `cli-linux` | Cliente de pruebas | Proxmox para sus recursos; herramientas del cliente para probar |

Si abres el navegador y visitas el panel, todavía no has entrado en
`srv-aso`. Seleccionar su consola sí te da acceso a ese invitado. Si ejecutas
Ansible desde el anfitrión hacia `192.168.56.20`, las tareas del servicio
se aplican al servidor seleccionado, no al nodo `192.168.56.10`.

**Tres situaciones resueltas:**

- Cierras el navegador: el nodo y los invitados pueden continuar ejecutándose.
- Apagas `cli-linux`: pierdes ese cliente de pruebas, pero `srv-aso` puede seguir
  prestando servicio a otros clientes autorizados.
- Apagas la VM Proxmox desde VirtualBox: interrumpes también los invitados que
  dependían de ella. Tener sus consolas cerradas no los protege.

En la instalación física opcional se elimina la capa VirtualBox, no la separación entre
nodo, servidor y cliente. El equipo de administración accede al nodo por la
red autorizada; no hace falta ejecutar el navegador dentro de Proxmox.

## Cuatro lugares que no debes confundir

| Lugar | Para qué lo usas | Qué no debes hacer |
|---|---|---|
| Equipo de administración, normalmente LliureX | Navegador, Git, editor y Ansible | Borrarlo para instalar sin permiso |
| VirtualBox en ese mismo equipo | Crear la VM que alojará tu Proxmox | Crear fuera de Proxmox el servidor y el cliente del proyecto |
| Tu nodo Proxmox | Crear y administrar tu plantilla, servidor y cliente | Instalar Samba aquí |
| Invitados `srv-aso` y `cli-linux` | Servicio Linux y pruebas | Confundir su consola con la del nodo |

En la instalación física opcional, tu Proxmox se instala directamente en el equipo autorizado.
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

Este diagrama explica las capas, no la red física. En la instalación física opcional
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

## Localiza un ejemplo resuelto

| Duda | Ejemplo explicado |
|---|---|
| ¿Qué significa lo configurado en una VM? | [Leer una configuración sin modificarla](arquitectura.md#ejemplo-configuracion) |
| ¿Elijo VM o contenedor? | [Tres decisiones de virtualización](virtualizacion.md#casos-eleccion) |
| ¿Cabe el laboratorio? | [Calcular RAM y margen paso a paso](recursos.md#ejemplo-presupuesto) |
| ¿Por dónde viaja una conexión? | [Conexión local y salida exterior](redes-teoria.md#ejemplo-recorridos) |
| ¿Por qué falla una escritura con espacio libre? | [Tres capas de capacidad](almacenamiento-teoria.md#ejemplo-capacidad) |
| ¿Qué debe cambiar en un clon? | [Separar identidades](clonado-teoria.md#ejemplo-identidad) |
| ¿Qué puedo recuperar y cuánto tardo? | [Ensayo con RPO y RTO](operacion-recuperacion.md#ejemplo-recuperacion) |
| ¿Cómo interpreto el panel? | [Lectura de una captura real](interfaz.md#lectura-captura) |

Los esquemas y resultados de ejemplo son material didáctico, no capturas de
un laboratorio instalado para ti. Contrasta las hipótesis con tu equipo y
añade tus propias evidencias a los documentos existentes.

## Comprueba que lo entiendes

Explica dónde están el navegador, Samba y Ansible en tu caso.
Después responde: si `srv-aso` se apaga, ¿debería seguir accesible el panel
del nodo? ¿Y si se apaga el nodo? Guarda la conclusión junto a tu diagrama.

Continúa con la [interfaz](interfaz.md) y, tras validar el diseño, con la
[instalación](instalacion.md).
