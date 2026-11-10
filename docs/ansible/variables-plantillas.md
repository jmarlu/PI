# YAML, variables, facts y plantillas

## YAML representa datos

La indentación forma parte de la estructura. Utiliza espacios y una convención
constante, por ejemplo dos espacios por nivel. Una lista comienza con `-`;
un diccionario relaciona claves y valores.

Ejemplo original de variables de laboratorio:

~~~yaml
fase: inventario
reserva_nodo_mib: 2048
nodo:
  nombre: pve-alumno
  ram_mib: 8192
invitados:
  - nombre: srv-aso
    ram_mib: 2048
  - nombre: cli-linux
    ram_mib: 1024
~~~

`invitados` es una lista de diccionarios; `ram_mib` es un número; `fase` es
texto. Especificar unidades en los nombres evita mezclar MiB y GiB. Usa
`true`/`false` para booleanos y comillas para modos como `"0700"`.
[Referencia YAML de Ansible](https://docs.ansible.com/projects/ansible/latest/reference_appendices/YAMLSyntax.html).

Una clave duplicada puede ocultar un valor previo. Un archivo que parece
alineado visualmente no está validado: ejecuta `--syntax-check`, recordando
que esa comprobación no verifica la conectividad ni el efecto de las tareas.

## Datos deseados, datos descubiertos y resultados

| Origen | Ejemplo | Qué representa |
|---|---|---|
| Variables del proyecto | RAM prevista o nombre del servicio | Una decisión de configuración |
| Facts | Distribución o arquitectura del destino | Información descubierta del sistema |
| `register` | Resultado de leer un archivo | Salida de una tarea de esta ejecución |

Distingue los valores que eliges de los que has medido. En el laboratorio local, tú escribes la RAM prevista en `variables.yml` y Ansible la utiliza para generar un informe del diseño. El ejercicio no consulta la API ni mide la RAM de un nodo real.

`gather_facts: true` recoge información mediante el mecanismo de facts.
Puedes acceder a `ansible_facts['os_family']`, si ese dato se ha recogido.
Con `gather_facts: false` no asumas que existen.
[Facts y variables descubiertas](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_vars_facts.html).

## Sustitución y tipos

Una expresión Jinja se escribe con `{{ ... }}`. Si ocupa el comienzo del valor
YAML, entrecomilla el valor completo:

~~~yaml
path: "{{ playbook_dir }}/salida"
~~~

En `when:` y en las condiciones de `assert:` se escribe directamente la expresión, sin envolverla de nuevo en `{{ ... }}`. Revisa también el tipo de cada dato: `2048` es un número y `"2048"` es texto. Si necesitas convertirlo, hazlo de forma explícita después de comprobar la entrada. Consulta las [variables y su precedencia](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html).

## Jinja separa configuración y valores

Ejemplo de una plantilla `informe.md.j2`:

~~~jinja
# Nodo {{ nodo.nombre }}

Fase: {{ fase }}
Memoria asignada al nodo: {{ nodo.ram_mib }} MiB

{% for invitado in invitados %}
- {{ invitado.nombre }}: {{ invitado.ram_mib }} MiB
{% endfor %}
~~~

El módulo `template` combina la plantilla con los valores de las variables en el controlador y envía el archivo resultante al destino. Guarda la plantilla `.j2` en Git: es el archivo que editas para definir el contenido. El archivo generado se puede volver a crear a partir de ella y de las variables. Consulta el [módulo template](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/template_module.html).

Si incluyes la hora actual o un número aleatorio en la plantilla, el archivo puede cambiar cada vez que ejecutes el playbook aunque la configuración sea la misma. Añádelos solo cuando sean necesarios. Para documentar cuándo hiciste una prueba, puedes registrar la fecha aparte.

## Validar antes de configurar

Una automatización debe rechazar entradas imposibles, no limitarse a
escribirlas:

~~~yaml
- name: Validar el presupuesto declarado
  ansible.builtin.assert:
    that:
      - nodo.ram_mib is integer
      - reserva_nodo_mib is integer
      - nodo.ram_mib >= (invitados | map(attribute='ram_mib') | sum) + reserva_nodo_mib
    fail_msg: "La RAM declarada no permite este reparto"
~~~

Es un fragmento para las variables anteriores; un proyecto completo debe
validar además la estructura y los valores de cada invitado antes de sumarlos.
La descarga didáctica incluye esas comprobaciones.
El [módulo assert](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/assert_module.html)
convierte condiciones de aceptación en tareas verificables.

No uses `default` para ocultar que falta un dato obligatorio. Un valor
predeterminado sirve cuando has definido expresamente ese comportamiento.

## Precedencia sin sorpresas

Las variables pueden venir del inventario, archivos, plays, roles o argumentos.
No hay que memorizar toda la tabla al principio, pero sí evitar definir el mismo
dato en cinco lugares.

Una organización sencilla:

- Valores habituales y sustituibles: defaults del rol, cuando exista.
- Diferencias entre destinos: inventario y `group_vars`/`host_vars`.
- Parámetros de una ejecución de ensayo: `--extra-vars`, registrados.
- Secretos: mecanismo protegido, nunca texto público en esas ubicaciones.

`--extra-vars` tiene prioridad alta en las variables y puede sobreescribir
decisiones importantes. Una prueba que funciona con un parámetro olvidado
no es reproducible para quien solo descarga el repositorio.

## Aplicación al proyecto

Separa tres valores hoy escritos dentro de tus tareas y conviértelos en
variables con nombres claros. Justifica cuál debe ser común y cuál específico
del host. Después demuestra que cambiar un valor legítimo modifica solo el
resultado esperado.

Continúa con [tareas, handlers y errores](playbooks.md).

