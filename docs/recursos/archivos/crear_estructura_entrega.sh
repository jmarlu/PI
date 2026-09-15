#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  crear_estructura_entrega.sh APELLIDO_NOMBRE [DESTINO]

Ejemplo:
  ./crear_estructura_entrega.sh garcia_maria ./entregas

Crea la estructura local para el repositorio GitHub del proyecto:
README, .gitignore, ficha, bitacora, memoria, scripts, Ansible y evidencias.
No inicializa Git ni publica en GitHub; el alumno realiza esos pasos.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

raw_name="$1"
base_dir="${2:-.}"

slug="$(printf '%s' "$raw_name" \
  | tr '[:upper:]' '[:lower:]' \
  | tr -cs '[:alnum:]' '-' \
  | sed 's/^-//; s/-$//')"

if [[ -z "$slug" ]]; then
  echo "ERROR: nombre no valido." >&2
  exit 1
fi

project_dir="${base_dir%/}/pi-proxmox-${slug}"

if [[ -e "$project_dir" ]]; then
  echo "ERROR: ya existe $project_dir" >&2
  exit 1
fi

mkdir -p \
  "$project_dir/docs" \
  "$project_dir/scripts" \
  "$project_dir/ansible" \
  "$project_dir/evidencias/capturas-o-salidas"

cat > "$project_dir/README.md" <<EOF_README
# Proyecto Intermodular: nodo Proxmox individual

Alumno/a: ${raw_name}

URL GitHub: PENDIENTE

## Objetivo

PENDIENTE: explicar la necesidad que resolvera el laboratorio.

## Modalidad

PENDIENTE: fisica o virtualizada; justificar la eleccion.

## Indice de documentacion

- [Ficha inicial](docs/00-ficha-inicial.md)
- [Bitacora de sesiones](docs/00-bitacora.md)
- [Inventario](docs/01-inventario-hardware.md)
- [Diagrama de red](docs/02-diagrama-red.md)
- [Instalacion de Proxmox](docs/03-instalacion-proxmox.md)
- [Plantilla Linux](docs/04-plantilla-linux.md)
- [VMs y LXC](docs/05-vms-lxc.md)
- [Servicio ASO](docs/06-servicio-aso.md)
- [Automatizacion Bash y Ansible](docs/07-automatizacion.md)
- [Copias y restauracion](docs/08-copias-restauracion.md)
- [Rendimiento y seguridad](docs/09-rendimiento-seguridad.md)
- [Memoria tecnica](docs/10-memoria-tecnica.md)
- [Evidencias](evidencias/README.md)

## Estado

- [ ] GitHub creado y primer commit publicado
- [ ] URL entregada y acceso docente comprobado
- [ ] Modalidad indicada
- [ ] Inventario
- [ ] Diagrama de red
- [ ] Instalacion Proxmox
- [ ] Plantilla Linux
- [ ] VMs/LXC
- [ ] Servicio ASO
- [ ] Scripts Bash
- [ ] Ansible
- [ ] Copias y restauracion
- [ ] Rendimiento y seguridad
- [ ] Memoria final
EOF_README

cat > "$project_dir/.gitignore" <<'EOF_IGNORE'
# Credenciales y configuracion privada local
.env
.env.*
!.env.example
*.pem
*.key
id_rsa*
id_ed25519*
.vault_pass*
.vault-password*
secrets/
*.local.ini
*.local.yml

# Imagenes y copias: usar el almacenamiento autorizado
*.iso
*.qcow2
*.vmdk
*.vdi
*.raw
*.img
*.vma*
*.tar
*.tar.*
*.zip
backups/

# Archivos temporales
*.retry
*.swp
*~
.DS_Store
EOF_IGNORE

cat > "$project_dir/docs/00-ficha-inicial.md" <<'EOF_FICHA'
# Ficha inicial

