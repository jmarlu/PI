# Ansible: modelo y fundamentos

## Qué problema resuelve

Configurar una máquina a mano puede resolver una necesidad inmediata, pero
resulta difícil demostrar qué pasos se repitieron, cuáles faltan y cómo
reconstruir el resultado. Ansible permite expresar configuración como código,
aplicarla a destinos definidos y registrar sus resultados.

En este proyecto **Ansible y Bash son obligatorios**. El playbook debe configurar
una parte útil del servicio en `srv-aso`. Los dos scripts aportan procedimientos
como inventario y copia. No se sustituyen entre sí.

## Estado deseado frente a secuencia de órdenes

Un procedimiento imperativo describe acciones: “ejecuta este comando y después
este otro”. Una tarea declarativa expresa una condición: “este directorio debe
existir con este modo”.

Ejemplo didáctico de tarea dentro de un playbook:

~~~yaml
- name: Mantener el directorio de salida del ejercicio
  ansible.builtin.file:
    path: "{{ playbook_dir }}/salida"
    state: directory
    mode: "0700"
~~~

La tarea compara lo existente con lo solicitado y aplica lo necesario. El nombre
explica la intención; el módulo realiza la operación; sus argumentos definen
el estado. El [modelo de playbooks](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html)
describe cómo organizar estas tareas.

Ansible también ejecuta comandos imperativos. Usarlo no vuelve declarativo o
idempotente cualquier comando que escribas.

## Idempotencia, convergencia y deriva

**Idempotencia:** reaplicar una configuración ya satisfecha no introduce cambios
innecesarios. **Convergencia:** aproximar el sistema al estado declarado.
**Deriva de configuración:** diferencia entre ese estado y el real, por ejemplo
porque alguien modificó un archivo manualmente.

Ejemplo original del curso:

| Momento | Estado real | Resultado esperado |
|---|---|---|
| Antes de ejecutar | El informe no existe | Se crea |
| Segunda ejecución sin cambios | Coincide con la plantilla | `changed=0` |
| Edición manual del informe | Ya no coincide | Ansible lo corrige |
| Cambio de la variable fuente | La configuración deseada es otra | Se actualiza de forma justificada |

`changed=0` por sí solo no demuestra que el servicio funcione. Podrías haber
seleccionado un host equivocado o no haber descrito una parte importante de la
configuración. Necesitas pruebas de aceptación independientes.

Tampoco debes imponer `changed_when: false` a una tarea que modifica datos
para conseguir una captura “verde”: ocultaría información real.

## Controlador, destinos y transporte

El **controlador** ejecuta `ansible-playbook`, lee el inventario y carga módulos.
Los **nodos gestionados** reciben las operaciones. Para Linux se utiliza
habitualmente SSH y Python compatible; no se instala un agente Ansible
permanente en cada destino.
[Requisitos de instalación](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html).

En este curso el controlador puede ser el equipo de administración o un
`cli-linux` compatible y autorizado. No lo instalamos en el nodo Proxmox para
administrar el servicio. El destino es `srv-aso`, no la VM externa de VirtualBox.

El [laboratorio inicial](laboratorio.md) usa `connection: local` y solo escribe
en su carpeta de salida. Sirve para entender la herramienta; **no cumple por
sí solo la automatización remota exigida en el proyecto**.

## Vocabulario de una ejecución

| Elemento | Función |
|---|---|
| Inventario | Identifica hosts y grupos, con variables asociadas |
| Play | Selecciona hosts y organiza una aplicación de tareas |
| Playbook | Documento YAML con uno o más plays |
| Tarea | Invoca un módulo con parámetros y controles |
| Módulo | Implementa una operación concreta |
| Plugin | Amplía aspectos como conexión, inventario o salida |
| Handler | Tarea diferida que responde a una notificación de cambio |
| Colección | Distribución con nombres de módulos, plugins, roles u otros recursos |

`ansible.builtin.file` es un nombre completo: espacio de nombres, colección
y módulo. Usarlo reduce ambigüedades frente a módulos de igual nombre.

## Qué leer en el resumen

- `ok`: tareas procesadas correctamente; puede incluir tareas que también cambiaron.
- `changed`: tareas que notificaron modificación.
- `unreachable`: no se pudo establecer la comunicación necesaria.
- `failed`: una tarea falló durante la ejecución.
- `skipped`: una condición o un modo evitó ejecutarla.
- `rescued` y `ignored`: hubo tratamiento o ignorado de fallos; debes revisarlos.

No sumes `ok` y `changed` como si fueran categorías excluyentes.
Un playbook terminado necesita comprobar destinos, tareas y resultado funcional.

## Preguntas para explicar en clase

1. ¿Por qué “el comando terminó” no equivale a “el estado está bien definido”?
2. ¿Qué diferencia hay entre corregir deriva y ocultar cambios?
3. ¿Dónde ejecutas Ansible y sobre qué máquina actúa en tu montaje?
4. ¿Cómo probarías un playbook que siempre devuelve `changed=0`?

Continúa con [inventario y conexión](inventario-conexion.md).

