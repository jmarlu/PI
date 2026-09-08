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

## Linux y automatización

| Síntoma | Comprobación | Siguiente paso |
|---|---|---|
| Samba rechaza usuario | Cuenta Linux y alta Samba | Revisar identidad y contraseña de forma privada |
| Samba autentica pero no deja escribir | Grupo, valid users, POSIX y máscara ACL | Corregir permiso mínimo; no usar chmod 777 |
| testparm falla | Primera línea de error y sección duplicada | Corregir antes de reiniciar |
| Ansible unreachable | IP de inventario, SSH, usuario y huella | Probar primero SSH normal |
| Ansible pide privilegios | Sudo autorizado | Usar --ask-become-pass; no incrustar contraseña |
| Módulo ACL no encontrado | Colección ansible.posix | Instalar los requisitos del ejemplo |
| Segunda ejecución cambia siempre | Módulo, condición o agente externo | Investigar idempotencia, no ocultar cambios reales |
| Backup incompleto | Orígenes, montaje, espacio, rsync y permisos | Conservar el error, corregir y generar otra copia |
| Datos restaurados pero acceso falla | Propietarios, ACL, cuentas y configuración | Recuperar dependencias y repetir desde el cliente |

Si el bloqueo depende del centro, entrega una incidencia verificable y una
alternativa propuesta. No cambies la infraestructura ajena para continuar.
