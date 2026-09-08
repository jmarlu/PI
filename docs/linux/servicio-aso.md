# Servicio ASO: Samba con permisos y ACL

**Sesiones 21-25.** Ejemplo para un `srv-aso` Debian/Ubuntu nuevo y autorizado,
con cliente Linux separado. No ejecutes estos pasos en el nodo Proxmox.
Puedes proponer otro servicio, pero necesita aprobación y pruebas equivalentes.

## Las tres comprobaciones

1. **Identidad:** existe la cuenta Linux y puede autenticarse en Samba.
2. **Autorización:** Samba permite el recurso a ese usuario o grupo.
3. **Sistema de archivos:** permisos POSIX y ACL permiten la operación.

Que un usuario se autentique no garantiza que tenga acceso al recurso.
Samba no puede conceder un acceso que el sistema de archivos impide.
[Referencia de configuración](https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html).

## 1. Preparar el servidor

Confirma primero `hostname`. En `srv-aso`:

~~~bash
sudo apt update
sudo apt install samba smbclient acl rsync
getent group grupo_asir
id alumno1
id profesor
~~~

Los últimos comandos pueden indicar que todavía no existen. Crea **solo lo que
falte**; no reutilices una cuenta real ni repitas `useradd` ignorando sus errores:

~~~bash
sudo groupadd grupo_asir
sudo useradd -m -s /usr/sbin/nologin alumno1
sudo useradd -m -s /usr/sbin/nologin profesor
sudo usermod -aG grupo_asir alumno1
sudo usermod -aG grupo_asir profesor
sudo smbpasswd -a alumno1
sudo smbpasswd -a profesor
~~~

Estas cuentas son de prueba para el servicio; la administración SSH utiliza
otra cuenta con permisos sudo. `smbpasswd -a` solicita una contraseña de forma
interactiva y requiere que exista antes el usuario Linux. No guardes ni muestres
la contraseña. [Manual de smbpasswd](https://www.samba.org/samba/docs/current/man-html/smbpasswd.8.html).

## 2. Directorio y permisos

~~~bash
sudo mkdir -p /srv/grupo_asir
sudo chown root:grupo_asir /srv/grupo_asir
sudo chmod 2770 /srv/grupo_asir
sudo setfacl -m g:grupo_asir:rwx /srv/grupo_asir
sudo setfacl -m d:g:grupo_asir:rwx /srv/grupo_asir
getfacl /srv/grupo_asir
id alumno1
~~~

`2770` incluye setgid para heredar el grupo en elementos nuevos del directorio.
La ACL de acceso actúa sobre el directorio; la ACL por defecto interviene en la
herencia. Revisa también la máscara efectiva que muestra `getfacl`.
La herencia no corrige automáticamente archivos antiguos.

## 3. Configurar el recurso

Conserva una copia previa de `/etc/samba/smb.conf` **fuera de GitHub**.
Abre el archivo con `sudoedit /etc/samba/smb.conf`. En un servidor de laboratorio
standalone, añade una única sección, sin duplicar otra con el mismo nombre:

~~~ini
[grupo_asir]
   path = /srv/grupo_asir
   browseable = yes
   read only = no
   guest ok = no
   valid users = @grupo_asir
   create mask = 0660
   directory mask = 2770
~~~

Valida primero:

~~~bash
sudo testparm -s
~~~

Si no hay errores, aplica y comprueba:

~~~bash
sudo systemctl restart smbd
sudo systemctl enable smbd
sudo systemctl is-active smbd
sudo ss -ltnp
sudo journalctl -u smbd -n 30 --no-pager
~~~

Si `testparm` falla, corrige o recupera la configuración antes de reiniciar.
El firewall solo debe permitir los clientes autorizados. Para SMB directo
se utiliza TCP 445; documenta si tu configuración necesita también NetBIOS.

## 4. Prueba positiva desde cli-linux

Instala `smbclient` en el cliente. Crea con tu editor un pequeño archivo local
`prueba.txt` con texto identificable pero sin datos personales.

~~~bash
smbclient -L //IP_SRV_ASO -U alumno1
smbclient //IP_SRV_ASO/grupo_asir -U alumno1
~~~

Dentro del indicador `smb: \>`:

~~~text
put prueba.txt prueba.txt
ls
get prueba.txt prueba-recuperada.txt
quit
~~~

En el cliente, compara `sha256sum prueba.txt prueba-recuperada.txt`.
En el servidor, revisa propietario y ACL del archivo creado.
Repite una lectura con `profesor`. Guarda resultados y explica qué demuestran.

## 5. Prueba negativa que compruebe permisos

En `srv-aso`, crea una tercera cuenta **solo de laboratorio**, sin el grupo
permitido; si ya existe, revisa su pertenencia antes de usarla:

~~~bash
sudo useradd -m -s /usr/sbin/nologin ajeno_pi
sudo smbpasswd -a ajeno_pi
id ajeno_pi
~~~

Desde `cli-linux`, con su contraseña correcta:

~~~bash
smbclient //IP_SRV_ASO/grupo_asir -U ajeno_pi
~~~

Debes obtener denegación al conectar con el recurso. Contrasta el registro del
servidor para distinguir error de contraseña de denegación por autorización.
Una contraseña incorrecta solo prueba la autenticación, no el control del grupo.

## Evidencias y siguiente paso

En `docs/06-servicio-aso.md` registra paquetes/versiones, cuentas de prueba,
grupo, configuración sin secretos, ACL, estado, pruebas positiva y negativa y
diagnóstico de incidencias. No copies salidas inventadas.

Continúa con [Bash y Ansible](automatizacion.md). El ejemplo Ansible administra
una configuración completa: revísalo antes de sustituir la configuración manual.
