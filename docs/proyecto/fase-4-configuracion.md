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
cada interfaz con su adaptador Red NAT `NatNetwork` o solo-anfitrión.
Comprueba `vmbr0` de salida (`10.0.2.15/24`, gateway `10.0.2.1`) y
`vmbr1` de gestión e invitados (`192.168.56.10/24`, sin otro gateway).
El DNS de referencia es `10.0.2.3`. Abre el panel desde
el anfitrión y comprueba que el nodo resuelve nombres y accede al
repositorio de paquetes autorizado. Si necesitas ajustar el montaje,
consulta el [taller de red y almacenamiento](../proxmox/red-almacenamiento.md)
y la [red local de VirtualBox](../proxmox/virtualbox.md#red-local).

Ten abierta la consola de VirtualBox cuando cambies la red de gestión,
para poder corregirla si pierdes la conexión del navegador.

## 3. Revisa quién puede administrar el nodo

Empieza por la [explicación de usuarios, roles y ámbitos](../proxmox/operacion-recuperacion.md#usuarios-grupos-privilegios-y-roles).
Después abre **Datacenter → Permisos → Usuarios** y revisa tus cuentas.
En **Permisos**, comprueba a quién se ha dado cada rol y en qué ruta.
Revisa también los grupos y los permisos heredados si los hay.

Guarda una tabla como esta en `docs/03-instalacion-proxmox.md`, con los
datos de tu laboratorio:

| Cuenta | Dónde se utiliza | Rol o permisos | Ámbito | Para qué la necesitas |
|---|---|---|---|---|
| `root@pam` | Panel de Proxmox | Administración completa | Instalación de Proxmox | Preparación y recuperación del nodo |
| Tu cuenta adicional, si existe | Panel de Proxmox | Los que hayas comprobado | Ruta real de su asignación | Tarea concreta que realiza |

Si solo usas `root@pam`, indícalo y explica que no es una cuenta limitada.
No inventes usuarios para completar la tabla. Las cuentas del interior de
los invitados se documentarán cuando los crees; no son las mismas que las
del panel de Proxmox.

### Ejercicio guiado: crear y probar un acceso limitado {#ejercicio-usuarios-permisos}

Realiza este ejercicio **si se acuerda en clase**. La revisión de tus cuentas
y su alcance sí forma parte de la fase. Para el ejercicio solo necesitas el
nodo; todavía no hace falta haber creado ninguna VM o contenedor.

**Prepara el acceso antes de empezar.** Mantén abierta tu sesión administrativa
y comprueba que puedes entrar por la consola de VirtualBox o la consola
física. Usa una ventana privada para la cuenta limitada. En los ejemplos,
el nodo se llama `pve-apellido` y su IP es `192.168.56.10`: sustitúyelos por
los de tu instalación. No cambies los permisos de `root@pam`.

**1. Crea la cuenta de prueba.** Desde la sesión administrativa, abre
**Datacenter → Permisos → Usuarios → Añadir**. Escribe `alumno-lectura`,
elige el dominio **Proxmox VE authentication server** (`pve`), establece
una contraseña de laboratorio y deja la cuenta habilitada, sin grupos.
Su identificador será `alumno-lectura@pve`.

Si ya existe una cuenta con ese nombre, revisa sus grupos y asignaciones
antes de reutilizarla. Para obtener los resultados del ejemplo no debe
tener otros permisos.

**2. Entra sin asignarle un rol.** Abre el panel en la ventana privada e
inicia sesión con `alumno-lectura`, su contraseña y el dominio `pve`.
Comprueba el usuario que aparece en la esquina del panel. La cuenta puede
identificarse, pero aún no debe poder consultar el estado del nodo. Según
la versión, el nodo puede estar oculto o su información no estar disponible.

**3. Crea el rol.** Vuelve a la sesión administrativa y abre
**Datacenter → Permisos → Roles → Crear**. Llámalo `AulaLectura` y selecciona
solo `Sys.Audit`. No añadas privilegios de modificación, consola o apagado.
Si el rol ya existe, comprueba su lista de privilegios.

**4. Asígnalo al nodo.** En **Datacenter → Permisos → Añadir → Permiso de
usuario**, completa:

| Campo | Valor del ejemplo |
|---|---|
| Ruta | `/nodes/pve-apellido` |
| Usuario | `alumno-lectura@pve` |
| Rol | `AulaLectura` |
| Propagar | Desmarcado |

No uses `/` como ruta para este ensayo. En la ventana privada, cierra la
sesión de prueba y vuelve a entrar para actualizar la interfaz. Selecciona
el nodo y abre **Resumen**: ahora debes poder consultar su estado.

**5. Comprueba una operación permitida y otra denegada.** En dos pestañas
nuevas de **esa misma ventana privada**, abre estas direcciones adaptadas
a tu nodo:

```text
https://192.168.56.10:8006/api2/json/nodes/pve-apellido/status
https://192.168.56.10:8006/api2/json/nodes/pve-apellido/syslog?limit=1
```

La primera debe devolver datos del estado del nodo en formato JSON: busca
`uptime`, `cpu` o `memory`. La segunda debe rechazarse por falta de
`Sys.Syslog`, con código **HTTP 403**. Son dos consultas de lectura;
no modifican el sistema ni requieren crear un token.

Si necesitas ver el código HTTP, abre las herramientas del navegador con
`F12`, selecciona **Red** y recarga la dirección. Un **401** indica que debes
revisar la sesión; un **404** requiere comprobar la ruta y el nombre del nodo.
Esos errores no demuestran la restricción que buscamos. Si puedes leer el
registro, revisa qué cuenta estás usando y si tiene otros roles o grupos.

**6. Retira el permiso y repite la consulta.** Como administrador, elimina
solo la asignación de `AulaLectura` a `alumno-lectura@pve` en la ruta del nodo.
Mantén la cuenta y recarga `status` en la ventana privada. Ahora debe
rechazarse por permisos. La cuenta sigue existiendo y puede iniciar sesión:
lo que has retirado es su autorización para consultar el nodo.

**7. Guarda lo que has comprobado.** Completa una tabla con el resultado
real, junto con capturas de la asignación y de las consultas:

| Cuenta y situación | Prueba | Resultado previsto | Resultado obtenido y explicación |
|---|---|---|---|
| `alumno-lectura@pve`, sin ACL | Iniciar sesión | Permitido, sin acceso al estado del nodo | |
| Con `AulaLectura` en el nodo | Consultar `status` | Permitido | |
| Con `AulaLectura` en el nodo | Consultar `syslog` | Denegado, HTTP 403 | |
| Tras retirar la asignación | Consultar `status` | Denegado, HTTP 403 | |

No copies el resultado previsto como si fuera una prueba realizada. Si algo
sale distinto, explica qué has encontrado y repite la comprobación después
de corregirlo. Mantén contraseñas, cookies de sesión y claves fuera de las
capturas y del repositorio.

??? note "Alternativa desde la terminal del nodo"
    Estos comandos sustituyen los pasos de creación del panel. Ejecútalos
    como root en el **nodo Proxmox**, con su nombre real en la ruta. Consulta
    primero el estado y ejecuta las altas solo si la cuenta y el rol no existen.

    ```bash
    pveum user list
    pveum role list
    pveum acl list

    pveum user add alumno-lectura@pve --comment "Prueba de acceso limitado"
    pveum passwd alumno-lectura@pve
    pveum role add AulaLectura --privs "Sys.Audit"
    pveum acl modify /nodes/pve-apellido --users alumno-lectura@pve --roles AulaLectura --propagate 0
    pveum user permissions alumno-lectura@pve --path /nodes/pve-apellido
    ```

    `passwd` pide la contraseña de forma interactiva. No la escribas como
    argumento. Para retirar la asignación del paso 6:

    ```bash
    pveum acl delete /nodes/pve-apellido --users alumno-lectura@pve --roles AulaLectura
    ```

    Las pruebas se hacen con la cuenta limitada en el navegador. Una consulta
    ejecutada como root en la terminal no demuestra sus permisos.
    Puedes contrastar las opciones en el [manual de pveum](https://pve.proxmox.com/pve-docs/pveum.1.html).

Al terminar, cierra la sesión de prueba y documenta qué has dejado configurado.
Si el profesor indica que la cuenta ya no se va a utilizar, elimínala desde
**Usuarios** y borra el rol solo si no lo usa ninguna otra asignación.

### Acceso de red y recuperación

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
y la tabla de cuentas con su ámbito. Si has realizado el ejercicio de acceso
limitado, añade sus pruebas permitida y denegada. Acompaña las salidas
con una frase que indique qué has comprobado y qué queda pendiente.

La fase está lista cuando el panel es accesible, el nodo tiene la
conectividad prevista, los almacenamientos están disponibles y el
reparto de recursos deja margen para continuar.

---

[Anterior](fase-3-instalacion.md) · [Fase 5: Plantilla Linux](fase-5-plantilla.md)
