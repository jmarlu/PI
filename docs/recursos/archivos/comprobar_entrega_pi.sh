#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  comprobar_entrega_pi.sh [--inicio] RUTA_ENTREGA

Comprueba estructura minima, documentos, scripts Bash, Ansible y posibles
secretos en una entrega del Proyecto Intermodular, ademas del Git local
y su remoto GitHub. --inicio revisa solo el hito documental de la sesion 1.
No conecta a GitHub: acceso docente y publicacion requieren revision web.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

mode=final
if [[ "${1:-}" == "--inicio" ]]; then
  mode=inicio
  shift
fi
if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

root="${1%/}"
fails=0
warns=0

ok() { printf '[OK] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*"; warns=$((warns + 1)); }
fail() { printf '[FAIL] %s\n' "$*"; fails=$((fails + 1)); }

check_path() {
  local path="$1"
  if [[ -e "$root/$path" ]]; then
    ok "$path existe"
  else
    fail "$path no existe"
  fi
}

check_nonempty() {
  local path="$1"
  if [[ -s "$root/$path" ]]; then
    ok "$path tiene contenido"
  else
    fail "$path esta vacio o no existe"
  fi
}

if [[ ! -d "$root" ]]; then
  echo "ERROR: no existe la ruta $root" >&2
  exit 2
fi

echo "# Comprobacion de entrega PI"
echo "Ruta: $root"
echo

required_dirs=(
  docs
  scripts
  ansible
  evidencias
)

required_files=(
  README.md
  .gitignore
  docs/00-ficha-inicial.md
  docs/00-bitacora.md
  docs/10-memoria-tecnica.md
  evidencias/README.md
)

if [[ "$mode" == final ]]; then
required_files+=(
  docs/01-inventario-hardware.md
  docs/02-diagrama-red.md
  docs/03-instalacion-proxmox.md
  docs/04-plantilla-linux.md
  docs/05-vms-lxc.md
  docs/06-servicio-aso.md
  docs/07-automatizacion.md
  docs/08-copias-restauracion.md
  docs/09-rendimiento-seguridad.md
  scripts/inventario.sh
  scripts/backup_servicio.sh
  ansible/inventory.ini
  ansible/playbook.yml
)
fi

echo "## Estructura"
for dir in "${required_dirs[@]}"; do
  check_path "$dir"
done

echo
echo "## Ficheros obligatorios"
for file in "${required_files[@]}"; do
  check_nonempty "$file"
done

echo
echo "## Git local y GitHub"
if ! command -v git >/dev/null 2>&1; then
  fail "Git no esta instalado; no se puede comprobar el repositorio"
elif [[ "$(git -C "$root" rev-parse --show-toplevel 2>/dev/null || true)" != "$(cd "$root" && pwd -P)" ]]; then
  fail "la ruta debe ser la raiz de la copia Git del proyecto"
else
  ok "repositorio Git local encontrado"
  remote_url="$(git -C "$root" remote get-url origin 2>/dev/null || true)"
  if [[ "$remote_url" =~ ^(https://github\.com/|git@github\.com:|ssh://git@github\.com/)[A-Za-z0-9-]+/[A-Za-z0-9_.-]+/?$ ]]; then
    ok "origin apunta a un repositorio de github.com"
  else
    fail "origin debe usar una URL GitHub HTTPS o SSH sin credenciales incrustadas"
  fi
  if git -C "$root" rev-parse --verify HEAD >/dev/null 2>&1; then
    ok "hay historial de commits local"
    for file in "${required_files[@]}"; do
      if ! git -C "$root" cat-file -e "HEAD:$file" 2>/dev/null; then
        fail "$file no esta incluido en el ultimo commit"
      fi
    done
    if [[ -n "$(git -C "$root" status --porcelain)" ]]; then
      warn "hay cambios locales sin confirmar; revisar antes de entregar"
    fi
  else
    fail "no existe un primer commit"
  fi
fi
warn "revision web pendiente: comprobar publicacion, enlaces, contenido y acceso docente en GitHub"

if [[ "$mode" == final ]]; then
echo
echo "## Sintaxis Bash"
for script in "$root"/scripts/*.sh; do
  [[ -e "$script" ]] || { warn "no hay scripts .sh"; break; }
  if bash -n "$script"; then
    ok "$(basename "$script") sintaxis correcta"
  else
    fail "$(basename "$script") tiene errores de sintaxis"
  fi
done

echo
echo "## Ansible"
if command -v ansible-playbook >/dev/null 2>&1; then
  if ansible-playbook -i "$root/ansible/inventory.ini" "$root/ansible/playbook.yml" --syntax-check >/tmp/pi_ansible_check.log 2>&1; then
    ok "playbook.yml supera --syntax-check"
  else
    warn "playbook.yml no supera --syntax-check; revisa /tmp/pi_ansible_check.log"
  fi
else
  warn "ansible-playbook no esta instalado en este equipo"
fi

echo
echo "## Evidencias"
evidence_count=0
if [[ -d "$root/evidencias" ]]; then
  evidence_count="$(find "$root/evidencias" -type f ! -name README.md ! -name .gitkeep | wc -l)"
fi
if [[ "$evidence_count" -gt 0 ]]; then
  ok "hay $evidence_count fichero(s) de evidencia"
else
  warn "no se han encontrado ficheros en evidencias/"
fi
fi

echo
echo "## Posibles secretos"
secret_matches="$(grep -RIlE --exclude-dir=.git --exclude=.gitignore '(password|passwd|token|api[_-]?key|private key|BEGIN .*PRIVATE KEY)' "$root" 2>/dev/null || true)"
if [[ -n "$secret_matches" ]]; then
  warn "revisar estos ficheros: posibles secretos o menciones explicativas; no se muestra su contenido"
  printf '%s\n' "$secret_matches" | sed -n '1,20p'
else
  ok "no se han detectado patrones evidentes de secretos"
fi

echo
echo "## Resumen"
echo "Fallos: $fails"
echo "Avisos: $warns"

if [[ "$fails" -gt 0 ]]; then
  exit 1
fi

exit 0
