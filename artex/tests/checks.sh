#!/bin/sh
# In-container differential checks. Mounted read-only at /t and run as the
# ARTEX executor (uid 10001, HOME/XDG_CACHE_HOME under a scratch home, as
# server/execpriv_unix.go sets them) unless CHECK_AS=root.
# Emits "<check>\t<value>" lines; values are normalized for comparison.
set -u
export PATH="$PATH:/usr/sbin:/sbin"
W="${HOME}/work"; mkdir -p "$W"; cd "$W" || exit 1
r() { printf '%s\t%s\n' "$1" "$2"; }
first_ver() { grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1; }
ver() { n="$1"; shift
  if ! command -v "$1" >/dev/null 2>&1; then r "ver.$n" MISSING; return; fi
  v="$("$@" 2>&1 | first_ver)"; r "ver.$n" "${v:-unparsed}"; }
has() { for c in "$@"; do command -v "$c" >/dev/null 2>&1 && r "bin.$c" present || r "bin.$c" MISSING; done; }
# status of a command: ok / exit code. Output kept in $W/<name>.log for triage.
st() { n="$1"; shift; timeout "${T:-120}" "$@" >"$W/$n.log" 2>&1; c=$?; [ $c = 0 ] && echo ok || echo "exit$c"; }

r who "$(id -u):$(id -g)"

# ---- inventory: tools ARTEX's prompts/skills call --------------------------
ver nuclei nuclei -version; ver httpx httpx -version; ver subfinder subfinder -version
ver katana katana -version; ver ffuf ffuf -V; ver dalfox dalfox --version
ver sqlmap sqlmap --version; ver nmap nmap --version; ver legba legba --version
ver bbot bbot --version; ver python python3 --version; ver node node --version
ver playwright-mcp playwright-mcp --version; ver playwright-cli playwright-cli --version
ver rg rg --version; ver jq jq --version; ver curl curl --version; ver git git --version
ver vim vim --version; ver wget wget --version
has dig ping nc telnet whois unzip xz 7z bzip2 python npm npx sudo masscan
r py.sqlite3 "$(python3 -c 'import sqlite3;print("ok")' 2>&1 | tail -1)"
r py.ssl "$(python3 -c 'import ssl;print("ok")' 2>&1 | tail -1)"
r py.tkinter "$(python3 -c 'import tkinter' >/dev/null 2>&1 && echo present || echo absent)"
r setuid.files "$(find / -xdev -perm /6000 -type f 2>/dev/null | wc -l | tr -d ' ')"

