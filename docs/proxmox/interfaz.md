# Interfaz y operaciones de Proxmox

## Acceso al nodo correcto

Abre `https://IP_DE_TU_NODO:8006` desde el equipo de administración.
Usa la dirección de tu nodo y las credenciales configuradas según las normas del aula.
Si aparece un aviso de certificado, verifica dirección y huella con el profesor;
no aceptes certificados desconocidos de forma indiscriminada.

Selecciona el dominio de autenticación (*realm*) correspondiente a tu cuenta.
Un usuario PAM del sistema y un usuario del realm Proxmox no son equivalentes.

![Panel real de Proxmox VE, captura de referencia](../assets/proxmox-panel.png)

Fuente: Proxmox Server Solutions GmbH. Captura oficial de métricas de Proxmox VE 9.0.
Es una ilustración del producto, no una evidencia de tu práctica.
Los nombres, datos y menús pueden variar con la versión.

## Orientarte antes de pulsar

| Zona | Qué representa | Primera comprobación |
|---|---|---|
| Datacenter | Configuración de ámbito general | ¿He seleccionado mi instalación y el objeto correcto? |
| Nodo | Host Proxmox seleccionado | Nombre, versión y recursos |
| Invitado con ID | Una VM o un CT | Nombre, estado e ID propios |
| Storage | Destino y tipos de contenido admitidos | Capacidad real y uso |
| Summary / Resumen | Estado y métricas | CPU, memoria, disco y tiempo activo |
| Console / Consola | Terminal del objeto seleccionado | Ejecutar `hostname` antes de modificar |
| Tasks / Tareas | Operaciones y resultado | Abrir el log; no basta con cerrar una ventana |

Proxmox organiza la administración por objetos y permisos. Tener acceso al panel
no implica autorización para todas sus operaciones.
[Características oficiales](https://www.proxmox.com/en/products/proxmox-virtual-environment/features).

## Operaciones habituales

1. **Arrancar:** selecciona tu VM/CT y pulsa *Start*. Revisa estado y consola.
2. **Apagar:** solicita *Shutdown* al sistema. Si no responde, investiga.
   *Stop* es una parada forzada y puede perder datos.
3. **Abrir una consola:** confirma el nombre del sistema. Si la red falla,
   la consola puede servir para diagnosticarlo sin SSH.
4. **Cambiar recursos:** registra antes/después y comprueba si requiere apagar.
   No asignes al nodo o al invitado la RAM que necesita el anfitrión.
5. **Crear una VM o CT:** decide antes ID, nombre, storage, red e imagen.
6. **Consultar una tarea:** abre el registro y localiza el primer error significativo.
7. **Copiar:** usa *Backup* con el destino aprobado; *Snapshot* tiene otro alcance.

!!! warning "No ejecutar por ensayo"
    *Remove*, reinstalar, cambiar discos, alterar bridges o forzar una parada
    son operaciones con impacto. Confirma objeto, permiso y procedimiento de
    recuperación antes de ejecutarlas.

## Recorrido inicial sin cambios destructivos

Localiza tu nodo, la memoria total, el almacenamiento y las tareas recientes.
Cuando existan tus invitados, identifica sus IDs y abre cada consola.
Toma una captura de tu instalación, oculta datos ajenos y explica los objetos
visibles en `docs/03-instalacion-proxmox.md`.

No utilices la captura oficial de esta web como evidencia de tu trabajo.
