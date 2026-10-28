import csv

CSVP = r"C:\Users\malliath\Desktop\engine_sim\port\uflo.csv"
rows = [r for r in csv.reader(open(CSVP)) if r]
banks = [[float(v) for v in r] for r in rows[1:]]
AKS = [round(i * 0.05, 2) for i in range(21)]
B = dict(zip(AKS, banks))

# ---- 1. AK=0.35: the 35 cells that DID survive OCR ----
survived = ".84335 .85416 .86532 .87686 .88881 .90117 .91396 .92721 .9409 .955 .96824 " \
           ".97988 .98959 .9968 1 1.00451 1.01403 1.02654 1.04127 1.05775 1.0756 1.0945 " \
           "1.1137 1.13291 1.15211 1.17131 1.19051 1.20971 1.22892 1.24812 1.26732 1.28652 " \
           "1.30572 1.32492 1.34413"
surv = [float(t) for t in survived.split()]
print(f"legible tokens in AK=.35 block of source : {len(surv)}")
print(f"cells in a full bank                      : 41")
print(f"=> destroyed cells                        : {41-len(surv)}  (J=1..{41-len(surv)})\n")

print("AK=.35, J=7..41 (surviving cells) vs csv:")
d = [(7 + j, s, B[0.35][6 + j]) for j, s in enumerate(surv) if abs(s - B[0.35][6 + j]) > 5e-6]
print("  mismatches:", len(d), d if d else "")

print("\nAK=.35, J=1..6 (transcriber's interpolated cells) vs neighbours")
print(f"{'J':>3} {'csv(.35)':>10} {'lin .30/.40':>12} {'dev':>9} {'quad(.25,.30,.40)':>19} {'dev':>9} {'quad(.30,.40,.45)':>19} {'dev':>9}")
maxd1 = maxd2 = maxd3 = 0
for j in range(6):
    c = B[0.35][j]
    a30, a40 = B[0.30][j], B[0.40][j]
    lin = 0.5 * (a30 + a40)
    # Newton forward from (.30,.40) using curvature from .25 resp. .45
    # quadratic through x0=.30,.40,.45 -> value at .35
    def quad(x0, y0, x1, y1, x2, y2, x):
        return (y0 * (x - x1) * (x - x2) / ((x0 - x1) * (x0 - x2))
                + y1 * (x - x0) * (x - x2) / ((x1 - x0) * (x1 - x2))
                + y2 * (x - x0) * (x - x1) / ((x2 - x0) * (x2 - x1)))
    q1 = quad(0.25, B[0.25][j], 0.30, a30, 0.40, a40, 0.35)
    q2 = quad(0.30, a30, 0.40, a40, 0.45, B[0.45][j], 0.35)
    maxd1 = max(maxd1, abs(c - lin)); maxd2 = max(maxd2, abs(c - q1)); maxd3 = max(maxd3, abs(c - q2))
    print(f"{j+1:3d} {c:10.5f} {lin:12.5f} {c-lin:+9.5f} {q1:19.5f} {c-q1:+9.5f} {q2:19.5f} {c-q2:+9.5f}")
print(f"\nmax |csv - linear midpoint|      : {maxd1:.5f}")
print(f"max |csv - quadratic(.25,.30,.40)|: {maxd2:.5f}")
print(f"max |csv - quadratic(.30,.40,.45)|: {maxd3:.5f}")

# ---- 2. consistency: does the interpolated bank preserve monotone convexity? ----
print("\nmonotonicity / convexity of the four neighbour spacings at AK=.30/.35/.40 (J=1..6):")
for j in range(6):
    y25, y30, y35, y40, y45 = (B[k][j] for k in (0.25, 0.30, 0.35, 0.40, 0.45))
    s1 = y30 - y25; s2 = y35 - y30; s3 = y40 - y35; s4 = y45 - y40
    print(f"  J={j+1:2d} slopes/0.05: {s1:.5f} {s2:.5f} {s3:.5f} {s4:.5f}"
          f"   ({'decreasing, convex' if s1>s2>s3>s4 else 'ANOMALY'})")
