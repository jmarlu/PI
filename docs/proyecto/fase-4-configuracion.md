# Fase 4. Configuración base del nodo

[Guía de la práctica](practica.md) · **Al terminar:** red, almacenamiento, accesos y recursos revisados.

**Sesiones de clase:** 10–12. Consulta el [calendario](../clases/index.md).

Con Proxmox instalado, toca comprobar que tienes una base estable antes de
crear las máquinas. Trabaja desde la consola del nodo o una sesión SSH al
nodo y guarda los resultados en `docs/03-instalacion-proxmox.md`.

## 1. Revisa dónde se guardará cada cosa

Abre **Datacenter > Storage** y revisa los almacenamientos disponibles.
Anota para qué sirve cada uno, qué contenido admite y cuánto espacio queda.
Puedes contrastarlo desde la consola del nodo:

```bash
pvesm status
df -h
```

Relaciona las salidas con el panel: un almacenamiento para discos de VM no
tiene por qué admitir también copias o imágenes ISO. Prepara una carpeta o
un almacenamiento que admita backups en el destino autorizado y comprueba
que aparece disponible. La copia real se hará en la fase 9.

En VirtualBox, comprueba también el espacio libre del anfitrión. El espacio
que ve Proxmox dentro del VDI no garantiza que el disco real pueda alojar
su crecimiento. Si las copias van al mismo disco, deja anotado que un fallo
de ese disco afectaría tanto al laboratorio como a sus copias.

## 2. Relaciona las interfaces con tu diseño

En **Nodo > System > Network**, identifica las interfaces, los bridges y
la dirección de gestión. Comprueba en el nodo:

```bash
ip -br addr
ip route
```

Compara IP, máscara y gateway con tu diagrama. En VirtualBox, relaciona
cada interfaz con su adaptador NAT o solo-anfitrión. Abre el panel desde
el anfitrión y comprueba que el nodo resuelve nombres y accede al
repositorio de paquetes autorizado. Si necesitas ajustar el montaje,
consulta el [taller de red y almacenamiento](../proxmox/red-almacenamiento.md)
y la [red local de VirtualBox](../proxmox/virtualbox.md#red-local).

Ten abierta la consola de VirtualBox cuando cambies la red de gestión,
para poder corregirla si pierdes la conexión del navegador.

## 3. Revisa quién puede administrar el nodo

Anota las cuentas que utilizas y qué permisos tienen. Si el profesor pide
crear un usuario o un rol, comprueba que permite realizar las tareas
previstas y explica su alcance. Mantén contraseñas y claves fuera de las
capturas y del repositorio.

El firewall de Proxmox no es un objetivo obligatorio de esta práctica.
Si se acuerda configurarlo, prepara las reglas y el acceso por consola
antes de activarlo; después comprueba que sigues pudiendo administrar el
nodo. Documenta el estado que has dejado y las medidas de aislamiento
del laboratorio.

## 4. Ajusta el reparto de recursos

Recupera el presupuesto del inventario y actualízalo con lo que has
observado tras instalar. Indica los límites de CPU, RAM y disco de cada
máquina, la reserva del nodo y el margen para plantillas y copias.
En VirtualBox, conserva además la reserva para el anfitrión.

| Elemento | CPU/vCPU | RAM | Disco o almacenamiento | Motivo del reparto |
|---|---|---|---|---|
| Nodo Proxmox | | | | |
| `srv-aso` | | | | |
| `cli-linux` | | | | |
| Plantillas, ISO, copias y margen | | | | |

No hace falta consumir todos los recursos disponibles. El objetivo es
que puedas administrar el nodo mientras servidor y cliente funcionan.

## Antes de pasar a la plantilla

Guarda capturas legibles de red y almacenamiento, la tabla de recursos
y una explicación de los accesos administrativos. Acompaña las salidas
con una frase que indique qué has comprobado y qué queda pendiente.

La fase está lista cuando el panel es accesible, el nodo tiene la
conectividad prevista, los almacenamientos están disponibles y el
reparto de recursos deja margen para continuar.

---

[Anterior](fase-3-instalacion.md) · [Fase 5: Plantilla Linux](fase-5-plantilla.md)
