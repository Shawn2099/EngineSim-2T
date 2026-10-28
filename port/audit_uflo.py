"""Stage 2: repair AK=.35 J=1..6 (validated on the 35 surviving entries), audit, write CSV.

Coordinates reported are (I,J) with I = bank index 1..21 (AK = 0.00..1.00) and
J = column 1..41 (x = 0.60..1.40).  In the CSV, row = I+1 (row 1 is the x axis).
"""
import os, re
import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
exec(open(os.path.join(HERE, "build_uflo.py")).read())

X = [round(0.60 + 0.02 * j, 2) for j in range(41)]

# ---------- repair the 6 lost entries of the AK=.35 bank -----------------------
# J=7..41 survive, so every candidate AK-interpolation scheme can be *scored* on
# those 35 known entries before it is trusted for the 6 unknown ones.
def interp(ak_target, j, scheme):
    t = np.array(scheme, float)
    y = np.array([rows[a][j - 1] for a in scheme])
    return float(np.polyval(np.polyfit(t, y, len(scheme) - 1), ak_target))

schemes = {
    "linear .30-.40":        [0.30, 0.40],
    "quad .25/.30/.40":      [0.25, 0.30, 0.40],
    "quad .30/.40/.45":      [0.30, 0.40, 0.45],
    "cubic .20/.25/.30/.40": [0.20, 0.25, 0.30, 0.40],
    "cubic .25/.30/.40/.45": [0.25, 0.30, 0.40, 0.45],
    "quartic .20-.45":       [0.20, 0.25, 0.30, 0.40, 0.45],
}
score = {}
for name, sch in schemes.items():
    err = [abs(interp(0.35, j, sch) - rows[0.35][j - 7]) for j in range(7, 42)]
    score[name] = (max(err), float(np.sqrt(np.mean(np.square(err)))))
for name, (mx, rms) in sorted(score.items(), key=lambda kv: kv[1][1]):
    print(f"  {name:24s} max|err| on the 35 surviving = {mx:.5f}  rms = {rms:.6f}")

best = min(score, key=lambda k: score[k][1])
sch = schemes[best]
print("selected scheme:", best)

repair = {j: round(interp(0.35, j, sch), 5) for j in range(1, 7)}
print("repaired AK=.35 J=1..6 ->", [f"{v:.5f}" for v in repair.values()])
spread = {j: max(abs(interp(0.35, j, s) - repair[j]) for s in schemes.values()) for j in range(1, 7)}
print("spread across schemes   ->", [f"{v:.5f}" for v in spread.values()])
rows[0.35] = [repair[j] for j in range(1, 7)] + rows[0.35]

# ---------- 22 x 41 table: row 1 = x axis, rows 2..22 = banks I=1..21 -----------
aks = [round(0.05 * i, 2) for i in range(21)]
banks = {aks[0]: list(X)}                     # I=1 (AK=0) is y = x
banks.update({ak: rows[ak] for ak in sorted(rows)})
table = [list(X)] + [banks[ak] for ak in aks]
assert len(table) == 22 and all(len(r) == 41 for r in table)
B = {ak: banks[ak] for ak in aks}
print("\nshape: 22 rows x 41 cols;", sum(len(r) for r in table), "numbers")

# ---------- invariants ----------------------------------------------------------
fails, touch = [], []
def chk(cond, I, J, msg):
    if not cond:
        fails.append((I, J, msg))

# (a) J=21 exactly 1.00000 in every bank
for I, ak in enumerate(aks, 1):
    chk(B[ak][20] == 1.0, I, 21, f"J=21 = {B[ak][20]!r}, not exactly 1.00000")
# (b) I=1 (AK=0) must be y = x, cell for cell
for J in range(41):
    chk(B[0.0][J] == X[J], 1, J + 1, "AK=0 bank != x")
# (c) direction of each bank in x
for I, ak in enumerate(aks, 1):
    r = B[ak]
    for J in range(1, 41):
        chk(r[J] > r[J - 1], I, J + 1, f"not monotonic in x ({r[J-1]:.5f} -> {r[J]:.5f})")
    if not all(r[J] > r[J - 1] for J in range(1, 41)):
        print("   dir fail I=%d" % I)
    chk(all(r[J] > r[J-1] for J in range(1, 41)), I, 1, "row direction")
# (d) banks ordered in AK, no crossings
for J in range(41):
    if J == 20:
        continue
    inc = J < 20
    for I in range(2, 22):
        a, b = B[aks[I - 1]][J], B[aks[I - 2]][J]
        same = (a == b)
        if same:
            touch.append((I, J + 1, a))
        chk(same or ((a > b) if inc else (a < b)), I, J + 1,
            f"bank crossing ({b:.5f} -> {a:.5f}; expected {'rising' if inc else 'falling'} in AK)")

print("\nINVARIANT VIOLATIONS:", len(fails))
for f in fails:
    print("   I=%d J=%d  %s" % f)
print("bank pairs that touch without crossing (equal values):", len(touch))
for t in touch:
    print("   I=%d J=%d value=%.5f" % t)

# margins: how close does any bank come to crossing its neighbour?
gaps = []
for J in range(41):
    if J == 20:
        continue
    for I in range(2, 22):
        gaps.append(abs(B[aks[I - 1]][J] - B[aks[I - 2]][J]))
print("adjacent-bank separation: min %.5f, median %.5f" % (min(gaps), sorted(gaps)[len(gaps) // 2]))
print("smallest within-row step : %.5f" % min(min(r[J] - r[J-1] for J in range(1, 41)) for r in B.values()))

# ---------- own-transcription check: digits must exist verbatim in the source ----
src = [p for p in os.listdir(os.path.join(HERE, "..", "references", "text"))
       if "Basic_Design" in p][0]
lines = open(os.path.join(HERE, "..", "references", "text", src), encoding="utf-8",
             errors="replace").read().splitlines()[20131:20359]
digits = [re.sub(r"\D", "", l) for l in lines]

def tokpat(v):
    return re.sub(r"0+$", "", f"{v:.5f}".split(".")[1])

unverified = []
for I, ak in enumerate(aks, 1):
    if ak == 0.0:
        continue
    for c0 in range(0, 41, 5):
        chunk = B[ak][c0:c0 + 5]
        pat = r"\D*".join((r"1?" if v >= 1 else "") + tokpat(v) + r"0*" for v in chunk)
        if not any(re.search(pat, d) for d in digits):
            unverified.append((I, ak, c0 + 1, chunk))
print("\nchunks whose digits are NOT found verbatim in the source:", len(unverified))
for I, ak, J, chunk in unverified:
    print(f"   I={I} AK={ak:.2f} J={J}..{J+len(chunk)-1}: " + " ".join(f"{v:.5f}" for v in chunk))

# ---------- write ---------------------------------------------------------------
with open(os.path.join(HERE, "uflo.csv"), "w", newline="") as f:
    for r in table:
        f.write(",".join(f"{v:.5f}" for v in r) + "\n")
print("\nwrote uflo.csv")
