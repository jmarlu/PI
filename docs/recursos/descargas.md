# Descargas y plantillas

## Para empezar el proyecto

Elige **una** de estas dos formas de obtener la misma estructura inicial:

| Recurso | Uso |
|---|---|
| [crear_estructura_entrega.sh](archivos/crear_estructura_entrega.sh) | Genera la carpeta local con tu identificador; no sobrescribe una existente |
| [Plantilla inicial ZIP](archivos/plantilla-alumno.zip) | Descomprime en una carpeta nueva y cambia el nombre e identificador de ejemplo |

Después sigue la [primera sesión](../proyecto/primera-sesion.md) para completar
los documentos, iniciar Git y publicar en **tu** repositorio.
El ZIP no contiene un repositorio Git ni crea uno en GitHub.

No necesitas instalar MkDocs para entregar tu trabajo: tu documentación es
Markdown en GitHub. Esta web es el material del profesor.

## Automatización del alumno

La plantilla incluye los dos scripts y un playbook **de inicio**, no una
solución terminada. Es normal que sus documentos tengan apartados pendientes
antes de hacer la práctica; esos pendientes no deben quedar en la entrega final.

- [Ejemplo Ansible ampliado para Samba](archivos/ansible-samba.zip).
- [Playbook ampliado](archivos/ansible-samba/playbook.yml).
- [Inventario de ejemplo](archivos/ansible-samba/inventory.ini).
- [Colección requerida](archivos/ansible-samba/requirements.yml).
- [Plantilla de configuración Samba](archivos/ansible-samba/templates/smb.conf.j2).

Descomprime el ejemplo ampliado fuera de tu repositorio, compara los archivos
con tu `ansible/` y adapta o integra lo necesario. No sobrescribas trabajo propio
sin revisarlo. Conserva `templates/` junto a `playbook.yml`.

El ejemplo reemplaza la configuración del Samba de laboratorio y no automatiza
las contraseñas. Lee antes la [guía de automatización](../linux/automatizacion.md).

## Herramientas de apoyo

| Archivo | Ejecutar en | Alcance |
|---|---|---|
| [inventario_nodo_pi.sh](archivos/inventario_nodo_pi.sh) | Tu equipo inventariado o nodo propio | Recoge datos, no decide la viabilidad |
| [comprobar_entrega_pi.sh](archivos/comprobar_entrega_pi.sh) | Equipo de administración | Revisa estructura local y avisos, no pone nota |
| [auditar_servicio_aso.sh](archivos/auditar_servicio_aso.sh) | Cliente autorizado | Diagnóstico de conectividad y puertos del propio servidor |

Revisa el código y las salidas antes de publicarlas. Los inventarios pueden
contener identificadores, IPs y nombres que debas ocultar.

Ejemplos desde la carpeta de descarga; adapta los destinos:

~~~bash
bash inventario_nodo_pi.sh inventario-local.md
bash comprobar_entrega_pi.sh --inicio /RUTA_DE_TU_REPOSITORIO
bash comprobar_entrega_pi.sh /RUTA_DE_TU_REPOSITORIO
bash auditar_servicio_aso.sh IP_SRV_ASO 22 445
~~~

El comprobador no conecta a GitHub, no comprueba acceso docente, no demuestra
que el contenido esté completado ni detecta todos los secretos. Puede terminar
con avisos aunque no encuentre fallos de estructura. Lee los avisos y contrasta
la [entrega real](../proyecto/evaluacion.md).

La auditoría necesita sus herramientas opcionales instaladas para esas pruebas.
No conviertas la falta de `nmap` o `nc` en un resultado de seguridad favorable.
Solo se autoriza la IP de tu servidor, no la subred del aula.

## Integridad de las descargas

[Sumas SHA-256](archivos/SHA256SUMS.txt). Permiten detectar alteraciones accidentales,
no certifican la seguridad ni la autoría del código. Para comprobar los dos ZIP,
descárgalos junto con las sumas, manteniendo sus nombres:

~~~bash
sha256sum -c SHA256SUMS.txt --ignore-missing
~~~

También se ofrecen las sumas de scripts y archivos Ansible. Un archivo que no
has descargado se omite con esa opción. Revisa que se compruebe el ZIP deseado.
