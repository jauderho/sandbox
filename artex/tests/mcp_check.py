"""Drive Playwright MCP over stdio the way ARTEX's seeded browser MCP does.

Usage: mcp_check.py BASE_URL -- playwright-mcp --headless --browser chromium
Prints one "mcp.<check>\t<value>" line per check; values are normalized so two
images can be compared line by line.
"""
import json
import re
import subprocess
import sys
import threading
import time

base = sys.argv[1]
cmd = sys.argv[sys.argv.index("--") + 1:]
p = subprocess.Popen(cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
seq = 0


def out(name, value):
    print(f"mcp.{name}\t{value}", flush=True)


def call(method, params=None, notify=False, timeout=60):
    global seq
    msg = {"jsonrpc": "2.0", "method": method}
    if params is not None:
        msg["params"] = params
    if not notify:
        seq += 1
        msg["id"] = seq
    p.stdin.write(json.dumps(msg) + "\n")
    p.stdin.flush()
    if notify:
        return None
    box = {}

    def read():
        while True:
            line = p.stdout.readline()
            if not line:
                box["eof"] = True
                return
            r = json.loads(line)
            if r.get("id") == seq:
                box["r"] = r
                return

    t = threading.Thread(target=read, daemon=True)
    t.start()
    t.join(timeout)
    if "r" not in box:
        out("fatal", "eof" if box.get("eof") else "timeout")
        out("stderr", p.stderr.read()[:300].replace("\n", " ") if box.get("eof") else "")
        p.kill()
        sys.exit(0)
    return box["r"]


def tool(name, **args):
    r = call("tools/call", {"name": name, "arguments": args})
    res = r.get("result", {})
    text = " ".join(c.get("text", "") for c in res.get("content", []) if c.get("type") == "text")
    ok = "error" not in r and not res.get("isError")
    return ok, text, res


def result_of(text):
    # browser_evaluate returns a markdown block; pull the value under "### Result".
    m = re.search(r"### Result\s*\n(.*?)(\n###|$)", text, re.S)
    return (m.group(1) if m else text).strip().strip('"')[:80]


def ev(fn):
    ok, text, _ = tool("browser_evaluate", function=fn)
    return result_of(text) if ok else "ERROR"


init = call("initialize", {"protocolVersion": "2025-06-18", "capabilities": {}, "clientInfo": {"name": "difftest", "version": "1"}})
out("server", init.get("result", {}).get("serverInfo", {}).get("name", "none"))
call("notifications/initialized", notify=True)
tools = call("tools/list").get("result", {}).get("tools", [])
out("tools.count", len(tools))

ok, _, _ = tool("browser_navigate", url=base + "/")
out("navigate", "ok" if ok else "fail")
out("title", ev("() => document.title"))
out("jquery", ev("() => window.jQuery && jQuery.fn.jquery"))

tool("browser_navigate", url=base + "/xss.html?q=%3Cimg%20src%3Dx%20onerror%3D%22window.pwned%3Ddocument.domain%22%3E")
time.sleep(1)
out("xss.onerror", ev("() => String(window.pwned)"))
out("cookie", ev("() => document.cookie"))
out("fetch", ev("() => document.title"))
out("iframe", ev("() => document.querySelector('iframe').contentDocument?.title || 'no access'"))

ok, text, _ = tool("browser_navigate", url=base + "/xss.html?q=%3Cimg%20src%3Dx%20onerror%3Dalert(1)%3E")
ok, text, _ = tool("browser_handle_dialog", accept=True)
out("xss.dialog", "handled" if ok else "none")

ok, snap, _ = tool("browser_snapshot")
m = re.search(r"textbox[^\n]*\[ref=([a-z0-9]+)\]", snap)
if m:
    tool("browser_type", target=m.group(1), ref=m.group(1), element="user", text="admin' OR 1=1--")
    out("type", ev("() => document.getElementById('user').value"))
else:
    out("type", "no textbox ref")

ok, text, _ = tool("browser_network_requests")
out("network", "p2-seen" if "/p2.html" in text else "missing")

tool("browser_navigate", url=base + "/spa.html")
ok, _, _ = tool("browser_wait_for", text="rendered by js")
out("spa.wait", "ok" if ok else "fail")
ok, snap, _ = tool("browser_snapshot")
m = re.search(r'button "press" \[ref=([a-z0-9]+)\]', snap)
if m:
    tool("browser_click", target=m.group(1), ref=m.group(1), element="press")
    out("spa.click", ev("() => document.getElementById('b')?.textContent"))
else:
    out("spa.click", "no button ref")

ok, _, res = tool("browser_take_screenshot")
img = [c for c in res.get("content", []) if c.get("type") == "image"]
out("screenshot", "png" if img and len(img[0]["data"]) > 1000 else "none")

tool("browser_navigate", url=base + "/gl.html")
out("webgl", ev("() => document.title"))

tool("browser_close")
p.kill()
