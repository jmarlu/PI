# Ansible: modelo y fundamentos

## Qué problema resuelve

Cuando configuras un servidor a mano, necesitas anotar los pasos para poder repetirlos en otro equipo o recuperar el sistema. Con Ansible puedes describir esa configuración en archivos de texto y aplicarla a las máquinas de tu inventario. El resultado de la ejecución permite revisar qué tareas se han realizado y cuáles han fallado.

En este proyecto **Ansible y Bash son obligatorios**. El playbook debe configurar
una parte útil del servicio en `srv-aso`. Los dos scripts aportan procedimientos
como inventario y copia. No se sustituyen entre sí.

## Estado deseado frente a secuencia de órdenes

Puedes indicar una acción, como «ejecuta este comando», o describir el resultado que quieres, como «este directorio debe existir y tener estos permisos». La primera forma se llama **imperativa** y la segunda, **declarativa**. Muchos módulos de Ansible trabajan con la segunda: comprueban cómo está el recurso y lo ajustan a lo solicitado.

Ejemplo didáctico de tarea dentro de un playbook:

~~~yaml
- name: Mantener el directorio de salida del ejercicio
  ansible.builtin.file:
    path: "{{ playbook_dir }}/salida"
    state: directory
    mode: "0700"
~~~

En este ejemplo, `name` describe la tarea. El módulo `ansible.builtin.file` comprueba el directorio, y las opciones `path`, `state` y `mode` indican dónde debe estar, qué tipo de objeto se necesita y sus permisos. El módulo hace los cambios necesarios para cumplir esas condiciones. Consulta el [modelo de playbooks](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html) para ver cómo se agrupan las tareas.

Ansible también ejecuta comandos imperativos. Usarlo no vuelve declarativo o
idempotente cualquier comando que escribas.

## Idempotencia, convergencia y deriva

Una tarea es **idempotente** cuando, una vez conseguido el resultado, volver a ejecutarla no añade cambios innecesarios. Por ejemplo, si el directorio ya existe con los permisos previstos, no hace falta volver a crearlo.

La **convergencia** consiste en llevar la configuración real al estado descrito en el playbook. Si alguien modifica a mano un archivo que Ansible administra, aparece una **deriva de configuración**: el archivo ya no coincide con lo previsto. La siguiente ejecución puede corregir esa diferencia.

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

Utiliza `changed_when` para describir lo que realmente hace una tarea. Si una tarea modifica datos y le asignas `changed_when: false` solo para que el resumen no muestre cambios, estarás ocultando el resultado en lugar de comprobar la idempotencia.

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

Una tarea puede contarse en `ok` y también en `changed`, por lo que no debes sumar ambas cifras como si fueran grupos separados. Después de leer el resumen, comprueba que las tareas se aplicaron a los destinos previstos y prueba el servicio.

## Preguntas para explicar en clase

1. ¿Por qué “el comando terminó” no equivale a “el estado está bien definido”?
2. ¿Qué diferencia hay entre corregir deriva y ocultar cambios?
3. ¿Dónde ejecutas Ansible y sobre qué máquina actúa en tu montaje?
4. ¿Cómo probarías un playbook que siempre devuelve `changed=0`?

Continúa con [inventario y conexión](inventario-conexion.md).

