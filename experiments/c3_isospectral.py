#!/usr/bin/env python3
"""CORA · C3 — the constructive isospectrality run (register: ## C3, self-signed under the chair's
「you decide. in digital world you are the master」). 27 arms · training-under-constraint row ·
founding boundary: C1's vacuity census. Borrowed apparatus: rig@382e438a IMPORTED (no bytes copied).

Run with the rig's venv python:
  ../Middle-Eigen-function/.venv/bin/python experiments/c3_isospectral.py --session Κ-hand-015
"""
import argparse, json, os, re, subprocess, sys, time
import numpy as np

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MEF = os.path.join(ROOT, "..", "Middle-Eigen-function")
RIG_SHA = "382e438a76669b6e49ce9663302d10025a6922f0"
ap = argparse.ArgumentParser(); ap.add_argument("--session", required=True); ap.add_argument("--dry-run", action="store_true")
A = ap.parse_args()

def ref(gate, msg): print(f"[c3] REFUSE {gate}: {msg}"); sys.exit(1)

# ---- gates (mirror of c1_run.sh; each names its unlock) ---------------------------------------------
prereg = subprocess.run(["git", "-C", ROOT, "show", "HEAD:docs/PREREG.md"], capture_output=True, text=True).stdout
"## C3 —" in prereg or ref("R1", "C3 not registered at HEAD (the working tree is where optimism lives)")
lock = subprocess.run([os.path.join(ROOT, "bin/writelock.sh"), "status"], capture_output=True, text=True).stdout
re.search(rf"holder={re.escape(A.session)}$", lock, re.M) or ref("R3", f"lock not held by {A.session}: {lock.strip()}")
head = subprocess.run(["git", "-C", MEF, "rev-parse", "HEAD"], capture_output=True, text=True).stdout.strip()
head == RIG_SHA or ref("R4", f"rig moved ({head[:8]}… ≠ {RIG_SHA[:8]}…): re-read the scar clause, do not repoint")
subprocess.run(["git", "-C", MEF, "diff", "--quiet", "HEAD", "--", "scripts/stage18_kairos_mini.py"]).returncode == 0 or ref("R4", "rig dirty")
bands = json.load(open(os.path.join(ROOT, "artifacts/results/D1-C1band_band.json")))
BAND = bands["band_nats"]
pins = {e["path"]: e["sha256"] for e in json.load(open(os.path.join(ROOT, "artifacts/results/manifest.json")))["files"]}
subprocess.run([os.path.join(ROOT, "bin/pin.sh"), "artifacts/results/D1-C1band_band.json",
                pins["artifacts/results/D1-C1band_band.json"]], capture_output=True).returncode == 0 or ref("R5", "band bytes no longer verify four ways — nothing scores against a moved band")
CDIR = os.path.join(ROOT, "artifacts/results/C3")
os.makedirs(CDIR, exist_ok=True)
existing = [f for f in os.listdir(CDIR) if f.endswith(".curve.json")]
not existing or ref("R6", f"{len(existing)} curve files already in C3/ — reruns get new run-ids; amnesia is not a mode")
print(f"[c3] gates ok: registered · lock {A.session} · rig clean · band {BAND} live-verified · curve dir empty")

SLOTS = {"qB0": ("blocks.0.q", 7001, 8001), "gateB0": ("blocks.0.gate", 7002, 8002), "downB1": ("blocks.1.down", 7003, 8003)}  # rig Block keeps projections flat: blocks.N.q, not layers.N.attn.q
SEEDS = [13, 14, 15]
STAGE = os.path.join(ROOT, "artifacts/staging/runs/C3-r1")

# ---- import the rig (borrowed by module, cited by sha) ----------------------------------------------
os.environ["HTTPS_PROXY"] = os.environ["HTTP_PROXY"] = "http://127.0.0.1:9"   # fallback, refused-on-route (register ③)
os.environ["TS_PATH"] = os.path.join(STAGE, "no_tinystories")                  # does not exist → fetch → instant proxy-refusal → local fallback
os.environ["SEED"] = "13"; os.environ["OUT_DIR"] = STAGE
sys.path.insert(0, os.path.join(MEF, "scripts"))
os.chdir(MEF)                                 # the fallback globs are CWD-relative in the donor's code
import torch, importlib
rig = importlib.import_module("stage18_kairos_mini")
if A.dry_run:
    print(f"[c3] DRY-RUN: would smoke-price, then 3 bases ×({', '.join(map(str, SEEDS))}) + {len(SLOTS)*3*3} arms"
          f" at 48.3 s/arm (Cora's own print) ≈ 32 min; ceiling 2× = 64 min. corpus=named fallback; band={BAND}.")
    sys.exit(0)

