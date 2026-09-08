#!/usr/bin/env python3
"""Prueba el laboratorio Ansible en copias temporales, nunca sobre servidores."""
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs/recursos/archivos/ansible-laboratorio"
RECAP = re.compile(r"localhost\s+:\s+ok=\d+\s+changed=(\d+)\s+unreachable=(\d+)\s+failed=(\d+)")


def require(condition, message):
    if not condition:
        raise RuntimeError(message)


def validate():
    with tempfile.TemporaryDirectory(prefix="pi-ansible-test-") as directory:
        base = Path(directory)
        lab = base / "laboratorio"
        shutil.copytree(SOURCE, lab, ignore=shutil.ignore_patterns("salida"))
        config = base / "ansible.cfg"
        config.write_text(
            "[defaults]\nstdout_callback=default\nretry_files_enabled=False\n"
            "interpreter_python=auto_silent\n",
            encoding="utf-8",
        )
        env = dict(os.environ, ANSIBLE_CONFIG=str(config), ANSIBLE_NOCOLOR="1",
                   ANSIBLE_LOCAL_TEMP=str(base / "ansible-tmp"))

        def run(*options, expected_changes=None, fail=False):
            result = subprocess.run(
                [sys.executable, "-m", "ansible.cli.playbook", "-i", "inventory.yml",
                 "playbook.yml", *options],
                cwd=lab, env=env, capture_output=True, text=True, timeout=120,
            )
            output = result.stdout + result.stderr
            if fail:
                require(result.returncode != 0, "Se esperaba rechazo de la entrada\n" + output)
            else:
                require(result.returncode == 0, output)
            if expected_changes is not None:
                match = RECAP.search(output)
                require(match is not None, "Falta el resumen de localhost\n" + output)
                require(int(match[1]) == expected_changes and int(match[2]) == 0
                        and int(match[3]) == 0, "Resumen inesperado\n" + output)
            return output

        run("--syntax-check")
        run("--check", "--diff", expected_changes=2)
        require(not (lab / "salida").exists(), "Check mode ha creado la salida")
        print("OK: sintaxis y check mode sin crear salida", flush=True)

        first = run(expected_changes=2)
        report = lab / "salida/informe.md"
        original = report.read_text(encoding="utf-8")
        require("Fase: inventario" in original and "srv-aso: 2048 MiB" in original,
                "El informe no refleja las variables")
        require((lab / "salida").stat().st_mode & 0o777 == 0o700, "Modo de salida incorrecto")
        require(report.stat().st_mode & 0o777 == 0o600, "Modo del informe incorrecto")
        require("RUNNING HANDLER" in first, "No se ha notificado el handler")
        second = run(expected_changes=0)
        require("RUNNING HANDLER" not in second, "El handler se repite sin cambios")
        require(report.read_text(encoding="utf-8") == original, "La repeticion modifica contenido")
        print("OK: primera aplicacion e idempotencia, con permisos privados", flush=True)

        changed = run("--extra-vars", json.dumps({"fase": "despliegue"}), expected_changes=1)
        require("RUNNING HANDLER" in changed, "El cambio deseado no notifica")
        desired = report.read_text(encoding="utf-8")
        require("Fase: despliegue" in desired, "No se aplica el cambio deseado")
        run("--extra-vars", json.dumps({"fase": "despliegue"}), expected_changes=0)
        report.write_text(desired.replace("Fase: despliegue", "Fase: cambio-manual"),
                          encoding="utf-8")
        run("--extra-vars", json.dumps({"fase": "despliegue"}), expected_changes=1)
        require(report.read_text(encoding="utf-8") == desired, "No se corrige la deriva")
        run("--extra-vars", json.dumps({"fase": "despliegue"}), expected_changes=0)
        print("OK: cambio deseado, correccion de deriva y nueva idempotencia", flush=True)

        for values in ({"reserva_nodo_mib": 999999}, {"fase": "desconocida"},
                       {"invitados": [{"nombre": "srv", "ram_mib": 10},
                                      {"nombre": "srv", "ram_mib": 10}]}):
            run("--extra-vars", json.dumps(values), fail=True)
            require(report.read_text(encoding="utf-8") == desired,
                    "Una entrada invalida ha modificado el informe")
        print("OK: rechazo de presupuesto, fase y nombres invalidos sin escribir", flush=True)

        external = base / "archivo-ajeno.md"
        external.write_text("contenido ajeno\n", encoding="utf-8")
        report.unlink()
        report.symlink_to(external)
        run(fail=True)
        require(external.read_text(encoding="utf-8") == "contenido ajeno\n",
                "Se ha modificado un archivo externo")
        report.unlink()
        (lab / "salida").rmdir()
        (lab / "salida").symlink_to(base, target_is_directory=True)
        run(fail=True)
        require(not (base / "informe.md").exists(), "Se ha escrito fuera del laboratorio")
        print("OK: rechazo de enlaces en informe y directorio", flush=True)


if __name__ == "__main__":
    validate()

