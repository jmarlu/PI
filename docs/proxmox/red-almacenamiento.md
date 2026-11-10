# Red y almacenamiento

## Una red acordada, no una red inventada

Un bridge conecta interfaces a nivel de enlace; no crea por sí mismo NAT,
DHCP ni aislamiento. Una VLAN separa tráfico si toda la ruta y sus puertos
están configurados para ello.

Pide subred, IPs, gateway, DNS y bridge/VLAN autorizados. Una red sin salida
puede ser adecuada para pruebas, pero necesitará una vía aprobada para instalar
paquetes. No añadas un servidor DHCP al bridge del aula.

Para el montaje habitual de clase, sigue la
[red local en VirtualBox](virtualbox.md#red-local), con NAT para salida y
red solo-anfitrión para gestión y laboratorio. Las comprobaciones de esta
página también te sirven para revisar ese montaje.

## Ejemplo para la instalación física opcional

Este ejemplo se aplica solo a una instalación directa en equipo propio
autorizada por el profesor. Sustituye las direcciones por las de tu diseño:

| Sistema | IP de ejemplo | Papel |
|---|---|---|
| Tu nodo | 192.168.50.10/24 | Administración de Proxmox |
| srv-aso | 192.168.50.20/24 | Servicio Samba |
| cli-linux | 192.168.50.30/24 | Pruebas |
| Gateway | 192.168.50.1 | Solo si realmente existe y está autorizado |

~~~mermaid
flowchart TD
    A["Equipo de administración"] --> B["Bridge/VLAN autorizados"]
    B --> N["Tu nodo · gestión"]
    B --> S["srv-aso · SMB"]
    B --> C["cli-linux · pruebas"]
    C -->|"TCP 445"| S
~~~

Si tu diseño usa una red interna distinta, dibuja sus dos interfaces y el
enrutamiento o NAT autorizado. No copies este ejemplo como si describiera
una infraestructura que no has comprobado.

## Diagnóstico por capas

Desde cada invitado, registra:

~~~bash
hostname
ip -br addr
ip route
ping -c 4 IP_DEL_OTRO_INVITADO
getent hosts NOMBRE_CONFIGURADO
~~~

Primero revisa interfaz y dirección; después subred/ruta; finalmente resolución
y servicio. Que `ping` funcione no demuestra que Samba escuche. Que falle
tampoco prueba por sí solo que el equipo esté apagado: ICMP podría estar filtrado.

En VirtualBox, configura la red solo-anfitrión y el modo promiscuo del adaptador
local conforme a la [guía específica](virtualbox.md#red-local). El NAT de VirtualBox
por sí solo no proporciona acceso desde el host al panel ni salida a los
invitados internos: sigue el diseño de las dos interfaces y el NAT del nodo.

## Ejemplo de diagnóstico con resultado limitado

Escenario: desde el anfitrión puedes abrir el panel en `192.168.56.10:8006`;
desde `cli-linux` no puedes llegar a `srv-aso` en `192.168.56.20`.

La primera prueba valida la ruta de administración, **no** la interfaz virtual
del cliente ni la del servidor. Revisa sus IP y máscaras, su conexión a
`vmbr1` y el puerto concreto del servicio.

| Resultado observado | Conclusión permitida | Siguiente comprobación |
|---|---|---|
| El nodo aparece en el panel | La gestión es accesible desde ese origen | Consola y configuración de cada invitado |
| Cliente sin dirección prevista | Su configuración no coincide con el diseño | Corregir esa diferencia por el procedimiento aprobado |
| Acceso por IP funciona, por nombre no | El problema puede estar en resolución | Nombre configurado y resolver de ese cliente |
| Puerto accesible, operación rechazada | Hay comunicación con una aplicación | Prueba de aceptación del servicio y sus registros |

No soluciones una IP duplicada abriendo puertos ni un error de autenticación
creando otro bridge. Usa los [recorridos explicados](redes-teoria.md#ejemplo-recorridos)
para formular una hipótesis comprobable.

## Qué almacena cada storage

Los nombres son ejemplos habituales, no una garantía de tu instalación:

| Tipo o nombre | Contenido habitual | Comprobación |
|---|---|---|
| Directory, a menudo `local` | ISO, plantillas CT y backups según configuración | Tipos de contenido habilitados |
| LVM-thin, a menudo `local-lvm` | Discos de VM y volúmenes CT | Espacio del thin pool, no solo tamaño virtual |
| Destino de backup autorizado | Copias de invitados | Capacidad, permisos y dominio de fallo |
| Disco del invitado | Sistema y datos del servicio | `df -h` dentro del invitado |

Una plantilla CT descargada no es un contenedor ya configurado.
Una ISO tampoco es una VM instalada.

Consulta el [manual de almacenamiento](https://pve.proxmox.com/pve-docs/chapter-pvesm.html)
para los tipos admitidos por tu versión.

## Presupuestar sin contar dos veces

Reserva espacio para sistema, discos de invitados, plantilla, ISO, crecimiento
y copias. El aprovisionamiento fino permite anunciar más capacidad virtual
que la ocupada, pero no crea espacio físico. Si varios storages comparten
disco o pool, no sumes sus capacidades como si fueran discos independientes.

Ejemplo didáctico de RAM, **no una solución para tu inventario**: con una VM Proxmox
de 8 GiB, reservas estimadas de 2 GiB para el nodo, 2 GiB para servidor,
1 GiB para cliente y 1 GiB de margen dejan 2 GiB sin asignar. Debes justificar
esas reservas y contrastarlas durante las pruebas. Fuera de esa VM, también
necesitas RAM para LliureX, VirtualBox, navegador, editor y Ansible. Las vCPU se comparten;
no son núcleos exclusivos.

## Evidencias

`docs/02-diagrama-red.md` debe contener diagrama, tabla IP, interfaces,
límites de acceso, supuestos y pruebas. Relaciona el presupuesto de storage
con el inventario. No sustituyas las
[tres respuestas de viabilidad](../proyecto/fase-1-inventario.md)
por el ejemplo de esta página.
