# Playbooks, módulos, handlers y errores

## Estructura y orden

Un playbook es una lista de plays. Cada play selecciona hosts y define tareas.
En el modelo habitual las tareas se aplican en orden sobre los destinos
seleccionados; la ejecución entre hosts depende de la estrategia y paralelismo.

~~~yaml
---
- name: Preparar archivos del ejercicio local
  hosts: laboratorio
  gather_facts: false
  become: false
  tasks:
    - name: Mantener directorio privado
      ansible.builtin.file:
        path: "{{ playbook_dir }}/salida"
        state: directory
        mode: "0700"
~~~

Este ejemplo necesita un inventario con grupo `laboratorio` y conexión local.
El [laboratorio completo](laboratorio.md) aporta ambos. Un fragmento de tareas
no se puede ejecutar como playbook completo sin su contexto.

## Elegir módulos por su contrato

| Necesidad | Módulo habitual | Qué debes decidir |
|---|---|---|
| Directorio o atributos de archivo | `ansible.builtin.file` | Estado, ruta y modo |
| Archivo estático | `ansible.builtin.copy` | Fuente, destino y permisos |
| Archivo con variables | `ansible.builtin.template` | Plantilla y validación |
| Paquetes | `ansible.builtin.apt` o gestor apropiado | Plataforma y política de versiones |
| Estado de servicio | `ansible.builtin.service` | Arranque y estado deseado |
| Lectura de archivo | `ansible.builtin.slurp` | Tamaño y privacidad del contenido |
| Comprobar una condición | `ansible.builtin.assert` | Qué significa aceptar o rechazar |
| Ejecutar un programa | `ansible.builtin.command` | Argumentos y criterios de resultado |

Consulta `ansible-doc ansible.builtin.template` o el módulo elegido en la
[colección builtin](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/index.html).
El nombre no basta: revisa parámetros, requisitos, soporte de check mode y
valores devueltos.

`shell` interpreta sintaxis de shell; `command` no lo hace. No uses `shell`
por costumbre ni construyas comandos concatenando entradas sin validar.
Cuando existe un módulo de estado, suele expresar mejor la intención.

## Bucles y condiciones

Un bucle evita duplicar la misma tarea para una lista de objetos. Una condición
controla en qué caso tiene sentido ejecutarla:

~~~yaml
- name: Revisar los tamaños previstos
  ansible.builtin.assert:
    that:
      - item.ram_mib is integer
      - item.ram_mib > 0
  loop: "{{ invitados }}"
  loop_control:
    label: "{{ item.nombre }}"
~~~

`when:` no corrige una plataforma incompatible: debes definir qué haces si
la condición no se cumple. Una tarea omitida puede ser correcta o revelar una
configuración incompleta.
[Bucles](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_loops.html)
y [condiciones](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_conditionals.html).

## Register y semántica de resultado

`register` conserva la estructura de resultado de una tarea. No todos los módulos
devuelven `stdout` o `rc`. Por ejemplo, `slurp` entrega contenido codificado y
metadatos; hay que consultar su contrato antes de interpretar la respuesta.

En tareas `command` de diagnóstico puede tener sentido `changed_when: false`,
porque leer un estado no modifica la configuración. Una tarea de reparación no
debe ocultar su cambio. `failed_when` define condiciones reales de fallo;
no debe convertirse en una forma de silenciar cualquier error.

## Handlers: reaccionar a cambios

Una tarea que cambia puede notificar un handler. Varias notificaciones al mismo
handler suelen agruparse para ejecutarlo una vez en el punto correspondiente,
por ejemplo al terminar las tareas del play. Si nada lo notifica, no se ejecuta.
[Funcionamiento de handlers](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_handlers.html).

Ejemplo didáctico, sin reiniciar servicios:

~~~yaml
tasks:
  - name: Renderizar el informe
    ansible.builtin.template:
      src: informe.md.j2
      dest: "{{ playbook_dir }}/salida/informe.md"
      mode: "0600"
    notify: Informar de la actualizacion

handlers:
  - name: Informar de la actualizacion
    ansible.builtin.debug:
      msg: "Se ha actualizado el informe del laboratorio"
~~~

En un servicio real, la notificación puede solicitar una recarga o reinicio.
Si después necesitas probar la nueva configuración, el handler debe haberse
ejecutado antes de esa prueba. `meta: flush_handlers` permite forzar ese punto;
úsalo de forma deliberada, no en cada tarea.

## Errores: Ansible no es una transacción

Si la tarea cuarta falla, las tres primeras pueden haber cambiado el sistema.
No se deshacen automáticamente. Diseña validación previa, copias, operaciones
idempotentes y un procedimiento de recuperación.

`block`, `rescue` y `always` permiten agrupar operaciones, tratar ciertos
fallos y ejecutar acciones finales. No capturan todas las clases de error:
un problema de sintaxis o un host inalcanzable no se maneja igual que una
tarea fallida.
[Tratamiento de errores](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_error_handling.html).

Un `ignore_errors: true` generalizado puede dejar un resumen aparentemente
aceptable y un servicio a medias. Explica cualquier error ignorado, condición
de recuperación y prueba posterior.

## Ejercicio de lectura

Predice qué sucede en cuatro ejecuciones: primera instalación, repetición sin
cambios, modificación de una variable y error de validación. Para cada una
indica tareas cambiadas, handler esperado y estado final.

Compruébalo con el [laboratorio](laboratorio.md). Continúa con
[organización y validación](organizacion-validacion.md).

