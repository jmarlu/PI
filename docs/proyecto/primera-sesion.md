# Primera sesion: GitHub y documentacion Markdown

**Duracion:** 3 horas seguidas (180 minutos).  
**Entrega H0:** URL de tu repositorio individual, documentacion inicial
en Markdown y primer commit publicado y accesible al profesor.

Crear el repositorio y empezar la documentacion es tu primera actividad
del proyecto, antes de inventariar hardware o instalar Proxmox. Esta
sesion forma parte de las 100 horas previstas; no anade horas al curso.

## 1. Organizacion de la clase

| Minutos | Actividad | Resultado |
|---|---|---|
| 0-10 | Presentacion del reto y del primer entregable | Identificar el repositorio como lugar de trabajo del curso |
| 10-35 | Explicacion de Git, GitHub y Markdown | Distinguir documento, version local y version publicada |
| 35-60 | Demostracion completa del profesor | Ver la creacion, edicion, commit, push y lectura en GitHub |
| 60-145 | Trabajo individual guiado | Crear repositorio y publicar los documentos iniciales |
| 145-165 | Validacion por el profesor | Comprobar URL, acceso, enlaces, contenido e historial |
| 165-180 | Cierre | Actualizar bitacora, publicar cambios y entregar URL en Aules |

## 2. Preparacion

Utiliza tu cuenta individual de GitHub y un equipo de aula con navegador,
Git y editor de texto. Comprueba `git --version`. Si falta Git, utiliza
la instalacion facilitada por el profesor. La documentacion puede
prepararse desde el equipo de aula en cualquiera de las dos modalidades
de Proxmox.

