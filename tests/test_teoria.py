from pathlib import Path
import tempfile
import unittest
from zipfile import ZipFile

from tools.preparar_descargas import archive_tree

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"


class TheoryTest(unittest.TestCase):
    def test_new_chapters_are_in_navigation(self):
        nav = (ROOT / "mkdocs.yml").read_text(encoding="utf-8")
        chapters = [
            "proxmox/arquitectura.md", "proxmox/virtualizacion.md",
            "proxmox/recursos.md", "proxmox/redes-teoria.md",
            "proxmox/almacenamiento-teoria.md", "proxmox/clonado-teoria.md",
            "proxmox/operacion-recuperacion.md", "ansible/fundamentos.md",
            "ansible/inventario-conexion.md", "ansible/variables-plantillas.md",
            "ansible/playbooks.md", "ansible/organizacion-validacion.md",
            "ansible/laboratorio.md", "proyecto/automatizacion.md",
        ]
        for chapter in chapters:
            with self.subTest(chapter=chapter):
                self.assertTrue((DOCS / chapter).is_file())
                self.assertIn(chapter, nav)
        self.assertNotIn("Administrar Linux:", nav)
        self.assertNotIn("linux/", nav)

    def test_removed_theory_has_no_pages_or_links(self):
        self.assertEqual(list((DOCS / "linux").glob("*.md")), [])
        for page in DOCS.rglob("*.md"):
            with self.subTest(page=page):
                self.assertNotIn("../linux/", page.read_text(encoding="utf-8"))

    def test_local_lab_does_not_replace_project_requirements(self):
        guide = (DOCS / "ansible/laboratorio.md").read_text(encoding="utf-8")
        delivery = (DOCS / "proyecto/automatizacion.md").read_text(encoding="utf-8")
        self.assertIn("no cumple por", guide)
        self.assertIn("automatización", guide)
        self.assertIn("dos scripts Bash y un playbook Ansible", delivery)
        self.assertIn("srv-aso", delivery)

    def test_lab_archive_preserves_complete_sources(self):
        source = DOCS / "recursos/archivos/ansible-laboratorio"
        required = {"inventory.yml", "variables.yml", "playbook.yml",
                    "templates/informe.md.j2", ".gitignore"}
        self.assertEqual({p.relative_to(source).as_posix()
                          for p in source.rglob("*") if p.is_file()}, required)
        with tempfile.TemporaryDirectory(prefix="pi-lab-zip-") as directory:
            destination = Path(directory) / "laboratorio.zip"
            archive_tree(source, destination, "ansible-laboratorio")
            with ZipFile(destination) as archive:
                self.assertEqual(set(archive.namelist()),
                                 {"ansible-laboratorio/" + name for name in required})
                for name in required:
                    self.assertEqual(archive.read("ansible-laboratorio/" + name),
                                     (source / name).read_bytes())


if __name__ == "__main__":
    unittest.main()

