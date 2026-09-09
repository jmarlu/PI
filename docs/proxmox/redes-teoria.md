# Redes virtuales: recorrido de los paquetes

## Interfaces, bridges y direcciones

La interfaz virtual de una VM se conecta a un bridge del nodo. Un bridge Linux
actúa como un conmutador de nivel 2: une interfaces en un mismo dominio de enlace.
No asigna automáticamente direcciones, no configura DNS y no hace NAT por el
hecho de existir.

`vmbr0` o `vmbr1` son nombres convencionales de bridges, no promesas de acceso
a Internet. Un bridge puede incluir una interfaz física/virtual del nodo o
existir sin ella para una red interna.
[Redes en Proxmox](https://pve.proxmox.com/pve-docs/chapter-sysadmin.html).

La IP de administración del nodo se asigna según el diseño del bridge.
Cada invitado tiene su propia IP y MAC. El bridge y la VM no comparten por
necesidad dirección IP, aunque estén en la misma red.

## Tres decisiones distintas

| Decisión | Pregunta | Error frecuente |
|---|---|---|
| Subred y máscara | ¿Qué destinos considera locales el equipo? | Dos IP parecidas con máscaras incoherentes |
| Gateway | ¿A quién envío destinos no locales? | Usar como gateway una máquina que no enruta |
| DNS | ¿Quién traduce nombres a direcciones? | Cambiar DNS cuando ni siquiera se alcanza una IP |

Ejemplo: `192.168.56.20/24` y `192.168.56.30/24` pertenecen a la misma subred.
El cliente puede alcanzar directamente al servidor a través del bridge; ese
tráfico no necesita recorrer el gateway. Para un destino fuera de la subred,
sí necesita una ruta apropiada y un camino de retorno.

Tener dos interfaces no convierte por sí solo al nodo en router. El reenvío
y, cuando corresponda, las reglas de traducción son decisiones adicionales.

## El montaje local de este curso

Este es el diseño explicado en la [guía de VirtualBox](virtualbox.md), sujeto
a aprobación y ausencia de conflictos con otras redes del equipo:

| Capa | Red o dirección de ejemplo | Papel |
|---|---|---|
| VirtualBox, adaptador 1 | NAT | Salida de la VM Proxmox |
| Nodo, `vmbr0` | `10.0.2.15/24` | Red exterior del nodo, gateway `10.0.2.2` |
| VirtualBox, adaptador 2 | Solo-anfitrión | Acceso privado desde el equipo del alumno |
| Equipo anfitrión | `192.168.56.1/24` | Administración local |
| Nodo, `vmbr1` | `192.168.56.10/24` | Administración y gateway de los invitados |
| `srv-aso` y `cli-linux` | `192.168.56.20` y `192.168.56.30` | Cargas del proyecto |

Aquí hay **dos NAT para salir a Internet**: el configurado en el nodo para
los invitados y el NAT exterior de VirtualBox. En cambio, el navegador del
anfitrión llega al panel por la red solo-anfitrión, no por esa salida.
[Modos de red de VirtualBox](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/networkingdetails.html).

## Sigue tres recorridos

**Administración:** navegador del anfitrión → adaptador solo-anfitrión →
`vmbr1` → dirección del nodo, TCP 8006.

**Prueba del servicio:** `cli-linux` → interfaz virtual → `vmbr1` →
interfaz virtual de `srv-aso` → puerto del servicio.

**Actualizaciones del invitado:** invitado → gateway `192.168.56.10` →
reenvío/NAT del nodo → `vmbr0` → NAT de VirtualBox → red del anfitrión.

La respuesta necesita completar el recorrido inverso. Si el panel funciona
pero un invitado no descarga paquetes, ya sabes que no debes empezar
reinstalando el navegador. Investiga la ruta, el reenvío, el NAT y la resolución
del invitado. El [apartado oficial de masquerading](https://pve.proxmox.com/pve-docs/pve-admin-guide.html#sysadmin_network_masquerading)
explica aspectos que dependen también del firewall utilizado.

## Dos conexiones, paso a paso {#ejemplo-recorridos}

El siguiente esquema distingue el tráfico enviado al otro invitado del enviado
al gateway. Las flechas son recorridos lógicos, no cables nuevos que tengas
que añadir.

~~~mermaid
flowchart TD
    C["cli-linux · .30"] --> B["Bridge vmbr1"]
    B -->|"Destino local"| S["srv-aso · .20"]
    B -->|"Tráfico al gateway"| G["Nodo · .10"]
    G -->|"Enrutamiento y NAT"| W["vmbr0 · 10.0.2.15"]
    W --> V["NAT de VirtualBox"]
    V --> E["Destino exterior autorizado"]
~~~

En las direcciones abreviadas, `.30`, `.20` y `.10` pertenecen a
`192.168.56.0/24`. El diagrama presupone el montaje de dos interfaces aprobado.

### Caso resuelto A: SSH entre los dos invitados

`cli-linux`, con `192.168.56.30/24`, se conecta a `192.168.56.20`.

1. Con su máscara, determina que el destino pertenece a la misma subred.
2. Resuelve la dirección de enlace del destino mediante ARP en este ejemplo IPv4.
3. El tráfico atraviesa el bridge hasta la interfaz de `srv-aso`.
4. El servidor debe escuchar en TCP 22 y permitir esa conexión.

No hay que pasar por el gateway para esa comunicación local. Si se borra solo
la ruta por defecto del cliente, **esta conexión por IP puede seguir
funcionando**; los destinos de otras redes dejarían de ser alcanzables si no
existen rutas alternativas. No borres rutas para comprobarlo: razona con la
tabla y consulta el recorrido.

En la consola de `cli-linux`, para el direccionamiento de este ejemplo:

~~~bash
ip route get 192.168.56.20
~~~

Debes interpretar interfaz, dirección de origen y presencia o ausencia de
`via`, no copiar una salida idéntica: los nombres de interfaces pueden cambiar.

### Caso resuelto B: llegar a un repositorio exterior

El invitado envía el tráfico no local a `192.168.56.10`. El nodo necesita
reenviar entre sus redes y aplicar el NAT previsto; después actúa el NAT
de VirtualBox. El retorno debe estar permitido y conservar su asociación
con la conexión iniciada.

Una regla NAT no corrige una IP duplicada, una máscara equivocada o un gateway
inexistente. Por eso el orden de diagnóstico importa: validar primero un
tramo evita modificar reglas que no eran la causa.

### Caso resuelto C: funciona por IP, falla por nombre

Si SSH al servidor por su IP funciona, has comprobado una ruta y un puerto.
Si el mismo servidor por nombre no se encuentra, empieza por la resolución:
¿ese nombre está registrado en el mecanismo que usa **ese cliente**?

Cambiar el hostname del invitado o su etiqueta en Proxmox no crea
automáticamente un registro DNS. Tampoco una modificación de `/etc/hosts`
en el nodo configura la resolución del anfitrión y del cliente.

**Conclusión que puedes documentar:** “El acceso por IP y puerto es correcto;
la incidencia está acotada a la resolución del nombre probado”. No escribas
“toda la red funciona”: aún faltan otros recorridos y servicios.

## NAT, aislamiento y VLAN no son sinónimos

NAT traduce direcciones; un firewall aplica una política de tráfico. Una red
solo-anfitrión separa el laboratorio de un bridge directo al aula, pero el
anfitrión sigue siendo parte de esa red. No equivale a una barrera contra todo
acceso.

Las VLAN etiquetan tráfico para separar redes lógicas sobre enlaces comunes.
Requieren coherencia entre bridge, interfaces y dispositivos conectados.
Inventar una etiqueta en una VM no configura los switches del centro. No son
obligatorias en este proyecto y no debes modificar la red del aula.

La opción de modo promiscuo del adaptador local de VirtualBox puede ser
necesaria para transportar las MAC de invitados internos. Se aplica solo al
adaptador de laboratorio indicado en la guía, no indiscriminadamente.

## Diagnóstico por capas

Registra siempre origen, destino y protocolo. “No hay red” no es una evidencia
suficiente.

1. ¿La interfaz existe y está conectada al bridge previsto?
2. ¿IP, máscara y ausencia de duplicados son coherentes?
3. ¿Hay ruta de ida y retorno?
4. ¿Funciona la resolución si se utiliza un nombre?
5. ¿Está escuchando el servicio y permite el firewall ese tráfico?
6. ¿La aplicación acepta la operación solicitada?

Ping usa ICMP; no demuestra que SSH o el servicio ASO funcionen. Una prueba
negativa de autenticación tampoco demuestra que el tráfico esté bloqueado.

**Aplicación:** dibuja los tres recorridos sobre tu diagrama existente e indica
en cuál de ellos interviene NAT. Justifica qué cambio investigarías si funciona
el acceso por IP, pero no por nombre.
