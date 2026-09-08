# Entrega de automatización: Bash y Ansible

Esta página reúne las comprobaciones de entrega, no un tema de administración
Linux. La [fase 8 de la práctica](practica.md#14-fase-8-automatizacion) conserva
los requisitos: **dos scripts Bash y un playbook Ansible**, ejecutados y explicados.

## Dos scripts propios adaptados

Debes entregar inventario y copia del servicio, partiendo de la plantilla si
lo necesitas. Identifica autor, propósito, lugar de ejecución, variables de
entrada, dependencias, salida y códigos de error.

~~~bash
bash -n scripts/inventario.sh
bash -n scripts/backup_servicio.sh
~~~

Adapta las rutas a los nombres reales de tus scripts. Una sintaxis correcta no
demuestra que el inventario sea completo ni que la copia sea recuperable.

Comprueba en un entorno de prueba:

- Caso correcto y un caso de error real.
- Fallo explícito si no existe un origen obligatorio o una dependencia.
- Destino controlado, que no quede dentro del origen ni lo resuelva por un enlace.
- Copias diferenciadas sin sobrescribir versiones previas.
- Datos, configuración y metadatos necesarios incluidos según tu servicio.
- Sin mensaje de éxito ni registro completo cuando la operación falla.

Si el destino debe ser otro dispositivo, verifica que esté montado antes:
la existencia de un directorio no demuestra que corresponda al disco externo.
Conserva los resultados y enlázalos desde la memoria.

## Playbook remoto obligatorio

El [laboratorio local](../ansible/laboratorio.md) prepara la técnica, pero tu
entrega debe actuar sobre `srv-aso` y configurar una parte útil del servicio
aprobado. No basta con mostrar un mensaje o ejecutar solamente `ping`.

Elige tareas con un alcance coherente: dependencias, directorios/cuentas
necesarios, configuración mediante plantilla, estado del servicio y validación.
Declara las partes que siguen siendo manuales y sus razones. No publiques
credenciales para conseguir una ejecución desatendida.

Recorrido recomendado:

1. Estudia [fundamentos](../ansible/fundamentos.md) y revisa el inventario.
2. Verifica SSH, identidad del destino y privilegios.
3. Comprueba dependencias, sintaxis y hosts seleccionados.
4. Ensaya check/diff con sus limitaciones y sin mostrar secretos.
5. Ejecuta dos veces sobre el servidor autorizado.
6. Explica cambios e idempotencia.
7. Repite la prueba funcional desde `cli-linux`.

## Ejemplo práctico de servicio

Se mantiene el [ejemplo descargable de Ansible para Samba](../recursos/archivos/ansible-samba.zip)
como apoyo a quien haya elegido ese servicio en la práctica. No es un tema
teórico de Samba ni una solución que puedas entregar sin adaptar.

**Revisa el código antes de ejecutarlo:** reemplaza la configuración de Samba
del servidor de laboratorio. Utilízalo solo en tu `srv-aso` aprobado, con copia
previa. No administra las contraseñas del servicio; esa parte es manual y debe
quedar fuera de Git.

El ejemplo requiere `ansible.posix` según su `requirements.yml`. Mantén
`templates/` junto al playbook y utiliza un controlador compatible según la
[preparación de Ansible](../ansible/laboratorio.md#1-preparar-ansible).

Desde la carpeta del ejemplo, después de adaptar el inventario:

~~~bash
ansible-galaxy collection install -r requirements.yml
ansible-inventory -i inventory.ini --graph
ansible-playbook -i inventory.ini playbook.yml --list-hosts
ansible-playbook -i inventory.ini playbook.yml --syntax-check
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
~~~

No apliques este playbook a un servicio diferente. Adapta las tareas al servicio
alternativo aprobado y declara sus propios requisitos.

## Qué debe verse en GitHub

Código revisado, versiones y dependencias, órdenes utilizadas, evidencia de
ejecución de ambos scripts y del playbook, comparación de dos ejecuciones,
prueba funcional, incidencias y limitaciones. Usa `docs/07-automatizacion.md`,
sin añadir otra memoria paralela.

Las copias binarias, discos virtuales, claves y contraseñas no se suben.
La recuperación se demuestra en la
[fase de copias y restauración](practica.md#15-fase-9-copias-y-restauracion).

