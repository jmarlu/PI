import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

from tools.comprobar_enlaces import check_site
from tools.preparar_descargas import archive_tree
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parents[1]
FILES = ROOT / "docs/recursos/archivos"


class MaterialsTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="pi-test-")
        self.addCleanup(self.temp.cleanup)
        self.base = Path(self.temp.name)
        self.result = self.generate()
        self.project = self.base / "pi-proxmox-prueba-alumno"

    def generate(self):
        return subprocess.run(
            ["bash", str(FILES / "crear_estructura_entrega.sh"), "prueba_alumno", str(self.base)],
            capture_output=True, text=True,
        )

    def backup(self, **overrides):
        env = dict(os.environ, SOURCE_DATA=str(self.base / "datos"),
                   SOURCE_CONFIG=str(self.base / "smb.conf"),
                   BACKUP_ROOT=str(self.base / "copias"))
        env.update(overrides)
        return subprocess.run(
            ["bash", str(self.project / "scripts/backup_servicio.sh")],
            env=env, capture_output=True, text=True,
        )

    def seed_data(self):
        (self.base / "datos").mkdir()
        (self.base / "datos/prueba.txt").write_text("contenido de prueba\n")
        (self.base / "smb.conf").write_text("[global]\n")

    def test_required_structure_and_no_git(self):
        self.assertEqual(self.result.returncode, 0, self.result.stderr)
        required = ["README.md", ".gitignore", "docs/00-ficha-inicial.md",
                    "docs/00-bitacora.md", "docs/01-inventario-hardware.md",
                    "docs/10-memoria-tecnica.md", "scripts/inventario.sh",
                    "scripts/backup_servicio.sh", "ansible/inventory.ini",
                    "ansible/playbook.yml", "evidencias/README.md"]
        for name in required:
            self.assertGreater((self.project / name).stat().st_size, 0)
        self.assertFalse((self.project / ".git").exists())
        inventory = (self.project / "docs/01-inventario-hardware.md").read_text()
        for word in ("instalar", "limitaciones", "criticos"):
            self.assertIn(word, inventory.lower())
        journal = (self.project / "docs/00-bitacora.md").read_text()
        memory = (self.project / "docs/10-memoria-tecnica.md").read_text()
        for text in ("Acciones realizadas", "Pruebas y resultados", "Siguiente paso"):
            self.assertIn(text, journal)
        for text in ("Objetivo comprobable", "criterios de aceptacion", "no copies el"):
            self.assertIn(text, memory)

    def test_existing_work_is_preserved(self):
        readme = self.project / "README.md"
        readme.write_text("Trabajo propio\n")
        result = self.generate()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(readme.read_text(), "Trabajo propio\n")

    def test_shell_syntax(self):
        for path in list(FILES.glob("*.sh")) + list((self.project / "scripts").glob("*.sh")):
            result = subprocess.run(["bash", "-n", str(path)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)

    def test_missing_data_fails_without_success(self):
        result = self.backup()
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("Copia terminada", result.stdout)
        self.assertFalse((self.base / "copias").exists())

    def test_missing_config_fails(self):
        (self.base / "datos").mkdir()
        result = self.backup()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("falta configuracion", result.stderr)

    @unittest.skipUnless(shutil.which("rsync"), "rsync no instalado")
    def test_real_backup_and_unique_destinations(self):
        self.seed_data()
        for _ in range(2):
            result = self.backup()
            self.assertEqual(result.returncode, 0, result.stderr)
        copies = list((self.base / "copias").iterdir())
        self.assertEqual(len(copies), 2)
        for copy in copies:
            self.assertEqual((copy / "datos/prueba.txt").read_text(), "contenido de prueba\n")
            self.assertEqual((copy / "config/smb.conf").read_text(), "[global]\n")
            self.assertTrue((copy / "backup.log").is_file())
            self.assertEqual(copy.stat().st_mode & 0o777, 0o700)
        self.assertTrue((self.base / "datos/prueba.txt").is_file())

    @unittest.skipUnless(shutil.which("rsync"), "rsync no instalado")
    def test_destination_inside_source_fails(self):
        self.seed_data()
        result = self.backup(BACKUP_ROOT=str(self.base / "datos/copia"))
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("fuera", result.stderr)

    @unittest.skipUnless(shutil.which("rsync"), "rsync no instalado")
    def test_symlink_destination_inside_source_fails(self):
        self.seed_data()
        (self.base / "enlace").symlink_to(self.base / "datos", target_is_directory=True)
        result = self.backup(BACKUP_ROOT=str(self.base / "enlace/copia"))
        self.assertNotEqual(result.returncode, 0)

    def test_rsync_failure_not_reported_as_success(self):
        self.seed_data()
        fake = self.base / "bin"
        fake.mkdir()
        command = fake / "rsync"
        command.write_text("#!/bin/sh\nexit 23\n")
        command.chmod(0o750)
        result = self.backup(PATH=f"{fake}:{os.environ['PATH']}")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("copia incompleta", result.stderr)
        self.assertNotIn("Copia terminada", result.stdout)
        self.assertEqual(list((self.base / "copias").rglob("backup.log")), [])

    def test_checker_does_not_accept_non_git_directory(self):
        result = subprocess.run(
            ["bash", str(FILES / "comprobar_entrega_pi.sh"), "--inicio", str(self.project)],
            capture_output=True, text=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("revision web pendiente", result.stdout)

    def test_archive_is_deterministic_and_keeps_gitignore(self):
        one, two = self.base / "one.zip", self.base / "two.zip"
        archive_tree(self.project, one, "plantilla")
        archive_tree(self.project, two, "plantilla")
        self.assertEqual(one.read_bytes(), two.read_bytes())
        with ZipFile(one) as archive:
            self.assertIn("plantilla/.gitignore", archive.namelist())
            self.assertFalse(any("/.git/" in name for name in archive.namelist()))


class LinksTest(unittest.TestCase):
    def setUp(self):
        temp = tempfile.TemporaryDirectory(prefix="pi-links-")
        self.addCleanup(temp.cleanup)
        self.root = Path(temp.name)

    def test_nested_page_anchor_asset_and_base_path(self):
        (self.root / "index.html").write_text(
            '<a href="guia/#t%C3%ADtulo">Ir</a><a href="/curso/guia/">Base</a>'
        )
        (self.root / "guia").mkdir()
        (self.root / "guia/index.html").write_text(
            '<h1 id="título">Título</h1><a href="../fichero.zip">ZIP</a>'
        )
        (self.root / "fichero.zip").write_bytes(b"zip")
        self.assertEqual(check_site(self.root, "https://example.org/curso/"), [])

    def test_missing_target_and_anchor_are_errors(self):
        (self.root / "index.html").write_text(
            '<a href="#falta">Ancla</a><img src="no-existe.png">'
        )
        self.assertEqual(len(check_site(self.root)), 2)

    def test_external_urls_are_not_requested(self):
        (self.root / "index.html").write_text(
            '<a href="https://invalid.example/no-existe">Externo</a>'
        )
        self.assertEqual(check_site(self.root), [])

    def test_empty_site_fails(self):
        self.assertTrue(check_site(self.root))


class CourseTest(unittest.TestCase):
    def test_local_virtualbox_and_all_sessions(self):
        practice = (ROOT / "docs/proyecto/practica.md").read_text()
        self.assertIn("VirtualBox", practice)
        self.assertIn("sistema anfitrión", practice)
        for text in ("dentro del Proxmox del centro", "VM del centro", "Tipo host"):
            self.assertNotIn(text, practice)
        sessions = (ROOT / "docs/clases/index.md").read_text()
        numbers = re.findall(r"^\| \[(\d+)\]\(", sessions, re.MULTILINE)
        self.assertEqual([int(number) for number in numbers], list(range(1, 34)))
        self.assertIn("100 horas", sessions)

    def test_class_index_links_to_existing_materials(self):
        sessions = (ROOT / "docs/clases/index.md").read_text()
        destinations = re.findall(r"^\| \[\d+\]\(([^)]+)\)", sessions, re.MULTILINE)
        self.assertEqual(len(destinations), 33)
        for destination in destinations:
            path = (ROOT / "docs/clases" / destination.split("#", 1)[0]).resolve()
            with self.subTest(destination=destination):
                self.assertTrue(path.is_relative_to(ROOT / "docs"))
                self.assertTrue(path.is_file())

    def test_explanations_page_and_references_are_removed(self):
        self.assertFalse((ROOT / "docs/clases/explicaciones.md").exists())
        for page in list((ROOT / "docs").rglob("*.md")) + [ROOT / "mkdocs.yml"]:
            with self.subTest(page=page):
                self.assertNotIn("explicaciones.md", page.read_text())


if __name__ == "__main__":
    unittest.main()
