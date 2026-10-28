import re, io, glob

p = glob.glob(r"C:\Users\malliath\Desktop\engine_sim\references\text\Blair*SAE*")[0]
raw = io.open(p, encoding="utf-8", errors="replace").read().splitlines()
blk = raw[20130:20346]

print("=== tokens in the Data Bank 2.0 block that are NOT well-formed decimals ===")
for n, line in enumerate(blk, start=20131):
    for tok in re.split(r"[,\s]+", line.strip()):
        if not tok:
            continue
        if re.fullmatch(r"\.?\d+(\.\d+)?", tok):
            continue
        print(f"  line {n}: {tok!r:14s}  context: {line.strip()[:70]}")
