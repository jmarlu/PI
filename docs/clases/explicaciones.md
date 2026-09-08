# Explicaciones de las 33 sesiones

Cada sesión dura **180 minutos**: apertura 10, explicación 25, demostración 25,
práctica 85, validación 20 y cierre 15. El profesor puede ajustar el reparto
para una incidencia; no se añaden horas. La primera sesión tiene su
[guion detallado](../proyecto/primera-sesion.md).

En todas las clases: abre tu repositorio al empezar y, al cerrar, actualiza el
documento indicado y la bitácora, realiza un commit significativo, haz push y
comprueba su publicación. Si existe un bloqueo, registra pruebas y siguiente paso.

El [calendario](index.md) agrupa las sesiones por hitos. Los requisitos y la
rúbrica se concentran en la [práctica](../proyecto/practica.md).

## Sesión 01. GitHub y Markdown {#s01}

### Explicación

Git guarda versiones en tu equipo; GitHub aloja el historial compartido. Un commit local no es una entrega publicada. Markdown conserva texto, enlaces y comandos en archivos que se pueden revisar junto al código.

### Demostración en clase

El profesor crea un repositorio vacío, edita un README, confirma cambios, hace push y abre la misma versión en GitHub.

### Lo haces

Completa la primera sesión paso a paso. Crea README, ficha, bitácora y memoria inicial antes del inventario.

### Validas y documentas

Abre los enlaces desde GitHub y verifica el primer commit y el acceso del profesor.

**Evidencia de salida:** README, ficha, bitácora, memoria iniciada, URL en Aules y H0 validado.

[Procedimiento y recursos de la sesión](../proyecto/primera-sesion.md).

## Sesión 02. Inventario investigado y viabilidad {#s02}

### Explicación

Instalar el hipervisor no garantiza poder ejecutar servidor y cliente a la vez. Las especificaciones del fabricante, los datos detectados y la asignación local en VirtualBox son evidencias distintas. Un cuello de botella limita el rendimiento; un componente crítico también puede serlo por el impacto de su fallo.

### Demostración en clase

El profesor contrasta una CPU y la RAM detectada con fuentes oficiales, calcula un presupuesto y justifica una conclusión condicionada.

### Lo haces

Responde las tres preguntas de la fase 1: si puedes instalarlo, qué limitaciones tendrás y qué componentes son más críticos. Investiga al menos tres fuentes primarias; calcula RAM y disco y ordena al menos tres componentes.

### Validas y documentas

Cada respuesta debe unir dato, evidencia, fuente y argumento propio. Distingue instalación, proyecto completo y aspectos pendientes de confirmar.

**Evidencia de salida:** docs/01-inventario-hardware.md con las tres respuestas y el dictamen de viabilidad.

