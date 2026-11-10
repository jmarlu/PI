const { chromium } = require("playwright");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const { PNG } = require("pngjs");

const base = process.env.PREVIEW_URL || "http://127.0.0.1:8765/";
const output = process.env.SCREENSHOT_DIR || "/tmp/pi-web-capturas";
fs.mkdirSync(output, { recursive: true });
const routes = [
  "", "proyecto/primera-sesion/", "proyecto/practica/", "proyecto/evaluacion/",
  "proyecto/fase-0-inicio/", "proyecto/fase-1-inventario/", "proyecto/fase-2-red/",
  "proyecto/fase-3-instalacion/", "proyecto/fase-4-configuracion/", "proyecto/fase-5-plantilla/",
  "proyecto/fase-6-despliegue/", "proyecto/fase-7-servicio/", "proyecto/fase-8-automatizacion/",
  "proyecto/fase-9-copias/", "proyecto/fase-10-rendimiento/", "proyecto/fase-11-seguridad/",
  "proyecto/entrega/",
  "clases/", "clases/presentacion/", "proxmox/conceptos/", "proxmox/interfaz/",
  "proxmox/instalacion/", "proxmox/virtualbox/", "proxmox/red-almacenamiento/",
  "proxmox/plantillas/", "proxmox/arquitectura/", "proxmox/virtualizacion/",
  "proxmox/recursos/", "proxmox/redes-teoria/", "proxmox/almacenamiento-teoria/",
  "proxmox/clonado-teoria/", "proxmox/operacion-recuperacion/",
  "ansible/fundamentos/", "ansible/inventario-conexion/", "ansible/variables-plantillas/",
  "ansible/playbooks/", "ansible/organizacion-validacion/", "ansible/laboratorio/",
  "proyecto/automatizacion/", "recursos/descargas/", "recursos/incidencias/",
  "recursos/glosario/", "recursos/fuentes/"
];

