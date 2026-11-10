# Resolver incidencias

Registra siempre: objetivo, máquina, comando o acción, salida exacta sin secretos,
hipótesis, prueba, resultado y siguiente paso. Cambia una cosa cada vez.
La bitácora debe mostrar el proceso, no una lista de intentos sin explicación.

## GitHub y documentación

| Síntoma | Comprobación | Siguiente paso |
|---|---|---|
| El profesor no ve el repo | Visibilidad e invitación a su cuenta | Verificar aceptación y URL en Aules |
| El commit no está en GitHub | `git status`, `git log -1` y resultado de push | Resolver autenticación/conexión sin publicar tokens |
| Primer push rechazado | El remoto ya tenía README u otros commits | Conservar trabajo, clonar en otra carpeta e integrar; no forzar |
| Documento sin cambios visibles | Archivo, rama y commit abierto | Comparar local y remoto, publicar y recargar |
| Imagen o enlace roto | Ruta relativa y mayúsculas | Confirmar que el destino también está publicado |
| Credencial publicada | Puede seguir en el historial | Avisar y revocar/rotar de inmediato; borrar una línea no basta |
| Acceso temporalmente caído | Guardado y commits locales | Documentar incidencia y publicar al recuperar acceso |

## Nodo y red

| Síntoma | Comprobación | Siguiente paso |
|---|---|---|
| Panel inaccesible | IP asignada, interfaz, ruta, puerto 8006 y consola | Diagnosticar por capas; no reinstalar a ciegas |
| Aviso de certificado | Dirección y huella | Confirmar con el profesor |
| KVM no disponible dentro de tu nodo | CPU del host, versión de VirtualBox y opción Nested VT-x/AMD-V | Revisar VirtualBox con el profesor o validar LXC dentro de Proxmox |
| Invitados internos sin red | Adaptadores VirtualBox, solo-anfitrión, promiscuo, gateway y NAT del nodo | Revisar el montaje local; no recurrir a un servidor del centro |
| IP duplicada tras clonar | IP, hostname e identidad del clon | Aislar el clon por consola y corregir antes de conectarlo |
| Storage lleno | Pool físico, discos, ISO y copias | Detener nuevas escrituras y acordar ampliación/limpieza; no borrar al azar |
| CT con operación no permitida | Permisos, montaje, kernel y límites del CT | Investigar compatibilidad; no convertirlo en privilegiado sin aprobación |

## Ansible

| Síntoma | Comprobación | Siguiente paso |
|---|---|---|
| No hay hosts coincidentes | Grupo del play e inventario seleccionado | Revisar --graph y --list-hosts antes de ejecutar |
| Ansible unreachable | IP de inventario, SSH, usuario y huella | Probar primero SSH normal |
| Ansible pide privilegios | Sudo autorizado | Usar --ask-become-pass; no incrustar contraseña |
| Módulo no encontrado | Nombre completo, colección y versión | Instalar los requisitos declarados del ejemplo |
| Variable indefinida | Nombre, archivo, grupo y ámbito | Corregir la fuente; no ocultar un dato obligatorio con default |
| Check mode omite una validación | Soporte del módulo y dependencias todavía inexistentes | Revisar el diseño y validar con una ejecución real autorizada |
| Handler no se ejecuta | Cambio real y notificación coincidente | Comprobar cuándo se procesa; no forzar cambios ficticios |
| Segunda ejecución cambia siempre | Módulo, condición o agente externo | Investigar idempotencia, no ocultar cambios reales |
| Presupuesto rechazado en el laboratorio local | Variables y suma de RAM | Corregir los datos, no eliminar la aserción |

Para incidencias del servicio, utiliza el procedimiento de ASO aprobado y
registra las pruebas en la [práctica](../proyecto/fase-7-servicio.md).
Para copias, revisa [alcance y recuperación](../proxmox/operacion-recuperacion.md).

Si el bloqueo depende del centro, entrega una incidencia verificable y una
alternativa propuesta. No cambies la infraestructura ajena para continuar.
