# Fase 8. Automatización con Bash y Ansible

[Guía de la práctica](practica.md) · **Al terminar:** dos scripts y un playbook ejecutados.

**Sesiones de clase:** 26–28. Consulta el [calendario](../clases/index.md).

Automatiza parte del montaje con Bash y con Ansible. Las dos herramientas
son obligatorias: explica qué tarea resuelve cada una y comprueba el resultado.

Documenta las ejecuciones en `docs/07-automatizacion.md`. La
[guía de entrega de automatización](automatizacion.md) te ayuda a revisar
errores, secretos y pruebas antes de cerrar esta fase.

## Mínimo con Bash

Crea al menos dos scripts:

| Script | Función |
|---|---|
| `scripts/inventario.sh` | Recoge CPU, RAM, disco, red y versión del sistema |
| `scripts/backup_servicio.sh` | Copia datos y configuración del servicio ASO |

Requisitos de los scripts:

- Cabecera con autor, fecha y función.
- Uso de variables.
- Comprobación de errores básica.
- Salida clara por pantalla.
- Permisos correctos, por ejemplo `chmod 750`.
- Ejecución demostrada.

## Mínimo con Ansible

Entrega obligatoriamente:

- `ansible/inventory.ini`.
- `ansible/playbook.yml`.
- Tareas para instalar paquetes, copiar configuración, crear usuarios o
  directorios, arrancar servicios y validar estado.
- Ejecución contra `srv-aso` desde tu equipo de administración, `cli-linux`
  o el entorno autorizado por el profesor.

## Qué guardar en tu repositorio

- Código de los scripts y del playbook.
- Captura de ejecución de Bash y de Ansible.
- Explicación de qué parte automatiza cada herramienta.
- Comprobación posterior del estado del sistema.

---

[Anterior](fase-7-servicio.md) · [Fase 9: Copias y restauración](fase-9-copias.md)