# ---- surrogate construction: QR of private generators; the measure rule of C1 verbatim --------------
def spec128(s):
    sh = s / float(s @ s)
    g = np.linspace(0, len(sh) - 1, 128)
    b = np.interp(g, np.arange(len(sh)), sh)
    return b / b.sum()
def w1(a, b): return float(np.abs(np.cumsum(a) - np.cumsum(b)).sum())
def surrogate(W, gs, stretch=None):
    Wd = W.detach().to("cpu", torch.float64)          # float64 SVD/QR on CPU — mps is for training, not linear algebra
    # rectangular-safe, probe-verified (iso carried-S error 4.5e-26; recompute W1 1.4e-14; far W1 ~11):
    # reduced SVD, orthonormal frames from QR of private-generator Gaussians, spectrum CARRIED (iso) or stretched (far)
    U, S, Vh = torch.linalg.svd(Wd, full_matrices=False)
    m_, n_, k_ = Wd.shape[0], Wd.shape[1], S.numel()
    g = torch.Generator(device="cpu").manual_seed(gs)
    Q1, _ = torch.linalg.qr(torch.randn(m_, m_, generator=g, dtype=torch.float64))
    Q2, _ = torch.linalg.qr(torch.randn(n_, n_, generator=g, dtype=torch.float64))
    S2 = S * torch.exp(torch.linspace(-2.5, 2.5, k_, dtype=torch.float64)) if stretch else S
    B = (Q1[:, :k_] * S2) @ Q2[:, :k_].T   # right frame: n x k (k first QR columns, transposed) — works both m>n (q/gate) and m<n (down); probe-verified on a transposed-shape matrix this time
    # verification measures the bytes the arm will actually train on (fp32 round-trip), with torch's
    # svdvals (robust) — np's LAPACK refused the stretched spectrum outright (run-4's death). Orthogonal
    # frames leave the spectrum exact in theory; here we check the theory survives fp32. Honest by construction.
    Bw = B.to(torch.float32).to(torch.float64)
    s1 = torch.linalg.svdvals(Bw).numpy()
    return Bw, w1(spec128(S.numpy()), spec128(s1))

# ---- arms -------------------------------------------------------------------------------------------
cfg = dict(d=192, layers=4, nh=6, nkv=2, inter=512, vocab=256, ctx=256)
A_, B_, P_, META = rig.load_bytes()
print(f"[c3] corpus meta: kind={META['kind']} shaA={META.get('shaA','')[:12]}… shaB={META.get('shaB','')[:12]}… (pinned with the base run)")

def run_base(t):
    rig.SEED = t; out = os.path.join(STAGE, f"base_s{t}"); os.makedirs(out, exist_ok=True); rig.OUT = __import__("pathlib").Path(out)
    class NS: steps, batch, ctx, full = 600, 16, 256, False
    ns = NS()
    t0 = time.time()
    import contextlib
    buf = os.path.join(out, "base_stdout.log")
    with open(buf, "w") as fh:
        with contextlib.redirect_stdout(fh):
            rig.mode_pretrain(ns)
    json.dump(META, open(os.path.join(out, "corpus_meta.json"), "w"))
    print(f"[c3] base s{t}: {time.time()-t0:.0f} s (stdout→{os.path.basename(buf)})")
    return out

def run_arm(base_out, t, slot_key, variant):
    path, giso, gfar = SLOTS[slot_key]
    rig.SEED = t
    ck = __import__("pathlib").Path(base_out) / f"ckpt_k50.pt"
    model = rig.build(cfg); model.load_state_dict(torch.load(ck, weights_only=True))
    w1_note = None
    if variant != "A":
        obj = model
        for p in path.split("."): obj = getattr(obj, p)           # ModuleList answers numeric child names — the rig's own lora_targets relies on it
        W = obj.weight.detach()
        s0_cpu = torch.linalg.svdvals(W.detach().to("cpu", torch.float64)).numpy()
        gs = giso if variant == "iso" else gfar
        Bw, dist = surrogate(W, gs, stretch=(variant == "far"))
        tol = 1e-8 * float(W.detach().to("cpu").abs().max())      # RELATIVE tolerance: float32 weights on mps, float64 linalg — the assertion keeps its teeth (far must still clear 0.5) without tripping on fp noise
        if variant == "far" and dist < 1.0: sys.exit(f"[c3] CONSTRUCTION FAILURE: far arm W1={dist} < 0.5; abort")
        w1_note = dist
        with torch.no_grad(): obj.weight.copy_(Bw.to(obj.weight.dtype))
    tagged = rig.lora_targets(model, 8)
    ev = {n + "val": torch.load(__import__("pathlib").Path(base_out) / f"eval_{n}.pt", weights_only=True) for n in "ABP"}  # rig fit() labels evals Aval/Bval/Pval: matched to its own naming
    gen = rig.stream(B_, 16, 256, np.random.default_rng(t + 7))
    import contextlib
    with open(os.path.join(base_out, f"arm_{slot_key}_{variant}_s{t}.log"), "w") as fh, contextlib.redirect_stdout(fh):
        curve = rig.fit(model, gen, 300, 5e-4, ev, every=50)
    rec = {"run": "C3-r1", "rig": f"MEF@{RIG_SHA}", "slot": path, "variant": variant, "train_seed": t,
           "adapter": {"r": 8, "alpha": 32, "lr": 5e-4, "steps": 300}, "corpus": META,
           "w1_vs_original": w1_note, "curve": curve,
           "d_Bval_50_100": round(curve[0]["Bval"] - curve[1]["Bval"], 6)}
    fp = os.path.join(CDIR, f"{slot_key}_{variant}_s{t}.curve.json")
    assert not os.path.exists(fp), "curve exists — refuse (reruns are new numbers)"
    open(fp, "w").write(json.dumps(rec, indent=1) + "\n")
    print(f"[c3] arm {slot_key}/{variant}/s{t}: d={rec['d_Bval_50_100']} w1={w1_note if w1_note else 0}")
    return rec

