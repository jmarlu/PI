# Revisión de materiales y alcance de publicación

Fecha: 2026-09-08. No se ha publicado un repositorio remoto ni se han generado DOCX.

## Material utilizado

Se revisaron los Markdown de índice, programación general, programación Proxmox,
práctica, primera sesión, secuenciación, guía docente, exposición y programación
departamental, así como los cuatro scripts de apoyo. Se consultó la guía local
«Guía para elaboración del proyecto intermodular cas.pdf» y el contexto de
`promts/information.md` (equipos de aula de 16 GB), actualizado por la indicación
expresa posterior: VirtualBox local en el equipo del alumno. El Proxmox del
centro queda excluido de los recursos.

Los DOCX/PPTX son versiones de distribución o referencias de formato.
No sustituyen al Markdown actualizado ni se vuelcan a la web. Se conserva la
estructura departamental original, fuera de este sitio.

## Decisiones

- Web del profesor, independiente de los repositorios individuales del alumnado.
- GitHub y Markdown como primera tarea; no se exige Pages al alumno.
- 33 sesiones de 180 minutos y una hora final, dentro de las 100 horas de segundo.
- Materiales adaptados al alumno, sin notas privadas del docente.
- Inventario integrado en la práctica: tres preguntas, investigación y cálculos.
- Modalidad física con permiso de borrado; alternativa en VirtualBox local,
  sin utilizar el Proxmox del centro. Servidor y cliente quedan dentro de Proxmox.
- Se investiga el host y se reserva RAM/disco para él; LXC es alternativa cuando
  Proxmox arranca en VirtualBox pero KVM interno no está disponible.
- Un nodo, no un clúster HA; no se promete tolerancia a fallos inexistente.
- Bash y Ansible obligatorios; ejemplos identificados como ayuda.
- Planificación, aceptación, seguimiento y decisiones conservados para el
  carácter intermodular; el proyecto no se reduce a instalar una aplicación.

## Correcciones realizadas

### Ampliación de teoría de la web

- Siete capítulos nuevos de Proxmox: arquitectura, VM/LXC y anidación,
  dimensionamiento, redes, almacenamiento, clonado e identidad, operación
  y recuperación. El índice conceptual enlaza el recorrido completo.
- Cinco capítulos de fundamentos y técnica Ansible, más un laboratorio guiado:
  inventarios, conexión, YAML, variables, facts, plantillas, módulos, handlers,
  errores, roles, colecciones, secretos y validación.
- Ejemplos originales, cálculos, preguntas de aplicación y fuentes oficiales;
  las respuestas se integran en la memoria existente, sin otra fase de inventario.
- Eliminadas las cuatro páginas del antiguo directorio de teoría Linux y sus
  enlaces. No queda un bloque teórico de administración Linux, Samba o ACL.
- Servicio ASO, pruebas, dos scripts Bash y Ansible remoto conservados en la
  práctica. El ejemplo Samba sigue siendo una descarga práctica opcional para
  ese servicio, no un tema teórico ni sustituto de la adaptación del alumno.
- Laboratorio Ansible local descargable, sin sudo ni conexión a servidores:
  variables, informe Jinja, aserciones, handler y pruebas de deriva/idempotencia.
- Calendario enlazado al temario sin añadir horas. Las sesiones del servicio
  aplican contenidos de ASO; roles y cloud-init son profundización.
- Conservada la decisión de dejar el calendario fuera del menú; sigue accesible
  desde Inicio y desde la presentación del proyecto.
- No se modifica la programación departamental ni se regeneran DOCX/PPTX.

### Revisión de Clases

- La comprobación inicial no detectó destinos ni anclas inexistentes.
- Retirada la página de explicaciones diarias por indicación del usuario.
- Sustituidos los 33 enlaces de sesión por destinos directos a la práctica,
  los procedimientos y la teoría correspondiente.
- Eliminadas las referencias al archivo retirado en Inicio y en MkDocs,
  incluidas las entradas comentadas y la declaración fuera de navegación.
- Actualizadas las pruebas para comprobar las 33 sesiones desde el calendario,
  la ausencia de referencias obsoletas y la navegación desde la presentación.
- Comprobado que la página retirada no permanece en el índice de búsqueda
  ni en el sitio generado. ZIP de distribución regenerado.

### Revisión previa conservada

En la práctica original y en su adaptación web:
- Alta interactiva de credenciales Samba, distinta de las cuentas Linux.
- Validación y comprobación de servicio después de guardar configuración.
- Prueba negativa con credenciales válidas y usuario no autorizado.
- Eliminada la instantánea como alternativa a un backup real.
- Aclaradas las dependencias no incluidas al copiar solo datos y smb.conf.
- Corregido un espacio que impedía renderizar el énfasis del commit semanal.

