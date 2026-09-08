#!/usr/bin/env python3
"""Regenera las descargas desde los ejemplos versionados, sin acceso a GitHub."""
import hashlib
from pathlib import Path
import subprocess
import tempfile
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo

ROOT = Path(__file__).resolve().parents[1]
FILES = ROOT / "docs/recursos/archivos"


def archive_tree(source: Path, destination: Path, prefix: str) -> None:
    # Fecha y permisos estables para evitar cambios del ZIP sin cambios de contenido.
    with ZipFile(destination, "w", compression=ZIP_DEFLATED) as archive:
        for path in sorted(source.rglob("*")):
            if not path.is_file():
                continue
            name = f"{prefix}/{path.relative_to(source).as_posix()}"
            entry = ZipInfo(name, date_time=(2026, 1, 1, 0, 0, 0))
            entry.compress_type = ZIP_DEFLATED
            entry.create_system = 3
            entry.external_attr = (0o100750 if path.suffix == ".sh" else 0o100644) << 16
            archive.writestr(entry, path.read_bytes())


def main() -> None:
    for script in sorted(FILES.glob("*.sh")):
        subprocess.run(["bash", "-n", str(script)], check=True)
    with tempfile.TemporaryDirectory(prefix="pi-plantilla-") as directory:
        subprocess.run(
            ["bash", str(FILES / "crear_estructura_entrega.sh"), "apellido_nombre", directory],
            check=True,
        )
        archive_tree(
            Path(directory) / "pi-proxmox-apellido-nombre",
            FILES / "plantilla-alumno.zip",
            "pi-proxmox-apellido-nombre",
        )
    archive_tree(FILES / "ansible-samba", FILES / "ansible-samba.zip", "ansible")
    downloads = sorted(
        p for p in FILES.rglob("*") if p.is_file() and p.name != "SHA256SUMS.txt"
    )
    checksums = [
        f"{hashlib.sha256(p.read_bytes()).hexdigest()}  {p.relative_to(FILES).as_posix()}"
        for p in downloads
    ]
    (FILES / "SHA256SUMS.txt").write_text("\n".join(checksums) + "\n", encoding="utf-8")
    print(f"Descargas preparadas: {len(downloads)} archivos con SHA-256")


if __name__ == "__main__":
    main()
