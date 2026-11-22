#!/bin/sh
# npm/npx and Playwright flows that ARTEX's skills run at runtime:
#   api-recon:      cd recon && npm install; node runtime_harvest.js config.json
#   playwright-cli: npx --no-install playwright --version; npx playwright test;
#                   video-start/-stop, tracing-start/-stop, screenshot, pdf
# Sourced by checks.sh (needs r, st, first_ver, $W, $B). Needs registry access.
r eco.npm "$(npm --version 2>&1 | first_ver)"
r eco.npx "$(npx --version 2>&1 | first_ver)"
r eco.npx.noinstall.playwright "$(timeout 60 npx --no-install playwright --version 2>&1 | first_ver)"
r eco.playwright "$(timeout 30 playwright --version 2>&1 | head -1)"
r eco.chromium.bin "$([ -x /usr/bin/chromium ] && /usr/bin/chromium --headless --no-sandbox --dump-dom "$B/" 2>/dev/null | grep -o 'DIFF OK' | head -1 || echo MISSING)"

# ---- prebuilt packages, no npm step (NODE_PATH) ---------------------------------
rm -rf "$W/pre"; mkdir -p "$W/pre/tests"; cp /app/skills/api-recon/scripts/runtime_harvest.js "$W/pre/"
cd "$W/pre" || exit 1
printf '{"baseUrl":"%s/","routes":["/","/spa.html"],"apiPattern":"/api/","waitMs":800,"perRouteMs":600}\n' "$B" >config.json
T=180 st pre-harvest node runtime_harvest.js config.json >/dev/null
r eco.pre.apirecon.api "$(grep -o '/api/user' api_merged.txt 2>/dev/null | sort -u | head -1)"
cat >tests/seed.spec.js <<EOF
const { test, expect } = require('@playwright/test');
test('title', async ({ page }) => { await page.goto('$B/'); await expect(page).toHaveTitle('DIFF OK'); });
EOF
PLAYWRIGHT_HTML_OPEN=never T=240 st pre-pt-default playwright test --reporter=line >/dev/null
r eco.pre.pwtest.default "$(grep -oE '[0-9]+ passed' "$W/pre-pt-default.log" | head -1)$(grep -m1 -oE "Executable doesn't exist at [^ ]+" "$W/pre-pt-default.log" | sed 's/.*ms-playwright\//missing:/')"
printf "module.exports = { use: { channel: 'chromium' } };\n" >playwright.config.js
PLAYWRIGHT_HTML_OPEN=never T=240 st pre-pt-channel playwright test --reporter=line >/dev/null
r eco.pre.pwtest.channel "$(grep -oE '[0-9]+ passed' "$W/pre-pt-channel.log" | head -1)$(grep -m1 -oE "Executable doesn't exist at [^ ]+|Cannot find module '[^']+'" "$W/pre-pt-channel.log" | sed 's/.*ms-playwright\//missing:/')"
r eco.browsers "$(ls "${PLAYWRIGHT_BROWSERS_PATH:-/root/.cache/ms-playwright}" | grep -v json | tr '\n' ' ')"
cd "$W" || exit 1

# ---- api-recon runtime harvest ------------------------------------------------
rm -rf "$W/recon"; mkdir -p "$W/recon"; cp -r /app/skills/api-recon/scripts/. "$W/recon/"
cd "$W/recon" || exit 1
r eco.apirecon.install "$(T=300 st api-install npm install)"
r eco.apirecon.puppeteer "$(node -e 'console.log(require("puppeteer-core/package.json").version)' 2>&1 | first_ver)"
printf '{"baseUrl":"%s/","routes":["/","/spa.html"],"apiPattern":"/api/","forward":true,"headless":true,"waitMs":800,"perRouteMs":600}\n' "$B" >config.json
r eco.apirecon.harvest "$(T=180 st api-harvest node runtime_harvest.js config.json)"
r eco.apirecon.api "$(grep -o '/api/user' api_merged.txt 2>/dev/null | sort -u | head -1)"
cd "$W" || exit 1

# ---- Playwright test runner (playwright-cli skill, test-generation reference) -----
rm -rf "$W/pt"; mkdir -p "$W/pt/tests"; cd "$W/pt" || exit 1
printf '{"name":"pt","private":true}\n' >package.json
r eco.pwtest.install "$(T=300 st pt-install npm install -D @playwright/test@1.64.1)"
cat >tests/seed.spec.js <<EOF
const { test, expect } = require('@playwright/test');
test('title', async ({ page }) => {
  await page.goto('$B/');
  await expect(page).toHaveTitle('DIFF OK');
});
EOF
printf "module.exports = { projects: [{ name: 'chromium', use: { browserName: 'chromium' } }] };\n" >playwright.config.js
PLAYWRIGHT_HTML_OPEN=never T=240 st pt-run npx playwright test --reporter=line >/dev/null
r eco.pwtest.run "$(grep -oE '[0-9]+ passed' "$W/pt-run.log" | head -1 || true)"
r eco.pwtest.err "$(grep -m1 -oE "Executable doesn't exist|browserType.launch: [^\n]{0,60}" "$W/pt-run.log")"
cd "$W" || exit 1

# ---- playwright-cli artifacts (video, tracing, screenshot, pdf) ---------------------
rm -rf "$W/art"; mkdir -p "$W/art"; cd "$W/art" || exit 1
T=90 st cli-open playwright-cli open "$B/spa.html" --browser=chromium >/dev/null
timeout 60 playwright-cli video-start v.webm >"$W/cli-video.log" 2>&1
timeout 60 playwright-cli goto "$B/" >>"$W/cli-video.log" 2>&1
timeout 60 playwright-cli video-stop >>"$W/cli-video.log" 2>&1
timeout 60 playwright-cli tracing-start >"$W/cli-trace.log" 2>&1
timeout 60 playwright-cli goto "$B/p2.html" >>"$W/cli-trace.log" 2>&1
timeout 60 playwright-cli tracing-stop >>"$W/cli-trace.log" 2>&1
timeout 60 playwright-cli screenshot >"$W/cli-shot.log" 2>&1
timeout 60 playwright-cli pdf >"$W/cli-pdf.log" 2>&1
timeout 30 playwright-cli close >/dev/null 2>&1
found() { f="$(find "$W/art" -name "$1" -size +0 2>/dev/null | head -1)"; [ -n "$f" ] && echo present || echo "none:$(tail -c 100 "$2" | tr '\n' ' ')"; }
r eco.cli.video "$(found '*.webm' "$W/cli-video.log")"
r eco.cli.trace "$(found '*.trace' "$W/cli-trace.log")"
r eco.cli.screenshot "$(found '*.png' "$W/cli-shot.log")"
r eco.cli.pdf "$(found '*.pdf' "$W/cli-pdf.log")"
cd "$W" || exit 1
