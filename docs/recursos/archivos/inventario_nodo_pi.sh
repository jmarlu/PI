#!/usr/bin/env bash
set -euo pipefail

output="${1:-}"

emit() {
  if [[ -n "$output" ]]; then
    tee -a "$output"
  else
    cat
  fi
}

run_cmd() {
  local title="$1"
  local status
  shift
  {
    echo "## $title"
    echo
    echo '```text'
    if "$@" 2>&1; then
      :
    else
      status=$?
      printf '\nEstado de salida: %s. Interpretar el resultado o documentar la limitacion.\n' "$status"
    fi
    echo '```'
    echo
  } | emit
}

if [[ -n "$output" ]]; then
  : > "$output"
fi

{
  echo "# Inventario de nodo PI"
  echo
  echo "- Fecha: $(date -Is)"
  echo "- Host: $(hostname -f 2>/dev/null || hostname)"
  echo "- Usuario: $(id -un)"
  echo
  echo "Datos de apoyo: contrastar con fuentes y completar el informe de viabilidad."
  echo "Identificar si se observa el equipo fisico o una VM; no inferir datos ocultos del host."
  echo "Revisar identificadores antes de publicar. systemd-detect-virt puede devolver 1 si no detecta virtualizacion."
  echo
} | emit

run_cmd "Sistema" hostnamectl
run_cmd "Entorno fisico o virtual" systemd-detect-virt
run_cmd "CPU" lscpu
run_cmd "Memoria" free -h
run_cmd "Discos y dispositivos visibles" lsblk -o NAME,TYPE,SIZE,MODEL,ROTA,TRAN
run_cmd "Dispositivos PCI y controladores" lspci -nnk
run_cmd "Espacio en disco" df -h
run_cmd "Red" ip -br addr
run_cmd "Rutas" ip route

if command -v VBoxManage >/dev/null 2>&1; then
  run_cmd "Version VirtualBox en el anfitrion" VBoxManage --version
  run_cmd "VMs locales registradas en VirtualBox" VBoxManage list vms
fi

if grep -Eq 'vmx|svm' /proc/cpuinfo 2>/dev/null; then
  {
    echo "## Virtualizacion CPU"
    echo
    echo "Extensiones vmx/svm visibles en este entorno."
    echo "No sustituyen la comprobacion de configuracion ni una prueba de virtualizacion funcional."
    echo
  } | emit
else
  {
    echo "## Virtualizacion CPU"
    echo
    echo "No se detecta vmx/svm en /proc/cpuinfo o no esta expuesto."
    echo "En una VM no permite concluir que la CPU fisica carezca de soporte. Consultar configuracion docente."
    echo
  } | emit
fi

if command -v pveversion >/dev/null 2>&1; then
  run_cmd "Version Proxmox" pveversion
fi

if command -v pvesm >/dev/null 2>&1; then
  run_cmd "Storage Proxmox" pvesm status
fi

if command -v qm >/dev/null 2>&1; then
  run_cmd "VMs Proxmox" qm list
fi

if command -v pct >/dev/null 2>&1; then
  run_cmd "Contenedores Proxmox" pct list
fi

run_cmd "Servicios fallidos" systemctl --failed --no-pager

if [[ $EUID -eq 0 ]] && command -v dmidecode >/dev/null 2>&1; then
  run_cmd "Fabricante del equipo" dmidecode -s system-manufacturer
  run_cmd "Modelo del equipo" dmidecode -s system-product-name
  run_cmd "Fabricante de placa" dmidecode -s baseboard-manufacturer
  run_cmd "Modelo de placa" dmidecode -s baseboard-product-name
  run_cmd "Version de firmware" dmidecode -s bios-version
else
  {
    echo "## Datos del equipo"
    echo
    echo "Ejecuta como root con dmidecode instalado para obtener fabricante/modelo."
    echo
  } | emit
fi

if [[ -n "$output" ]]; then
  echo "Inventario guardado en $output"
fi
