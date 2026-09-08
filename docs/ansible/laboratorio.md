# Laboratorio Ansible: configurar, repetir y corregir

## Alcance

Este ejercicio trabaja **solo en el controlador Linux**, con conexión local,
sin sudo, sin servicios y sin conexión a Proxmox. Genera un informe Markdown a
partir de variables que describen un diseño de nodo e invitados.

No instala VMs, no mide hardware y no cumple por sí solo la automatización
remota del servicio ASO. Su finalidad es que observes variables, plantillas,
validaciones, notificaciones e idempotencia antes de actuar sobre `srv-aso`.

## 1. Preparar Ansible

Necesitas Python compatible, entorno virtual y acceso a los paquetes. El
material se comprueba con `ansible-core 2.21.3`, que requiere Python 3.12 o
posterior dentro de sus versiones admitidas en el controlador. Contrasta la
[matriz de soporte](https://docs.ansible.com/projects/ansible-core/devel/reference_appendices/release_and_maintenance.html)
si utilizas otra combinación.

En un equipo Debian/Ubuntu/LliureX compatible y autorizado, si faltan los
requisitos:

~~~bash
python3 --version
sudo apt install python3-venv openssh-client
python3 -m venv ~/.venvs/pi-ansible
~/.venvs/pi-ansible/bin/python -m pip install ansible-core==2.21.3
source ~/.venvs/pi-ansible/bin/activate
ansible --version
~~~

No reemplaces el Python del sistema para adaptar el ejercicio. Si la versión
del equipo no es compatible, utiliza un `cli-linux` autorizado compatible o
acuerda una versión soportada y documenta la diferencia.

## 2. Examinar los archivos

Descarga [ansible-laboratorio.zip](../recursos/archivos/ansible-laboratorio.zip),
extráelo en una carpeta nueva de tu usuario y entra en `ansible-laboratorio`:

~~~text
ansible-laboratorio/
  inventory.yml
  variables.yml
  playbook.yml
  templates/informe.md.j2
  .gitignore
~~~

El playbook escribirá únicamente en su subcarpeta `salida/`. Utiliza una
extracción nueva, sin enlaces simbólicos ni archivos propios en esa ubicación.
No ejecutes el ejercicio con sudo.

Lee antes `variables.yml`. Sus tamaños son un **diseño de ejemplo**, no valores
medidos ni requisitos oficiales. El inventario contiene solo `localhost` con
conexión local y selecciona el Python que ejecuta el playbook.

## 3. Predecir y validar

Desde esa carpeta, con el entorno virtual activo:

~~~bash
ansible-inventory -i inventory.yml --graph
ansible-playbook -i inventory.yml playbook.yml --list-hosts
ansible-playbook -i inventory.yml playbook.yml --syntax-check
ansible-playbook -i inventory.yml playbook.yml --check --diff
~~~

Predice qué tareas crearían archivos. Durante check mode no se valida el
contenido de un informe todavía inexistente: las tareas de lectura se omiten.
Comprueba que `salida/` no se ha creado solo por esa simulación.

## 4. Primera y segunda ejecución

~~~bash
ansible-playbook -i inventory.yml playbook.yml
ansible-playbook -i inventory.yml playbook.yml
~~~

En una extracción nueva la primera debe crear directorio e informe.
El handler anuncia la actualización. La segunda debe terminar sin fallos y
con `changed=0`; no debe volver a ejecutar el handler.

Abre `salida/informe.md`. Compara nombres, fase y tamaños con `variables.yml`.
La tarea `slurp` lo lee y las aserciones comprueban su contenido. No conviertas
el texto generado en una evidencia de hardware real.

## 5. Cambiar el estado deseado

Edita `variables.yml` y cambia `fase: inventario` por `fase: despliegue`.
Guarda y repite el playbook. El informe debe cambiar y la siguiente ejecución
volver a `changed=0`.

Explica por qué esta modificación es legítima y no un defecto de idempotencia.
En Git versionarías la variable o la plantilla que expresa la decisión, no
necesariamente el resultado regenerable.

## 6. Reparar una desviación

Con tu editor, cambia únicamente en `salida/informe.md` la línea de fase por
`Fase: cambio-manual`. No toques los archivos fuente.

Ejecuta otra vez. Ansible debe restaurar la fase declarada en las variables,
notificar el handler y superar las validaciones. Repite para confirmar ausencia
de cambios adicionales.

Esta prueba actúa sobre un informe desechable. No la traslades a archivos reales
del servicio sin una prueba autorizada y una copia previa.

## 7. Rechazar una entrada inválida

Modifica temporalmente `reserva_nodo_mib` a `999999` en `variables.yml`.
La suma ya no cabe en el nodo declarado. El playbook debe fallar con un mensaje
de presupuesto antes de renderizar un nuevo informe.

Devuelve la reserva a su valor válido y comprueba que vuelve a funcionar.
Un error esperado y explicado es una evidencia positiva de validación, no una
captura que haya que ocultar.

## Registro de resultados

Incorpora una tabla breve en tu documento existente de automatización:

| Ensayo | Predicción | Resultado observado | Conclusión |
|---|---|---|---|
| Primera ejecución | Crea salida | Completar con tu resultado | Estado inicial |
| Repetición | Sin cambios | Completar | Idempotencia |
| Cambio de variable | Actualiza informe | Completar | Cambio deseado |
| Deriva manual | Corrige informe | Completar | Convergencia |
| Presupuesto inválido | Falla antes de escribir | Completar | Validación |

No copies esta tabla como si ya hubieses ejecutado las pruebas.

## Trasladarlo al servicio ASO

En el proyecto el inventario pasa de localhost al servidor propio y las tareas
deben describir configuración útil del servicio aprobado. Conserva el mismo
método: alcance explícito, parámetros, validación, cambios justificables y prueba
desde el cliente.

Consulta los [requisitos de Bash y Ansible](../proyecto/automatizacion.md).
Los roles son una posibilidad de organización, no un requisito nuevo impuesto
por este laboratorio.