En el generador original y en la copia descargable:
- El backup falla si falta un origen o rsync, en lugar de anunciar éxito.
- Destino único, permisos restrictivos y prohibición de copiar dentro del origen.
- Sin borrado de destinos mediante rsync --delete.
- Un backup.log completo solo se produce tras las dos copias correctas.

En las guías web:
- Tamaños del laboratorio diferenciados de los mínimos oficiales.
- Diferenciados equipo anfitrión, VirtualBox local, nodo Proxmox e invitados.
- Playbook base del generador identificado como incompleto; ejemplo ampliado con
  configuración validada y cuentas Samba manuales fuera de Git.
- Comprobador local no presentado como evaluador ni como verificación de GitHub.
- Imágenes oficiales no presentadas como trabajo del alumnado.

## Pendiente de concretar por el departamento

No se han inventado estas decisiones:

1. La programación contiene pesos por RA y una rúbrica de producto con otros
   pesos. Falta explicitar su transformación y el tratamiento oficial del trabajo
   de primero. La web conserva la rúbrica de la práctica, no suma escalas y remite
   la nota oficial a la programación aprobada. No adopta el 25/75 como regla firme.
2. Contrastar las horas por UD de la programación departamental con el calendario
   operativo de 33 sesiones antes de aprobar fechas concretas.
3. Confirmar cuentas, versión de VirtualBox, reserva de recursos del host,
   red local/NAT, DNS, gateway y destino de backup,
   versión de Proxmox/Linux, servicio alternativo y permisos del aula.
4. La hora final es cierre, no tiempo suficiente garantizado para todas las
   defensas. Asignar turnos según el grupo y calendario del centro.
5. No se ha instalado VirtualBox/Proxmox ni ejecutado Samba/Ansible contra equipos
   del aula. La prueba funcional y la recuperación requieren ese entorno.
6. El centro debe fijar licencia de sus materiales y revisar privacidad antes de
   publicar. Los recursos de terceros mantienen sus derechos y atribución.

## Qué queda fuera de Pages

Solo `docs/` se convierte en sitio. No se publican la guía PDF interna, las
programaciones oficiales completas, los originales Word, expedientes, rúbricas
cumplimentadas ni notas docentes. README y este informe quedan visibles como código
si el repositorio es público; no contienen datos de alumnos.

Las guías enlazan documentación oficial; las versiones y etiquetas de interfaz
deben contrastarse al iniciar el curso.

## Verificación técnica

- Construcción MkDocs estricta completada y enlaces internos/anclas/descargas comprobados.
- Probada también la construcción bajo una subruta equivalente a GitHub Pages.
- 22 pruebas unitarias correctas: estructura, preservación de trabajo existente,
  sintaxis Bash, copias reales en directorios temporales, fallos de rsync,
  destinos recursivos, ZIP reproducible, enlaces, 33 sesiones, navegación
  teórica, contenido completo de la nueva descarga y enlaces del calendario.
- Ejemplo Ansible validado con ansible-core 2.21.3 y ansible.posix 2.2.2,
  sin conexión a servidores ni ejecución de tareas de administración.
- Laboratorio Ansible ejecutado en copias temporales: check sin crear salida,
  primera aplicación, segunda sin cambios, permisos privados, handler,
  cambio deseado, reparación de deriva, rechazo de presupuesto/fase/nombres
  inválidos y rechazo de enlaces hacia archivos o directorios externos.
- Coherencia comprobada entre la práctica original y la web y entre las cuatro
  herramientas originales y sus copias descargables.
- Referencias externas comprobadas por HTTP; el manual GNU Bash devuelve 403
  a la consulta automatizada, por lo que ese acceso no se da por verificado.
- Los DOCX/PPTX previos no se han regenerado: pueden conservar la modalidad
  anterior. La revisión vigente está en Markdown y en la web.
- 30 páginas verificadas con Chromium/Playwright en 1440x1000 y 390x844:
  navegación, menú móvil, búsqueda, descargas, imágenes y ausencia de
  desbordamiento horizontal del documento. Diagramas inspeccionados mediante
  DOM/CDP y comprobación de píxeles no vacíos; capturas revisadas visualmente.
- El workflow de Pages está preparado; no se ha ejecutado un despliegue remoto
  porque todavía no se ha configurado un repositorio GitHub de destino.
