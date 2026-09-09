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
