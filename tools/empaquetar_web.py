#!/usr/bin/env python3
"""Crea un ZIP para un repositorio nuevo, sin entorno virtual ni HTML generado."""
import argparse
from pathlib import Path
from preparar_descargas import archive_tree, main as prepare
import shutil
import tempfile

ROOT = Path(__file__).resolve().parents[1]
INCLUDED = [".github", ".gitignore", "mkdocs.yml", "requirements.txt", "README.md",
            "REVISION.md", "docs", "tools", "tests"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    destination = args.destination.resolve()
    if destination.is_relative_to(ROOT):
        parser.error("El ZIP de distribucion debe guardarse fuera de web_alumnado.")
    prepare()
    with tempfile.TemporaryDirectory(prefix="pi-web-") as directory:
        stage = Path(directory)
        for name in INCLUDED:
            source = ROOT / name
            if source.is_dir():
                shutil.copytree(source, stage / name, ignore=shutil.ignore_patterns("__pycache__", "*.pyc"))
            else:
                shutil.copy2(source, stage / name)
        archive_tree(stage, destination, "web_alumnado")
    print(f"Web lista para subir: {destination}")


if __name__ == "__main__":
    main()