| Campo | Contenido |
|---|---|
| Identificador del alumno | PENDIENTE |
| URL GitHub | PENDIENTE |
| Acceso docente comprobado | PENDIENTE |
| Modalidad fisica o virtualizada | PENDIENTE |
| Recursos conocidos | PENDIENTE |
| Nombre del nodo | PENDIENTE |
| Servicio ASO previsto | PENDIENTE |
| Red de laboratorio | PENDIENTE |
| Riesgos y dudas iniciales | PENDIENTE |

[Volver al indice](../README.md)
EOF_FICHA

cat > "$project_dir/docs/00-bitacora.md" <<'EOF_BITACORA'
# Bitacora de sesiones

La bitacora es el registro cronologico del trabajo. Anade una entrada al final
de cada sesion y conserva las anteriores. Escribe datos comprobables y enlaza
las evidencias utiles; evita frases generales como "he trabajado en Proxmox".

## Sesion 01 - FECHA

- Objetivo: iniciar GitHub y la documentacion Markdown.
- Acciones realizadas: PENDIENTE: configuraciones, cambios o investigacion.
- Decisiones y motivos: PENDIENTE: eleccion realizada y alternativas valoradas.
- Pruebas y resultados: PENDIENTE: resultado esperado, comando o metodo y resultado obtenido.
- Documentos o evidencias: [Ficha inicial](00-ficha-inicial.md).
- Incidencias y solucion o estado pendiente: PENDIENTE.
- Siguiente paso: PENDIENTE: accion concreta para la proxima sesion.

Anadir una entrada con esta estructura en cada sesion. El historial de
GitHub registra los commits; no hace falta incluir el hash del propio
commit dentro de su entrada de bitacora.

[Volver al indice](../README.md)
EOF_BITACORA

cat > "$project_dir/docs/01-inventario-hardware.md" <<'EOF_HARDWARE'
# Inventario investigado y viabilidad

## Contexto de la observacion

- Fecha y sistema utilizado: PENDIENTE.
- Modalidad, equipo anfitrion y VM VirtualBox si procede: PENDIENTE.
- Version de Proxmox prevista: PENDIENTE.

## Inventario inicial

| Area | Dato observado y evidencia | Especificacion y fuente | Limite o diferencia | Justificacion |
|---|---|---|---|---|
| CPU | | | | |
| RAM | | | | |
| Almacenamiento | | | | |
| Red | | | | |
| Plataforma | | | | |

## 1. Puedo instalar Proxmox en este equipo?

Contrastar el inventario con requisitos oficiales de la version prevista.
Responder por separado y justificar con datos y fuentes:

- Puedo instalar y arrancar Proxmox: PENDIENTE.
- Puedo ejecutar el servidor ASO y el cliente del proyecto: PENDIENTE.
- Condiciones o comprobaciones pendientes: PENDIENTE.

## 2. Que limitaciones tendre con este hardware?

Analizar RAM, CPU, disco y red para las cargas previstas. Identificar lo
medido y lo estimado. En VirtualBox, investigar host real y VM: version,
RAM reservada al anfitrion, vCPU, VDI, espacio fisico y red local.
No se utiliza el Proxmox del centro como recurso.

### Reparto de recursos

| Elemento | CPU/vCPU | RAM | Disco | Justificacion |
|---|---|---|---|---|
| Proxmox | | | | |
| srv-aso | | | | |
| cli-linux | | | | |
| Plantilla, ISOs y copias | No aplica | No aplica | | |
| Margen de operacion | | | | |

Mostrar calculos de RAM y disco, reparto de vCPU, unidades y supuestos.
Explicar las cargas que pueden funcionar simultaneamente.

| Limitacion | Evidencia o estimacion | Consecuencia | Medida y limite que permanece |
|---|---|---|---|
| | | | |

## 3. Que componentes son mas criticos en mi servidor y por que?

Ordenar al menos tres componentes para este equipo y su servicio.
Distinguir cuello de botella, disponibilidad e integridad de los datos.

| Prioridad y componente | Funcion | Efecto si es insuficiente | Efecto si falla | Evidencia y justificacion |
|---|---|---|---|---|
| 1. | | | | |
| 2. | | | | |
| 3. | | | | |

Componente que mejoraria primero y motivo para priorizarlo frente a otro:
PENDIENTE.