[Procedimiento y recursos de la sesión](../proyecto/practica.md#7-fase-1-inventario-investigado-y-viabilidad).

## Sesión 03. Requisitos, alcance y riesgos {#s03}

### Explicación

Un requisito describe algo verificable: por ejemplo, un usuario autorizado escribe un archivo y uno ajeno no entra al recurso. El alcance fija qué entregarás; las exclusiones evitan prometer un clúster o disponibilidad que un nodo no proporciona. Un riesgo necesita prevención y respuesta.

### Demostración en clase

Durante los primeros 20 minutos se revisan los dictámenes de inventario. Después se transforma una necesidad en requisitos y pruebas de aceptación.

### Lo haces

Corrige y defiende tu inventario. Define necesidad, objetivos, servicio, exclusiones, dependencias y riesgos; vincula cada requisito con una prueba.

### Validas y documentas

Comprueba que tus recursos permiten lo prometido. Identifica qué autorización o recurso local falta y quién debe resolverlo.

**Evidencia de salida:** Inventario revisado y memoria con alcance, requisitos, aceptación y riesgos.

[Procedimiento y recursos de la sesión](../proyecto/practica.md).

## Sesión 04. Diseño de red {#s04}

### Explicación

Dirección IP y prefijo determinan la red del sistema; el gateway permite alcanzar otras redes y DNS resuelve nombres. Un bridge no equivale a un router ni proporciona aislamiento automáticamente. El diagrama debe reflejar conexiones reales, no solo nombres de máquinas.

### Demostración en clase

Se dibuja el recorrido navegador-nodo y cliente-servidor, señalando NAT y solo-anfitrión de VirtualBox en la modalidad virtualizada.

### Lo haces

Prepara diagrama y tabla de IP, prefijo, interfaz, bridge/VLAN, gateway y DNS con los datos autorizados.

### Validas y documentas

No debe haber IP duplicada ni gateway inventado. Explica desde dónde se administrará cada máquina.

**Evidencia de salida:** docs/02-diagrama-red.md iniciado.

[Procedimiento y recursos de la sesión](../proxmox/red-almacenamiento.md).

## Sesión 05. Dimensionamiento de recursos {#s05}

### Explicación

Los recursos se reservan para el nodo y para los invitados. Las vCPU comparten procesador; no equivalen a núcleos exclusivos. Un disco virtual aprovisionado no garantiza espacio físico disponible. Las copias y los clones también consumen almacenamiento.

### Demostración en clase

Se compara el presupuesto con ambos invitados activos y se calcula el espacio de una copia adicional.

### Lo haces

Define CPU, RAM y disco por máquina, plantilla y copias. Revisa el saldo y el margen de tu inventario.

### Validas y documentas

Justifica los supuestos y evita contar dos veces un mismo pool. La swap no sustituye RAM suficiente.

**Evidencia de salida:** Tabla de recursos enlazada desde inventario y diseño.

[Procedimiento y recursos de la sesión](../proxmox/red-almacenamiento.md).

## Sesión 06. Revisión del diseño {#s06}

### Explicación

Un diseño se aprueba antes de ejecutar operaciones irreversibles. Necesitas saber qué cambiarás, cómo comprobarás el resultado y cómo volverás atrás. La alternativa virtualizada mantiene los productos, aunque cambie la capa física.

### Demostración en clase

El profesor muestra una revisión de requisitos, red, capacidad, permisos y plan de instalación.

### Lo haces

Corrige el diseño y prepara una lista previa: autorización, disco, ISO, versión, red, acceso de consola y copia de datos que deban conservarse.

### Validas y documentas

Defiende una decisión VM/LXC y un riesgo importante. No instales mientras exista un bloqueo de autorización o capacidad.

**Evidencia de salida:** H2: diseño y plan de instalación aprobados.

[Procedimiento de instalación](../proxmox/instalacion.md) y [montaje VirtualBox](../proxmox/virtualbox.md).

## Sesión 07. Instalación de Proxmox {#s07}

### Explicación

En modo físico el instalador modifica discos reales; en modo virtualizado actúa sobre el VDI de tu VM creada en VirtualBox. El nombre del nodo y la IP de gestión no son los del futuro servidor Samba. Seleccionar el destino equivocado puede destruir datos.

### Demostración en clase

Se crea la VM en VirtualBox cuando corresponde, se revisan RAM del host, VDI, adaptadores y virtualización anidada; después se recorre el instalador y se comprueba el destino.

### Lo haces

Instala en el equipo dedicado autorizado o en la VM que creas en VirtualBox local. Registra opciones, versión, almacenamiento y red; no fotografíes credenciales.

### Validas y documentas

Reinicia, retira el medio y abre el panel de tu nodo desde el equipo de administración.

**Evidencia de salida:** Capturas propias y procedimiento de instalación.

[Procedimiento de instalación](../proxmox/instalacion.md) y [montaje VirtualBox](../proxmox/virtualbox.md).

## Sesión 08. Red del nodo y actualización {#s08}

### Explicación

La consola y el acceso web son vías diferentes. Si cambias mal la IP de gestión puedes perder la conexión web aunque el nodo siga activo. Los repositorios deben corresponder a la versión y condiciones de soporte del centro.

### Demostración en clase

Se revisan hostname, interfaces, rutas, resolución y versión desde la consola; se consulta Updates y Repositories.

### Lo haces

Configura o verifica la red autorizada; en VirtualBox comprueba acceso solo-anfitrión y salida NAT para nodo e invitados. Actualiza durante la ventana indicada. Conserva acceso de consola antes de cambiar red o reiniciar.

### Validas y documentas

Comprueba pveversion, resolución de nombres, gateway cuando exista y acceso web posterior.

**Evidencia de salida:** Salidas de red, versión y actualización en docs/03-instalacion-proxmox.md.

[Procedimiento de instalación](../proxmox/instalacion.md) y [montaje VirtualBox](../proxmox/virtualbox.md).

## Sesión 09. Validación del nodo {#s09}

### Explicación

Diagnosticar es separar hipótesis. Si la web no abre, comprueba antes dirección, ruta y servicio que reinstalar. Un aviso de certificado no es el mismo problema que una conexión rechazada. Conserva la salida exacta que permite distinguirlos.

### Demostración en clase

Se analiza una incidencia de red o DNS y se verifica cada hipótesis con una prueba.

### Lo haces

Resuelve incidencias, repite el acceso tras reinicio autorizado y completa el procedimiento de instalación.

### Validas y documentas

Otro compañero, bajo supervisión y sin compartir contraseñas, debe poder entender los pasos y localizar las pruebas.

**Evidencia de salida:** docs/03-instalacion-proxmox.md completo con incidencias y soluciones.

[Procedimiento y recursos de la sesión](../recursos/incidencias.md).

## Sesión 10. Almacenamiento, ISO y plantillas {#s10}

### Explicación

Un storage admite determinados contenidos. ISO es medio de instalación; plantilla CT es una imagen base; disco de VM contiene el sistema instalado. Los nombres local y local-lvm no significan que ambos acepten cualquier archivo.

### Demostración en clase

Se comparan tipos de contenido, capacidad del pool y opciones de backup.

### Lo haces

Selecciona los storages de ISO, discos y copia. Sube o descarga solo imágenes autorizadas y registra origen y comprobación.

### Validas y documentas

Comprueba espacio físico disponible y justifica dónde quedará cada objeto. No formatees discos adicionales para probar.

**Evidencia de salida:** Tabla y capturas de almacenamiento con alcance de cada destino.

[Procedimiento y recursos de la sesión](../proxmox/red-almacenamiento.md).

## Sesión 11. Seguridad base del nodo {#s11}

### Explicación

La cuenta y el ámbito del permiso determinan qué se puede administrar. Administrar tu nodo no autoriza a modificar el sistema anfitrión sin supervisión. Un firewall necesita reglas de acceso y un medio de recuperación antes de activarse.

### Demostración en clase

Se localizan usuarios, realms, permisos y reglas relevantes sin modificar cuentas ajenas.

### Lo haces

Aplica solo los controles acordados: cuentas, privilegios, actualización y firewall si procede. Documenta accesos necesarios.

### Validas y documentas

Comprueba una nueva conexión autorizada antes de cerrar la sesión existente. Mantén acceso de consola.

**Evidencia de salida:** Tabla de cuentas/roles y controles del nodo, sin secretos.

[Procedimiento y recursos de la sesión](../proxmox/interfaz.md).

## Sesión 12. Hito Proxmox {#s12}

### Explicación

Validar un hito significa demostrar que sus dependencias están listas para la fase siguiente. Un nodo accesible pero sin storage utilizable o red para invitados todavía no resuelve el diseño.

### Demostración en clase

Se hace una revisión técnica breve del nodo, tareas, red, almacenamiento y permisos.

### Lo haces

Completa lo pendiente y ordena las evidencias en la documentación. Contrasta el nodo real con el diseño aprobado.

### Validas y documentas

Arranque, acceso, versión, red, capacidad y permisos deben tener evidencia propia. Registra bloqueos reales con plan de recuperación.

**Evidencia de salida:** H3: nodo Proxmox validado.

[Procedimiento de instalación](../proxmox/instalacion.md) y [montaje VirtualBox](../proxmox/virtualbox.md).

## Sesión 13. Sistema Linux base {#s13}

### Explicación

La plantilla debe contener lo común, no el servicio final ni datos de usuarios. VM y CT se preparan de manera distinta: la VM tiene su kernel y el CT comparte el del nodo. Esta elección condiciona consumo y compatibilidad.

### Demostración en clase

Se crea un sistema mínimo desde ISO o plantilla CT, con recursos previstos.

### Lo haces

Instala el Linux base aprobado; registra versión, disco, hostname, red y paquetes iniciales.

### Validas y documentas

El sistema debe arrancar, disponer de almacenamiento y alcanzar los repositorios autorizados.

**Evidencia de salida:** docs/04-plantilla-linux.md iniciado.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 14. SSH y administración del Linux base {#s14}

### Explicación

La cuenta administrativa no tiene por qué ser root. SSH comprueba la identidad del servidor mediante su clave de host; sudo permite ejecutar tareas autorizadas. QEMU Guest Agent es para VMs, no una necesidad de LXC.

### Demostración en clase

Se prepara un usuario administrativo, se verifica SSH y se distinguen guest agent y cloud-init.

### Lo haces

Instala paquetes comunes y prepara SSH, zona horaria y sudo. Añade guest agent o cloud-init solo en la ruta correspondiente.

### Validas y documentas

Conecta desde el equipo de administración con la cuenta prevista y comprueba identidad y privilegios sin publicar claves.

**Evidencia de salida:** Prueba SSH y preparación común de la plantilla.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 15. Conversión y clonado {#s15}

### Explicación

Clonar copia un punto de partida; sin preparación también puede duplicar nombres, IPs e identidades. Una plantilla no debe contener credenciales privadas reutilizadas. Los clones enlazados dependen de la base y del storage.

### Demostración en clase

Se limpia una base por el mecanismo autorizado, se apaga, se convierte en plantilla y se crea un clon con identidad distinta.

### Lo haces

Prepara y convierte tu plantilla. Crea un clon de ensayo con ID libre y configura nombre/IP únicos.

### Validas y documentas

Verifica identidad del sistema y claves públicas de host SSH cuando correspondan. No conectes dos sistemas con la misma IP.

**Evidencia de salida:** Captura de la plantilla y procedimiento de clonado probado.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 16. Validación de plantilla {#s16}

### Explicación

Reutilizable significa que se puede repetir el despliegue sin corregir a mano un conjunto de errores ocultos. Debes conocer qué configura automáticamente el primer arranque y qué debes configurar por clon.

### Demostración en clase

Se contrasta la lista de requisitos con un clon recién creado.

### Lo haces

Corrige la base si procede, documenta su versión y repite la prueba de clon. Retira el clon de ensayo solo con autorización y tras guardar evidencia.

### Validas y documentas

Comprueba paquetes, usuario, SSH, hora, identidad y ausencia de secretos heredados.

**Evidencia de salida:** H4: plantilla validada y docs/04-plantilla-linux.md completo.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 17. Despliegue de srv-aso {#s17}

### Explicación

El servidor del servicio es un invitado, no el nodo. Separarlo permite probar, copiar y restaurar el servicio sin instalar sus paquetes en el hipervisor. Sus recursos deben respetar el presupuesto.

### Demostración en clase

Se clona la plantilla y se asignan ID, nombre, IP y límites de servidor.

### Lo haces

Despliega srv-aso, configura su identidad y verifica SSH y sudo.

### Validas y documentas

Comprueba nombre/IP únicos, arranque y acceso administrativo. Registra cualquier diferencia frente al diseño.

**Evidencia de salida:** srv-aso operativo e inventario de máquinas iniciado.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 18. Despliegue de cli-linux {#s18}

### Explicación

Un cliente separado comprueba el recorrido real de red y autorización. Probar solo en el servidor puede ocultar errores de firewall o escucha. El cliente debe ser suficientemente ligero para coexistir con el servidor.

### Demostración en clase

Se clona el cliente y se comprueba que no hereda la IP del servidor.

### Lo haces

Despliega cli-linux, asigna sus recursos y prepara las herramientas de cliente necesarias.

### Validas y documentas

Enciende ambos invitados y compara memoria disponible con lo previsto. Revisa nombres y rutas.

**Evidencia de salida:** cli-linux operativo y tabla de sus recursos.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 19. Conectividad y acceso remoto {#s19}

### Explicación

La conectividad se prueba por capas: enlace/dirección, ruta, resolución y aplicación. Ping no comprueba SSH ni Samba. Una entrada de /etc/hosts resuelve nombres localmente, no configura DNS en toda la red.

### Demostración en clase

Se comparan ping, resolución de nombres y conexión SSH, explicando qué prueba cada uno.

### Lo haces

Valida el recorrido cliente-servidor y la administración remota. Documenta DNS o /etc/hosts según el diseño.

### Validas y documentas

Guarda resultados desde ambos invitados e investiga diferencias; no desactives todo el firewall para resolverlas.

**Evidencia de salida:** Pruebas de red enlazadas desde docs/05-vms-lxc.md.

[Procedimiento y recursos de la sesión](../proxmox/red-almacenamiento.md).

## Sesión 20. Inventario de máquinas {#s20}

### Explicación

El inventario inicial describe la viabilidad; el de invitados registra lo realmente desplegado. Son complementarios. Si cambias recursos o modalidad, la memoria debe explicar el motivo y su impacto.

### Demostración en clase

Se relaciona cada fila de la tabla con el objeto real en Proxmox.

### Lo haces

Completa ID, nombre, tipo, plantilla de origen, CPU, RAM, disco, IP, bridge y función de cada sistema.

### Validas y documentas

Compara panel y tabla. No dejes datos previstos presentados como si fueran mediciones reales.

**Evidencia de salida:** H5 y docs/05-vms-lxc.md completo.

[Procedimiento y recursos de la sesión](../proxmox/plantillas.md).

## Sesión 21. Instalación del servicio ASO {#s21}

### Explicación

Un servicio debe responder a una necesidad y tener una prueba de aceptación. Samba relaciona cuentas, permisos Linux, red y administración. Instalar el paquete no demuestra que el recurso funcione.

### Demostración en clase

Se identifican paquetes, configuración, unidad systemd y puertos del servicio.

### Lo haces

Confirma el servicio aprobado e instala sus paquetes en srv-aso. Prepara smbclient en el cliente si eliges Samba.

### Validas y documentas

Localiza servicio y configuración y registra versión. Distingue instalado, activo y funcional.

**Evidencia de salida:** Servicio instalado y docs/06-servicio-aso.md iniciado.

[Procedimiento y recursos de la sesión](../linux/servicio-aso.md).

## Sesión 22. Usuarios, grupos y ACL {#s22}

### Explicación

La cuenta Linux y la contraseña Samba son elementos distintos. El grupo organiza permisos; setgid influye en la herencia del grupo y la ACL por defecto en los permisos heredados. La máscara puede limitar una ACL aparentemente amplia.

### Demostración en clase

Se crean cuentas de laboratorio, credenciales Samba interactivas, grupo y directorio; se interpreta getfacl.

### Lo haces

Configura usuarios, grupo, propietario, permisos y ACL. Mantén las credenciales fuera del repositorio.

### Validas y documentas

Explica permisos efectivos y herencia. Comprueba id y getfacl, no solo que los comandos terminen.

**Evidencia de salida:** Tabla de identidades y evidencias de permisos.

[Procedimiento y recursos de la sesión](../linux/servicio-aso.md).

## Sesión 23. Configuración y systemd {#s23}

### Explicación

La configuración describe el recurso publicado; systemd administra el proceso. Un archivo sintácticamente correcto puede seguir teniendo permisos equivocados. Validar antes de reiniciar evita introducir errores evitables en el servicio.

### Demostración en clase

Se guarda una copia previa, se edita el recurso y se ejecuta testparm antes del reinicio.

### Lo haces

Configura el servicio y aplica el cambio de forma controlada. Consulta estado y registros.

### Validas y documentas

Diferencia testparm correcto, smbd activo y puerto escuchando. Si algo falla, conserva y explica el primer error.

**Evidencia de salida:** Configuración sin secretos y estado del servicio.

[Procedimiento y recursos de la sesión](../linux/servicio-aso.md).

## Sesión 24. Pruebas positivas y negativas {#s24}

### Explicación

Una prueba positiva demuestra el uso previsto; una negativa demuestra que la restricción actúa. Rechazar una contraseña incorrecta no demuestra autorización por grupo. Usa una cuenta Samba válida pero no autorizada al recurso.

### Demostración en clase

Se carga y descarga un archivo desde el cliente y se compara su hash; después se prueba la cuenta ajena.

### Lo haces

Ejecuta ambas pruebas desde cli-linux y contrasta registros del servidor.

### Validas y documentas

El archivo debe recuperarse íntegro y el acceso ajeno denegarse por la causa prevista.

**Evidencia de salida:** docs/06-servicio-aso.md con prueba positiva, negativa y diagnóstico.

[Procedimiento y recursos de la sesión](../linux/servicio-aso.md).

## Sesión 25. Endurecimiento del servicio {#s25}

### Explicación

Reducir superficie de exposición implica permitir solo lo necesario y conservar capacidad de administración. Una regla que bloquea todo puede impedir el ataque y también el trabajo legítimo. Cada mejora necesita una prueba posterior.

### Demostración en clase

Se relacionan puertos escuchando, usuarios, ACL y reglas autorizadas.

### Lo haces

Aplica una mejora justificada y registra estado anterior, cambio y posibilidad de recuperación.

### Validas y documentas

Repite acceso válido y denegado. Comprueba que no has abierto permisos para solucionar un error.

**Evidencia de salida:** H6 e informe breve de hardening con riesgos pendientes.

[Procedimiento y recursos de la sesión](../linux/pruebas.md).

## Sesión 26. Scripts Bash {#s26}

### Explicación

Bash ejecuta procedimientos. Variables, comillas y comprobaciones de error hacen que una tarea sea repetible y diagnosticable. Una salida que dice éxito cuando faltan datos es un defecto, aunque no se vea un error de sintaxis.

### Demostración en clase

Se revisan inventario y backup, se pasa bash -n y se compara un caso correcto con otro de origen inexistente.

### Lo haces

Crea y adapta los dos scripts obligatorios, añade identificación y documentación de variables y ejecútalos en el sistema adecuado.

### Validas y documentas

La copia debe fallar si faltan orígenes, conservar metadatos y no borrar otras copias. Revisa el código de retorno.

**Evidencia de salida:** Scripts ejecutados y docs/07-automatizacion.md iniciado.

[Procedimiento y recursos de la sesión](../linux/automatizacion.md).

## Sesión 27. Ansible: conexión e inventario {#s27}

### Explicación

El controlador ejecuta Ansible; el inventario identifica el destino. El ping de Ansible comprueba SSH y Python, no ICMP. El usuario SSH y become determinan la identidad y los privilegios de las tareas.

### Demostración en clase

Se verifica SSH, se crea inventory.ini y se ejecuta ansible.builtin.ping.

### Lo haces

Prepara Ansible en el equipo autorizado y conecta solo a srv-aso. No incluyas claves privadas ni contraseñas en el inventario.

### Validas y documentas

Comprueba el grafo de inventario y la identidad del destino antes del primer playbook.

**Evidencia de salida:** inventory.ini, playbook inicial y ping Ansible real.

[Procedimiento y recursos de la sesión](../linux/automatizacion.md).

## Sesión 28. Ansible: configuración e idempotencia {#s28}

### Explicación

Un playbook describe estado deseado mediante módulos. Un handler reinicia solo cuando la tarea que lo notifica cambia. La segunda ejecución permite detectar configuraciones que se reescriben o tareas que anuncian cambios sin necesidad.

### Demostración en clase

Se revisa el ejemplo ampliado, se valida sintaxis y se ejecuta dos veces con una comprobación final del servicio.

### Lo haces

Automatiza una parte útil del servicio: paquetes, usuarios/directorios, configuración, servicio y validación. Documenta qué sigue siendo manual, como las credenciales del ejemplo.

### Validas y documentas

Compara resúmenes y prueba Samba otra vez. Justifica cualquier cambio repetido; --check no sustituye la ejecución.

**Evidencia de salida:** H7: Bash y Ansible ejecutados, resultados e idempotencia explicados.

[Procedimiento y recursos de la sesión](../linux/automatizacion.md).

## Sesión 29. Copias de seguridad {#s29}

### Explicación

Snapshot, backup de invitado y copia del servicio tienen alcances diferentes. Un archivo en el mismo disco no protege del fallo de ese disco. RPO describe la pérdida de datos tolerada y RTO el objetivo de recuperación.

### Demostración en clase

Se revisa el destino, se crea un backup real en Proxmox y se ejecuta la copia de datos/configuración con Bash.

### Lo haces

Crea ambas copias, registra alcance, espacio, fecha, ubicación y limitaciones. Prepara el fichero para la restauración.

### Validas y documentas

Confirma el resultado de las tareas, la existencia de los datos y el acceso protegido a las copias.

**Evidencia de salida:** Backup Proxmox y copia del servicio documentados.

[Procedimiento y recursos de la sesión](../linux/copias.md).

## Sesión 30. Restauración y recuperación {#s30}

### Explicación

Una copia no validada conserva una incertidumbre: puede existir y no servir para recuperar. Debes comprobar contenido, permisos y acceso del cliente después del fallo simulado. El tiempo medido se compara con el objetivo, no se inventa.

### Demostración en clase

Se renombra un archivo de ensayo, se restaura desde la copia y se verifica hash y acceso Samba.

### Lo haces

Ejecuta la recuperación controlada sobre tu archivo de prueba, conserva la secuencia antes/fallo/después y mide el tiempo.

### Validas y documentas

Comprueba contenido y permisos, prueba positiva y negativa. No sobrescribas invitados ni datos de trabajo para hacer una demo.

**Evidencia de salida:** H8 y docs/08-copias-restauracion.md completo.

[Procedimiento y recursos de la sesión](../linux/copias.md).

## Sesión 31. Rendimiento y límites reales {#s31}

### Explicación

Una medida necesita unidad, condiciones y repetición. Una transferencia puede estar limitada por disco, red, CPU o caché; su duración aislada no identifica la causa. En modo virtualizado influye la carga de tu propio anfitrión: LliureX, VirtualBox, navegador y Ansible.

### Demostración en clase

Se observan CPU/RAM/disco y una transferencia limitada, calculando MiB/s y anotando condiciones.

### Lo haces

Realiza las pruebas mínimas con ambos invitados y repite la transferencia. Compara resultados con el inventario y explica el límite observado.

### Validas y documentas

Distingue estimación inicial de dato medido. No uses benchmarks ilimitados ni afirmes capacidad de producción a partir del ensayo.

**Evidencia de salida:** Resultados interpretados en docs/09-rendimiento-seguridad.md.

[Procedimiento y recursos de la sesión](../linux/pruebas.md).

## Sesión 32. Revisión de seguridad {#s32}

### Explicación

La revisión combina exposición, identidades, permisos, actualización y recuperación. Un escáner no demuestra que un sistema sea seguro. El alcance autorizado excluye equipos de compañeros y la red corporativa.

### Demostración en clase

Se inspeccionan ss, servicios fallidos y logs; desde el cliente se revisan puertos concretos del propio servidor.

### Lo haces

Ejecuta las pruebas, justifica cada puerto y revisa GitHub para retirar posibles secretos antes de publicar.

### Validas y documentas

Relaciona cada hallazgo con una medida o riesgo pendiente y vuelve a probar los cambios. Una ausencia de avisos no garantiza ausencia de fallos.

**Evidencia de salida:** H9 e informe de seguridad final.

[Procedimiento y recursos de la sesión](../linux/pruebas.md).

## Sesión 33. Memoria, exposición y defensa {#s33}

### Explicación

La memoria permite reconstruir el trabajo y la defensa demuestra que entiendes sus decisiones. La documentación se ha escrito durante el curso: hoy se revisa y cierra. La demo necesita evidencias alternativas si falla un componente.

### Demostración en clase

El profesor presenta una demo breve: repositorio, topología, nodo, invitados, servicio, automatización y recuperación.

### Lo haces

Comprueba enlaces, citas, bitácora, scripts y anexos. Prepara una exposición breve con necesidad, diseño, demostración, pruebas y conclusiones; ensaya las preguntas técnicas.

### Validas y documentas

Verifica el checklist final y el commit publicado. Localiza cada evidencia sin leer toda la memoria. Respeta el turno y duración asignados.

**Evidencia de salida:** H10: memoria cerrada, demo preparada y entrega identificada en Aules.

[Procedimiento y recursos de la sesión](../proyecto/evaluacion.md).

## Hora final de cierre

Se reserva una hora para revisión, entrega, recuperación puntual o registro final,
según el calendario del centro. Con las 33 sesiones suma **100 horas**.
El profesor concreta fechas y turnos en Aules; no es una hora extra semanal.
