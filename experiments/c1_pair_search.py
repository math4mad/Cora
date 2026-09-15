#!/usr/bin/env python3
"""CORA · C1 pair search — the registered ε=0.01 search, minutes of SVD, zero training.

Entry law it obeys:
  · corpus = Θ's pinned treasures only (every consumed file must pass the father's four ways;
    the ledger written here is what c1_run.sh's R7 consumes);
  · spectra normalized and discretized BY RULE, the rule named before any distance is computed
    (H6c's scar: the measure in units and amplitude before the fit);
  · ε frozen at 0.01 in the register at HEAD — this script READS it, never retunes it;
  · the empty result is a first-class outcome (Sarcos' row: the arena may not exist) — printed,
    pinned, and it closes the row as a registered negative, no second search in-row.

Rule, in words before numbers: s(M) = singular values of M (float64, full SVD of small matrices),
normalized  ŝ_i = σ_i / Σσ² ; discretized to 128 bins on the INDEX axis (rank positions resampled
to 128 by linear interpolation of the normalized sequence, a length-128 probability vector);
distance = W1 = Σ|CDF_a − CDF_b| on those bins. Both matrices taken from the SAME tensor name
across two models where possible (the layer-type control), and cross-type pairs admitted;
shape (rows, cols) must match exactly — no padding, no interpolation between geometries.
"""
import hashlib, itertools, json, os, re, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)                     # Cora's root
CHORA = os.path.join(ROOT, "..", "chora")
import numpy as np
# torch, not numpy-safetensors: Θ's Qwen weights are bfloat16 — the numpy reader chokes on the
# whole file; and an EMPTY corpus must never masquerade as the registered negative (see guard below)
try:
    import torch
    from safetensors.torch import load_file as load_t
except Exception:
    raise SystemExit("run me with the rig's venv python (torch + safetensors live there)")

# ---- ε read from the register at git HEAD (never hardcoded, never retuned) -------------------------
prereg = subprocess.run(["git", "-C", ROOT, "show", "HEAD:docs/PREREG.md"],
                        capture_output=True, text=True).stdout
m = re.search(r"frozen NOW at \*\*([\d.]+)\*\*|frozen NOW at ([\d.]+)", prereg)
EPS = float(next(g for g in (m.groups() if m else ()) if g)) if m else None
assert EPS is not None, "no frozen ε found at HEAD — the register is the only source for this number"
BINS, REG = 128, re.compile(r"\.(q|k|v|o|gate|up|down)_proj\.weight$")
print(f"[pairsearch] ε from register HEAD: {EPS} · bins: {BINS} · rule: name-pattern {REG.pattern}")

# ---- corpus: which pinned bytes we will touch (ledger first, consumption after) --------------------
MODEL = "models/models/Qwen--Qwen2.5-0.5B/snapshots/master/model.safetensors"
MODEL2 = "models/models/AI-ModelScope--bert-base-uncased/snapshots/master/model.safetensors"
ledger_path = os.path.join(ROOT, "artifacts/results/C1/spectra_source.tsv")
os.makedirs(os.path.dirname(ledger_path), exist_ok=True)

def pin_of(rel_in_chora):
    for mf in ["models/manifest.json"]:
        for e in json.load(open(os.path.join(CHORA, mf)))["files"]:
            if e["path"] == rel_in_chora: return e["sha256"]
    return None

ledger = []
for rel in (MODEL, MODEL2):
    sha = pin_of(rel)
    assert sha, f"treasure {rel} unpinned — law 9: no pin, no consumption"
    r = subprocess.run([os.path.join(ROOT, "bin/pin.sh"), rel, sha], capture_output=True, text=True)
    assert r.returncode == 0, f"pin.sh refused {rel}: four-ways not met"
    ledger.append((rel, sha))
with open(ledger_path, "w") as f:
    f.write("# C1 spectra corpus: every line (path<TAB>sha256) four-ways VERIFIED at write time (Θ's registers)\n")
    for rel, sha in ledger: f.write(f"{rel}\t{sha}\n")
print(f"[pairsearch] ledger written: {len(ledger)} treasures, all four-way green at consumption")

