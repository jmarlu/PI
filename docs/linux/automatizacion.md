# Automatización: Bash y Ansible

**Sesiones 26-28. Ambas herramientas son obligatorias.**
Descarga los ejemplos desde [recursos](../recursos/descargas.md), léelos y
adáptalos. Entregar una plantilla sin ejecución ni explicación no completa H7.

## Bash: procedimientos locales

`scripts/inventario.sh` recoge estado; `scripts/backup_servicio.sh` realiza una
copia de datos y configuración. Añade autor o identificador, fecha, propósito,
dependencias, variables y tratamiento de errores.

Desde la raíz de tu repositorio, revisa la sintaxis:

~~~bash
bash -n scripts/inventario.sh
bash -n scripts/backup_servicio.sh
chmod 750 scripts/inventario.sh scripts/backup_servicio.sh
~~~

Ejecuta el inventario en el equipo que estás documentando. Para el backup,
el código debe estar en `srv-aso` y tener acceso a sus orígenes y al destino
autorizado. No basta con ejecutarlo en LliureX si los datos están en otro sistema.

El ejemplo de backup:

- Comprueba que existen datos y configuración y que está instalado `rsync`.
- Rechaza un destino situado dentro del directorio de origen.
- Crea una carpeta única con acceso restringido.
- Conserva metadatos mediante `rsync -aHAX`.
- No borra copias anteriores ni anuncia éxito si falla una copia.
- Escribe `backup.log` al completar; una carpeta parcial no es un backup validado.

Con sudo puede preservar propietarios y ACL; comprueba que el sistema de archivos
destino los soporta. Un montaje ausente podría hacer que escribas en el disco local:
verifica `findmnt` y `df -h` antes de ejecutar. El script no configura el montaje
ni sustituye una política de copias.

Prueba al menos un caso correcto y otro con origen inexistente. Registra la
salida y el código de retorno. `set -euo pipefail` ayuda, pero no verifica que los
datos copiados sean los correctos.

## Ansible: estado deseado remoto

Ansible se ejecuta desde un **nodo de control**: LliureX, `cli-linux` o el entorno
indicado. Se conecta por SSH al servidor y usa módulos para gestionar su estado.
El módulo `ping` de Ansible no es ICMP: comprueba conexión y ejecución Python.
[Introducción oficial](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html).

### 1. Preparación

Pide la instalación de Ansible en el controlador o utiliza el entorno facilitado.
Comprueba `ansible --version` y `ansible-playbook --version`.
En el servidor necesitas Python 3, SSH y una cuenta administrativa con sudo.
Verifica primero `ssh USUARIO_ADMIN@IP_SRV_ASO` y la huella del servidor.

El ejemplo ampliado utiliza `ansible.posix 2.2.2`, que requiere
`ansible-core >= 2.16`. No presupongas que el Ansible preinstalado en LliureX
cumple esa condición. Se ha validado la sintaxis con `ansible-core 2.21.3`.

Para reproducir ese entorno en un controlador autorizado con **Python 3.12
o posterior**, comprueba primero `python3 --version` y prepara un entorno virtual:

```bash
sudo apt install python3-venv openssh-client
python3 -m venv ~/.venvs/pi-ansible
~/.venvs/pi-ansible/bin/python -m pip install ansible-core==2.21.3
source ~/.venvs/pi-ansible/bin/activate
ansible --version
```

Si el Python del host es anterior, utiliza `cli-linux` con una distribución
compatible autorizada o el entorno facilitado por el profesor. No sustituyas
el Python del sistema ni instales Ansible en el nodo Proxmox. Lleva tu carpeta
`ansible/` al controlador elegido conservando sus rutas; no copies claves privadas
entre equipos como solución a un problema de autenticación.

Copia a tu `ansible/` los archivos del
[ejemplo ampliado](../recursos/archivos/ansible-samba.zip) y adapta `inventory.ini`.
El playbook mínimo del generador inicial **solo instala paquetes, crea grupo y
directorio y arranca Samba**; no configura un recurso completo.

~~~ini
[srv_aso]
srv-aso ansible_host=IP_SRV_ASO ansible_user=USUARIO_ADMIN

[srv_aso:vars]
ansible_become=true
~~~

No pongas contraseñas en el inventario. Usa clave SSH o `--ask-pass` si tu entorno
lo admite, y `--ask-become-pass` para sudo. Si debes gestionar secretos con Ansible,
consulta [Ansible Vault](https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html)
y las instrucciones del profesor; no publiques la clave de descifrado.

### 2. Conexión y revisión

Desde la raíz del repositorio:

~~~bash
ansible-galaxy collection install -r ansible/requirements.yml
ansible-inventory -i ansible/inventory.ini --graph
ansible srv_aso -i ansible/inventory.ini -m ansible.builtin.ping --ask-become-pass
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --syntax-check
~~~

El ejemplo ampliado utiliza `ansible.posix.acl` además de módulos integrados;
el archivo de requisitos instala esa colección.
[Referencia y ejemplos de ACL](https://docs.ansible.com/projects/ansible/latest/collections/ansible/posix/acl_module.html).

### 3. Qué automatiza el ejemplo

| Archivo o tarea | Finalidad |
|---|---|
| `inventory.ini` | Un único servidor autorizado y su usuario SSH |
| `playbook.yml` | Paquetes, grupo, usuarios Linux, directorio, ACL y servicio |
| `templates/smb.conf.j2` | Configuración completa del Samba de laboratorio |
| `template.validate` | Comprobar con testparm antes de sustituir el archivo |
| Handler | Reiniciar cuando cambie la configuración |
| Comprobación final | Verificar que smbd está activo |

!!! warning "Alcance del ejemplo"
    Sustituye `/etc/samba/smb.conf` y guarda copia previa en el servidor.
    Úsalo solo en tu `srv-aso` de laboratorio. No crea contraseñas Samba:
    completa `smbpasswd -a` de forma interactiva como indica la guía del servicio.
    Tampoco crea la red ni configura el firewall o las copias.

### 4. Ejecutar y repetir

Primero revisa el modo de comprobación. En un servidor aún sin paquetes
puede no anticipar todas las dependencias; **no prueba el funcionamiento**:

~~~bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check --diff --ask-become-pass
~~~

Después, en el laboratorio autorizado:

~~~bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --ask-become-pass
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --ask-become-pass
~~~

Conserva ambos resúmenes. En la segunda ejecución sin cambios externos,
las tareas de configuración deben permanecer sin cambios. Si una tarea vuelve
a cambiar, identifica por qué. Un comando arbitrario no es idempotente por
escribirlo en YAML. Vuelve a probar Samba desde el cliente.

## Entrega H7

En `docs/07-automatizacion.md` enlaza los dos scripts y el playbook, dependencias,
variables adaptadas, máquina de ejecución, pruebas, errores y explicación de
idempotencia. Incluye salidas reales revisadas para no revelar secretos.
