# Glosario

| Término | Significado en este proyecto |
|---|---|
| ASO | Administración de Sistemas Operativos; aporta el servicio Linux administrado |
| Nodo / host | Sistema Proxmox que aloja invitados |
| Hipervisor | Capa que permite ejecutar máquinas virtuales |
| Invitado / guest | VM o contenedor gestionado por el nodo |
| KVM | Virtualización del kernel Linux utilizada para las VMs |
| LXC / CT | Contenedor Linux que comparte el kernel del nodo |
| Virtualización anidada | Ejecutar un hipervisor virtualizado con soporte para sus invitados |
| vCPU | Procesador virtual programado sobre recursos del anfitrión |
| Bridge | Conexión de interfaces a nivel de enlace; no implica NAT |
| VLAN | Segmentación lógica de red que requiere configuración coherente |
| Gateway | Siguiente salto para alcanzar otras redes |
| DNS | Resolución de nombres |
| Storage | Almacenamiento configurado con tipos de contenido admitidos |
| Thin provisioning | Asignación de espacio a medida que se utiliza; no crea capacidad física |
| ISO | Imagen del medio de instalación |
| Plantilla | Base reutilizable para crear invitados |
| Clon completo | Copia independiente del disco base |
| Clon enlazado | Invitado cuyos discos dependen de una base |
| Cloud-init | Inicialización de una instancia, con identidad y parámetros propios |
| Snapshot | Estado al que volver; no sustituye una copia independiente |
| Backup | Copia de seguridad con alcance y destino definidos |
| RPO | Pérdida de datos tolerable, expresada como intervalo temporal |
| RTO | Tiempo objetivo de recuperación; debe compararse con la prueba |
| ACL | Lista de control de acceso que complementa permisos POSIX |
| setgid | En un directorio, facilita heredar el grupo en elementos nuevos |
| Realm | Dominio de autenticación elegido en Proxmox |
| systemd | Gestor del sistema y de servicios en el Linux del proyecto |
| Idempotencia | Repetir una configuración ya satisfecha sin cambios innecesarios |
| Playbook | Conjunto de tareas Ansible expresado en YAML |
| Inventario Ansible | Destinos y variables de conexión, distinto del inventario de hardware |
| Handler | Tarea Ansible activada por una notificación de cambio |
| Become | Elevación de privilegios en Ansible |
| Markdown | Texto estructurado para la documentación |
| Commit | Versión registrada en el historial Git |
| Push | Publicación de commits en el remoto |
| Evidencia | Resultado propio explicado que permite verificar una afirmación |
| Hito | Punto de revisión con entregables y criterios verificables |

Amplía los conceptos en las [guías de Proxmox](../proxmox/conceptos.md)
y [automatización](../linux/automatizacion.md).
