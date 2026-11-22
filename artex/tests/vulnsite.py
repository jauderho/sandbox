"""Deliberately vulnerable local test target for the differential suite.

Binds 127.0.0.1 only. Endpoints:
  /               static index (title "DIFF OK"), links to /p2.html, loads /js/jquery-1.8.1.min.js
  /r?q=           reflected XSS (q echoed unescaped)
  /item?id=       SQL injection (sqlite, id concatenated into the query)
  /basic          HTTP basic auth, admin:secret
  everything else static from the site dir (xss.html, spa.html, gl.html, robots.txt)
"""
import base64
import http.server
import os
import sqlite3
import sys
import urllib.parse

SITE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "site")
db = sqlite3.connect(":memory:", check_same_thread=False)
db.executescript(
    "CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT);"
    "INSERT INTO items VALUES (1,'apple'),(2,'pear'),(3,'plum');"
)


class H(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **k):
        super().__init__(*a, directory=SITE, **k)

    def log_message(self, *a):
        pass

    def send(self, code, body, ctype="text/html", headers=()):
        b = body.encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(b)))
        for k, v in headers:
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(b)

    def do_GET(self):
        u = urllib.parse.urlsplit(self.path)
        qs = urllib.parse.parse_qs(u.query)
        if u.path == "/r":
            q = qs.get("q", [""])[0]
            return self.send(200, f"<html><head><title>R</title></head><body><p>Results for {q}</p></body></html>")
        if u.path == "/item":
            i = qs.get("id", ["1"])[0]
            try:
                rows = db.execute(f"SELECT name FROM items WHERE id={i}").fetchall()
                return self.send(200, "<html><body>" + "".join(f"<li>{r[0]}</li>" for r in rows) + "</body></html>")
            except sqlite3.Error as e:
                return self.send(500, f"<html><body>sqlite error: {e}</body></html>")
        if u.path == "/api/user":
            return self.send(200, '{"code":0,"user":"difftest","role":"admin"}', "application/json")
        if u.path == "/basic":
            want = "Basic " + base64.b64encode(b"admin:secret").decode()
            if self.headers.get("Authorization") == want:
                return self.send(200, "welcome")
            return self.send(401, "auth", headers=[("WWW-Authenticate", 'Basic realm="t"')])
        return super().do_GET()


port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
http.server.ThreadingHTTPServer(("127.0.0.1", port), H).serve_forever()