# ---- live tool runs against the local vulnerable site ------------------------
python3 -I /t/vulnsite.py 8000 >/dev/null 2>&1 &
i=0; until curl -fs http://127.0.0.1:8000/ >/dev/null || [ $i -ge 50 ]; do sleep 0.2; i=$((i+1)); done
B=http://127.0.0.1:8000
r live.site "$(curl -fs $B/ | grep -o 'DIFF OK' || echo down)"
if [ "${ONLY:-}" = eco ]; then
  . /t/eco.sh; kill %1 2>/dev/null
  [ -d /out ] && cp "$W"/*.log /out/ 2>/dev/null
  exit 0
fi

out="$(httpx -u $B -title -status-code -silent -nc 2>/dev/null)"
r live.httpx "$(echo "$out" | grep -q 'DIFF OK' && echo title-found || echo "no:$out")"

T=60 st katana katana -u $B -silent -d 2 -nc >/dev/null
r live.katana "$(grep -c -E 'p2.html|/r\?q=|/item\?id=' "$W/katana.log") urls"

printf 'p2.html\nnope\nrobots.txt\nindex.html\nmissing\n' > wl.txt
ffuf -u $B/FUZZ -w wl.txt -mc 200 -s >ffuf.log 2>&1
r live.ffuf "$(sort ffuf.log | tr '\n' ' ' | sed 's/ $//')"

T=120 st nuclei nuclei -u $B -t /t/nuclei-difftest.yaml -duc -silent -nc -ni >/dev/null
r live.nuclei "$(grep -q artex-difftest-title "$W/nuclei.log" && echo matched || echo "no-match:$(tail -c 120 "$W/nuclei.log" | tr '\n' ' ')")"

T=120 st dalfox dalfox scan "$B/r?q=hello" --silence --no-color >/dev/null
r live.dalfox "$(grep -qiE 'poc|\[V\]|vulnerab' "$W/dalfox.log" && echo xss-found || echo "none:$(tail -c 120 "$W/dalfox.log" | tr '\n' ' ')")"

T=180 st sqlmap sqlmap -u "$B/item?id=1" --batch --flush-session --output-dir="$W/sq" --level 1 --risk 1 >/dev/null
r live.sqlmap "$(grep -q "Parameter: id" "$W/sqlmap.log" && echo injectable || echo "no:$(grep -E 'CRITICAL|ERROR' "$W/sqlmap.log" | head -1)")"
r live.sqlmap.dbms "$(grep -oE "back-end DBMS: [A-Za-z]+" "$W/sqlmap.log" | head -1)"

out="$(nmap -sT -Pn -p 8000 127.0.0.1 2>&1)"
r live.nmap "$(echo "$out" | grep -q '8000/tcp open' && echo open || echo "no:$(echo "$out" | tail -1)")"

printf 'nope\nsecret\nfoo\n' > pw.txt
T=60 st legba legba http.basic --target "$B/basic" --username admin --password pw.txt --quiet >/dev/null
r live.legba "$(grep -q 'secret' "$W/legba.log" && echo cracked || echo "no:$(tail -c 100 "$W/legba.log" | tr '\n' ' ')")"

# ---- playwright-cli (the playwright-cli skill) --------------------------------
T=90 st pwcli-open playwright-cli open "$B/" --browser=chromium >/dev/null
out="$(timeout 60 playwright-cli eval '() => document.title' 2>&1)"
r pwcli.title "$(echo "$out" | grep -q 'DIFF OK' && echo 'DIFF OK' || echo "fail:$(tail -c 120 "$W/pwcli-open.log" | tr '\n' ' ')")"
timeout 30 playwright-cli close >/dev/null 2>&1

# ---- Playwright MCP as ARTEX seeds it ------------------------------------------
timeout 240 python3 -I /t/mcp_check.py "$B" -- playwright-mcp --headless --browser chromium 2>"$W/mcp.err" || r mcp.exit "$?"

# ---- npm/npx/Playwright flows the api-recon and playwright-cli skills run ------
. /t/eco.sh

# ---- bbot, as the bbot-recon skill runs it ----------------------------------------
# dry run with every module the skill names, --no-deps (the skill's rule)
r bbot.dry.exit "$(T=300 st bbot-dry bbot -t example.com -m "$MODS" -om json,txt --no-deps -y --dry-run --no-color)"
r bbot.dry.loaded "$(grep -oE 'Loaded [0-9]+/[0-9]+ scan modules' "$W/bbot-dry.log" | head -1)"
r bbot.dry.failed "$(grep -oE 'Failed to (set up|load)[^:]*: ?[a-z0-9_, ]*|module [a-z0-9_]+ .*(failed|error)' "$W/bbot-dry.log" | head -3 | tr '\n' ';')"
r bbot.dry.errors "$(grep -cE '\[(ERRR|CRIT)\]' "$W/bbot-dry.log")"
r bbot.dry.firsterr "$(grep -E '\[(ERRR|CRIT)\]' "$W/bbot-dry.log" | grep -vE 'generic_ssrf|host_header|portscan|interactsh' | head -1 | cut -c1-140)"
# live scan of the local site: http + robots + retirejs + gowitness (Chromium)
r bbot.live.exit "$(T=420 st bbot-live bbot -t "$B/" -m http,robots,retirejs,gowitness -c web.spider_distance=1 web.spider_depth=2 -om json --no-deps -y --no-color -n live -o "$W/scans")"
j="$W/scans/live/output.json"
cnt() { [ -f "$j" ] && grep -c "\"type\": *\"$1\"" "$j" || echo nojson; }
# Page URLs only: with gowitness running, bbot races on the .js URL (seen
# 4 or 5 URLs run to run in the same image), so it is not counted here.
urls() { for p in / /p2.html /r /item; do grep -q "\"type\": *\"URL\".*\"url\": *\"$B$p\"," "$j" 2>/dev/null && printf '%s ' "$p"; done; }
r bbot.live.url "$([ -f "$j" ] && urls || echo nojson)"
r bbot.live.retirejs "$([ -f "$j" ] && grep -c '"type": *"FINDING".*Vulnerable JavaScript library detected: jquery v1.8.1' "$j" || echo nojson)"
r bbot.live.screenshot "$(n=$(cnt WEBSCREENSHOT); [ "$n" != nojson ] && [ "$n" -gt 0 ] && echo taken || echo "none:$n")"
r bbot.live.robots "$( [ -f "$j" ] && grep -q 'secret-admin' "$j" && echo found || echo none)"

kill %1 2>/dev/null
[ -d /out ] && cp "$W"/*.log "$W"/mcp.err /out/ 2>/dev/null
exit 0
