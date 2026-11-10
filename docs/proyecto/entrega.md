# Memoria, entrega y defensa

[Guía de la práctica](practica.md) · [Última fase: seguridad](fase-11-seguridad.md)

**Cierre y defensa:** sesión 33 y una hora adicional de cierre. La memoria se trabaja desde la sesión 1. Consulta el [calendario](../clases/index.md).

Aquí tienes lo que necesitas para cerrar el proyecto. Consulta la estructura
de la memoria desde el inicio y utiliza la lista de revisión antes de entregar.

## Memoria técnica en Markdown {#18-memoria-tecnica-en-markdown}

La memoria debe estar en `docs/10-memoria-tecnica.md` dentro del
repositorio de GitHub. Se inicia en la primera sesión y se completa cada
semana, enlazando los documentos técnicos para evitar duplicaciones.
La sesión final se dedica a revisar y cerrar la memoria ya elaborada.

Estructura mínima:

```markdown
# Proyecto Intermodular: Nodo Proxmox individual

## 1. Resumen
## 2. Necesidad y objetivos
## 3. Modalidad utilizada
## 4. Inventario de hardware
## 5. Diseño de red
## 6. Instalación y configuración de Proxmox
## 7. Plantilla Linux
## 8. VMs y contenedores desplegados
## 9. Servicio ASO
## 10. Automatización
## 11. Copias y restauración
## 12. Pruebas de rendimiento
## 13. Pruebas de seguridad
## 14. Incidencias y decisiones
## 15. Presupuesto y sostenibilidad
## 16. Conclusiones
## 17. Anexos
```

La memoria debe permitir que otra persona reconstruya el laboratorio. No
entregues solo capturas: cada captura debe ir acompañada de explicación,
comando o decisión técnica.

En cada apartado explica cinco elementos cuando sean aplicables: qué necesidad
se resuelve, qué configuración final se utiliza, por qué se eligió, cómo se
comprobó y qué limitaciones quedan. Enlaza el documento detallado o la evidencia
en vez de duplicarlos. La bitácora conserva la cronología, incluidos intentos y
errores; la memoria presenta el resultado técnico revisado y las conclusiones
que se sostienen con esas pruebas.

## Antes de entregar {#19-checklist-final}

Marca cada punto antes de entregar:

- [ ] Creé el repositorio GitHub y la documentación Markdown en la primera sesión.
- [ ] El profesor tiene acceso a la URL entregada en Aules.
- [ ] README enlaza los documentos y las evidencias con rutas relativas.
- [ ] La bitácora y el historial reflejan el trabajo de las sesiones.
- [ ] He publicado la última versión y he entregado su identificador de commit.
- [ ] He documentado el montaje en VirtualBox o la instalación opcional autorizada.
- [ ] El nodo Proxmox arranca y es accesible.
- [ ] He investigado el hardware y, si uso VirtualBox, los recursos del host y de la VM.
- [ ] He entregado diagrama de red.
- [ ] He creado una plantilla Linux.
- [ ] He desplegado dos VMs o contenedores.
- [ ] Las máquinas tienen IP, hostname y conectividad.
- [ ] El servicio ASO funciona.
- [ ] He probado el servicio desde un cliente.
- [ ] He creado y ejecutado los scripts Bash obligatorios.
- [ ] He creado y ejecutado el playbook Ansible obligatorio.
- [ ] He realizado copia de seguridad.
- [ ] He restaurado y verificado el servicio.
- [ ] He hecho pruebas de rendimiento.
- [ ] He hecho pruebas de seguridad dentro del laboratorio.
- [ ] No he incluido secretos ni datos personales.
- [ ] La memoria está en Markdown y es reproducible.
- [ ] Puedo defender el proyecto sin leer la memoria.

## Criterios de calificación {#20-criterios-de-calificacion}

| Bloque | Peso |
|---|---:|
| Requisitos, inventario, alcance y sostenibilidad | 10 % |
| Nodo Proxmox instalado y administrado | 15 % |
| Diagrama de red, almacenamiento y seguridad base | 10 % |
| Plantilla Linux reutilizable | 10 % |
| Dos VMs/LXC desplegados y documentados | 10 % |
| Servicio ASO funcional | 15 % |
| Automatización con scripts Bash y Ansible | 10 % |
| Copias, restauración y continuidad | 10 % |
| Pruebas de rendimiento y seguridad | 5 % |
| Memoria Markdown, seguimiento en GitHub, defensa y autoría | 5 % |

La documentación y las evidencias en GitHub son obligatorias para revisar
todos los bloques. El apartado documental valora claridad,
reproducibilidad, enlaces, bitácora y autoría; no la cantidad de commits.

## Defensa final {#21-defensa-final}

La defensa es individual e incluye una demostración. Empieza abriendo
el repositorio de GitHub: localiza la memoria, la bitácora y las evidencias
desde el README. Después muestra y explica estos elementos:

1. Acceso al nodo Proxmox.
2. Inventario y diagrama.
3. Plantilla Linux.
4. Dos VMs o contenedores.
5. Servicio ASO funcionando.
6. Automatización Bash y Ansible ejecutada.
7. Backup y restauración.
8. Pruebas de rendimiento y seguridad.
9. Decisiones técnicas y limitaciones.

Preguntas habituales de defensa:

- ¿Por qué elegiste VM o LXC?
- ¿Qué limitaciones tiene tu hardware o nodo virtualizado?
- ¿Cómo has aislado la red?
- ¿Qué puertos necesita tu servicio y por qué?
- ¿Cómo restaurarías el servicio ante un fallo?
- ¿Qué mejorarías con más tiempo o recursos?

## Entrega {#22-entrega}

La entrega formal se realizará en Aules mediante la URL del repositorio
GitHub y el identificador completo del commit de entrega (`git rev-parse
HEAD`). Comprueba que ese commit está publicado y accesible al profesor.
Cada nueva entrega o recuperación identificará su propio commit.

El repositorio debe incluir:

- README con índice y enlaces relativos funcionales.
- Documentación y memoria Markdown.
- Scripts y playbooks.
- Evidencias de ejecución.
- Diagramas.
- Capturas relevantes.
- Registro de incidencias y decisiones.

Los discos de VMs, ISOs y backups se guardan en el almacenamiento
autorizado; en GitHub se documentan su ubicación, procedimiento y pruebas
sin credenciales. Una exportación PDF puede acompañarla, pero no
sustituye la documentación Markdown ni el historial del repositorio.

La falta de evidencias individuales, la copia de material sin citar o la
imposibilidad de defender técnicamente la entrega podrán limitar la
calificación aunque el laboratorio aparente funcionar.