## Fuentes tecnicas

Consultar al menos tres fuentes primarias, incluyendo Proxmox y
fabricante o plataforma virtual. Relacionarlas con las tres respuestas.

| Fuente y URL | Version/modelo y fecha de consulta | Afirmacion respaldada | Aplicacion al nodo |
|---|---|---|---|
| | | | |

## Dictamen de viabilidad

Apto, apto con condiciones o no apto para la propuesta actual: PENDIENTE.

Sintetizar las tres respuestas y las condiciones pendientes de comprobar.

## Evidencias y revision docente

Enlazar salidas revisadas desde ../evidencias/. Un listado automatico no
sustituye la investigacion. Registrar la pregunta de defensa y respuesta.

[Volver al indice](../README.md)
EOF_HARDWARE

for doc in \
  02-diagrama-red.md \
  03-instalacion-proxmox.md \
  04-plantilla-linux.md \
  05-vms-lxc.md \
  06-servicio-aso.md \
  07-automatizacion.md \
  08-copias-restauracion.md \
  09-rendimiento-seguridad.md
do
  title="${doc%.md}"
  cat > "$project_dir/docs/$doc" <<EOF_DOC
# ${title}

## Objetivo

## Procedimiento

## Comandos usados

\`\`\`bash

\`\`\`

## Evidencias

## Incidencias

## Conclusion

[Volver al indice](../README.md)
EOF_DOC
done

cat > "$project_dir/docs/10-memoria-tecnica.md" <<'EOF_MEMORIA'
# Memoria tecnica: nodo Proxmox individual

La memoria presenta el resultado tecnico por temas. Debe explicar como esta
construido el laboratorio, por que se tomaron las decisiones y con que pruebas
se demostro su funcionamiento. Usa la bitacora como fuente, pero no copies el
diario completo: resume la configuracion final, los resultados y las
limitaciones que sigan abiertas.

## Resumen

PENDIENTE: describir en un parrafo que se va a construir, para quien y con que
resultado esperado. Revisar este resumen al cerrar el proyecto.

## Necesidad y objetivos

Necesidad que atiende el laboratorio: PENDIENTE.

- Objetivo comprobable 1: PENDIENTE.
- Objetivo comprobable 2: PENDIENTE.
- Objetivo comprobable 3: PENDIENTE.

## Alcance y criterios de aceptacion

PENDIENTE: indicar que incluye el proyecto, que queda fuera y que pruebas
permitiran considerar aceptado cada resultado principal.

## Modalidad e inventario

[Inventario](01-inventario-hardware.md)

## Diseno de red

[Diagrama y direccionamiento](02-diagrama-red.md)

## Instalacion y configuracion de Proxmox

[Procedimiento](03-instalacion-proxmox.md)

## Plantilla Linux y despliegue

[Plantilla](04-plantilla-linux.md) y [VMs/LXC](05-vms-lxc.md)

## Servicio ASO

[Instalacion y pruebas](06-servicio-aso.md)

## Automatizacion con Bash y Ansible

[Automatizacion](07-automatizacion.md)

## Copias y restauracion

[Procedimiento y validacion](08-copias-restauracion.md)

## Rendimiento y seguridad

[Resultados](09-rendimiento-seguridad.md)

## Incidencias y decisiones

[Bitacora](00-bitacora.md)

## Presupuesto y sostenibilidad

## Conclusiones

## Fuentes y anexos

[Evidencias](../evidencias/README.md) y [volver al indice](../README.md)
EOF_MEMORIA

cat > "$project_dir/evidencias/README.md" <<'EOF_EVIDENCIAS'
# Evidencias del proyecto

Guardar capturas o salidas revisadas en capturas-o-salidas/ con nombres
como s07-panel-proxmox.png. Enlazar cada evidencia desde el documento
Markdown de su fase y explicar procedimiento, resultado y conclusion.

No incluir credenciales ni datos personales. Guardar ISOs, discos y
backups en el almacenamiento autorizado y documentar su ubicacion y las
pruebas de recuperacion en docs/08-copias-restauracion.md.

[Volver al indice](../README.md)
EOF_EVIDENCIAS

cat > "$project_dir/scripts/inventario.sh" <<'EOF_INV'
#!/usr/bin/env bash
set -euo pipefail

echo "# Inventario del sistema"
echo
echo "Fecha: $(date -Is)"
echo "Host: $(hostname -f 2>/dev/null || hostname)"
echo

run() {
  local title="$1"
  shift
  echo "## $title"
  echo
  echo '```text'
  "$@" 2>&1 || true
  echo '```'
  echo
}

