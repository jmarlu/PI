# Evaluación y defensa

## Qué se revisa

La rúbrica operativa del proyecto está en la
[práctica completa](practica.md#20-criterios-de-calificacion).
La documentación es una evidencia transversal: una captura aislada o una
plantilla sin completar no demuestra un criterio.

| Hito | Comprobación individual |
|---|---|
| H0 | Repositorio, primer commit, documentos iniciados y acceso docente |
| H1-H2 | Tres respuestas del inventario, fuentes, cálculos y diseño defendible |
| H3-H5 | Nodo, plantilla y dos máquinas que funcionan |
| H6 | Servicio probado desde el cliente, con un acceso permitido y otro denegado |
| H7 | Dos scripts Bash y Ansible ejecutados; explicación de resultados y errores |
| H8 | Copia real y restauración con una prueba del dato recuperado |
| H9-H10 | Medidas interpretadas, seguridad, memoria y defensa |

**Bash y Ansible son obligatorios. Una instantánea no sustituye al backup.**
No se evalúa el número de commits, sino su contenido, continuidad y autoría.

## Resultados de aprendizaje

La programación distingue identificar necesidades (RA1), diseñar (RA2),
planificar la ejecución (RA3) y definir el seguimiento y control (RA4).
Conserva también planificación, criterios de aceptación, incidencias y
comparación entre lo previsto y lo obtenido: no solo el resultado técnico.

La calificación oficial del módulo se rige por la programación aprobada y
la información comunicada por el departamento. Los pesos de la rúbrica de
producto no se suman a los pesos por RA ni constituyen dos notas adicionales.
Las fechas, recuperación y condiciones oficiales de superación las comunica
el profesor en Aules.

## Preparar la demostración

1. Abre el README de GitHub y el commit que vas a entregar.
2. Justifica si tu equipo puede ejecutar el proyecto y cuál es su principal límite.
3. Relaciona el diagrama con el nodo y sus invitados reales.
4. Muestra la plantilla y los dos sistemas con nombre, IP y recursos.
5. Prueba el servicio desde el cliente y explica un acceso denegado.
6. Localiza y explica ambos scripts y el playbook; muestra sus ejecuciones.
7. Enseña la copia, la restauración, el dato recuperado y el tiempo medido.
8. Interpreta una medida de rendimiento y un riesgo pendiente.

Prepara los comandos, un fichero de prueba sin datos personales y las evidencias
de respaldo. No realices un borrado improvisado de datos para la defensa.
El profesor asignará el tiempo individual; no se presupone que todas las
defensas quepan en una única hora.

## Entrega formal

Sigue la [lista final](practica.md#19-checklist-final) y entrega en Aules:

- URL de tu repositorio individual.
- Identificador completo del commit publicado: `git rev-parse HEAD`.
- Incidencias pendientes, si las hay, con su procedimiento de recuperación.

Verifica el acceso desde la cuenta docente. Un `git remote -v` local no lo acredita.
No entregues ISOs, discos, copias ni secretos en GitHub.

## Autoría y fuentes

Cita las fuentes técnicas, la versión consultada y qué decisión apoyan.
Identifica código adaptado y explica tus modificaciones. Una ayuda generada
o descargada no sustituye la ejecución y defensa individual. Sigue las normas
del centro sobre herramientas de asistencia y declara su uso cuando corresponda.