(async () => {
  const browser = await chromium.launch({ headless: true });
  const failures = [];
  try {
    for (const viewport of [{ width: 1440, height: 1000 }, { width: 390, height: 844 }]) {
      const context = await browser.newContext({ viewport, deviceScaleFactor: 1 });
      const page = await context.newPage();
      page.on("pageerror", error => failures.push(error.message));
      for (const route of routes) {
        const response = await page.goto(new URL(route, base).href, { waitUntil: "domcontentloaded" });
        assert.equal(response.status(), 200, route);
        assert.ok(await page.locator("article h1").isVisible(), route);
        await page.waitForFunction(() => [...document.querySelectorAll("article img")]
          .every(img => img.complete), { timeout: 10000 });
        const layout = await page.evaluate(() => ({
          viewport: innerWidth, width: document.documentElement.scrollWidth,
          brokenImages: [...document.querySelectorAll("article img")]
            .filter(img => !img.complete || !img.naturalWidth).map(img => img.src)
        }));
        assert.ok(layout.width <= layout.viewport + 1, JSON.stringify({ route, ...layout }));
        assert.deepEqual(layout.brokenImages, [], route);
        if (route === "proxmox/conceptos/" || route === "proxmox/virtualbox/" ||
            route === "proxmox/red-almacenamiento/" || route === "proyecto/fase-2-red/") {
          await page.locator(".mermaid").first().scrollIntoViewIfNeeded();
          // Material aloja el SVG en un shadow root cerrado; CDP permite inspeccionarlo.
          const diagram = page.locator("div.mermaid").first();
          await diagram.waitFor({ state: "visible", timeout: 20000 });
          const box = await diagram.boundingBox();
          assert.ok(box && box.width > 100 && box.height > 80, route);
          const cdp = await context.newCDPSession(page);
          const { root } = await cdp.send("DOM.getDocument", { depth: -1, pierce: true });
          const nodes = [];
          const visit = node => {
            nodes.push(node);
            for (const child of [...(node.children || []), ...(node.shadowRoots || [])]) visit(child);
          };
          visit(root);
          assert.ok(nodes.some(node => node.nodeName.toLowerCase() === "svg" &&
            (node.attributes || []).some(value => value.startsWith("__mermaid_"))), route);
          await cdp.detach();
          const bitmap = await diagram.screenshot({ path: path.join(output,
            "diagrama-" + route.replaceAll("/", "-") + viewport.width + ".png") });
          const pixels = PNG.sync.read(bitmap);
          let colored = 0;
          for (let i = 0; i < pixels.data.length; i += 4) {
            if (pixels.data[i] < 225 || pixels.data[i + 1] < 225 || pixels.data[i + 2] < 225) colored++;
          }
          assert.ok(colored > 200, "Diagrama en blanco: " + route);
        }
        if (route === "clases/") {
          const sessions = page.locator("article table").nth(1).locator("tbody tr");
          assert.equal(await sessions.count(), 33);
          for (let index = 0; index < 33; index++) {
            const link = sessions.nth(index).locator("td").first().locator("a");
            assert.equal(await link.innerText(), String(index + 1));
            const destination = await link.getAttribute("href");
            assert.ok(destination && !destination.includes("explicaciones"));
          }
        }
        if (route === "proyecto/practica/") {
          const body = await page.locator("article").innerText();
          assert.ok(body.includes("VirtualBox"));
          assert.equal(await page.locator('article table a[href*="fase-"]').count(), 12);
        }
        if (route === "proyecto/fase-1-inventario/") {
          const body = await page.locator("article").innerText();
          assert.ok(body.includes("Pregunta 1."));
          assert.ok(body.includes("Pregunta 2."));
          assert.ok(body.includes("Pregunta 3."));
        }
        assert.equal(await page.locator('.md-sidebar--primary a[href*="/linux/"]').count(), 0);
        assert.equal(await page.locator('a[href*="clases/explicaciones"]').count(), 0);
        if (["", "clases/", "clases/presentacion/", "proxmox/virtualbox/", "proyecto/practica/", "proyecto/fase-1-inventario/", "recursos/descargas/",
             "ansible/laboratorio/", "ansible/variables-plantillas/", "proxmox/recursos/"].includes(route)) {
          await page.screenshot({
            path: path.join(output, (route.replaceAll("/", "-") || "inicio") + viewport.width + ".png"),
            fullPage: route === "" || route === "recursos/descargas/"
          });
        }
      }

      await page.goto(new URL("clases/presentacion/", base).href);
      await page.getByRole("link", { name: "calendario de las 33 sesiones y sus hitos" }).click();
      await page.waitForURL("**/clases/");
      await page.locator("article table").nth(1).locator("tbody tr").nth(26).locator("td a").first().click();
      await page.waitForURL("**/ansible/inventario-conexion/");

      const removed = await context.request.get(new URL("clases/explicaciones/", base).href);
      assert.equal(removed.status(), 404);
      const searchIndex = await (await context.request.get(new URL("search/search_index.json", base).href)).json();
      assert.ok(searchIndex.docs.every(doc => !doc.location.startsWith("clases/explicaciones/")));

      await page.goto(base);
      if (viewport.width < 800) {
        await page.locator('.md-header label[for="__drawer"]').click();
        await page.locator('.md-sidebar--primary').getByText("Taller de Proxmox", { exact: true }).first().click();
        await page.locator('.md-sidebar--primary a[href$="proxmox/virtualbox/"]').click();
        await page.waitForURL("**/proxmox/virtualbox/");
      }
      if (viewport.width < 800) {
        await page.locator('.md-header__button[for="__search"]').click();
      }
      const search = page.locator('input[data-md-component="search-query"]');
      await search.click();
      await search.pressSequentially("VirtualBox", { delay: 100 });
      await page.waitForFunction(() => {
        const result = document.querySelector('[data-md-component="search-result"]');
        return result && result.querySelectorAll("a").length > 0;
      });
      assert.ok((await page.locator('[data-md-component="search-result"]').innerText()).includes("VirtualBox"));
      await page.screenshot({ path: path.join(output, "busqueda-" + viewport.width + ".png") });
      await page.keyboard.press("Escape");

      for (const name of ["plantilla-alumno.zip", "ansible-samba.zip", "ansible-laboratorio.zip", "SHA256SUMS.txt"]) {
        const response = await context.request.get(new URL("recursos/archivos/" + name, base).href);
        assert.equal(response.status(), 200, name);
        assert.ok((await response.body()).length > 100, name);
      }
      console.log(JSON.stringify({ viewport, pages: routes.length, search: "OK", downloads: "OK" }));
      await context.close();
    }
    assert.deepEqual(failures, []);
    console.log("OK: navegación, búsqueda, diagramas, imágenes y descargas. Capturas en " + output);
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exit(1); });
