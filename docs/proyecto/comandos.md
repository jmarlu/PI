# Comandos del proyecto: comprender, ejecutar y comprobar

Este material acompaña la práctica. No se trata de memorizar comandos: debes
saber **dónde se ejecutan, qué modifican y cómo comprobar el resultado**.
Los nombres, ID, rutas e IP son ejemplos: sustitúyelos por los de tu diseño.
No es el solucionario docente ni un script para ejecutar de principio a fin.

## 1. Las tres terminales del laboratorio

| Entorno | Qué administra | Comandos habituales |
|---|---|---|
| Anfitrión Linux | Equipo físico y VM exterior de VirtualBox | `VBoxManage`, `lscpu`, `git` |
| Nodo Proxmox | Almacenamiento e invitados interiores | `pct`, `qm`, `pveam`, `vzdump` |
| Invitado Linux | Usuarios, SSH y servicio ASO | `systemctl`, `ip`, `getfacl` |

Una terminal SSH administra el equipo al que te has conectado. Una pestaña del
navegador con Proxmox no cambia el destino de otra terminal. Comprueba tu ubicación:

```bash
hostname
whoami
pwd
```

`hostname` muestra el nombre del sistema; `whoami`, el usuario efectivo; `pwd`, el
directorio actual. `root` es administrador del sistema donde estás, que puede ser
un contenedor y no el nodo. `sudo comando` ejecuta una orden con privilegios
si tu usuario está autorizado. No antepongas `sudo` a todo por costumbre.

## 2. Cómo leer un comando

```bash
pct config 201
```

`pct` es el programa de administración de LXC; `config` solicita su configuración;
`201` identifica el contenedor. Consultarlo no lo arranca ni modifica.

```bash
VBoxManage modifyvm "pve-apellido" --memory 6144
```

`modifyvm` modifica una VM existente; el argumento entre comillas es su nombre;
`--memory` selecciona la propiedad y `6144` son MiB de RAM. Son 6 GiB asignados a
la VM, no memoria añadida al ordenador. Este cambio se prepara con la VM apagada.

| Sintaxis | Significado |
|---|---|
| `--opcion valor` | Selecciona una opción y proporciona su valor |
| `"nombre con espacios"` | Conserva el texto como un solo argumento |
| `comando1 \| comando2` | Pasa la salida del primero al segundo |
| `> archivo` | Escribe la salida; reemplaza el contenido anterior |
| `>> archivo` | Añade salida al final |
| `comando1 && comando2` | Ejecuta el segundo solo si el primero termina bien |
| `# explicación` | Comentario; no se ejecuta |

El estado de salida se consulta con `echo $?` inmediatamente después de una
orden: 0 suele indicar éxito. El significado exacto de otros valores depende
del programa. Un comando sin salida también puede haber funcionado.

## 3. Inventario y recursos: antes de instalar

**Dónde:** anfitrión Linux. Son consultas.

```bash
lscpu
free -h
df -h
lsblk -f
VBoxManage --version
```

- `lscpu`: arquitectura, modelo y capacidades del procesador. Que exista VT-x o
  AMD-V no garantiza que VirtualBox pueda exponerla a una VM interior.
- `free -h`: memoria total, usada y disponible. Para dimensionar, interpreta
  `available`, además de la RAM total.
- `df -h`: espacio de sistemas de archivos montados. Comprueba el destino del VDI.
- `lsblk -f`: discos, particiones, UUID y puntos de montaje. Identificar un disco
  no autoriza a borrarlo.
- `VBoxManage --version`: versión instalada para consultar el manual adecuado.

**Evidencia:** tabla de recursos del host, reserva para el host y reparto dentro
de Proxmox. Explica por qué un VDI dinámico puede agotar el disco físico.

## 4. VirtualBox: administrar la VM exterior

**Dónde:** anfitrión, con el usuario propietario de la VM.

### Consultar antes de modificar

```bash
VBoxManage list vms
VBoxManage list runningvms
VBoxManage showvminfo "pve-apellido"
VBoxManage list natnetworks
VBoxManage list hostonlyifs
```

`list vms` enumera VM registradas; `runningvms`, las que están encendidas.
`showvminfo` permite revisar CPU, memoria, discos y NIC. Las otras consultas
identifican redes compartidas NAT y redes solo-anfitrión realmente existentes.

