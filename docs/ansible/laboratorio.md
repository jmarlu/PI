# Laboratorio Ansible: configurar, repetir y corregir

## Alcance

En este ejercicio ejecutarás Ansible **solo en tu equipo Linux**, con conexión local y sin sudo. El playbook leerá unas variables con un diseño de laboratorio y generará un informe Markdown en una carpeta de salida. No se conectará a Proxmox ni instalará un servicio.

El objetivo es aprender cómo se utilizan variables, plantillas y comprobaciones, y observar qué ocurre al repetir una ejecución o cambiar un archivo. Los datos del informe son los que tú escribes en las variables; no son mediciones del equipo. Más adelante tendrás que aplicar Ansible al servicio de `srv-aso`, porque este ensayo local no cumple por sí solo esa entrega remota.

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

Esta vez el informe debe cambiar porque has pedido otra fase en las variables. Eso es compatible con la idempotencia: después de aplicar el nuevo valor, repetir la ejecución debería mantenerlo sin más cambios. Para poder reproducirlo, guarda en Git las variables y la plantilla que has utilizado.

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

Devuelve la reserva a su valor válido y ejecuta de nuevo el playbook. Explica que el fallo anterior era el resultado esperado: la comprobación ha impedido generar un informe con un reparto de memoria imposible.

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

Para aplicar lo aprendido al servicio ASO, cambia el inventario local por el de tu servidor y escribe tareas que configuren una parte útil del servicio aprobado. Antes de ejecutarlas, revisa la máquina seleccionada, los parámetros y los permisos. Después, repite la ejecución, explica los cambios y prueba el servicio desde el cliente.

Consulta los [requisitos de Bash y Ansible](../proyecto/automatizacion.md).
Los roles son una posibilidad de organización, no un requisito nuevo impuesto
por este laboratorio.

