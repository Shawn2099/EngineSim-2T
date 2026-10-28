import csv

CSVP = r"C:\Users\malliath\Desktop\engine_sim\port\uflo.csv"
rows = [r for r in csv.reader(open(CSVP)) if r]
B = [[float(v) for v in r] for r in rows[1:]]   # 21 banks x 41

print("=== structural checks ===")
print("bank at J=21 (Bl/XC=1.0) all exactly 1.0:",
      all(abs(b[20] - 1.0) < 1e-12 for b in B))
print("monotone increasing along J in every bank:",
      all(all(b[j] < b[j + 1] for j in range(39)) for b in B))
# along AK: ABX falls as AK rises for J>21, rises for J<21
print("monotone along AK for J<=20:", all(B[i][j] < B[i + 1][j] for j in range(20) for i in range(20)))
print("monotone along AK for J>=22:", all(B[i][j] > B[i + 1][j] for j in range(21, 41) for i in range(20)))

print("\n=== bicubic-style residual scan (flags any cell that breaks local smoothness) ===")
# For each interior cell, predict from the 4 diagonal neighbours (average of the two
# 2nd-order cross predictions) and report residual normalised by the local mean |delta|.
flags = []
for i in range(1, 20):
    for j in range(1, 40):
        pred = (B[i - 1][j - 1] + B[i - 1][j + 1] + B[i + 1][j - 1] + B[i + 1][j + 1]) / 4.0
        r = B[i][j] - pred
        # typical magnitude of 2nd differences here
        scale = max(abs(B[i][j + 1] - 2 * B[i][j] + B[i][j - 1]),
                    abs(B[i + 1][j] - 2 * B[i][j] + B[i - 1][j]), 1e-9)
        flags.append((abs(r), r, i, j, B[i][j]))
flags.sort(reverse=True)
print("top 12 residuals:")
for a, r, i, j, v in flags[:12]:
    print(f"  AK={i*0.05:.2f} J={j+1:2d} value={v:.5f} residual={r:+.5f}")
print(f"\ncells with |residual| > 0.002 : {sum(1 for a,_,_,_,_ in flags if a > 0.002)} of {len(flags)}")