### Ajustar recursos y red

**Solo con la VM apagada y después de comprobar los nombres de red:**

```bash
VBoxManage modifyvm "pve-apellido" --cpus 2 --memory 6144
VBoxManage modifyvm "pve-apellido" --nic1 natnetwork --nat-network1 "NatNetwork"
VBoxManage modifyvm "pve-apellido" --nic2 hostonly --hostonlyadapter2 "vboxnet0"
VBoxManage modifyvm "pve-apellido" --nicpromisc2 allow-all
```

`--cpus` asigna CPU virtuales, sin crear núcleos físicos. NIC 1 utiliza una
**Red NAT `NatNetwork`** ya creada, con `10.0.2.0/24`, gateway `10.0.2.1`
y DHCP desactivado; NIC 2 conecta al laboratorio host-only. `allow-all` permite
recibir en esa NIC tráfico destinado a las MAC de los invitados del bridge.
Después, vuelve a consultar `showvminfo` para comprobar los cambios.

En Proxmox, NIC 1 se incorpora a `vmbr0` (`10.0.2.15/24`, gateway `10.0.2.1`)
y NIC 2 a `vmbr1` (`192.168.56.10/24`, gestión e invitados). DNS: `10.0.2.3`.
La [guía de interfaces](../proxmox/virtualbox.md#red-local) contiene el archivo
completo y la persistencia del reenvío y NAT.

**NAT simple y Red NAT son modos diferentes.** El proyecto usa Red NAT;
comprueba la red existente antes de aplicar estos valores. Para la instalación física opcional, estas órdenes de VirtualBox
no se aplican. El firewall de PVE no es un objetivo de esta práctica.

### Activar y comprobar la virtualización anidada

En el **anfitrión**, con la VM Proxmox apagada y usando su nombre real:

```bash
VBoxManage modifyvm "pve-apellido" --nested-hw-virt on
```

Después de arrancar Proxmox, en la **consola de esa VM**:

```bash
grep -Ec '(vmx|svm)' /proc/cpuinfo
```

La primera orden solicita que VirtualBox exponga VT-x/AMD-V. La segunda
cuenta líneas que contienen esas extensiones: `0` significa que no se ven;
un valor positivo permite seguir comprobando KVM, pero aún debes arrancar
una VM interna. `grep` devuelve código de salida 1 si no encuentra coincidencias.

Si falla, revisa la [guía de virtualización anidada y conflictos del anfitrión](../proxmox/virtualbox.md#3-comprobar-la-virtualizacion-anidada):
en LliureX/Linux puede interferir KVM y en Windows pueden influir Hyper-V
y las funciones que lo utilizan. Allí se incluyen las referencias oficiales
y las consultas para diagnosticarlo.

### Encender y solicitar apagado

```bash
VBoxManage startvm "pve-apellido" --type headless
VBoxManage controlvm "pve-apellido" acpipowerbutton
```

`headless` arranca sin ventana gráfica. `acpipowerbutton` solicita al invitado un
apagado mediante ACPI: comprueba que realmente termina. Antes, apaga los
invitados interiores de forma ordenada. `poweroff` equivale a cortar la corriente;
no es el apagado habitual. Un snapshot tampoco sustituye una copia recuperable.

## 5. Proxmox: distinguir nodo, contenedor y VM

**Dónde:** Shell del nodo Proxmox o sesión SSH al nodo con permisos suficientes.

```bash
pveversion -v
pvesm status
pct list
qm list
```

`pveversion` informa de versiones; `pvesm status` muestra almacenamientos y su
estado; `pct list` enumera LXC; `qm list`, máquinas virtuales. Un CT no se administra
con `qm`. El ID identifica al invitado dentro de Proxmox, no es su IP.

### Consultar y operar un contenedor

```bash
pct config 201
pct status 201
pct start 201
pct exec 201 -- hostname
pct enter 201
```

Las dos primeras órdenes consultan. `start` arranca el CT existente. `exec`
ejecuta una orden dentro de él: `--` separa los argumentos de `pct` del comando
interior. `enter` abre una consola dentro; `exit` vuelve al nodo.
Para solicitar el apagado del contenedor se utiliza `pct shutdown 201` y luego
`pct status 201`. `pct stop` fuerza su parada; no equivale al apagado ordenado.

### Qué significan las opciones de creación

| Opción de `pct create` | Teoría que debes comprender |
|---|---|
| `--unprivileged 1` | El root interior se mapea a un UID sin privilegios del nodo |
| `--cores 1` | Límite de núcleos disponibles para el contenedor |
| `--memory 512` | Límite de memoria en MiB |
| `--rootfs local-lvm:4` | Crea la raíz en ese almacenamiento con 4 GiB |
| `--net0 ...` | Describe interfaz, bridge, IP y gateway |
| `--features nesting=1` | Habilita nesting de LXC; no expone VT-x/AMD-V |

En un LXC no privilegiado, root puede administrar el interior. Su UID 0 suele
mapearse al UID 100000 del nodo, aunque el mapa es configurable. Esto reduce
privilegios sobre el host; no impide usar sudo o instalar Samba. **No cambies a
privilegiado como arreglo automático de un problema de permisos.**

### Plantilla y clon: cambia la identidad

```bash
pveam available
pct config 9000
pct clone 9000 201 --hostname srv-aso --full 1
```

`pveam` permite consultar plantillas de contenedor. En el ejemplo, 9000 debe ser
una plantilla preparada y 201 un ID libre. `--full 1` solicita un clon completo.
La clonación ocupa disco y crea un invitado: no se repite si ya existe el ID.
Revisa IP, hostname, machine-id y claves de host SSH del clon. Consulta el
[taller de plantillas](../proxmox/plantillas.md) antes de convertir o clonar.

Si se usan VM KVM, las consultas equivalentes son `qm config ID` y `qm status ID`;
el hardware anidado debe estar realmente disponible y probado.

## 6. Red Linux: localizar la avería por capas

**Dónde:** nodo o invitado que se diagnostica; anota cuál.

```bash
ip -br address
ip route
ping -c 3 DIRECCION_GATEWAY
getent hosts deb.debian.org
ss -lnt
```

`ip -br address` comprueba interfaces e IP; `ip route`, rutas y gateway.
Sustituye `DIRECCION_GATEWAY` por la IP de tu diseño. Un ping al gateway prueba
alcance ICMP, no DNS ni Samba. `getent hosts` consulta la resolución del sistema.
`ss -lnt` muestra sockets TCP en escucha: `127.0.0.1:445` solo admite conexiones
locales; escuchar en una IP accesible no garantiza que los permisos SMB permitan
entrar. Para asociar sockets con procesos usa `sudo ss -lntp`.

Orden de diagnóstico: IP → gateway → alcance del destino → resolución DNS →
puerto del servicio → autenticación → autorización. No cambies todas las capas
a la vez: perderías la explicación del fallo.

## 7. SSH y systemd: entender una reparación

**Dónde:** dentro del Linux que ofrece SSH; no en el host por defecto.

```bash
systemctl status ssh --no-pager
journalctl -u ssh -b --no-pager -n 40
```

`status` muestra estado y mensajes recientes. `journalctl` consulta el registro de
SSH del arranque actual (`-b`), limitado a 40 líneas. Antes de reparar, identifica
la causa: no es lo mismo una clave ausente que una configuración incorrecta.

Si un clon arranca sin claves de host y acumula intentos fallidos, la reparación es:

```bash
sudo ssh-keygen -A
sudo systemctl reset-failed ssh.service ssh.socket
sudo systemctl restart ssh
systemctl is-active ssh
```

1. `ssh-keygen -A` genera las claves de host que falten. Identifican al servidor;
   no son la clave personal del alumno y no cambian su contraseña. Las existentes
   se conservan.
2. `reset-failed` limpia el estado fallido y el contador de intentos. Permite
   intentar otro arranque; no corrige por sí mismo la causa ni inicia SSH.
3. `restart` arranca de nuevo el servicio; si estaba activo lo reinicia.
4. `is-active` comprueba que ahora está `active`. Después prueba una conexión.

No es una secuencia necesaria en cada arranque. `enable` configura inicio
persistente; `start` inicia ahora; `restart` reinicia ahora. `enable` sin `--now`
no inicia por sí solo un servicio.

## 8. Usuarios, grupos y permisos del servicio

**Dónde:** invitado servidor Linux.

```bash
id alumno1
ls -ld /srv/grupo_asir
getfacl /srv/grupo_asir
testparm -s
systemctl is-active smbd
```

`id` permite comprobar UID y grupos. `ls -ld` muestra permisos del directorio;
`getfacl` añade ACL y su máscara efectiva. En `2770`, el 2 activa setgid para
heredar grupo, 7 concede rwx a propietario y grupo y 0 niega acceso al resto.
Las ACL por defecto determinan la herencia en nuevos elementos. No uses
`chmod 777` para ocultar una configuración incorrecta.

`testparm` valida y muestra la configuración Samba; no demuestra acceso remoto.
`is-active smbd` tampoco demuestra que escuche en la interfaz correcta. Prueba
lectura/escritura desde el cliente y una denegación con una cuenta válida sin
permisos. Con `smbclient ... -U usuario` introduce la contraseña cuando la pida,
sin escribirla en el comando ni subirla a Git.

## 9. Copias: crear no equivale a recuperar

**Dónde:** nodo Proxmox; CT existentes y espacio comprobado.

```bash
pvesm status
vzdump 201 --storage local --mode stop --compress zstd
pvesm list local --content backup
```

`vzdump` crea una copia del invitado. `--storage` selecciona destino; `--mode stop`
implica parada durante la copia; `--compress zstd` selecciona compresión.
El almacenamiento `local` debe existir y aceptar backups. Contabiliza el espacio
y la interrupción antes de ejecutarlo. La copia contiene secretos del sistema.

La restauración usa `pct restore ID_LIBRE ARCHIVO_REAL --storage DESTINO`.
Los nombres en mayúsculas son marcadores, no argumentos literales. Comprueba un
ID libre y cambia IP/hostname antes de conectar el restaurado, para evitar
colisión con el original. Verifica datos, permisos y servicio desde el cliente.
Documenta tiempo de recuperación y antigüedad de la copia. Una copia en el mismo
disco no protege frente a la avería de ese disco.

## 10. Git, Bash y Ansible

**Dónde:** equipo de trabajo, dentro de tu repositorio.

```bash
git status
git diff
bash -n scripts/mi_script.sh
ansible all -i ansible/inventory.ini -m ping
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --syntax-check
```

`git status` muestra cambios y `git diff` permite revisarlos antes de añadirlos.
`bash -n` revisa sintaxis sin ejecutar: no prueba funcionamiento. El módulo `ping`
de Ansible comprueba conexión y Python, no ICMP. `--syntax-check` analiza el
playbook, sin demostrar conectividad ni comportamiento del servicio.

Después de revisar inventario y secretos, ejecuta el playbook y repítelo. Explica
`ok`, `changed`, `unreachable` y `failed`; para tareas estables, la segunda
aplicación debería evitar cambios innecesarios. Sigue la
[entrega de automatización](automatizacion.md).

## 11. Cómo demostrar que lo entiendes

En cada hito elige los comandos que has necesitado y registra:

| Campo | Qué debes aportar |
|---|---|
| Objetivo y entorno | Qué querías comprobar y en qué máquina/usuario |
| Comando | Orden real sin contraseñas, tokens ni claves privadas |
| Explicación | Significado de opciones y efecto esperado |
| Resultado | Salida relevante, interpretada con tus palabras |
| Validación | Comprobación posterior y corrección si hubo fallo |

En la defensa debes poder explicar un comando de VirtualBox si usaste modalidad
virtual, uno de Proxmox y uno del invitado. Relaciónalos con tu propio proyecto.
No se exige ejecutar todas las órdenes de esta página ni memorizar sus opciones.

## Consulta de ayuda

```bash
VBoxManage help modifyvm
pct help create
qm help config
man ssh-keygen
man systemctl
```

La ayuda instalada permite comprobar las opciones de tu versión. Referencias:
[VBoxManage, Oracle](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/vboxmanage.html),
[documentación Proxmox VE](https://pve.proxmox.com/pve-docs/),
[ssh-keygen, OpenSSH](https://man.openbsd.org/ssh-keygen) y
[systemctl, systemd](https://www.freedesktop.org/software/systemd/man/latest/systemctl.html).
