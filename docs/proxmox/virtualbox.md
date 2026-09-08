# Proxmox en VirtualBox local

**Modalidad virtual. Todo el laboratorio se ejecuta en el equipo del alumno.**
El Proxmox del centro no se utiliza.

Necesitas VirtualBox instalado, espacio local y permisos para configurar tus VMs
y sus redes. No necesitas borrar LliureX ni disponer de otro ordenador dedicado.

## 1. Comprobar el anfitrión

En LliureX, desde la terminal del **anfitrión**, no desde Proxmox:

~~~bash
VBoxManage --version
lscpu
free -h
df -h
~~~

Investiga modelo de CPU, virtualización de hardware, RAM y disco real.
Registra restricciones de BIOS/UEFI, permisos y versión. Si VirtualBox no arranca
una VM de 64 bits, solicita revisión; no descargues módulos, cambies Secure Boot
o desactives protecciones del sistema por ensayo.

Completa el [inventario obligatorio](../proyecto/practica.md#7-fase-1-inventario-investigado-y-viabilidad)
con **dos niveles de presupuesto**:

- Host: LliureX, VirtualBox, navegador, editor, Git/Ansible y margen.
- VM Proxmox: hipervisor, plantilla, `srv-aso`, `cli-linux` y margen.

Ejemplo de punto de partida para un host con 16 GiB reales: VM Proxmox de
8 GiB y hasta 8 GiB restantes para el host y sus aplicaciones. Dentro de la VM
puedes estudiar reservas de 2 GiB al nodo, 2 GiB al servidor y 1 GiB al cliente,
manteniendo margen. **Es una estimación, no una garantía de viabilidad.**
La CPU i3 concreta, el disco y la carga del host deben investigarse.

## 2. Crear la VM exterior

En VirtualBox, pulsa *Nueva* y prepara una instalación manual:

| Opción | Punto de partida a justificar |
|---|---|
| Nombre | `pve-apellido` |
| Tipo/arquitectura | Linux, Debian de 64 bits o equivalente de la versión |
| Instalación desatendida | Omitir; seguir el instalador Proxmox |
| Memoria | 6-8 GiB, dejando margen suficiente al anfitrión |
| CPU | 2 vCPU; ampliar solo con justificación |
| Disco | VDI, 80 GiB orientativos, en una carpeta con espacio real suficiente |
| ISO | Proxmox VE de la versión autorizada, con SHA-256 contrastado |
| Adaptador 1 | NAT, cable conectado |
| Adaptador 2 | Solo-anfitrión, conectado a la red local creada en el paso siguiente |

Un VDI dinámico crece al usarse: vigila **tanto `df -h` del host como el storage
interno de Proxmox**. No pongas VDI, ISO, snapshots o backups de VirtualBox
en tu repositorio GitHub.

La preparación de las VMs se describe en el
[manual de VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/working-with-vms.html).

## 3. Comprobar la virtualización anidada

Con la VM Proxmox **apagada**, revisa en *Configuración > Sistema > Procesador*
la opción *Habilitar VT-x/AMD-V anidado*. Debe estar disponible y ser compatible
con tu host y versión.

Como alternativa de configuración, en el anfitrión, sustituyendo el nombre real:

~~~bash
VBoxManage modifyvm "pve-apellido" --nested-hw-virt on
VBoxManage showvminfo "pve-apellido"
~~~

Esto solicita la exposición del soporte, pero no lo crea si el equipo no lo tiene.
Tras instalar Proxmox, comprueba extensiones visibles y arranque de una VM KVM
de prueba. No confundas ejecutar el comando con demostrar el funcionamiento.
[VirtualBox: virtualización anidada](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/AdvancedTopics.html).

**Alternativa:** si Proxmox arranca pero KVM interno no funciona, utiliza LXC
dentro de Proxmox con validación docente. Mantienes plantilla, servidor, cliente,
ASO, Bash, Ansible y restauración. Si falla la propia VM exterior, esta alternativa
no resuelve el problema del anfitrión.

## 4. Red local {#red-local}

El diseño propuesto usa **NAT para salida y solo-anfitrión para gestión y servicio**,
sin conectar por bridge el laboratorio a la red física del aula.

En las herramientas de red de VirtualBox crea o revisa una red solo-anfitrión.
Ejemplo: interfaz del host `192.168.56.1/24` y DHCP desactivado para usar IP estática.
No modifiques una red ya usada por otros laboratorios sin autorización.

En el adaptador 2 de la VM selecciona esa red y, para permitir las MAC de los
invitados internos hacia el host, configura **modo promiscuo: permitir todo**
solo en ese adaptador de laboratorio. No cambies la interfaz física del aula.

El modo solo-anfitrión conecta el host y el laboratorio, pero no proporciona
Internet por sí mismo. NAT y solo-anfitrión tienen alcances distintos.
[Redes de VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/networkingdetails.html).

| Elemento | Dirección de este ejemplo | Función |
|---|---|---|
| Interfaz solo-anfitrión del host | 192.168.56.1/24 | Navegador, SSH y Ansible hacia el laboratorio |
| Proxmox `vmbr0` sobre adaptador 1 NAT | 10.0.2.15/24 | Salida del nodo |
| Gateway NAT de VirtualBox | 10.0.2.2 | Salida al exterior permitido |
| DNS NAT de VirtualBox | 10.0.2.3 | Resolución en este ejemplo |
| Proxmox `vmbr1` sobre adaptador 2 | 192.168.56.10/24 | Gestión del nodo y gateway de invitados |
| `srv-aso` en `vmbr1` | 192.168.56.20/24 | Servidor Linux |
| `cli-linux` en `vmbr1` | 192.168.56.30/24 | Cliente Linux |

Comprueba que estos rangos no colisionan con VPN u otras redes del host.
Si tu VirtualBox usa otra configuración NAT, adapta dirección, gateway y DNS.
No asignes gateway a la interfaz solo-anfitrión de LliureX.
Dentro de Proxmox solo `vmbr0` lleva el gateway por defecto.

~~~mermaid
flowchart TD
    H["Equipo del alumno · LliureX y VirtualBox"] --> A["Red solo-anfitrión · 192.168.56.1"]
    A --> L["Proxmox vmbr1 · 192.168.56.10"]
    L --> S["srv-aso · .20"]
    L --> C["cli-linux · .30"]
    C -->|"Samba"| S
    L -->|"Enrutamiento y NAT del nodo"| W["Proxmox vmbr0 · 10.0.2.15"]
    W --> V["NAT VirtualBox · 10.0.2.2"]
    V --> I["Salida autorizada del equipo"]
~~~

## 5. Instalar Proxmox y abrir el panel

1. Arranca la ISO en la consola de VirtualBox.
2. Selecciona el VDI de la VM, revisando capacidad y resumen antes de instalar.
3. Configura hostname como `pve-apellido.lab.test`, credenciales y zona horaria.
4. En este ejemplo, selecciona inicialmente la interfaz NAT e introduce
   `10.0.2.15/24`, gateway `10.0.2.2` y DNS `10.0.2.3`.
5. Tras instalar, retira la ISO y reinicia la VM.
6. Desde la consola de VirtualBox, configura la segunda red de Proxmox para
   poder abrir `https://192.168.56.10:8006` desde el navegador del host.

No necesitas acceder al Proxmox del centro para ningún paso.

## 6. Configuración de las dos interfaces del nodo

En **la consola de tu VM Proxmox**, identifica interfaces y MAC:

~~~bash
ip -br link
ip -br addr
ip route
~~~

Relaciona cada MAC con el adaptador 1/2 de VirtualBox.
El ejemplo siguiente supone `enp0s3` para NAT y `enp0s8` para solo-anfitrión.
**Tu versión puede usar otros nombres, por ejemplo `nic0` y `nic1`.**

Guarda una copia de `/etc/network/interfaces` fuera de GitHub y edítalo con
el profesor desde la consola. Integra los cambios en el archivo existente;
no dupliques bridges, interfaces ni la ruta por defecto.

Ejemplo de contenido relevante:

~~~text
auto lo
iface lo inet loopback

iface enp0s3 inet manual
iface enp0s8 inet manual

auto vmbr0
iface vmbr0 inet static
    address 10.0.2.15/24
    gateway 10.0.2.2
    bridge-ports enp0s3
    bridge-stp off
    bridge-fd 0

auto vmbr1
iface vmbr1 inet static
    address 192.168.56.10/24
    bridge-ports enp0s8
    bridge-stp off
    bridge-fd 0

source /etc/network/interfaces.d/*
~~~

Revisa sintaxis y aplica con `ifreload -a` desde la consola, no desde una
única sesión SSH que puedas perder. Comprueba rutas y acceso al panel.
Ajusta `/etc/hosts` para que el nombre del nodo resuelva a su IP de gestión
`192.168.56.10`, no a loopback ni a otra VM; compruébalo con `hostname -f`
y `getent hosts pve-apellido.lab.test`.

## 7. Salida a repositorios de los invitados

Los invitados tienen gateway `192.168.56.10` y DNS `10.0.2.3` en este ejemplo.
Además del NAT exterior de VirtualBox, necesitas **enrutamiento y NAT en tu
nodo Proxmox** para que sus paquetes salgan con la dirección `10.0.2.15`.

Con aprobación docente, en tu nodo comprueba `command -v iptables` y registra
las reglas existentes. No mezcles este ejemplo con reglas de otra práctica,
ni vacíes el firewall. Si existe una política de filtrado, el profesor debe
integrar también el tráfico de ida y retorno permitido.

Para una prueba temporal, desde la consola de tu nodo:

~~~bash
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s 192.168.56.0/24 -o vmbr0 -j MASQUERADE
~~~

Ejecuta la adición **una sola vez** y prueba desde un invitado `ip route`,
resolución DNS y acceso al repositorio Linux autorizado. Si el tráfico se filtra,
consulta los registros; no desactives todo el firewall. El NAT es traducción,
no una política completa de aislamiento.

Después de validar, retira la regla temporal antes de configurar su persistencia:

~~~bash
iptables -t nat -D POSTROUTING -s 192.168.56.0/24 -o vmbr0 -j MASQUERADE
~~~

Añade bajo la sección `vmbr1` del ejemplo anterior:

~~~text
    post-up sysctl -w net.ipv4.ip_forward=1
    post-up iptables -t nat -A POSTROUTING -s 192.168.56.0/24 -o vmbr0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s 192.168.56.0/24 -o vmbr0 -j MASQUERADE
~~~

Programa un reinicio limpio del nodo para verificar persistencia sin acumular
reglas por aplicaciones repetidas. Detén primero los invitados de forma ordenada.
Si el firewall Proxmox de tu versión requiere ajustes adicionales de forwarding
o seguimiento de conexiones, revísalos con el profesor antes de darlo por validado.
No copies reglas globales de otros sistemas.

Referencia del mecanismo y de las zonas de conntrack:
[manual Proxmox, apartado Masquerading (NAT)](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#sysadmin_network_masquerading).

Este diseño es una propuesta de laboratorio que debes comprobar en tu versión;
no se ha ejecutado sobre tu equipo real.

## 8. Validación y evidencia

- Desde el host: panel del nodo y SSH autorizado a `srv-aso`.
- Desde el nodo: resolución y acceso a repositorios.
- Desde los invitados: nombres/IP únicos, comunicación mutua y repositorios.
- En el host: RAM disponible y espacio libre con ambos invitados arrancados.
- Tras reiniciar: gestión y NAT siguen funcionando.
- En GitHub: configuración de VirtualBox, dos presupuestos, diagrama, pruebas
  propias y limitaciones, sin VDI ni secretos.

El primer inventario incluye la investigación; las capturas de VirtualBox y
esta configuración se documentan en `docs/03-instalacion-proxmox.md` y
`docs/02-diagrama-red.md`. Las máquinas finales se crean dentro de Proxmox.
