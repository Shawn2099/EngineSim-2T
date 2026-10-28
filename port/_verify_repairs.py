import csv

CSVP = r"C:\Users\malliath\Desktop\engine_sim\port\uflo.csv"
rows = [r for r in csv.reader(open(CSVP)) if r]
B = [[float(v) for v in r] for r in rows[1:]]
AKS = [round(i * 0.05, 2) for i in range(21)]
idx = {ak: i for i, ak in enumerate(AKS)}

# ---- repairs: (AK, J, raw token, source line) ----
REP = [
    (0.00, 21, "C", 20137),
    (0.05,  7, "75942", 20145),
    (0.10, 21, "1 (from '1.1 01315')", 20163),
    (0.10, 24, "1 04882", 20163),
    (0.10, 25, "1 0679", 20163),
    (0.15, 20, "97671<bad>99062 -> .99062", 20172),
    (0.20,  5, ". 79153", 20179),
    (0.25,  5, ".79332<bad>80355", 20189),
    (0.40,  6, "84063", 20221),
    (0.40,  7, "85097", 20221),
    (0.45,  3, ".8183", 20230),
    (0.45,  4, "82787", 20230),
    (0.45,  8, "86836", 20231),
    (0.45, 15, "95174", 20232),
    (0.65, 20, "-99885", 20278),
    (0.80, 15, "97489", 20309),
    (0.80, 22, "1.1.00054 -> 1.00054", 20311),
    (0.85,  1, "83931", 20317),
    (0.90,  7, ".9O089 (letter O)", 20328),
    (0.90,  8, ".91O92 (letter O)", 20328),
    (0.90, 20, "99908", 20330),
    (0.95, 10, "-93494", 20342),
    (1.00,  8, ",,91708", 20352),
    (1.00, 10, "92724<bad>93663", 20352),
    (1.00, 11, "94554", 20353),
]

print(f"{'AK':>5} {'J':>3} {'csv value':>10} {'J-1':>9} {'J+1':>9} {'brackets?':>9} "
      f"{'src line':>9}  raw OCR token")
allok = True
for ak, j, raw, ln in REP:
    i = idx[ak]
    v = B[i][j - 1]
    if j == 1:                      # leading edge: bracket along the AK axis instead
        lo, hi = B[i - 1][0], B[i + 1][0]
    else:
        lo = B[i][j - 2]
        hi = B[i][j] if j < 41 else None
    ok = lo < v < hi
    allok &= ok
    print(f"{ak:5.2f} {j:3d} {v:10.5f} {lo:9.5f} {hi:9.5f} {str(ok):>9} {ln:9d}  {raw}")
print("\nall repaired values strictly between their J-1 and J+1 neighbours:", allok)

# ---- 10 random spot checks, spread over banks / columns / page breaks ----
SPOT = [(0.05, 1), (0.10, 22), (0.15, 20), (0.25, 5), (0.30, 41),
        (0.45, 3), (0.70, 41), (0.80, 14), (0.90, 7), (0.95, 10)]
print("\n=== ten spot checks (I,J) ===")
for ak, j in SPOT:
    i = idx[ak]
    print(f"  (AK={ak:.2f}, J={j:2d})  csv = {B[i][j-1]:.5f}")
