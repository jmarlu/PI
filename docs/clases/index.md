# Secuenciacion de sesiones

## Proyecto Proxmox individual

**Modulo:** Proyecto Intermodular de ASIR  
**Curso:** 2.º de ASIR  
**Carga:** 3 horas semanales seguidas  
**Organizacion:** 33 sesiones de 3 horas + 1 hora final de cierre

## 1. Dinamica fija de cada sesion

Cada sesion se plantea con el modelo **explico, demuestro, lo haces,
validamos y documentas**.

| Momento | Duracion | Trabajo en aula |
|---|---:|---|
| Apertura | 10 min | Objetivo, producto del dia y comprobacion del estado anterior |
| Explicacion | 25 min | Conceptos tecnicos imprescindibles y decisiones a tomar |
| Demostracion | 25 min | Ejemplo del profesor en entorno controlado |
| Practica | 85 min | Ejecucion individual en el nodo, VM o contenedor del alumno |
| Validacion | 20 min | Pruebas minimas, errores frecuentes y correcciones |
| Cierre | 15 min | Markdown y bitacora actualizados, commit y push, verificacion en GitHub |

Regla de trabajo: ninguna sesion se considera terminada sin una
evidencia verificable. Puede ser una captura, salida de comandos,
diagrama, fichero de configuracion, script, playbook Ansible, prueba de
servicio o entrada de bitacora.

Cada alumno creara su repositorio individual de GitHub y su documentacion
Markdown como primera actividad del curso. Todos los cierres siguientes
incluyen al menos un commit significativo publicado y verificado en
GitHub. Ante una incidencia de acceso se documenta el bloqueo y se
completa la publicacion al recuperarlo.

Consulta las [explicaciones de cada una de las 33 sesiones](explicaciones.md).

## 2. Secuencia semanal

