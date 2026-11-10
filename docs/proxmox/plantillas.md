# Plantilla Linux, servidor y cliente

**Sesiones 13-20.** El nodo y el diseño deben estar validados.
Elige VM o LXC según tu investigación, no por apariencia del asistente.

## Ruta VM

1. Descarga la ISO Linux aprobada y registra versión y fuente.
2. En tu nodo, crea una VM base con ID libre, nombre, CPU, RAM, disco y red
   previstos. Selecciona el storage correcto y el medio de instalación.
3. Instala un Linux mínimo. Documenta particiones, usuario administrativo,
   hostname y red.
4. Desde el invitado, prepara los paquetes comunes.
5. Si utilizas cloud-init, añade su disco desde Proxmox y prepara el paquete
   en el invitado. Configura usuario, clave pública y parámetros de cada clon.
6. Limpia datos de prueba, secretos e identidades específicas mediante el
   procedimiento de tu distribución y apaga de forma ordenada.
7. Convierte la base en plantilla desde Proxmox.
8. Crea un clon de prueba con ID, nombre e IP distintos y verifica su identidad.

Una plantilla convertida deja de ser una VM normal de trabajo. Conserva un
plan para actualizar la base o generar una nueva versión.
[Manual de VMs](https://pve.proxmox.com/pve-docs/chapter-qm.html).

## Ruta LXC

1. En el storage habilitado, descarga una plantilla CT Linux autorizada.
2. Crea un CT base con ID libre, hostname, cuota y red del diseño.
3. Mantén el CT **no privilegiado** salvo necesidad justificada y autorizada.
4. Configura paquetes y usuario administrativo dentro del CT.
5. Detén el CT de forma ordenada y conviértelo en plantilla reutilizable.
6. Clona y asigna nombre e IP diferentes; comprueba permisos, SSH y servicio.

No habilites nesting, dispositivos o contenedores privilegiados simplemente
para evitar un error. Investiga el requisito y consúltalo.
El CT usa el kernel del nodo y no necesita `qemu-guest-agent`.
[Manual de contenedores](https://pve.proxmox.com/pve-docs/chapter-pct.html).

## Configuración común dentro del Linux base

Ejemplo para Debian/Ubuntu con permisos sudo, **no para el nodo Proxmox**:

~~~bash
sudo apt update
sudo apt install openssh-server sudo curl nano rsync acl python3
timedatectl
sudo systemctl enable --now ssh
~~~

El usuario administrativo debe existir y disponer del sudo autorizado.
Si aún no lo tiene, el profesor supervisará su creación desde la consola.
Solo en una VM añade `qemu-guest-agent` y activa su opción en Proxmox.
Cloud-init también es una preparación específica de la ruta VM, no un requisito
de los contenedores.

Desde el equipo de administración comprueba SSH con la cuenta no root.
Antes de convertir en plantilla, retira claves privadas, tokens y datos de pruebas.
No dupliques direcciones, identidad del sistema ni claves privadas de host SSH.
Usa los mecanismos de cloud-init o de inicialización de la distribución para
regenerar identidades; verifica el resultado en los clones.
[Cloud-init y limpieza](https://cloudinit.readthedocs.io/en/latest/reference/cli.html#clean).

## Desplegar las dos máquinas

| Máquina | Función | Comprobaciones |
|---|---|---|
| `srv-aso` | Servicio ASO | Nombre/IP únicos, sudo, SSH, paquetes |
| `cli-linux` | Pruebas independientes | Nombre/IP únicos, conectividad y cliente del servicio |

Crea ambas desde la plantilla validada. Un clon completo consume más espacio
pero no depende del disco base; un clon enlazado depende de su base y del
storage que lo soporte. Justifica tu elección.

Verifica en cada invitado:

~~~bash
hostnamectl
ip -br addr
ip route
free -h
df -h
~~~

Compara nombres, IP, `/etc/machine-id` y huellas públicas de SSH cuando correspondan.
No publiques claves privadas. No cambies una huella conocida en el cliente SSH
sin comprobar antes que realmente has recreado ese invitado.

## Ejemplo de validación de un clon

Escenario didáctico: la plantilla tiene ID 900 y has creado la VM 101
`srv-aso`, con la IP prevista `192.168.56.20/24`. Los números son ejemplos,
no IDs que debas reutilizar sin comprobarlos.

1. En Proxmox comprueba el ID, disco, bridge y recursos del clon.
2. En su consola comprueba hostname e IP antes de conectarlo donde pueda
   duplicar la dirección de otra máquina.
3. Desde el equipo de administración, verifica su identidad SSH mediante
   el mecanismo autorizado y prueba acceso.
4. Confirma que no heredó datos personales ni secretos de la base.
5. Repite con `cli-linux` y compara los resultados de ambos.

Si Proxmox muestra `srv-aso` pero el sistema interior conserva el hostname
de la base, **la clonación del objeto no ha resuelto toda la inicialización**.
Registra qué debe generar la plantilla y qué debes configurar en cada clon.

El QEMU Guest Agent es otro ejemplo de comprobación en dos lados: en una VM
debe estar instalado y funcionando dentro, y Proxmox debe tener habilitado
su uso. Una casilla marcada no demuestra la comunicación. En un CT no
necesitas ese agente porque no es una VM QEMU.

Las relaciones entre [base, disco e identidad](clonado-teoria.md#ejemplo-identidad)
explican por qué estas pruebas forman parte de aceptar la plantilla.

## Entrega

En `docs/04-plantilla-linux.md`: sistema, versión, preparación, limpieza,
conversión y prueba de clon.

En `docs/05-vms-lxc.md`: ID, nombre, tipo, origen, recursos, IP, bridge,
función y pruebas de ambas máquinas. Incluye una captura de tu nodo con ellas.

Continúa con el [servicio ASO de la práctica](../proyecto/fase-7-servicio.md).