# ---- spectra ---------------------------------------------------------------------------------------
t0 = time.time()
def spectra(fn):
    out = {}
    for k, v in load_t(os.path.join(CHORA, fn)).items():
        v = v.detach().to(torch.float32).numpy()
        if not (v.ndim == 2 and min(v.shape) >= BINS and REG.search(k)): continue
        s = np.linalg.svd(v.astype(np.float64), compute_uv=False)
        sh = s / (s @ s)                                     # the registered normalization
        grid = np.linspace(0, len(sh) - 1, BINS)
        b = np.interp(grid, np.arange(len(sh)), sh)
        out[k] = b / b.sum()                                 # probability vector over 128 bins
    return out
M = {}
for rel, _ in ledger:
    try: M.update({f"{os.path.basename(CHORA)}::{rel.split('/')[-4]}::{k}": v for k, v in spectra(rel).items()})
    except Exception as e: print("[pairsearch] skip", rel, e)
keys = sorted(M)
if not keys:
    raise SystemExit("[pairsearch] APPARATUS FAILURE: zero matrices admitted — this is NOT the "
                     "registered negative (that finding must be earned from a working reader); fix the reader, rerun.")
print(f"[pairsearch] matrices admitted: {len(keys)} ({', '.join(sorted({k.split('::')[-1].split('.')[-2] for k in keys}))}) in {time.time()-t0:.1f}s")

# ---- the search: one pass, both rows, no peeking-then-tuning ---------------------------------------
pairs_iso, pairs_ctrl, allw = [], [], []
t1 = time.time()
for a, b in itertools.combinations(keys, 2):
    va, vb = M[a], M[b]
    if va.shape != vb.shape: continue                        # same geometry only, by rule
    w = float(np.abs(np.cumsum(va) - np.cumsum(vb)).sum())   # W1 on the 128-bin CDFs
    allw.append((w, a, b))
    (pairs_iso if w <= EPS else pairs_ctrl).append((a, b, w))
allw.sort()
# VACUITY CHECK (law 7, the toll before the run): an empty row is a RESULT only if the arena was
# enterable. If the nearest natural pair sits far beyond eps, the event was ARITHMETICALLY unable
# to fire — different finding, different sentence, and it saves a 40-minute run scoring nothing.
dist = {"n_comparable_pairs": len(allw), "min_W1": round(allw[0][0], 4), "p01": round(allw[max(0,int(0.01*len(allw)))][0], 4),
        "median_W1": round(allw[len(allw)//2][0], 4),
        "nearest_pairs": [{"a": a, "b": b, "W1": round(w, 5)} for w, a, b in allw[:10]]}
print(f"[pairsearch] arena census: min W1 = {dist['min_W1']} (eps {EPS}) · p01 {dist['p01']} · median {dist['median_W1']}")
vacuous = bool(allw and allw[0][0] > 2*EPS)
if vacuous: print("[pairsearch] WARNING: nearest natural pair is >2x eps — the row may close VACUOUS, not merely empty")
print(f"[pairsearch] scanned in {time.time()-t1:.1f}s · ε-isospectral pairs: {len(pairs_iso)} · controls (>ε): {len(pairs_ctrl)}")
pairs_iso.sort(key=lambda x: x[2]); random_ctrl = sorted(pairs_ctrl, key=lambda x: -x[2])[:50]
out = {"eps": EPS, "bins": BINS, "rule": "ŝ=σ/Σσ², 128 index-bins, linear interp, W1 of CDFs; exact shape match required",
       "corpus": [l[0].split("/")[2] for l in ledger],
       "matrices": len(keys), "n_isospectral": len(pairs_iso), "arena": dist, "vacuity_flag": vacuous,
       "registered_negative_row": (len(pairs_iso) == 0),
       "top_isospectral": [{"a": a, "b": b, "W1": round(w, 6)} for a, b, w in pairs_iso[:200]],
       "farthest_controls": [{"a": a, "b": b, "W1": round(w, 6)} for a, b, w in random_ctrl]}
pj = os.path.join(ROOT, "artifacts/results/C1/pairs.json")
json.dump(out, open(pj, "w"), indent=1); open(pj, "a").write("\n")
print(f"[pairsearch] pairs.json written — {hashlib.sha256(open(pj,'rb').read()).hexdigest()[:16]}…")
print("[pairsearch] next: manifest pin BEFORE any citation; then c1_run.sh passes R7 by these bytes alone.")