| Sesion | Bloque | Explicacion y demostracion | Trabajo del alumnado | Evidencia de salida |
|---:|---|---|---|---|
| [1](explicaciones.md#s01) | GitHub y Markdown | Repositorio, README, enlaces, commit y push; reto y modalidades | Crear GitHub primero, publicar documentacion inicial y compartir URL | README, ficha, bitacora, memoria iniciada y primer commit accesibles al profesor |
| [2](explicaciones.md#s02) | Inventario investigado | Puedo instalarlo, que limitaciones tendre y que componentes son criticos | Investigar, citar fuentes, calcular recursos y justificar las tres respuestas | `01-inventario-hardware.md` con respuestas, evidencias, prioridades y dictamen |
| [3](explicaciones.md#s03) | Requisitos | Revisar el dictamen; necesidad, alcance, exclusiones y riesgos | Primeros 20 minutos: corregir y defender viabilidad; despues fijar requisitos | Inventario revisado, alcance validado y riesgos iniciales |
| [4](explicaciones.md#s04) | Red | Bridges, direccionamiento, gateway, DNS y aislamiento | Disenar tabla IP y primer diagrama | `02-diagrama-red.md` iniciado |
| [5](explicaciones.md#s05) | Recursos | Dimensionamiento de VMs/LXC, almacenamiento y cuotas | Definir CPU, RAM, disco y red de cada maquina | Tabla de recursos |
| [6](explicaciones.md#s06) | Diseno final | Revision del diseno antes de instalar | Corregir diagrama, plan de instalacion y checklist | Hito de diseno aprobado |
| [7](explicaciones.md#s07) | Instalacion | Instalacion Proxmox fisica o virtualizada | Instalar Proxmox en el entorno asignado | Capturas de instalacion |
| [8](explicaciones.md#s08) | Red del nodo | IP de gestion, hostname, repositorios y actualizacion | Configurar red base y actualizar nodo | `pveversion`, red y acceso web |
| [9](explicaciones.md#s09) | Validacion nodo | Errores tipicos de instalacion, DNS, gateway y acceso | Resolver incidencias y documentar nodo operativo | `03-instalacion-proxmox.md` completo |
| [10](explicaciones.md#s10) | Almacenamiento | Storages, ISOs, backups y plantillas | Configurar almacenamiento y subir/seleccionar ISO | Capturas de storage |
| [11](explicaciones.md#s11) | Seguridad base | Usuarios, permisos, firewall y acceso remoto | Aplicar controles minimos autorizados | Tabla de usuarios/permisos |
| [12](explicaciones.md#s12) | Hito Proxmox | Revision tecnica de nodo, red y almacenamiento | Completar documentacion de administracion base | Hito Proxmox validado |
| [13](explicaciones.md#s13) | Plantilla I | VM/CT base, paquetes minimos y actualizaciones | Crear sistema Linux base | `04-plantilla-linux.md` iniciado |
| [14](explicaciones.md#s14) | Plantilla II | SSH, usuario sudo, qemu agent/cloud-init si procede | Preparar acceso y configuracion comun | Prueba SSH y paquetes instalados |
| [15](explicaciones.md#s15) | Plantilla III | Limpieza, conversion a plantilla y clonado | Convertir en plantilla y crear clon de prueba | Evidencia de template |
| [16](explicaciones.md#s16) | Validacion plantilla | Criterios de plantilla reutilizable | Corregir plantilla y documentar procedimiento | Plantilla validada |
| [17](explicaciones.md#s17) | VM/LXC servidor | Despliegue de `srv-aso` desde plantilla | Crear servidor ASO con IP y hostname | Maquina `srv-aso` operativa |
| [18](explicaciones.md#s18) | VM/LXC cliente | Despliegue de `cli-linux` desde plantilla | Crear cliente de pruebas | Maquina `cli-linux` operativa |
| [19](explicaciones.md#s19) | Conectividad | Pruebas `ping`, `ssh`, rutas, DNS o `/etc/hosts` | Validar comunicacion cliente-servidor | Pruebas de red |
| [20](explicaciones.md#s20) | Inventario maquinas | Recursos, limites y documentacion Proxmox | Completar tabla de VMs/LXC | `05-vms-lxc.md` completo |
| [21](explicaciones.md#s21) | Servicio ASO I | Eleccion del servicio; ejemplo recomendado Samba/ACL | Instalar paquetes del servicio elegido | Servicio instalado |
| [22](explicaciones.md#s22) | Servicio ASO II | Usuarios, grupos, permisos POSIX y ACL | Crear usuarios, grupos y directorios | Evidencia de permisos |
| [23](explicaciones.md#s23) | Servicio ASO III | Configuracion del servicio y systemd | Configurar servicio y reiniciar de forma controlada | Configuracion y `systemctl status` |
| [24](explicaciones.md#s24) | Servicio ASO IV | Pruebas desde cliente y lectura de logs | Probar acceso correcto y denegado | `06-servicio-aso.md` completo |
| [25](explicaciones.md#s25) | Hardening servicio | Puertos, permisos, actualizaciones y logs | Aplicar mejoras basicas y registrar cambios | Informe breve de hardening |
| [26](explicaciones.md#s26) | Bash | Scripts de inventario y copia; variables y errores | Crear `inventario.sh` y `backup_servicio.sh` | Scripts Bash ejecutados |
| [27](explicaciones.md#s27) | Ansible I | Inventario, conexion SSH y estructura de playbook | Crear `inventory.ini` y primer `playbook.yml` | Ping Ansible correcto |
| [28](explicaciones.md#s28) | Ansible II | Instalacion, configuracion, servicios y validacion | Automatizar parte del servicio ASO | Playbook ejecutado correctamente |
| [29](explicaciones.md#s29) | Backup | Snapshots, backups Proxmox y copia de servicio | Crear copia antes de cambio controlado | Backup documentado |
| [30](explicaciones.md#s30) | Restauracion | Procedimiento de recuperacion y RTO | Simular fallo, restaurar y probar servicio | Restauracion demostrada |
| [31](explicaciones.md#s31) | Rendimiento | CPU, RAM, disco, red y lectura de metricas | Ejecutar pruebas y comentar resultados | `09-rendimiento-seguridad.md` iniciado |
| [32](explicaciones.md#s32) | Seguridad | Puertos, firewall, usuarios, permisos y logs | Ejecutar pruebas dentro del laboratorio autorizado | Informe de seguridad |
| [33](explicaciones.md#s33) | Cierre | Preparacion de defensa y demo final | Completar memoria, anexos y presentacion | Memoria final y demo preparada |

## 3. Hora final de cierre

La hora restante hasta completar las 100 horas se reserva para alguna de
estas acciones, segun calendario del centro:

- Revision individual de evidencias.
- Defensa breve de recuperacion.
- Correccion de una incidencia bloqueante.
- Registro final de evaluacion.
- Entrega formal de memoria y anexos.

## 4. Evidencias por hito

| Hito | Sesiones | Evidencia minima |
|---|---|---|
| H0. Inicio | 1 | GitHub creado como primera actividad; URL, README, ficha, bitacora, memoria iniciada y primer commit |
| H1. Analisis | 2-3 | Tres respuestas justificadas: instalacion viable, limitaciones y componentes criticos; fuentes, calculos, necesidad, alcance y riesgos |
| H2. Diseno | 4-6 | Diagrama, direccionamiento y recursos |
| H3. Nodo Proxmox | 7-12 | Nodo instalado, red, storage, usuarios y acceso |
| H4. Plantilla | 13-16 | Plantilla Linux reutilizable y clon probado |
| H5. VMs/LXC | 17-20 | Servidor y cliente desplegados con conectividad |
| H6. Servicio ASO | 21-25 | Servicio funcional, probado y con logs |
| H7. Automatizacion | 26-28 | Scripts Bash y playbook Ansible obligatorios |
| H8. Continuidad | 29-30 | Backup y restauracion demostrada |
| H9. Validacion | 31-32 | Pruebas de rendimiento y seguridad |
| H10. Cierre | 33 + 1 h | Memoria, demo y defensa |

## 5. Criterio de cierre de cada clase

Al terminar cada sesion, el alumno debe poder mostrar:

1. Que ha cambiado en su entorno.
2. Que comando, configuracion o procedimiento lo demuestra.
3. En que documento Markdown y commit publicado en GitHub esta la evidencia.
4. Que incidencia queda pendiente, si existe.

Si una tarea no ha podido completarse por una causa tecnica real, se
documentara la incidencia y se indicara el plan de recuperacion en la
bitacora.

La distribucion de los 180 minutos de la primera clase y las instrucciones
paso a paso estan en
[Primera sesion: GitHub y Markdown](../proyecto/primera-sesion.md).