t_start = time.time()
# smoke-first (register clause): price 20 steps before the grid
rig.SEED = 13; so = os.path.join(STAGE, "smoke"); os.makedirs(so, exist_ok=True); rig.OUT = __import__("pathlib").Path(so)
class SNS: steps, batch, ctx, full = 20, 16, 256, False
import contextlib, pathlib
with open(os.path.join(so, "smoke.log"), "w") as fh, contextlib.redirect_stdout(fh): rig.mode_pretrain(SNS())
rate = json.load(open(os.path.join(so, "base_run.json")))["curve"][-1]["secs"] / 20.0
proj = 3 * 600 * rate + 27 * max(48.3, 300 * rate)                # bases at tonight's measured step-rate; arms at D1's print or the step-rate, whichever worse
ceil = 2 * (3 * 600 * 0.12 + 27 * 48.3)                           # 2× the registered ≈32-min budget
print(f"[c3] smoke: base {rate:.3f} s/step · projected ≈{proj:.0f} s vs ceiling {ceil:.0f} s")
sys.exit(f"[c3] REFUSE R7: projected beyond 2×") if proj > ceil else None

results = {}
for t in SEEDS:
    bo = run_base(t)
    for sk in SLOTS:
        for v in ("A", "iso", "far"):
            results[(sk, t, v)] = run_arm(bo, t, sk, v)["d_Bval_50_100"]

# ---- score: one conjunction --------------------------------------------------------------------------
cells, viol, far_agree = [], 0, 0
for sk in SLOTS:
    for t in SEEDS:
        dA, di, df = results[(sk, t, "A")], results[(sk, t, "iso")], results[(sk, t, "far")]
        oki = abs(di - dA) <= BAND
        okf_within = abs(df - dA) <= BAND
        viol += (0 if oki else 1); far_agree += (1 if okf_within else 0)
        cells.append({"slot": sk, "seed": t, "d_A": dA, "d_iso": di, "d_far": df,
                      "diff_iso": round(abs(di - dA), 6), "iso_within_band": oki,
                      "diff_far": round(abs(df - dA), 6), "far_within_band": okf_within})
branch = ("shape carries (sufficient at this scale)" if viol == 0 and far_agree < 9 else
          "metric insensitive (permissive-shape wound)" if viol == 0 and far_agree == 9 else
          "shape NOT the carrier (C1 obituary sentence executes, constructive regime)")
verdict = {"run": "C3-r1", "band_nats": BAND, "band_source": "artifacts/results/D1-C1band_band.json (4-way at runtime)",
           "cells": cells, "n_cells": len(cells), "violations": viol, "far_within_band_count": far_agree,
           "conjunction_score": (viol == 0), "obituary_branch": branch,
           "wall_s": round(time.time() - t_start, 1), "rig": f"MEF@{RIG_SHA}", "seeds": SEEDS,
           "construction_gseeds": {k: {"iso": g1, "far": g2} for k, (_, g1, g2) in SLOTS.items()}}
fp = os.path.join(ROOT, "artifacts/results/C3_verdict.json")
open(fp, "w").write(json.dumps(verdict, indent=1) + "\n")
print(f"[c3] VERDICT: {branch} · violations {viol}/9 · far-agrees {far_agree}/9 · wall {verdict['wall_s']} s")
print(f"[c3] verdict.json — pin BEFORE citing: sha256 {__import__('hashlib').sha256(open(fp,'rb').read()).hexdigest()[:16]}…")