Configura con el profesor la autenticacion Git por HTTPS mediante un
gestor de credenciales o token, o por SSH mediante una clave. La
contrasena de la web de GitHub no sirve como contrasena de Git por HTTPS.
No escribas tokens en comandos, URLs ni documentos. Los metodos se
describen en la [documentacion oficial de autenticacion](https://docs.github.com/es/authentication/keeping-your-account-and-data-secure/about-authentication-to-github).

## 3. Crear el repositorio en GitHub

1. Accede a GitHub con tu cuenta y crea un repositorio llamado
   `pi-proxmox-apellido-nombre`, o con el identificador asignado.
2. Escribe una descripcion breve del proyecto.
3. Usa visibilidad privada por defecto y da acceso a la cuenta docente;
   tambien puede ser publico si asi se acuerda. No necesitas publicar
   tus datos personales para identificar el trabajo ante el profesor.
4. Para seguir los comandos de esta guia, crea el repositorio **vacio**:
   no anadas README, licencia ni `.gitignore` en el formulario. Los
   publicaras desde tu equipo.
5. Conserva su URL. En el ejemplo sera
   `https://github.com/USUARIO/pi-proxmox-apellido-nombre`.

GitHub permite elegir visibilidad y crear el repositorio desde su
interfaz; consulta [Primer repositorio en GitHub](https://docs.github.com/es/get-started/using-github/hello-world).

## 4. Preparar la documentacion local

Descarga [crear_estructura_entrega.sh](../recursos/archivos/crear_estructura_entrega.sh) en tu equipo de administracion. Tambien tienes la [plantilla ZIP](../recursos/descargas.md). Revisa el codigo y ejecutalo desde
la carpeta que contiene el script:

```bash
bash crear_estructura_entrega.sh apellido_nombre ./proyectos
cd ./proyectos/pi-proxmox-apellido-nombre
```

El script crea plantillas locales; aun tienes que completar y publicar
los documentos. No crea la cuenta ni el repositorio remoto. Si ya has
comenzado el proyecto, conserva tus ficheros y anade lo que falte
manualmente: el script no sobrescribe carpetas existentes.

Completa con el editor:

| Archivo | Contenido que debe quedar hoy |
|---|---|
| `README.md` | Identificador, objetivo, modalidad o decision pendiente, estado e indice con enlaces |
| `docs/00-ficha-inicial.md` | URL de GitHub, modalidad prevista, recursos conocidos y dudas |
| `docs/00-bitacora.md` | Fecha, objetivo, trabajo hecho, comprobaciones, incidencias y siguiente paso |
| `docs/10-memoria-tecnica.md` | Titulo, objetivos e indice inicial del proyecto |
| `.gitignore` | Exclusiones de credenciales, ficheros locales, ISOs, discos y backups |
| `evidencias/README.md` | Criterio de nombres y relacion entre evidencia y documento explicativo |

Los documentos de las fases posteriores pueden quedar como plantillas.
Los ejemplos de Bash y Ansible se estudiaran y adaptaran en sus sesiones;
su existencia hoy no demuestra todavia que domines la automatizacion.

## 5. Practicar Markdown

Anade al README un titulo, una lista, una tabla, un enlace relativo y un
bloque de comandos. Ejemplo:

````markdown
# Laboratorio Proxmox individual

## Objetivo

Desplegar y administrar un servicio Linux con Bash y Ansible.

- Modalidad: virtualizada.
- Estado: documentacion inicial.

| Elemento | Estado |
|---|---|
| Nodo Proxmox | Pendiente de instalacion |

[Ficha inicial](docs/00-ficha-inicial.md)
[Bitacora](docs/00-bitacora.md)

```bash
git status
```
````

En los documentos de `docs/`, las imagenes se enlazan desde esa carpeta,
por ejemplo `![Panel del nodo](../evidencias/capturas-o-salidas/s07-panel.png)`.
Solo anade el enlace cuando exista la imagen. Acompana cada evidencia
de una explicacion y del resultado observado.

## 6. Publicar el primer commit

Desde la raiz local del proyecto, sustituye los valores de ejemplo.
Utiliza el correo de commits configurado en tu cuenta GitHub; puedes
usar el correo privado `noreply` que muestre tu cuenta.

```bash
git init -b main
git config user.name "IDENTIFICADOR_ALUMNO"
git config user.email "CORREO_DE_COMMITS"
git status
git add README.md .gitignore docs scripts ansible evidencias
git diff --cached --stat
git diff --cached
git commit -m "S01: inicia documentacion Markdown y estructura del proyecto"
git remote add origin https://github.com/USUARIO/pi-proxmox-apellido-nombre.git
git push -u origin main
```

Revisa el contenido antes de confirmar. No subas claves privadas,
tokens, contrasenas, ISOs, discos virtuales ni copias completas. El
`.gitignore` ayuda a excluir archivos sin versionar; no elimina lo ya
incluido en el historial. Consulta [Ignorar archivos](https://docs.github.com/en/get-started/git-basics/ignoring-files).

Abre la URL en el navegador y comprueba el README renderizado, sus
enlaces y el commit. Entrega la URL en Aules; el profesor verificara el
acceso desde su cuenta.

## 7. Rutina para todas las sesiones

Al empezar, abre tu copia del repositorio y consulta `git status`. Si
esta limpia, usa `git pull --ff-only` para incorporar cambios publicados
desde otro equipo. Si hay cambios locales o un conflicto, revisalos con
el profesor antes de continuar.

Al terminar, actualiza el documento tecnico correspondiente y la
bitacora. Registra lo que ha funcionado y lo que queda pendiente, con
enlaces a evidencias. Revisa y publica los cambios:

```bash
git status
git add README.md .gitignore docs scripts ansible evidencias
git diff --cached
git commit -m "S02: documenta inventario y limitaciones del nodo"
git push
git log -1 --oneline
```

Adapta el mensaje a la sesion y al trabajo real. Comprueba en GitHub que
la version coincide. Se requiere al menos una actualizacion significativa
por sesion; no se valora acumular commits vacios o cambios cosmeticos.

## 8. Incidencias frecuentes

| Incidencia | Actuacion |
|---|---|
| El profesor no ve un repositorio privado | Revisar invitacion, aceptacion y cuenta docente |
| El commit existe localmente pero no en GitHub | Revisar `git status`, conexion y resultado de `git push` |
| GitHub ya contiene un README y rechaza el primer push | Conservar el trabajo local, clonar el repositorio en otra carpeta e incorporar alli los documentos; no forzar el push |
| Un enlace funciona en mi equipo pero no en GitHub | Revisar ruta relativa, mayusculas y que el destino este publicado |
| No hay acceso temporal a GitHub | Registrar incidencia y conservar documentos y commits locales; publicar al recuperar el acceso |
| Git aun no esta configurado pero la web funciona | Crear y editar Markdown en GitHub con ayuda docente; despues clonar ese repositorio y continuar su historial |

## 9. Validacion H0

- [ ] Repositorio individual GitHub creado como primera actividad.
- [ ] README completado y enlaces funcionando.
- [ ] Ficha, bitacora y memoria iniciadas en Markdown.
- [ ] `.gitignore` publicado y sin credenciales en los documentos.
- [ ] Primer commit visible en GitHub.
- [ ] URL entregada en Aules y acceso docente comprobado.

El profesor validara contenido y acceso antes del trabajo sobre Proxmox.
Una incidencia tecnica se registra para su subsanacion y no sustituye la
entrega. En el cierre final del curso entregaras tambien el identificador
completo del commit publicado, obtenido con `git rev-parse HEAD`.
