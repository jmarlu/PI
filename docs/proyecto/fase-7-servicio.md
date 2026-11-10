# Fase 7. Servicio ASO

[Guía de la práctica](practica.md) · **Al terminar:** servicio probado desde el cliente y permisos comprobados.

**Sesiones de clase:** 21–25. Consulta el [calendario](../clases/index.md).

En esta fase pondrás en marcha un servicio de ASO y comprobarás que se
puede usar desde el cliente. Guarda la configuración y las pruebas en
`docs/06-servicio-aso.md`. El servicio
recomendado es **servidor de ficheros Samba con permisos Linux y ACL**,
porque conecta con usuarios, permisos, servicios, red, administración
remota, automatización y copias.

Puedes elegir otro servicio si el profesor lo aprueba: NFS, SSH
bastionado, LDAP, CUPS, Nginx administrado con systemd, o monitorización
básica.

## Opción recomendada: Samba con ACL

En `srv-aso`:

1. Instala paquetes necesarios.
2. Crea un grupo de trabajo, por ejemplo `grupo_asir`.
3. Crea dos usuarios de prueba.
4. Crea el directorio `/srv/grupo_asir`.
5. Aplica propietario, permisos POSIX y ACL.
6. Configura un recurso compartido Samba.
7. Reinicia y comprueba el servicio.
8. Prueba acceso desde `cli-linux`.

Comandos orientativos que puedes adaptar:

```bash
sudo apt update
sudo apt install samba acl smbclient -y
sudo groupadd grupo_asir
sudo useradd -m -s /bin/bash alumno1
sudo useradd -m -s /bin/bash profesor
sudo usermod -aG grupo_asir alumno1
sudo usermod -aG grupo_asir profesor
sudo smbpasswd -a alumno1
sudo smbpasswd -a profesor
sudo mkdir -p /srv/grupo_asir
sudo chown root:grupo_asir /srv/grupo_asir
sudo chmod 2770 /srv/grupo_asir
sudo setfacl -m g:grupo_asir:rwX /srv/grupo_asir
sudo setfacl -m d:g:grupo_asir:rwX /srv/grupo_asir
sudo systemctl status smbd --no-pager
```

Fragmento orientativo para documentar en `smb.conf`:

```ini
[grupo_asir]
   path = /srv/grupo_asir
   read only = no
   browseable = yes
   create mask = 0660
   directory mask = 2770
   valid users = @grupo_asir
```

Las contraseñas Samba se introducen de forma interactiva, nunca en el
repositorio. Los usuarios Linux y las credenciales Samba son elementos
distintos. Después de guardar la configuración, valida y reinicia:

```bash
sudo testparm -s
sudo systemctl restart smbd
sudo systemctl is-active smbd
```

No reinicies si `testparm` informa de un error. Para la prueba negativa,
crea un usuario de laboratorio con credenciales Samba válidas pero sin
pertenencia a `grupo_asir`: debe autenticarse sin poder acceder al recurso.
Una contraseña incorrecta no demuestra que los permisos del recurso sean correctos.

Pruebas desde `cli-linux` (instala `smbclient` en el cliente):

```bash
smbclient -L //IP_SRV_ASO -U alumno1
smbclient //IP_SRV_ASO/grupo_asir -U alumno1
```

## Qué guardar en tu repositorio

- Estado del servicio con `systemctl`.
- Fragmento de configuración sin contraseñas.
- `testparm`.
- `getfacl /srv/grupo_asir`.
- Prueba de acceso correcto.
- Prueba de acceso denegado con un usuario no autorizado.
- Logs relevantes si hubo incidencias.

---

[Anterior](fase-6-despliegue.md) · [Fase 8: Automatización con Bash y Ansible](fase-8-automatizacion.md)
