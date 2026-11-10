# Web del alumnado: Proyecto Proxmox

Sitio MkDocs independiente para 2.º ASIR, curso 2026-2027. Esta carpeta es
la **raíz del repositorio que se publicará**. No hay que subir toda la carpeta PI.

Modalidad virtual: Proxmox en VirtualBox en el equipo del alumno. No se cuenta
con el Proxmox del centro. La guía local incluye recursos, interfaces y red NAT.

La teoría se concentra en Proxmox y Ansible: siete capítulos nuevos de Proxmox,
cinco de fundamentos y técnica Ansible, y un laboratorio Ansible guiado.
Se ha retirado el bloque teórico de administración Linux, Samba y ACL;
el servicio ASO y los dos scripts Bash siguen siendo entregables de la práctica.

## Vista local

Requisitos: Python 3.10 o posterior, soporte venv, Bash y acceso a Internet
para instalar dependencias. En LliureX, solicita al administrador el paquete
python3-venv si falta.

Estos comandos se ejecutan **dentro de `web_alumnado`**, donde están
`requirements.txt`, `mkdocs.yml`, `tools/` y `tests/`. Si tu terminal está
en la raíz `PI`, entra primero:

~~~bash
cd web_alumnado
~~~

Si has clonado únicamente el repositorio de la web, entra en la carpeta
de ese repositorio. Activar un entorno virtual no cambia la carpeta actual.

Prepara el entorno una vez; si `.venv` ya existe, omite la primera orden:

~~~bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
.venv/bin/python tools/preparar_descargas.py
.venv/bin/python -m unittest discover -s tests -v
.venv/bin/python -m mkdocs build --strict
.venv/bin/python tools/comprobar_enlaces.py site
~~~

Para arrancar la web en las siguientes sesiones, desde esta misma carpeta:

~~~bash
.venv/bin/python -m mkdocs serve --dev-addr 127.0.0.1:8765
~~~

Abrir http://127.0.0.1:8765/. Usa otro puerto si está ocupado.
La previsualización local no es una publicación en GitHub.

En la copia completa del proyecto, el README de la raíz `PI` incluye
también el comando para arrancar esta web sin cambiar de carpeta.

## Publicación en GitHub Pages

1. Crea un repositorio del profesor, por ejemplo `pi-asir-proxmox`, vacío.
   En GitHub Free, utiliza un repositorio público para Pages. No contiene
   entregas del alumnado ni documentos internos del departamento.
2. Sube **el contenido de esta carpeta**, incluidos `.github/` y `.gitignore`,
   conservando `mkdocs.yml` en la raíz. Elige la rama `main`.
3. En **Settings > Pages > Build and deployment > Source**, elige
   **GitHub Actions**. Si la organización restringe Actions o Pages, pide
   la habilitación al administrador.
4. En **Actions**, ejecuta `Validar y publicar la web` mediante `Run workflow`,
   o realiza un nuevo commit. Un despliegue fallido antes de habilitar Pages
   se puede volver a ejecutar.
5. Abre la URL que aparece en el trabajo `deploy` y en Settings > Pages.
   Habitualmente será `https://USUARIO.github.io/pi-asir-proxmox/`.
6. Prueba navegación, búsqueda, diagrama y ZIP antes de compartir la URL en Aules.

Ejemplo para un repositorio remoto **vacío**, sustituyendo USUARIO y REPOSITORIO.
Revisa primero que estás dentro de esta carpeta y que no pertenece a otro Git.

~~~bash
git init -b main
git add .github .gitignore mkdocs.yml requirements.txt README.md REVISION.md docs tools tests
git diff --cached --stat
git commit -m "Publica materiales del proyecto Proxmox"
git remote add origin https://github.com/USUARIO/REPOSITORIO.git
git push -u origin main
~~~

No hace falta un token personal para el workflow: usa los permisos limitados
de `GITHUB_TOKEN`. Autentica tu `git push` mediante el método de GitHub
aprobado; nunca escribas tokens en las URLs.

El workflow valida también las propuestas de cambio sin desplegarlas.
La publicación solo se ejecuta desde `main`. El repositorio individual
del alumno es distinto y puede ser privado con acceso docente.

## Mantenimiento

- Editar `docs/`: contenido público del curso.
- `docs/proyecto/practica.md`: guía general y recorrido de la práctica.
- `docs/proyecto/fase-*.md`: tareas y evidencias de cada fase (0-11).
- `docs/proyecto/entrega.md`: memoria, revisión final, rúbrica y defensa.
- `docs/clases/`: presentación y calendario de las 33 sesiones, con enlaces
  directos a la práctica y los temas.
- `docs/proxmox/`: teoría ampliada y procedimientos del taller.
- `docs/ansible/`: teoría progresiva y laboratorio guiado.
- `docs/recursos/archivos/`: scripts y ejemplos descargables.
- `tools/preparar_descargas.py`: regenera ZIP y sumas desde esos ejemplos.
- `tools/comprobar_enlaces.py`: valida páginas, anclas y archivos locales.
- `tests/`: pruebas del generador y del backup sin tocar el laboratorio.
- `REVISION.md`: procedencia, correcciones y asuntos del departamento.
- No subir `.venv/` ni `site/`; GitHub genera la web automáticamente.
- No regenerar Word para esta web ni publicar los originales internos.

Los materiales se adaptaron desde `programaciones/`; **no hay sincronización
automática** posterior. Si cambia el enunciado original, revisar su copia web.
La generación de ZIP sí se automatiza en cada build de GitHub.

Para empaquetar toda la web, sin entornos virtuales ni HTML generado:

~~~bash
.venv/bin/python tools/empaquetar_web.py ../web_alumnado-github.zip
~~~

## Verificación adicional

El workflow comprueba sintaxis Ansible con `ansible-core==2.21.3` y la colección
`ansible.posix==2.2.2`. También ejecuta el laboratorio introductorio en directorios
temporales: idempotencia, deriva, entradas inválidas y rechazo de enlaces.
No conecta ni modifica servidores. Para repetir esa prueba, con Ansible instalado
en el entorno Python compatible, ejecuta
`.venv/bin/python tools/validar_laboratorio_ansible.py`. La ejecución funcional
del servicio, el NAT y las restauraciones debe validarse en el laboratorio real.

La prueba de navegador es opcional y requiere Node, Playwright, pngjs y Chromium:

~~~bash
npm install --prefix /tmp/pi-web-browser playwright pngjs
/tmp/pi-web-browser/node_modules/.bin/playwright install chromium
NODE_PATH=/tmp/pi-web-browser/node_modules node tools/verificar_navegador.cjs
~~~

El servidor local debe estar arrancado. `PREVIEW_URL` permite cambiar su URL y
`SCREENSHOT_DIR` el destino de las capturas. Comprueba escritorio y móvil,
búsqueda, navegación, descargas y píxeles de los diagramas.

Los diagramas Mermaid utilizan la carga oficial del tema desde unpkg; el texto,
las imágenes del producto, el índice de búsqueda y las descargas se sirven
desde el propio sitio. La primera carga de diagramas necesita acceso a esa CDN.

`SITE_URL` permite indicar una URL canónica distinta. El workflow calcula la
URL estándar de un repositorio de proyecto. Para un dominio propio o un
repositorio `USUARIO.github.io`, adaptar ese valor y la configuración de Pages.

Documentación: [MkDocs](https://www.mkdocs.org/user-guide/deploying-your-docs/),
[Material](https://squidfunk.github.io/mkdocs-material/),
[GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages).
