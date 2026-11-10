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

Anota el modelo exacto del procesador, la memoria y el espacio libre del equipo. Comprueba la versión de VirtualBox y si tienes permiso para configurar las máquinas. Si no puedes arrancar una VM de 64 bits, consulta con el profesor qué ocurre antes de modificar BIOS/UEFI, Secure Boot o los módulos del sistema.

Completa el [inventario obligatorio](../proyecto/fase-1-inventario.md) calculando por separado los recursos que necesita el equipo anfitrión y los que asignarás a la VM de Proxmox. Después reparte los de Proxmox entre el propio nodo, el servidor y el cliente.

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

Sustituye `pve-apellido` por el nombre que aparece en `VBoxManage list vms`.
La orden se ejecuta en el **anfitrión**, con el usuario propietario de la VM.
En Windows puedes usar `VBoxManage.exe` desde su carpeta de instalación; si
usas PowerShell, antepón `&` a la ruta del ejecutable entre comillas.

Después de instalar y arrancar Proxmox, ejecuta en la **consola de esa VM
Proxmox**, no en el anfitrión ni en un contenedor:

~~~bash
grep -Ec '(vmx|svm)' /proc/cpuinfo
~~~

`-E` permite buscar las dos alternativas y `-c` cuenta las líneas que coinciden.
Un resultado mayor que cero indica que Proxmox ve extensiones Intel (`vmx`)
o AMD (`svm`). No cuenta niveles de virtualización ni garantiza por sí solo
que KVM funcione. Si devuelve `0`, no las está viendo; cuando no encuentra
coincidencias, `grep` también termina con código de salida 1.

Conserva la salida y **prueba el arranque de una VM KVM dentro de Proxmox**.
Activar la opción en VirtualBox solo solicita que se exponga ese soporte;
el hardware, el anfitrión y la versión utilizada deben permitirlo.
Consulta el [manual de virtualización anidada de VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/AdvancedTopics.html).

### Si la opción no aparece o la VM no arranca

- **LliureX/Linux:** KVM puede estar utilizando la virtualización del procesador
  y entrar en conflicto con VirtualBox. Oracle documenta este problema, por
  ejemplo, con la carga de módulos KVM en Linux 6.12. Anota `uname -r`, la
  versión de VirtualBox y el error completo; puedes consultar los módulos
  cargados con `lsmod | grep -E '^(kvm|vbox)'`. Que aparezca un módulo no
  demuestra por sí solo la causa. Revisa con el profesor las VM activas,
  los módulos de VirtualBox y su compatibilidad con el kernel instalado.
  Véanse las [notas de Oracle sobre KVM y Linux 6.12](https://docs.oracle.com/en/virtualization/virtualbox/7.1/relnotes/ChangeLog.html).
- **Windows con Hyper-V:** VirtualBox puede utilizar el hipervisor de Windows,
  con posibles limitaciones de rendimiento y de virtualización anidada.
  Hyper-V, la integridad de memoria o Credential Guard pueden influir aunque
  no hayas abierto una VM de Hyper-V. Consulta `msinfo32` y el registro
  `VBox.log`, y revisa el caso con el profesor. El proveedor de
  paravirtualización llamado «Hyper-V» en la configuración de una VM no
  demuestra que el hipervisor del anfitrión esté activo. Consulta la
  [guía de Microsoft sobre conflictos con Hyper-V](https://learn.microsoft.com/en-us/troubleshoot/windows-client/application-management/virtualization-apps-not-work-with-hyper-v)
  y el manual de Oracle enlazado arriba.

No descargues módulos del kernel ni desactives Hyper-V o protecciones del
equipo del aula por tu cuenta. El ajuste depende del equipo y puede afectar
a otros laboratorios; conserva el diagnóstico y acuerda la solución.

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

## Ejemplo de lectura de rutas

En la **consola del nodo Proxmox**, `ip route` debería ser coherente con el
diseño. Fragmento ilustrativo de dos entradas; no es la tabla completa ni una
salida medida en tu equipo:

~~~text
default via 10.0.2.2 dev vmbr0
192.168.56.0/24 dev vmbr1 proto kernel scope link src 192.168.56.10
~~~

La primera entrada envía destinos no cubiertos por rutas más específicas
hacia el NAT de VirtualBox. La segunda reconoce la red local de los invitados
por `vmbr1`. Tener una IP de gestión en `vmbr1` no obliga a poner también
allí otro gateway por defecto.

Dentro de `srv-aso` o `cli-linux` la ruta por defecto es distinta: su siguiente
salto previsto es `192.168.56.10`. No copies la tabla del nodo a sus invitados:
ocupan posiciones diferentes en la red.

**Caso resuelto:** el nodo descarga paquetes, pero los dos invitados no.

La descarga del nodo comprueba su propia salida. Todavía pueden faltar ruta
de los invitados, reenvío, NAT del nodo, tráfico de retorno permitido o
resolución. Revisa por orden, sin añadir la misma regla repetidamente.
Consulta el [esquema de los recorridos](redes-teoria.md#ejemplo-recorridos).

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
