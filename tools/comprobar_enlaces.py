#!/usr/bin/env python3
"""Valida destinos y anclas del HTML generado; no consulta sitios externos."""
import argparse
from html.parser import HTMLParser
import os
from pathlib import Path
from urllib.parse import unquote, urlsplit


class Page(HTMLParser):
    def __init__(self, text: str):
        super().__init__(convert_charrefs=True)
        self.ids: set[str] = set()
        self.refs: list[str] = []
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        attributes = dict(attrs)
        if attributes.get("id"):
            self.ids.add(attributes["id"])
        if tag == "a" and attributes.get("name"):
            self.ids.add(attributes["name"])
        for attribute in ("href", "src"):
            if attributes.get(attribute):
                self.refs.append(attributes[attribute])


def check_site(root: Path, base_url: str = "") -> list[str]:
    root = root.resolve()
    pages = {
        path: Page(path.read_text(encoding="utf-8"))
        for path in root.rglob("*.html")
    }
    if not pages:
        return ["No hay paginas HTML para comprobar."]
    base = urlsplit(base_url)
    prefix = base.path.rstrip("/") + "/" if base.path else "/"
    errors = []
    for source, page in pages.items():
        for reference in page.refs:
            link = urlsplit(reference)
            if link.scheme not in ("", "http", "https"):
                continue
            if link.netloc and (not base.netloc or link.netloc != base.netloc):
                continue
            path = unquote(link.path)
            if not path:
                target = source
            elif path.startswith("/"):
                if prefix != "/" and not path.startswith(prefix):
                    errors.append(f"{source.relative_to(root)}: fuera de la base: {reference}")
                    continue
                target = root / path[len(prefix):]
            else:
                target = source.parent / path
            target = target.resolve()
            if not target.is_relative_to(root):
                errors.append(f"{source.relative_to(root)}: sale del sitio: {reference}")
                continue
            if target.is_dir():
                target /= "index.html"
            if not target.is_file():
                errors.append(f"{source.relative_to(root)}: destino inexistente: {reference}")
            elif link.fragment and target in pages:
                fragment = unquote(link.fragment)
                if fragment not in pages[target].ids:
                    errors.append(f"{source.relative_to(root)}: ancla inexistente: {reference}")
    return sorted(set(errors))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("site", type=Path)
    parser.add_argument("--base-url", default=os.environ.get("SITE_URL", "http://127.0.0.1:8765/"))
    args = parser.parse_args()
    errors = check_site(args.site, args.base_url)
    if errors:
        print("\n".join(errors))
        raise SystemExit(1)
    print("OK: paginas, anclas y recursos locales sin enlaces rotos.")


if __name__ == "__main__":
    main()
