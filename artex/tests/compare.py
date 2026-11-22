"""Compare two differential runs.

Usage: compare.py UPSTREAM.tsv OURS.tsv EXPECTED.tsv [REPORT.md]

EXPECTED.tsv lines: "<check>\t<class>\t<reason>", class one of
  delta  intended difference (different base, versions, layout)
  fixed  upstream is broken here, ours works
  info   informational, value is not compared
Any other difference is UNEXPECTED and makes the exit status 1.
"""
import sys


def load(path):
    d = {}
    for line in open(path, encoding="utf-8"):
        line = line.rstrip("\n")
        if "\t" in line:
            k, v = line.split("\t", 1)
            d.setdefault(k, v)
    return d


up, ours = load(sys.argv[1]), load(sys.argv[2])
exp = {}
for line in open(sys.argv[3], encoding="utf-8"):
    if line.strip() and not line.startswith("#"):
        k, c, why = (line.rstrip("\n").split("\t") + ["", ""])[:3]
        exp[k] = (c, why)

rows, counts = [], {}
order = list(up) + [k for k in ours if k not in up]
for k in order:
    a, b = up.get(k, "(absent)"), ours.get(k, "(absent)")
    c, why = exp.get(k, ("", ""))
    if c == "info":
        st = "INFO"
    elif a == b:
        st = "MATCH" if not c else "MATCH (listed as " + c + ")"
    elif c == "delta":
        st = "DELTA"
    elif c == "fixed":
        st = "FIXED"
    else:
        st = "UNEXPECTED"
    counts[st.split()[0]] = counts.get(st.split()[0], 0) + 1
    rows.append((k, st, a, b, why))


def cell(s):
    return s.replace("|", "\\|")[:90]


md = ["| check | result | upstream | ours | note |", "|---|---|---|---|---|"]
md += [f"| `{k}` | {st} | {cell(a)} | {cell(b)} | {cell(why)} |" for k, st, a, b, why in rows]
summary = ", ".join(f"{v} {k}" for k, v in sorted(counts.items()))
text = f"**{summary}**\n\n" + "\n".join(md) + "\n"
if len(sys.argv) > 4:
    open(sys.argv[4], "w", encoding="utf-8").write(text)
print(summary)
for k, st, a, b, why in rows:
    if st.startswith(("UNEXPECTED", "FIXED", "DELTA")):
        print(f"  {st:10s} {k}: {a!r} -> {b!r}")
sys.exit(1 if counts.get("UNEXPECTED") else 0)
