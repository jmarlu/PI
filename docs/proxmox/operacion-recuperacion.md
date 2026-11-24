# Operación, permisos y recuperación

## Administrar con alcance limitado

Cuando entras en Proxmox ocurren dos cosas distintas. Primero se comprueba
quién eres: eso es la **autenticación**. Después se decide qué puedes hacer
y sobre qué recursos: eso es la **autorización**. Una cuenta puede entrar
correctamente en el panel y no tener permiso para consultar un nodo.

Para entender un permiso, responde a tres preguntas: **quién lo recibe,
qué acciones permite y dónde se aplica**. También debes conocer el dominio
de autenticación o *realm*, que indica dónde se comprueba la cuenta.

Una cuenta de lectura para observar métricas no necesita permiso para borrar
discos. Un token de API tampoco debe tener más alcance que la tarea que lo
requiere. Los permisos del panel son distintos de los usuarios del interior
de `srv-aso`.
[Gestión de usuarios de Proxmox](https://pve.proxmox.com/pve-docs/chapter-pveum.html).

Aplica mínimo privilegio, conserva una vía de recuperación autorizada y no
publiques contraseñas, tokens o claves privadas. En este proyecto no se exige
automatizar la API de Proxmox: el Ansible obligatorio configura una parte útil
del servicio invitado.

## Mismo nombre, cuentas diferentes

Ejemplo didáctico: `alumno@pve` y `alumno@pam` pueden representar identidades
de autenticación diferentes. No pruebes una contraseña contra ambos realms
por ensayo: identifica dónde existe tu cuenta.

Además, poder ver `srv-aso` en el panel no implica poder abrir su consola,
modificar sus discos o entrar por SSH al sistema interior. Son capacidades
distintas que debes verificar con la cuenta y el alcance autorizados.

| Operación de prueba | Resultado previsto para una cuenta solo de consulta |
|---|---|
| Consultar métricas autorizadas | Permitido dentro de su alcance |
| Eliminar un invitado | No permitido |
| Cambiar la configuración del nodo | No permitido |
| Entrar por SSH al invitado | Depende de otra cuenta y de sus permisos |

Esta tabla define una intención de acceso; no asegura que cualquier rol llamado
“lectura” la cumpla exactamente. Contrasta privilegios, rutas y herencia de tu
configuración real. No cambies la cuenta administrativa principal para ensayar
restricciones sin una vía de recuperación.

## Usuarios, grupos, privilegios y roles

Estos conceptos se relacionan, pero cada uno cumple una función:

| Concepto | Para qué sirve | Ejemplo |
|---|---|---|
| Usuario | Identifica a quien entra | `alumno-lectura@pve` |
| Realm | Indica cómo se comprueba esa identidad | `pve` usa las cuentas internas de Proxmox; `pam`, las del Linux del nodo |
| Grupo de Proxmox | Reúne usuarios para asignarles permisos en conjunto | Un grupo de personas que supervisan el laboratorio |
| Privilegio | Permite una acción concreta | `Sys.Audit` permite consultar el estado y la configuración del nodo |
| Rol | Agrupa uno o varios privilegios | `AulaLectura`, creado en clase con solo `Sys.Audit` |
| Ruta o ámbito | Delimita sobre qué recurso se concede el rol | `/nodes/pve-apellido` |
| ACL de Proxmox | Asigna un rol a una cuenta o grupo sobre una ruta | `alumno-lectura@pve` recibe `AulaLectura` en `/nodes/pve-apellido` |

En el panel se administran desde **Datacenter → Permisos** (*Permissions*).
Los nombres de los menús pueden cambiar con el idioma o la versión.

`root@pam` tiene acceso administrativo completo. Crear una cuenta en el realm
`pve` no crea un usuario Linux ni le concede acceso SSH al nodo. Tampoco crea
una cuenta dentro de `srv-aso`. Los grupos de Proxmox y los grupos del Linux
invitado se gestionan por separado.

Proxmox incluye roles preparados, como `Administrator` y `PVEAuditor`.
También puedes crear uno con los privilegios que necesites. Revisa su
contenido antes de asignarlo: ponerle el nombre «lectura» no limita sus
acciones por sí solo.

## Dónde se aplica un permiso y cómo se hereda

La ruta de una ACL pertenece al árbol de recursos de Proxmox. **No es una
carpeta del disco** y no se cambia con `chmod`.

| Ruta de ejemplo | Ámbito |
|---|---|
| `/` | Raíz del árbol de permisos |
| `/nodes/pve-apellido` | El nodo con ese nombre |
| `/vms/101` | El invitado con ID 101, cuando exista |
| `/storage/local` | El almacenamiento identificado como `local` |

La opción **Propagar** hace que una asignación se herede en las rutas
descendientes. Si concedes un rol en `/` y lo propagas, su alcance será mucho
mayor que si lo asignas a un recurso concreto. El nodo y sus invitados tienen
rutas distintas: un permiso sobre `/nodes/pve-apellido` no concede por sí
solo acceso a `/vms/101`.

Una cuenta puede recibir permisos directamente, por pertenecer a un grupo
o por herencia. Si al retirar una asignación todavía puede hacer algo,
revisa sus **permisos efectivos**, es decir, los que resultan de todas esas
asignaciones. No basta con mirar una sola fila de la tabla de permisos.

## Ejemplo: consultar el nodo sin leer sus registros

Imagina que una persona de soporte solo necesita ver CPU, memoria y tiempo
de actividad. Creamos `AulaLectura` con `Sys.Audit` y se lo asignamos a
`alumno-lectura@pve` en `/nodes/pve-apellido`, sin propagar.

| Prueba con esa cuenta | Resultado esperado | Motivo |
|---|---|---|
| Entrar en el panel | Permitido | La cuenta y su contraseña son válidas |
| Consultar el estado del nodo | Permitido | Tiene `Sys.Audit` en ese nodo |
| Leer el registro del sistema del nodo | Denegado | Le falta `Sys.Syslog` |
| Cambiar la configuración del nodo | Denegado | No tiene `Sys.Modify` |
| Consultar el estado tras retirar esa ACL | Denegado si no tiene otro acceso | Ya no tiene la autorización necesaria |

Los requisitos de las consultas se pueden comprobar en el
[visor oficial de la API](https://pve.proxmox.com/pve-docs/api-viewer/):
`GET /nodes/{node}/status` y `GET /nodes/{node}/syslog`.

Para probar una restricción utiliza una operación sin cambios, como la lectura
del registro. No intentes borrar un invitado o apagar el nodo para demostrar
que una cuenta no puede hacerlo.

Una contraseña incorrecta demuestra un fallo de autenticación. Para comprobar
los permisos necesitas entrar con credenciales válidas y obtener un rechazo
por falta de autorización. Hazlo en una ventana privada distinta de la sesión
administrativa: dos pestañas normales pueden compartir la cuenta de root.

Encontrarás los pasos y las evidencias en
[Usuarios y permisos de la fase 4](../proyecto/fase-4-configuracion.md#3-revisa-quien-puede-administrar-el-nodo).
La revisión de tus accesos forma parte de esa fase; la creación de una cuenta
limitada se realiza cuando se acuerde en clase.

## Exposición y mantenimiento del nodo

La administración web utiliza HTTPS, habitualmente TCP 8006. Comprueba la
dirección y el certificado del nodo propio antes de introducir credenciales.
No publiques ese puerto en Internet ni configures un bridge al aula sin
autorización.

Una regla de firewall debe tener objetivo, origen, destino, protocolo y prueba.
Antes de aplicarla, ten disponible la consola local o de VirtualBox para
evitar perder todo acceso. La política puede actuar en varios niveles;
consulta el [firewall de Proxmox](https://pve.proxmox.com/pve-docs/chapter-pve-firewall.html)
para la versión y backend utilizados.

Actualizar implica conocer versiones, repositorios configurados, copias y
necesidad de reinicio. No desactives comprobaciones de firma ni ejecutes
scripts de terceros para ocultar avisos de suscripción. Define una ventana de
mantenimiento y comprueba los invitados después.

## Snapshot, backup y copia del servicio

| Mecanismo | Recuperación que permite | Límite importante |
|---|---|---|
| Snapshot | Volver a un estado de los discos incluidos; puede incluir memoria en casos compatibles | Depende del almacenamiento original |
| Backup de invitado | Restaurar configuración y volúmenes incluidos en la copia | No incluye necesariamente todos los recursos externos |
| Copia del servicio | Recuperar datos y configuración seleccionados | Puede necesitar cuentas, paquetes y otros elementos |
| Clon | Crear otra instancia de una base | No define por sí solo una política de recuperación |

Una instantánea antes de un cambio puede ayudar a deshacerlo. No cumple el
requisito de **backup real y restauración**. Una carpeta de backup dentro del
mismo VDI solo demuestra un procedimiento, no protección frente a pérdida del
disco exterior.

## Consistencia de la copia

Una copia consistente debe permitir usar los datos recuperados. Copiar mientras
una aplicación escribe puede capturar un estado incompleto para esa aplicación.

Proxmox ofrece modos de copia con distintos compromisos de parada y
continuidad. Su funcionamiento difiere entre VM y CT. El modo denominado
`snapshot` de backup **produce un backup**, no significa simplemente conservar
un snapshot local. En VMs, el agente puede colaborar congelando/descongelando
sistemas de archivos cuando está configurado; algunas aplicaciones requieren
preparación adicional.
[Modos de copia de Proxmox](https://pve.proxmox.com/pve-docs/chapter-vzdump.html).

En contenedores, los bind mounts y device mounts no se incluyen en el backup;
los puntos de montaje gestionados requieren revisar su opción de copia.
Documenta cualquier dato externo y su protección específica.
[Montajes de contenedores](https://pve.proxmox.com/pve-docs/chapter-pct.html).

## RPO, RTO y dominio de fallo

El **RPO** indica cuánta información reciente se acepta perder, expresada como tiempo. Por ejemplo, un RPO de una hora exige poder recuperar los datos sin perder más de esa última hora. El **RTO** fija cuánto tiempo se acepta tardar en recuperar el servicio. Son objetivos que después se comparan con los resultados del ensayo.

Ejemplo original: haces una copia al terminar la clase semanal. Si se pierde
el disco justo antes de la siguiente copia, podrías perder el trabajo posterior
a la última. No puedes prometer un RPO de una hora con ese calendario.

Si restaurar el invitado tarda 12 minutos y validar el servicio otros 8,
el tiempo medido no son solo los 12 minutos de la tarea Proxmox. Añade las
operaciones necesarias para que el usuario pueda trabajar.

Llamamos **dominio de fallo** al conjunto de recursos que pueden perderse por una misma causa. Por ejemplo, dos VMs guardadas en el mismo disco pueden perderse si ese disco se avería, aunque tengan nombres distintos. Si no dispones de otro dispositivo autorizado para la copia, deja escrita esa limitación y acuerda cómo conservarla.

## Qué sobrevive a un fallo del disco

Ejemplo conceptual. Solo existe la rama externa si has acordado un destino
realmente independiente y copiado allí los datos; **no se da por disponible**.

~~~mermaid
flowchart TD
    D["Disco del equipo"] --> V["Nodo e invitados"]
    D --> S["Snapshots locales"]
    D --> L["Backup en el mismo disco"]
    V -.->|"Copia verificada"| B["Backup en otro dispositivo"]
~~~

Si se pierde el disco, pueden perderse también las tres ramas que dependen de él. La flecha discontinua representa una copia que se puede leer sin el original. Aunque esa copia externa se conserve, necesitarás un equipo compatible y tiempo para restaurarla.

Una copia independiente protege frente a ciertos fallos, no frente a todos.
Si original y copia se pierden por la misma causa, la independencia de
dispositivo no ha bastado. Documenta alcance y riesgos, sin prometer alta
disponibilidad en un nodo individual.

## Ensayo resuelto de recuperación {#ejemplo-recuperacion}

Las horas y resultados siguientes son **ficticios**, para aprender a razonar.

### Línea de tiempo y datos recuperables

- 09:00: estado de los datos incluido en una copia que después se completa
  y valida; contiene la versión A de un archivo.
- 09:20: el usuario guarda la versión B.
- 09:40: se pierde el disco del invitado.
- La copia de las 09:00 sigue disponible en el destino comprobado.

Si solo dispones de esa copia, recuperas A, no B. Han transcurrido 40 minutos
desde el punto recuperable; no significa que se hayan perdido exactamente
40 minutos de trabajo continuo. Has perdido los cambios que no estaban
incluidos ni protegidos por otra vía.

El punto recuperable no tiene por qué coincidir con la hora de finalización
de la tarea de copia. Registra ambos y comprueba qué estado contiene realmente.

Si tu RPO objetivo era 15 minutos, este escenario **no lo cumple**.
Una restauración rápida no compensa esa antigüedad de los datos.

### Duración del procedimiento

| Paso cronometrado | Duración del ejemplo |
|---|---:|
| Identificar copia y preparar destino | 5 min |
| Restaurar invitado | 12 min |
| Revisar arranque e identidad | 3 min |
| Probar datos y servicio desde el cliente | 5 min |
| Total medido | 25 min |

Con RTO de 30 minutos, este ensayo cabe en el objetivo **si esos pasos incluyen
todo el intervalo comprometido**. Si hubo espera previa, búsqueda de hardware
o descarga de la copia, añade también esos tiempos cuando pertenezcan al
periodo de indisponibilidad. Cronometrar solo la tarea Proxmox falsea el resultado.

### Estado del sistema y estado del archivo

Una tarea de restauración `OK` demuestra que terminó esa operación.
Todavía debes comprobar arranque, configuración necesaria, hash del archivo
de prueba y acceso real desde el cliente. El hash acredita que los contenidos
comparados coinciden; no demuestra por sí solo que permisos, usuarios y todos
los datos del servicio estén recuperados.

Para ensayar no hace falta destruir el original: usa una restauración
autorizada a otro ID libre, inicialmente aislada si duplica identidad.
Explica en tu memoria qué parte del incidente simulas y qué no has probado.

## Restaurar sin provocar otro incidente

1. Registra backup elegido, alcance, fecha, ubicación y requisitos.
2. Reserva espacio y un ID libre. No sobrescribas el original de ensayo.
3. Restaura aislado de la red si podría duplicar IP o identidad.
4. Comprueba arranque y datos, y ajusta identidad cuando corresponda.
5. Realiza el intercambio de red de forma controlada.
6. Repite las pruebas desde el cliente, incluida una restricción esperada.
7. Mide duración y compara integridad de un archivo de prueba mediante hash.

Los backups pueden contener secretos aunque el repositorio no los tenga.
Guárdalos con acceso restringido, fuera de GitHub. En Git se publican
procedimiento y evidencias revisadas, no imágenes completas de discos.

## Qué no ofrece un nodo individual

No hay otro nodo al que trasladar automáticamente la carga si este falla.
Un clúster, replicación y alta disponibilidad son conceptos relacionados,
pero distintos de mantener backups. Un segundo invitado en el mismo nodo
no aporta esa continuidad. No se requieren clúster ni Ceph en la práctica.

**Aplicación:** plantea pérdida del invitado, pérdida del nodo y pérdida del
disco del anfitrión. Indica qué copia serviría en cada caso y qué no podrías
recuperar. Integra la respuesta en
[las fases de copias y validación de la práctica](../proyecto/fase-9-copias.md).
