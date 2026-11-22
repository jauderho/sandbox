#!/bin/sh
# Differential test driver.
# Usage: tests/run.sh IMAGE LABEL
# Writes tests/results/LABEL.tsv ("<check>\t<value>") and per-check logs in
# tests/results/LABEL/. Compare two runs with tests/compare.py.
set -u
img="$1"; label="$2"
here="$(cd "$(dirname "$0")" && pwd)"
res="$here/results"; logs="$res/$label"
rm -rf "$logs"; mkdir -p "$logs"; chmod 0777 "$logs"
out="$res/$label.tsv"; : >"$out"
r() { printf '%s\t%s\n' "$1" "$2" >>"$out"; }
MODS="$(sed -n 's/^ARG BBOT_MODULES=//p' "$here/../Dockerfile")"
[ -n "$MODS" ] || { echo "BBOT_MODULES not found in Dockerfile" >&2; exit 1; }
echo "[$label] $img"

# ---- image metadata ---------------------------------------------------------
insp() { docker image inspect "$img" --format "$1"; }
r meta.entrypoint "$(insp '{{json .Config.Entrypoint}}')"
r meta.cmd "$(insp '{{json .Config.Cmd}}')"
r meta.ports "$(insp '{{json .Config.ExposedPorts}}')"
r meta.volumes "$(insp '{{json .Config.Volumes}}')"
r meta.workdir "$(insp '{{.Config.WorkingDir}}')"
r meta.user "$(insp '{{.Config.User}}')"
r meta.arch "$(insp '{{.Architecture}}')"
r meta.size_mb "$(($(insp '{{.Size}}') / 1000000))"
r meta.env.PLAYWRIGHT_BROWSERS_PATH "$(insp '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^PLAYWRIGHT_BROWSERS_PATH=//p')"

docker run --rm --entrypoint sh "$img" -c '
  cd /app
  printf "file.start.sh\t%s\n" "$(sha256sum start.sh | cut -c1-16)"
  printf "file.skills\t%s\n" "$(find skills -type f | sort | xargs sha256sum | sha256sum | cut -c1-16)"
  printf "file.skills.count\t%s\n" "$(find skills -type f | wc -l)"
  printf "file.artex.mode\t%s\n" "$(stat -c %a artex)"
  printf "file.keys.mode\t%s\n" "$(stat -c %a keys)"' >>"$out"

# ---- executor checks (uid 10001, as ARTEX runs agent commands) -----------------
echo "[$label] executor checks"
docker run --rm --user 10001:10001 --security-opt no-new-privileges:true \
  -e HOME=/tmp/exec-home -e XDG_CACHE_HOME=/tmp/exec-home/.cache -e MODS="$MODS" \
  -v "$here:/t:ro" -v "$logs:/out" --entrypoint sh "$img" /t/checks.sh >>"$out" 2>"$logs/checks.stderr"

# ---- bbot as root (ARTEX started with exec uid disabled) -------------------------
echo "[$label] root bbot"
docker run --rm -e MODS="$MODS" --entrypoint sh "$img" -c \
  'bbot -t example.com -m "$MODS" --no-deps -y --dry-run --no-color 2>&1 | tee /tmp/l >/dev/null
   printf "root.bbot.dry.loaded\t%s\n" "$(grep -oE "Loaded [0-9]+/[0-9]+ scan modules" /tmp/l | head -1)"
   printf "root.bbot.dry.errors\t%s\n" "$(grep -cE "\[(ERRR|CRIT)\]" /tmp/l)"' >>"$out"

# ---- server boot against PostgreSQL ------------------------------------------
echo "[$label] server"
n="artex-dt-$label"
docker rm -f -v "$n-app" "$n-pg" >/dev/null 2>&1; docker network rm "$n" >/dev/null 2>&1
docker network create "$n" >/dev/null
docker run -d --name "$n-pg" --network "$n" -e POSTGRES_USER=artex -e POSTGRES_PASSWORD=difftest \
  -e POSTGRES_DB=artex postgres:16-alpine >/dev/null
i=0; until docker exec "$n-pg" pg_isready -U artex -d artex >/dev/null 2>&1 || [ $i -ge 60 ]; do sleep 1; i=$((i+1)); done
docker run -d --name "$n-app" --network "$n" --security-opt no-new-privileges:true \
  -e "ARTEX_PG_DSN=postgres://artex:difftest@$n-pg:5432/artex?sslmode=disable" \
  -e ARTEX_JWT_KEY_DIR=/app/keys "$img" >/dev/null
x() { docker exec "$n-app" sh -c "$1"; }
i=0; until x 'curl -fs http://127.0.0.1:8787/api/health' >/dev/null 2>&1 || [ $i -ge 90 ]; do sleep 1; i=$((i+1)); done
r server.boot "$([ $i -lt 90 ] && echo up || echo timeout)"
r server.health "$(x 'curl -s http://127.0.0.1:8787/api/health')"
r server.ready "$(x 'curl -s -o /dev/null -w %{http_code} http://127.0.0.1:8787/api/ready')"
r server.auth_status "$(x 'curl -s http://127.0.0.1:8787/api/auth/status | jq -c "keys"')"
r server.api_unauth "$(x 'curl -s -o /dev/null -w %{http_code} http://127.0.0.1:8787/api/agents')"
r server.ui "$(x 'curl -s -o /dev/null -w %{http_code} http://127.0.0.1:8787/')"
r server.ui.asset "$(x 'a=$(curl -s http://127.0.0.1:8787/ | grep -oE "/_next/static/[^\"]+\.js" | head -1); curl -s -o /dev/null -w %{http_code} "http://127.0.0.1:8787$a"')"
r server.proxy "$(x 'curl -s -o /dev/null -w %{http_code} -x http://127.0.0.1:8788 http://127.0.0.1:8787/api/health')"
r server.browser_mcp "$(docker exec "$n-pg" psql -U artex -d artex -Atc "select command||' '||args::text||' enabled='||enabled from mcp_servers where name='browser'" 2>&1)"
r server.data "$(x 'ls /app/data | tr "\n" " "')"
r server.keys "$(x 'ls /app/keys | tr "\n" " "')"
r server.procs "$(x 'ps -eo user=,comm= 2>/dev/null | sort -u | tr -s " " | tr "\n" ";"' || echo no-ps)"
docker logs "$n-app" >"$logs/server.log" 2>&1
r server.log.errors "$(grep -ciE 'panic|fatal|level=error' "$logs/server.log")"
t0=$(date +%s); docker stop -t 15 "$n-app" >/dev/null; dt=$(($(date +%s) - t0))
docker logs "$n-app" >"$logs/server.log" 2>&1
r server.stop "$([ $dt -lt 10 ] && echo graceful || echo "slow")"
r server.stop.msg "$(grep -c '\[artex\] stopped' "$logs/server.log")"
docker rm -f -v "$n-app" "$n-pg" >/dev/null 2>&1; docker network rm "$n" >/dev/null 2>&1

echo "[$label] done: $(wc -l <"$out" | tr -d ' ') checks -> $out"
