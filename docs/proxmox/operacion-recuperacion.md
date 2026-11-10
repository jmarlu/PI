# Operación, permisos y recuperación

## Administrar con alcance limitado

La **autenticación** comprueba tu identidad al iniciar sesión. La **autorización** determina qué acciones puedes realizar y sobre qué recursos. En Proxmox intervienen la cuenta, el dominio de autenticación o realm, el rol y la ruta del recurso al que se aplica el permiso. El realm indica dónde se comprueba la cuenta; no identifica una VM o un contenedor.

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