run "CPU" lscpu
run "Memoria" free -h
run "Discos" lsblk
run "Red" ip -br addr
run "Rutas" ip route
run "Espacio" df -h

if command -v pveversion >/dev/null 2>&1; then
  run "Proxmox" pveversion
fi
EOF_INV

cat > "$project_dir/scripts/backup_servicio.sh" <<'EOF_BACKUP'
#!/usr/bin/env bash
set -euo pipefail

backup_root="${BACKUP_ROOT:-/backup/servicio-aso}"
source_data="${SOURCE_DATA:-/srv/grupo_asir}"
source_config="${SOURCE_CONFIG:-/etc/samba/smb.conf}"
[[ -d "$source_data" ]] || { echo "ERROR: faltan datos: $source_data" >&2; exit 1; }
[[ -f "$source_config" ]] || { echo "ERROR: falta configuracion: $source_config" >&2; exit 1; }
command -v rsync >/dev/null || { echo "ERROR: instala rsync" >&2; exit 1; }

# Impide incluir el destino dentro del origen y copiarlo recursivamente.
source_real="$(realpath "$source_data")"
backup_real="$(realpath -m "$backup_root")"
if [[ "$source_real" == / || "$backup_real" == "$source_real" || "$backup_real" == "$source_real/"* ]]; then
  echo "ERROR: el destino debe estar fuera del directorio de datos" >&2
  exit 1
fi
mkdir -p "$backup_root"
umask 077
dest="$(mktemp -d "${backup_root}/$(date +%Y-%m-%d_%H%M%S)-XXXXXX")"
trap 'echo "ERROR: copia incompleta; revisar $dest" >&2' ERR
mkdir "$dest/datos" "$dest/config"
echo "Iniciando copia en $dest"
rsync -aHAX "$source_data"/ "$dest/datos"/
cp -a "$source_config" "$dest/config/"

{
  echo "fecha=$(date -Is)"
  echo "origen_datos=$source_data"
  echo "origen_config=$source_config"
  echo "destino=$dest"
} > "$dest/backup.log"

echo "Copia terminada: $dest"
EOF_BACKUP

cat > "$project_dir/ansible/inventory.ini" <<'EOF_INVENTORY'
[srv_aso]
srv-aso ansible_host=IP_SRV_ASO ansible_user=USUARIO_ADMIN

[srv_aso:vars]
ansible_become=true
EOF_INVENTORY

cat > "$project_dir/ansible/playbook.yml" <<'EOF_PLAYBOOK'
---
- name: Configuracion base del servicio ASO
  hosts: srv_aso
  become: true

  vars:
    grupo_aso: grupo_asir
    recurso_aso: /srv/grupo_asir

  tasks:
    - name: Instalar paquetes base
      ansible.builtin.apt:
        name:
          - samba
          - acl
          - smbclient
          - rsync
        state: present
        update_cache: true

    - name: Crear grupo del servicio
      ansible.builtin.group:
        name: "{{ grupo_aso }}"
        state: present

    - name: Crear directorio compartido
      ansible.builtin.file:
        path: "{{ recurso_aso }}"
        state: directory
        owner: root
        group: "{{ grupo_aso }}"
        mode: "2770"

    - name: Asegurar servicio Samba activo
      ansible.builtin.service:
        name: smbd
        state: started
        enabled: true
EOF_PLAYBOOK

chmod 750 "$project_dir/scripts/"*.sh

echo "Estructura creada en: $project_dir"
echo "Completa los documentos y sigue Primera_Sesion_GitHub_Markdown.md para publicar."
