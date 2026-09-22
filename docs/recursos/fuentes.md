# Fuentes y créditos

Estas referencias son puntos de partida, **no sustituyen tu investigación**.
Anota título, organización, URL, fecha de consulta y versión; explica qué decisión
apoya cada fuente. En el inventario también necesitas documentación del fabricante
de tu equipo anfitrión y de VirtualBox cuando lo utilices, no solo páginas generales.

## Proxmox y virtualización

- [Descripción de Proxmox VE](https://www.proxmox.com/en/products/proxmox-virtual-environment/overview).
- [Requisitos oficiales](https://www.proxmox.com/en/products/proxmox-virtual-environment/requirements).
- [Descargas oficiales](https://www.proxmox.com/en/downloads).
- [Manual de administración](https://pve.proxmox.com/pve-docs/pve-admin-guide.html).
- [Almacenamiento](https://pve.proxmox.com/pve-docs/chapter-pvesm.html).
- [Máquinas virtuales](https://pve.proxmox.com/pve-docs/chapter-qm.html).
- [Consultas y opciones de qm](https://pve.proxmox.com/pve-docs/qm.1.html).
- [Contenedores](https://pve.proxmox.com/pve-docs/chapter-pct.html).
- [Consultas y opciones de pct](https://pve.proxmox.com/pve-docs/pct.1.html).
- [Sistema base, redes y ZFS](https://pve.proxmox.com/pve-docs/chapter-sysadmin.html).
- [Configuración distribuida pmxcfs](https://pve.proxmox.com/pve-docs/chapter-pmxcfs.html).
- [Usuarios, realms y permisos](https://pve.proxmox.com/pve-docs/chapter-pveum.html).
- [Firewall](https://pve.proxmox.com/pve-docs/chapter-pve-firewall.html).
- [Integración cloud-init](https://pve.proxmox.com/pve-docs/cloud-init.html).
- [Backups y restauración](https://pve.proxmox.com/pve-docs/chapter-vzdump.html).
- [KVM: invitados anidados](https://docs.kernel.org/virt/kvm/x86/running-nested-guests.html).
- [Kernel Linux: presión de recursos PSI](https://docs.kernel.org/accounting/psi.html).
- [Cloud-init: limpieza de una base](https://docs.cloud-init.io/en/latest/reference/cli.html#clean).

## Curso CEP de apoyo por sesiones

[Introducción a Proxmox VE, de José Domingo Muñoz Rodríguez (IES Gonzalo Nazareno / CEP)](https://github.com/iesgn/curso_proxmox_cep).
Consulta revisada el 15 de septiembre de 2026. Los enlaces siguientes sirven
para repasar explicaciones y consultar los vídeos incluidos en las lecciones.

La instalación del curso utiliza Proxmox VE 7.1 sobre Debian 11 y el laboratorio
VirtualBox 6.1.34. Contrasta capturas, opciones y comandos con los manuales de
la versión instalada. Para la red sigue el diseño de esta práctica y la
[guía local de VirtualBox](../proxmox/virtualbox.md): NAT para salida y
solo-anfitrión para gestión/laboratorio según el diseño autorizado.

Las tareas y evidencias que debes entregar son las de nuestra
[práctica](../proyecto/practica.md). Las etiquetas «obligatoria» y «voluntaria»
del curso externo corresponden a aquel curso: aquí las copias y la restauración
son obligatorias. Mantén también el trabajo de inventario, GitHub, servicio ASO,
Bash, Ansible, rendimiento y defensa indicado en nuestras sesiones.

| Sesión | Consulta de apoyo | Aplicación a nuestra práctica |
|---|---|---|
| 4. Red de laboratorio | [Redes](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo7/introduccion.md) · [Red interna](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo7/red_interna.md) | Aplicar el direccionamiento y aislamiento del diseño aprobado; en VirtualBox, seguir la guía local de NAT y solo-anfitrión. |
| 7. Instalación | [Instalación](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo2/instalacion.md) · [Laboratorio VirtualBox](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo2/laboratorio.md) | El ejemplo usa Proxmox VE 7.1 y VirtualBox 6.1.34. Adaptar a la versión autorizada y al diseño local; el adaptador puente del curso no es la configuración de referencia de esta práctica. |
| 8. Acceso al nodo | [Acceso web](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo2/acceso.md) · [Interfaz](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo2/vista_general.md) | Comprobar opciones en la versión instalada. Para repositorios y actualización, seguir la documentación oficial y la guía de clase. |
| 10. Almacenamiento | [Almacenamiento](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo4/almacenamiento.md) · [Directory](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo4/directory.md) | Usar los discos y la capacidad previstos en el inventario; justificar dónde se guardan las copias. |
| 11. Usuarios y permisos | [Usuarios y grupos](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo8/usuarios.md) · [Permisos](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo8/permisos.md) | Aplicar roles al ámbito necesario y demostrar una operación permitida y otra denegada. |
| 13. Linux base | [VM Linux](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo3/creacion_linux.md) · [Contenedor LXC](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo6/contenedor.md) | Elegir VM o LXC según la modalidad validada. La actividad Windows del curso no forma parte de esta entrega. |
| 14. Agente del invitado | [QEMU guest agent](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo3/agent.md) | Aplicable a VMs QEMU/KVM; en LXC seguir la preparación de acceso de nuestra guía. |
| 15. Plantilla y clon | [Plantillas](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo5/plantillas.md) · [Clonación](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo5/clonacion.md) | Completar con la limpieza e identidad de clones exigidas en la práctica; distinguir plantilla VM de plantilla LXC. |
| 16. Validación de clones | [Clonación](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo5/clonacion.md) | Verificar arranque, acceso e identidades diferenciadas siguiendo el criterio de aceptación local. |
| 17. Servidor | [Gestión de VMs](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo3/gestion.md) · [Gestión de LXC](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo6/gestion.md) | Desplegar srv-aso desde la plantilla propia y registrar sus recursos e identidad. |
| 18. Cliente | [Gestión de VMs](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo3/gestion.md) · [Gestión de LXC](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo6/gestion.md) | Desplegar cli-linux y comprobar que su identidad y dirección no coinciden con las del servidor. |
| 19. Conectividad | [VM en red interna](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo7/conexion_red_intena.md) · [LXC en red interna](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo7/conexion_red_intena2.md) | Adaptar interfaces e IP al diagrama propio y documentar los recorridos cliente-servidor. |
| 29. Copias | [Snapshots](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo5/snapshot.md) · [Backups](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo5/backup.md) | En este proyecto son obligatorias la copia del invitado y la del servicio. Distinguir snapshot de backup. |
| 30. Restauración | [Backups y restauración](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo5/backup.md) | Demostrar la recuperación del invitado y del servicio, comprobar datos desde el cliente y registrar tiempos reales. |
| 32. Cortafuegos | [Cortafuegos Proxmox](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo7/cortafuegos.md) | Revisar la documentación oficial de la versión instalada y probar reglas dentro del laboratorio autorizado conservando el acceso de gestión. |

Para repasar conceptos antes de trabajar con invitados: [Virtualización](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo1/virtualizacion.md) · [Tipos de virtualización](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo1/tipos.md) · [Proxmox y LXC](https://github.com/iesgn/curso_proxmox_cep/blob/main/modulo6/introduccion.md).

## VirtualBox local

- [Virtualización anidada](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/AdvancedTopics.html).
- [Red NAT y solo-anfitrión](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/networkingdetails.html).
- [Gestión de las máquinas](https://docs.oracle.com/en/virtualization/virtualbox/7.2/user/working-with-vms.html).

## Ansible

- [Instalación y requisitos](https://docs.ansible.com/projects/ansible/latest/installation_guide/intro_installation.html).
- [Inventarios](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_inventory.html).
- [Variables](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_variables.html).
- [Facts](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_vars_facts.html).
- [Ansible: playbooks](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_intro.html).
- [Ansible: templates y validación](https://docs.ansible.com/projects/ansible/latest/collections/ansible/builtin/template_module.html).
- [Handlers](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_handlers.html).
- [Errores](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_error_handling.html).
- [Check y diff](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_checkmode.html).
- [Roles](https://docs.ansible.com/projects/ansible/latest/playbook_guide/playbooks_reuse_roles.html).
- [Colecciones](https://docs.ansible.com/projects/ansible/latest/collections_guide/collections_installing.html).
- [Ansible Vault](https://docs.ansible.com/projects/ansible/latest/vault_guide/index.html).

## Herramientas de la práctica

Referencias de consulta para ejecutar y validar los entregables; no constituyen
un bloque teórico de administración Linux.

- [Manual GNU Bash](https://www.gnu.org/software/bash/manual/bash.html).
- [Manual de rsync](https://download.samba.org/pub/rsync/rsync.1).
- [Nmap: estados de puertos](https://nmap.org/book/man-port-scanning-basics.html).

## GitHub y Markdown

- [Primer repositorio](https://docs.github.com/es/get-started/using-github/hello-world).
- [Autenticación](https://docs.github.com/es/authentication/keeping-your-account-and-data-secure/about-authentication-to-github).
- [Sintaxis de escritura](https://docs.github.com/es/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).
- [Ignorar archivos](https://docs.github.com/en/get-started/git-basics/ignoring-files).

## Procedencia del curso

Material adaptado de la práctica individual, primera sesión, secuenciación,
explicaciones y exposición del Proyecto Intermodular ASIR 2026-2027.
Mantiene el carácter integrador de análisis, diseño, ejecución, seguimiento
y defensa de la programación. La documentación oficial del módulo y las fechas
las comunica el departamento en Aules.

Las instrucciones dependen de las versiones y del entorno aprobado para el aula.
Consulta el manual de tu versión si una opción no coincide con la captura.

## Imagen del producto

`assets/proxmox-panel.png` es la
[captura oficial de métricas Proxmox VE 9.0](https://www.proxmox.com/images/proxmox/screenshots/Proxmox-VE-9-0-Metrics.png).
Crédito: **Proxmox Server Solutions GmbH**.
La captura se conserva sin alterar y se usa como referencia didáctica.
La [información de medios de Proxmox](https://www.proxmox.com/en/?catid=11&id=737%3Amedia-kit-2&view=article)
permite utilizar capturas con atribución.

Los esquemas Mermaid de capas, red, almacenamiento, clones y recuperación
son diagramas didácticos propios. No representan una instalación real ni
sustituyen el diagrama que debe documentar cada alumno.

Proxmox es una marca de su titular. Este curso no es documentación oficial ni
está afiliado a Proxmox. Los recursos enlazados conservan sus derechos.
