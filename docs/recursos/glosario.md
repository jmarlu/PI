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
| Realm | Dominio de autenticación elegido en Proxmox |
| VirtIO | Interfaz de dispositivos orientada a virtualización, con soporte en el invitado |
| Ballooning | Ajuste de memoria utilizable de una VM cuando el invitado lo soporta |
| QEMU Guest Agent | Agente dentro de la VM para operaciones coordinadas con el nodo |
| LVM-thin | Backend de volúmenes de bloques con asignación de espacio bajo demanda |
| Dominio de fallo | Recursos que pueden perderse por una misma causa |
| Idempotencia | Repetir una configuración ya satisfecha sin cambios innecesarios |
| Convergencia | Aplicación que lleva el estado real hacia el declarado |
| Deriva | Diferencia entre configuración declarada y estado real |
| Controlador Ansible | Equipo que interpreta el playbook y dirige las operaciones |
| Nodo gestionado | Destino seleccionado por el inventario y el play |
| Playbook | Conjunto de tareas Ansible expresado en YAML |
| Play | Selección de destinos y tareas dentro de un playbook |
| Módulo | Implementación de una operación con parámetros y resultados definidos |
| Inventario Ansible | Destinos y variables de conexión, distinto del inventario de hardware |
| Facts | Información descubierta del destino, no valores escritos como previsión |
| Register | Captura del resultado estructurado de una tarea |
| Jinja | Motor de plantillas utilizado para renderizar valores y estructuras |
| Handler | Tarea Ansible activada por una notificación de cambio |
| Rol | Organización reutilizable de tareas y recursos relacionados |
| Colección | Paquete con módulos, plugins, roles u otros recursos bajo un namespace |
| Check mode | Simulación limitada por el soporte y dependencias de cada tarea |
| Vault | Cifrado de datos en reposo; no evita toda exposición durante la ejecución |
| Become | Elevación de privilegios en Ansible |
| Markdown | Texto estructurado para la documentación |
| Commit | Versión registrada en el historial Git |
| Push | Publicación de commits en el remoto |
| Evidencia | Resultado propio explicado que permite verificar una afirmación |
| Hito | Punto de revisión con entregables y criterios verificables |

Amplía los conceptos en las [guías de Proxmox](../proxmox/conceptos.md)
y [Ansible](../ansible/fundamentos.md).
