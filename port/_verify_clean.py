"""Static check that blair_clean.bas still forms a single, resolvable label space.

Checks, in the same spirit as VERIFY_STRUCTURE.md but on the CLEANED file:
  1. every numeric and named label within a unit is unique
  2. every GOTO/GOSUB target resolves within its own scope (MAIN or one SUB)
  3. no label is defined twice inside one unit
  4. the five fixes are present, and no leftover of the constructs they remove
REM lines are ignored everywhere: a REM that mentions "NEXT KK" is prose, not code.
"""
import re
import sys
from collections import defaultdict

PATH = r"port/blair_clean.bas"
lines = open(PATH, encoding="latin-1").read().replace("\r\n", "\n").split("\n")

STRIP = re.compile(r'"[^"]*"')
LABEL_NUM = re.compile(r"^\s*(\d+)\s")
LABEL_NAMED = re.compile(r"^\s*([A-Za-z][A-Za-z0-9_]*):")
BRANCH_NAMED = re.compile(r"\b(GOTO|GOSUB)\s+([A-Za-z][A-Za-z0-9_]*)")
BRANCH_NUM = re.compile(r"\b(GOTO|GOSUB)\s+(\d+)")


def code(line):
    """Return the executable part of a line, or '' for a REM / comment line."""
    s = line
    if re.match(r"^\s*REM\b", s, re.I) or re.match(r"^\s*'", s):
        return ""
    s = s.split("'")[0] if "'" in s else s
    s = STRIP.sub('""', s)
    return s.rstrip()


units = []            # [(unitname, [(fileline, code)])]
cur = ("MAIN", [])
for n, raw in enumerate(lines, 1):
    c = code(raw)
    m = re.match(r"^\s*SUB\s+([A-Za-z0-9_]+)", c, re.I)
    if m:
        units.append(cur)
        cur = (m.group(1).upper(), [])
    cur[1].append((n, c))
    if re.match(r"^\s*END\s+SUB\b", c, re.I):
        units.append(cur)
        cur = ("MAIN", [])
units.append(cur)

errors = []
report = []
main_branches = []

for name, body in units:
    if not body:
        continue
    labels = defaultdict(list)
    branches = []
    for n, c in body:
        if not c:
            continue
        m = LABEL_NUM.match(c)
        if m:
            labels[m.group(1)].append(n)
        m = LABEL_NAMED.match(c)
        if m:
            labels[m.group(1).upper()].append(n)
        for m in BRANCH_NUM.finditer(c):
            branches.append((m.group(2), n, m.group(1)))
        for m in BRANCH_NAMED.finditer(c):
            branches.append((m.group(2).upper(), n, m.group(1)))
    if name == "MAIN":
        main_branches = branches

    dup = {k: v for k, v in labels.items() if len(v) > 1}
    if dup:
        errors.append("%s: duplicate label(s) %s" % (name, dup))
    for tgt, n, kind in branches:
        if tgt not in labels:
            errors.append("%s: line %d %s %s does not resolve in this unit"
                          % (name, n, kind, tgt))
    if len(body) > 8:
        report.append("%-10s %2d label(s)  %3d branch(es)  %4d line(s)"
                      % (name, len(labels), len(branches), len(body)))

# ---- fixes ---------------------------------------------------------------
stmts = "\n".join(c for _, body in units for _, c in body if c)
whole_raw = "\n".join(lines)


def at(needle):
    i = stmts.find(needle)
    assert i >= 0, "statement not found: " + needle
    return i


cyl = None
for nm, body in units:
    if nm == "CYLINDER":
        cyl = "\n".join(c for _, c in body if c)


checks = [
    ("FIX1 title block gone",
     "COMPUTER PROGRAM" not in stmts and "ProgList.5.1" not in stmts
     and "PROGRAM NAME" not in stmts),
    ("FIX2 CYLINDER C20/C50",
     "C20: IF DEGC>PEAK THEN GOTO 60" in stmts
     and "C50: WORK=(P1+P2)*(V2-V1)/2" in stmts),
    ("FIX2 no CYLINDER 20/50",
     cyl is not None
     and not re.search(r"^\s*(20|50)\s", cyl, re.M)
     and not re.search(r"GOTO (20|50)\b", cyl)),
    ("FIX3 ratios before first use",
     at("PEX=((AE(1)+BE(1))/2)^7") < at("IF HTDC<=HEOT THEN GOSUB EXPORTSHUT")),
    ("FIX3 nothing left at 273-278",
     len(re.findall(r"^PEX=", stmts, re.M)) == 1),
    ("FIX4 STATIC frozen",
     "STATIC IS HONOURED" in whole_raw
     and "starts at 0 on every call" not in whole_raw),
    ("FIX5 no FOR KK", "FOR KK" not in stmts),
    ("FIX5 no NEXT KK", "NEXT KK" not in stmts),
    ("FIX5 single loop entry", stmts.count("CYCLELOOP:") == 1),
    ("FIX5 PRINTOUT returns", "PRINTMODE=1\nKK=1" in stmts),
    ("FIX5 D$ not a mode flag", 'IF D$="P"' not in stmts),
]

print("UNITS (units under 8 lines are the inter-SUB REM blocks, not code)")
for r in report:
    print("  " + r)
print("\nFIXES")
for nm, ok in checks:
    print("  %-34s %s" % (nm, "ok" if ok else "FAIL"))
    if not ok:
        errors.append("fix check failed: " + nm)

print("\n%d branch(es) in the main module, %d errors" % (len(main_branches), len(errors)))
for e in errors:
    print("  ! " + e)
sys.exit(1 if errors else 0)
