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
  "clases/", "clases/presentacion/", "clases/explicaciones/", "proxmox/conceptos/", "proxmox/interfaz/",
  "proxmox/instalacion/", "proxmox/virtualbox/", "proxmox/red-almacenamiento/",
  "proxmox/plantillas/", "linux/servicio-aso/", "linux/automatizacion/",
  "linux/copias/", "linux/pruebas/", "recursos/descargas/", "recursos/incidencias/",
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
            route === "proxmox/red-almacenamiento/" || route === "proyecto/practica/") {
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
        if (route === "clases/explicaciones/") {
          assert.equal(await page.locator('article h2[id^="s"]').count(), 33);
        }
        if (route === "proyecto/practica/") {
          const body = await page.locator("article").innerText();
          assert.ok(body.includes("VirtualBox"));
          assert.ok(body.includes("Pregunta 1."));
          assert.ok(body.includes("Pregunta 2."));
          assert.ok(body.includes("Pregunta 3."));
        }
        if (["", "proxmox/virtualbox/", "proyecto/practica/", "recursos/descargas/"].includes(route)) {
          await page.screenshot({
            path: path.join(output, (route.replaceAll("/", "-") || "inicio") + viewport.width + ".png"),
            fullPage: route !== "proyecto/practica/" && route !== "proxmox/virtualbox/"
          });
        }
      }

      await page.goto(base);
      if (viewport.width < 800) {
        await page.locator('.md-header label[for="__drawer"]').click();
        await page.locator('.md-sidebar--primary').getByText("Conocer Proxmox", { exact: true }).first().click();
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

      for (const name of ["plantilla-alumno.zip", "ansible-samba.zip", "SHA256SUMS.txt"]) {
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
