#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Uso:
  auditar_servicio_aso.sh IP_SERVIDOR [PUERTOS]

Ejemplos:
  ./auditar_servicio_aso.sh 10.50.0.11
  ./auditar_servicio_aso.sh 10.50.0.11 "22 139 445"

Ejecuta pruebas basicas desde el cliente: ping, puertos y nmap si existe.
USAGE
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

server_ip="$1"
ports="${2:-22 80 139 389 445 631}"

echo "# Auditoria basica de servicio ASO"
echo
echo "- Fecha: $(date -Is)"
echo "- Cliente: $(hostname -f 2>/dev/null || hostname)"
echo "- Servidor: $server_ip"
echo "- Puertos revisados: $ports"
echo

echo "## Ping"
echo '```text'
ping -c 4 "$server_ip" 2>&1 || true
echo '```'
echo

echo "## Puertos con nc"
if command -v nc >/dev/null 2>&1; then
  echo '```text'
  for port in $ports; do
    nc -zvw2 "$server_ip" "$port" 2>&1 || true
  done
  echo '```'
else
  echo "No esta instalado nc."
fi
echo

echo "## Nmap"
if command -v nmap >/dev/null 2>&1; then
  echo '```text'
  nmap -sV -Pn "$server_ip" -p "$(printf '%s' "$ports" | tr ' ' ',')" 2>&1 || true
  echo '```'
else
  echo "No esta instalado nmap."
fi
echo

echo "## Samba"
if command -v smbclient >/dev/null 2>&1; then
  echo '```text'
  smbclient -L "//$server_ip" -N 2>&1 || true
  echo '```'
else
  echo "No esta instalado smbclient."
fi
echo

echo "## Conclusion"
echo
echo "- Indica que puertos esperabas ver abiertos."
echo "- Justifica cualquier puerto abierto no previsto."
echo "- Anota incidencias y acciones correctivas."
