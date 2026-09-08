# Copias y restauración

**Sesiones 29-30.** Necesitas una copia real de VM/CT desde Proxmox
**y** una copia de datos/configuración del servicio. Debes demostrar restauración.

## Qué protege cada mecanismo

| Mecanismo | Utilidad | Límite |
|---|---|---|
| Snapshot | Volver a un estado antes de un cambio, si el storage lo permite | Depende del almacenamiento original; no sustituye un backup |
| Backup Proxmox | Recuperar un invitado con el alcance configurado | Hay que verificar discos y volúmenes incluidos |
| Copia del servicio | Recuperar datos y configuración seleccionados | No equivale a copiar cuentas, credenciales y sistema completo |

En LXC comprueba los puntos de montaje: no presupongas que un bind mount o
volumen externo entra en la copia. Consulta
[Backup y restauración de Proxmox](https://pve.proxmox.com/pve-docs/chapter-vzdump.html).

## 1. Plan de copia

Anota origen, destino autorizado, espacio disponible, permisos, frecuencia,
retención, datos excluidos y quién puede restaurar. Describe el **RPO** (pérdida
de datos tolerable desde la última copia) y el **RTO** (tiempo objetivo para
recuperar). Después compararás el objetivo con lo medido.

Un backup en el mismo disco no protege del fallo de ese disco. Si el aula solo
ofrece ese destino, declara el riesgo y propone un destino independiente.
No subas copias a GitHub: pueden contener contraseñas, claves y datos.

## 2. Backup desde Proxmox

1. Selecciona `srv-aso` o `cli-linux` en **tu nodo**.
2. Abre *Backup > Backup now* o el equivalente de tu versión.
3. Elige storage autorizado, modo y compresión acordes con recursos y consistencia.
4. Si procede detener el invitado, programa la interrupción con el profesor.
5. Espera la finalización y revisa el log completo; registra resultado, tamaño
   y ubicación. Verifica que el archivo o registro de backup existe.
6. Explica qué discos o volúmenes se incluyeron y cuáles quedaron fuera.

Si la cuota permite una restauración completa de prueba, hazla a un **ID nuevo**
y a una red aislada o con interfaz desconectada. Antes de conectarla, cambia
nombre/IP y evita duplicar servicios. No sobrescribas un invitado funcionando.
Esta comprobación amplía la restauración obligatoria del servicio.

## 3. Copia del servicio con Bash

Crea un archivo de prueba en el recurso Samba desde el cliente y guarda su hash.
Detén escrituras durante la copia de laboratorio para que no cambien los datos.

En `srv-aso` verifica montaje, espacio y acceso al destino. Desde la carpeta que
contiene `scripts/backup_servicio.sh`, adapta las rutas:

~~~bash
sudo env BACKUP_ROOT=/DESTINO_AUTORIZADO/servicio-aso \
  SOURCE_DATA=/srv/grupo_asir \
  SOURCE_CONFIG=/etc/samba/smb.conf \
  bash scripts/backup_servicio.sh
~~~

`/DESTINO_AUTORIZADO` es un marcador, no una ruta que debas crear por defecto.
El script mostrará una carpeta fechada con sufijo único. Registra esa ruta exacta,
revisa `backup.log`, datos, configuración, propietarios y ACL.

Este ejemplo no incluye la base de cuentas Samba ni las cuentas Linux.
Para recuperación en otro sistema necesitarás el backup de la VM/CT o reconstruir
cuentas y credenciales por un procedimiento seguro, conservando identidades,
propietarios y permisos coherentes.

## 4. Restauración controlada y obligatoria

Haz la prueba sobre **un archivo creado expresamente para el ejercicio**,
nunca sobre datos de trabajo ajenos.

1. Conserva hash, contenido y permisos de `prueba.txt` antes del fallo.
2. Comprueba que está en la copia completada.
3. Renombra el archivo del recurso a `prueba.txt.simulado` con permiso del profesor.
   Se simula pérdida sin destruir el original.
4. Inicia la medición del tiempo de recuperación.
5. Restaura solo el archivo elegido desde la copia exacta, en `srv-aso`:

~~~bash
sudo rsync -aHAX /RUTA_COPIA_COMPLETADA/datos/prueba.txt /srv/grupo_asir/
sudo getfacl /srv/grupo_asir/prueba.txt
sudo sha256sum /srv/grupo_asir/prueba.txt
~~~

6. Desde el cliente descarga `prueba.txt` con Samba. Compara su SHA-256 con el inicial.
7. Comprueba también el acceso denegado. Recuperar datos con permisos abiertos
   no es una restauración correcta.
8. Detén la medición al recuperar el servicio comprobado y registra el tiempo.
9. Conserva la evidencia y acuerda con el profesor la limpieza de archivos de ensayo.

Si necesitas recuperar `smb.conf`, guarda el estado actual y valida primero la copia
con `testparm -s /RUTA_COPIA_COMPLETADA/config/smb.conf`. No sustituyas
configuración ni reinicies si hay errores.

## Evidencia H8

En `docs/08-copias-restauracion.md` debe verse **antes, copia, fallo, restauración
y después**, con hash, permisos, prueba desde el cliente, duración y limitaciones.
La ausencia de errores al ejecutar el script no demuestra por sí sola la recuperación.
