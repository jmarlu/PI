# Inventario, SSH y privilegios

## Dos inventarios con propósitos distintos

El inventario de hardware demuestra viabilidad. El de Ansible identifica
destinos y agrupa máquinas para aplicar configuración. No sustituye a la
investigación de CPU, RAM y disco.

Ejemplo `inventory.ini`, que debes adaptar antes de ejecutar:

~~~ini
[srv_aso]
srv-aso ansible_host=192.168.56.20 ansible_user=USUARIO_ADMIN

[srv_aso:vars]
ansible_become=true
~~~

`srv-aso` es el alias del inventario; `ansible_host` es el destino de conexión;
`ansible_user` es la cuenta remota. El grupo `srv_aso` permite seleccionar
el servidor por función sin depender del alias.

Los grupos pueden tener hijos y un host pertenecer a varios. Eso no lo
convierte en varias máquinas: el inventario mantiene un host lógico con
variables asociadas.
[Inventarios y agrupación](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html).

## Seleccionar antes de actuar

Ejecuta desde la carpeta que contiene tu inventario y playbook:

~~~bash
ansible-inventory -i inventory.ini --graph
ansible-playbook -i inventory.ini playbook.yml --list-hosts
ansible-playbook -i inventory.ini playbook.yml --list-tasks
~~~

El grafo demuestra cómo se interpretan los grupos, no que haya conexión.
`--list-hosts` permite revisar los destinos del play. Si aparece un equipo que
no administras o ningún host coincide, corrige antes de continuar.

`--limit srv-aso` restringe los destinos ya seleccionados; no añade al play un
host que su patrón `hosts:` no incluyó. En el proyecto se actúa solo sobre los
sistemas propios autorizados.

## Cadena de conexión

Comprueba por orden:

1. Dirección y puerto SSH del destino propio.
2. Identidad de la máquina mediante su huella, especialmente después de clonar.
3. Autenticación con una cuenta autorizada.
4. Python compatible en el destino para los módulos que lo requieren.
5. Privilegios necesarios para las operaciones elegidas.

Prueba SSH antes de atribuir todos los errores al playbook:

~~~bash
ssh USUARIO_ADMIN@192.168.56.20
ansible -i inventory.ini srv_aso -m ansible.builtin.ping --ask-become-pass
~~~

El `ping` de Ansible es una prueba de conexión y ejecución de Python, **no
un ping ICMP**. Con `become` activado también puede depender de la elevación
de privilegios. El [módulo ping](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/ping_module.html)
explica su alcance.

Si utilizas claves SSH y sudo no requiere contraseña conforme a la política
autorizada, no necesitas solicitarla. Si SSH necesita contraseña, existe
`--ask-pass`; revisa los requisitos del método de conexión de tu versión.
No incluyas contraseñas en una línea que pueda quedar en el historial.

## Conectarse no es elevar privilegios

`remote_user`/`ansible_user` elige la cuenta de conexión. `become` solicita
ejecutar tareas con otra identidad, normalmente mediante sudo. No concede
permisos que esa cuenta no posea.
[Elevación de privilegios](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_privilege_escalation.html).

Evita ejecutar todo como administrador si parte del playbook no lo necesita.
La prueba local descargable usa `become: false` porque trabaja con archivos
del propio usuario. El playbook del servicio sí puede necesitar elevación
para paquetes o configuración del sistema invitado.

No desactives globalmente la comprobación de claves de host para resolver una
advertencia. Tras una restauración, verifica por consola qué identidad debe
tener el servidor y corrige el registro concreto cuando corresponda.

## Dónde guardar variables

Para un proyecto pequeño basta con un inventario legible y pocas variables.
Si crece, separa las comunes en `group_vars/srv_aso.yml` y las particulares en
`host_vars/srv-aso.yml`. El nombre debe corresponder al grupo o alias real.

Ansible también acepta inventario YAML, útil para representar listas,
diccionarios y tipos explícitos. No mezcles sintaxis INI y YAML en un archivo.
Revisa siempre el resultado con `ansible-inventory`.

## Configuración efectiva

El directorio de trabajo, `ANSIBLE_CONFIG`, un `ansible.cfg` del proyecto y
variables de entorno pueden cambiar el comportamiento. Antes de reproducir
una incidencia registra:

~~~bash
ansible --version
ansible-config dump --only-changed
~~~

La primera orden muestra también la configuración utilizada. Revisa la salida
antes de publicarla por si revela información privada. Configuración, opciones,
keywords y variables tienen reglas de prioridad distintas; no vale la regla
general “lo último escrito gana”.
[Precedencia general](https://docs.ansible.com/projects/ansible/latest/reference_appendices/general_precedence.html).

## Caso de diagnóstico

SSH manual funciona, pero Ansible informa `unreachable`. Compara IP, usuario,
puerto, clave y controlador utilizados en ambas pruebas. Si llega al destino
y el error menciona sudo o Python, cambia la hipótesis: ya no estás ante la
misma fase de conexión.

Documenta las comprobaciones en `docs/07-automatizacion.md`, sin claves ni
contraseñas. Continúa con [variables y plantillas](variables-plantillas.md).

