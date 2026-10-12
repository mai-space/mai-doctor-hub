// Rendert Icon und Vorstellungsgrafik nach store/android/ (braucht Playwright).
//   node tool/store_graphics/render.cjs <flutter>/bin/cache/artifacts/material_fonts
const { chromium } = require('playwright');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { pathToFileURL } = require('node:url');

const out = path.resolve(__dirname, '../../store/android');
const fonts = process.argv[2];
if (!fonts) throw new Error('Pfad zu material_fonts (Roboto) fehlt');

(async () => {
  const browser = await chromium.launch();
  async function render(html, size, file, query = '') {
    const page = await browser.newPage({ viewport: size, deviceScaleFactor: 1 });
    await page.goto(pathToFileURL(html).href + query);
    await page.evaluate(() => document.fonts.ready);
    fs.mkdirSync(path.dirname(file), { recursive: true });
    await page.screenshot({ path: file });
    await page.close();
  }

  // Schriftpfad einsetzen; die Vorlage im Repo bleibt ohne lokalen Pfad.
  const feature = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'store-')), 'feature.html');
  fs.writeFileSync(
    feature,
    fs.readFileSync(path.join(__dirname, 'feature.html'), 'utf8')
      .replaceAll('ROBOTO_DIR', pathToFileURL(fonts).href),
  );

  await render(path.join(__dirname, 'icon.html'), { width: 512, height: 512 }, path.join(out, 'icon-512.png'));
  for (const [lang, folder] of [['de', 'de-DE'], ['en', 'en-US']]) {
    await render(feature, { width: 1024, height: 500 }, path.join(out, folder, 'feature-graphic.png'), `?lang=${lang}`);
  }
  await browser.close();
})();
