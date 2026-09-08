# Organización, secretos y validación

## Estructura proporcional al proyecto

Un playbook pequeño puede permanecer en un archivo. Divide cuando la separación
permita entender, reutilizar o probar mejor una responsabilidad, no para llenar
carpetas vacías.

~~~text
ansible/
  inventory.ini
  playbook.yml
  requirements.yml
  group_vars/
    srv_aso.yml
  templates/
    configuracion.j2
  roles/
    servicio/
      defaults/main.yml
      tasks/main.yml
      handlers/main.yml
      templates/configuracion.j2
~~~

Es un ejemplo de posibilidades, **no una exigencia de tener todas las carpetas
ni de duplicar la misma plantilla en dos lugares**. Si pasas a un rol, traslada
allí su responsabilidad y conserva una única fuente.

Un rol agrupa tareas y recursos bajo una estructura reconocible. `defaults`
ofrece valores fáciles de sustituir; `vars` tiene otra prioridad y no debe
usarse indiscriminadamente para parámetros que el usuario necesita ajustar.
[Roles de Ansible](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_reuse_roles.html).

## Colecciones y versiones reproducibles

`ansible-core` aporta el motor y módulos builtin. El paquete `ansible` incluye
además una selección de colecciones. Un módulo de otra colección puede no
estar instalado aunque `ansible-playbook` funcione.

Declara las colecciones necesarias en `requirements.yml` y usa nombres completos.
No instales una colección cualquiera con un módulo del mismo nombre.
[Uso de colecciones](https://docs.ansible.com/projects/ansible/latest/collections_guide/collections_installing.html).

~~~bash
ansible --version
ansible-galaxy collection list
ansible-galaxy collection install -r requirements.yml
~~~

La última orden solo corresponde cuando tu ejemplo tiene ese archivo.
El laboratorio introductorio utiliza únicamente builtin y no necesita
colecciones adicionales. El ejemplo práctico de Samba declara sus propios
requisitos.

Registra versión de Python, core, colecciones y distribución destino.
Una actualización puede cambiar requisitos o comportamiento; no actualices
todo justo antes de la defensa sin volver a ejecutar las pruebas.

## Secretos y exposición indirecta

No publiques claves privadas, contraseñas ni tokens, tampoco en capturas,
inventarios, archivos de variables o historial Git.

Vault cifra datos en reposo para poder manejarlos de forma controlada. Su
contraseña no debe acompañar al archivo cifrado. Vault no evita por sí solo
que una tarea muestre el secreto ya descifrado.
[Ansible Vault](https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html).

`no_log: true` limita información registrada de una tarea, pero no protege
automáticamente otras tareas, salidas de depuración o archivos producidos.
`--diff` puede mostrar configuración sensible; úsalo solo con datos revisados
y desactiva diferencias en tareas que lo requieran.

Si publicas un secreto, revócalo o rótalo y avisa: borrar el archivo de la última
versión no lo elimina del historial ni de copias ya realizadas.

## Capas de validación

| Capa | Qué comprueba | Qué no demuestra |
|---|---|---|
| `--syntax-check` | Estructura interpretable y parte de las referencias | Acceso al servidor o comportamiento completo |
| `--list-hosts` | Selección de destinos | Conectividad |
| `ansible.builtin.ping` | Conexión y ejecución básica compatibles | Funcionamiento del servicio |
| `--check` | Predicción de módulos que lo soportan | Ejecución real completa |
| `--diff` | Diferencias que los módulos exponen | Ausencia de riesgos |
| Ejecución real | Aplicación de tareas | Aceptación funcional por el cliente |
| Segunda ejecución | Cambios repetidos y estabilidad | Cobertura de configuración no descrita |
| Prueba funcional | Resultado del servicio | Recuperación desde una copia |

## Limitaciones del modo check

Check mode no es una VM desechable ni una transacción. Hay módulos sin soporte
completo; resultados registrados pueden diferir o faltar; y una tarea que
necesita un archivo creado anteriormente puede no encontrarlo porque esa
creación solo fue simulada.
[Check y diff](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_checkmode.html).

Una tarea marcada `check_mode: false` puede ejecutarse realmente durante
`--check`. Revisa el código antes de confiar en ese indicador como garantía
de no modificación.

El laboratorio omite la lectura del informe en check mode precisamente porque
podría no existir todavía. Esa omisión debe documentarse; no demuestra que
el contenido haya sido validado.

## Estrategia de pruebas para el proyecto

1. Revisa variables, destinos, permisos y copia previa.
2. Comprueba sintaxis e inventario.
3. Ensaya check/diff cuando corresponda, sin publicar secretos.
4. Ejecuta sobre el `srv-aso` autorizado.
5. Repite sin cambiar las entradas y explica el resumen.
6. Comprueba el servicio desde `cli-linux`.
7. Introduce una desviación inocua autorizada y demuestra su corrección.
8. Verifica que una entrada inválida falla de forma comprensible.

No provoques deriva sobre datos reales del servicio ni borres configuración
para simular un desastre sin copia. El laboratorio local ofrece un lugar
acotado para aprender primero.

Las etiquetas `tags` y `--limit` ayudan a acotar ensayos, pero saltarse tareas
previas puede invalidarlos. Anota exactamente qué selección utilizaste.
[Etiquetas](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_tags.html).

## Evidencias que permiten reproducir

En `docs/07-automatizacion.md` enlaza código y commit, versiones, inventario
anonimizado cuando corresponda, órdenes ejecutadas, resumen de dos ejecuciones,
prueba funcional, cambios repetidos y límites. Una captura sin comando ni
destino no permite explicar qué se hizo.

Continúa con el [laboratorio guiado](laboratorio.md) y la
[integración obligatoria con Bash y el servicio](../proyecto/automatizacion.md).

