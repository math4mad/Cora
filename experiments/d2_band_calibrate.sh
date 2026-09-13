#!/usr/bin/env bash
# CORA · D2-C1band — the same band, measured on the store's treasure. (Register entry: D2; chair's
# 「running D2」 of 2026-09-13 is the live-run order. Paperwork was Κ-hand-005's; bytes are tonight's.)
#
# Differences from D1, deliberate and few: corpus = data/tiny_stories.txt read THROUGH THE MOUNT
# (pinned treasure, four-ways verified before consumption, fetch impossible at 400 MB > 5 MB floor);
# the ceiling gate is computed from the PINNED D1 curves (the "~7.5 min" in earlier prose was an
# estimate, never measured — this script's arithmetic replaces it, and the erratum stands in the register).
# Metric, seed, rig, window and per-arm rule are copied from D1 correction #3 verbatim, because the
# whole point is the corpus question and nothing else may vary.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
SESSION=""; DRY=0
while [ $# -gt 0 ]; do case "$1" in
  --session) SESSION="${2:?}"; shift 2;; --dry-run) DRY=1; shift;;
  *) echo "usage: $0 --session <Κ-hand-n> [--dry-run]"; exit 64;;
esac; done
REF() { echo "[d2] REFUSE $1: $2"; exit 1; }

# ---- gates -----------------------------------------------------------------------------------------
git show HEAD:docs/PREREG.md | grep -q '### D2-C1band' || REF R1 "D2 not registered at HEAD"
[ -f artifacts/results/C1/pairs.json ] && REF R2 "pairs exist — D2 after pairs is post-hoc; the obituary covers the other branch, not this one"
[ -n "$SESSION" ] || REF R3 "--session required"
case "$SESSION" in Κ-hand-*) ;; *) REF R3 "house mark required (Κ-hand-<n>)";; esac
bin/writelock.sh acquire "$SESSION" --ttl 7200 >/dev/null 2>&1 || { bin/writelock.sh status; REF R3 "lock held elsewhere"; }
trap 'bin/writelock.sh release >/dev/null 2>&1' EXIT
RIG="$ROOT/../Middle-Eigen-function"; SHA="382e438a76669b6e49ce9663302d10025a6922f0"
[ "$(git -C "$RIG" rev-parse HEAD)" = "$SHA" ] || REF R4 "rig HEAD moved under the plan"
git -C "$RIG" diff --quiet HEAD -- scripts/stage18_kairos_mini.py || REF R4 "rig dirty"
TS="$ROOT/data/tiny_stories.txt"
TSSHA="$(python3 -c "import json;print([e['sha256'] for e in json.load(open('$ROOT/data/manifest.json'))['files'] if e['path']=='data/tiny_stories.txt'][0])" 2>/dev/null || true)"
[ -n "${TSSHA:-}" ] || REF R5 "corpus unpinned"
bin/pin.sh data/tiny_stories.txt "$TSSHA" >/dev/null 2>&1 || REF R5 "treasure fails four ways at consumption"
echo "[d2] gates ok: registered · pre-pairs · lock $SESSION · rig clean · corpus = pinned treasure (${TSSHA:0:16}…)"

STAGE="$ROOT/artifacts/staging/drills/D2-C1band"; mkdir -p "$STAGE"
RIGCMD="cd $RIG && SEED=13 TS_PATH=$TS OUT_DIR"
# ---- ceiling gate: 2 × D1 wall, D1 wall ARITHMETICED from its own pinned curves ----------------------
python3 - "$ROOT" <<'PY' || REF R6 "cannot compute D1 ceiling from pinned curves"
import json, sys, os
root = sys.argv[1]
base = json.load(open(os.path.join(root, "artifacts/staging/drills/D1-C1band/base_run.json")))
t0 = base["curve"][-1]["secs"]
arms = sum(json.load(open(os.path.join(root, f"artifacts/results/D1-C1band/rep{i}.sweep_sched_a.json")))["arms"][a]["curve"][-1]["secs"]
           for i in (1,2,3) for a in range(5))
d1_wall = t0 + arms + 3*25   # + per-rep eval passes, generously 25 s
print(f"[d2] D1 wall, arithmetic from pinned bytes: {d1_wall:.0f} s (base {t0:.1f} + 15 arms {arms:.0f} + eval slack 75) — ceiling for D2 = {2*d1_wall:.0f} s")
open(os.path.join(root, "artifacts/staging/drills/D2-C1band/ceiling.txt"), "w").write(f"{d1_wall:.0f} {2*d1_wall:.0f}")
PY
[ "$DRY" = "1" ] && { echo "[d2] DRY-RUN stops here — gates and arithmetic shown, rig untouched."; exit 0; }

# ---- smoke-first: price BOTH phases before any replicate.
# R8-v2 (lives as an amendment; the gate's first live REFUSAL 2026-09-13 stands in the register):
# v1 applied the pretrain step-rate to the adapter arms — a units bug: D1's base ran 0.120 s/step
# while its arms ran ~0.054 s/step, and v1's formula could not have passed for D1 itself (would
# project D1 at ~2700 s against the 1744 s ceiling it actually met). Fixed by MEASURING both rates
# from 20-step smokes; the CEILING is untouched — an arithmetic repair, not a negotiation.
eval "$RIGCMD=$STAGE/smoke .venv/bin/python scripts/stage18_kairos_mini.py --mode pretrain --steps 20" >/dev/null 2>&1 \
  || REF R7 "base smoke failed — logged, not dropped"
eval "$RIGCMD=$STAGE/smoke .venv/bin/python scripts/stage18_kairos_mini.py --mode sweep --adapter-steps 20" >/dev/null 2>&1 \
  || REF R7 "arm smoke failed — logged, not dropped"
python3 - "$STAGE" <<'PY' || REF R8 "projected beyond 2× D1 wall — refuse before the science"
import json, sys, os, glob
stage = sys.argv[1]
rate_base = json.load(open(os.path.join(stage, "smoke", "base_run.json")))["curve"][-1]["secs"] / 20.0
sm = glob.glob(os.path.join(stage, "smoke", "sweep_sched_a.json"))
if sm:
    arms = json.load(open(sm[0]))["arms"]
    pts = [a["curve"][-1]["secs"] for a in arms if a.get("curve")]
    rate_arm = (sum(pts) / len(pts)) / 20.0 if pts else rate_base * 0.5
else:
    rate_arm = rate_base * 0.5
proj = (600 * rate_base + 45 * 300 * rate_arm + 3 * 30 + 60) * 1.3
ceil = float(open(os.path.join(stage, "ceiling.txt")).read().split()[1])
print(f"[d2] smoke prints (treasure corpus): base {rate_base:.3f} s/step · arm {rate_arm:.3f} s/step "
      f"· projected D2 wall ≈ {proj:.0f} s vs ceiling {ceil:.0f} s")
sys.exit(0 if proj <= ceil else 1)
PY

# ---- run: base ladder + 3 replicates (D1's structure, symlinks for the ladder) -----------------------
eval "$RIGCMD=$STAGE .venv/bin/python scripts/stage18_kairos_mini.py --mode pretrain --steps 600" >/dev/null 2>&1 || REF base "base ladder failed"
for i in 1 2 3; do
  mkdir -p "$STAGE/rep$i"
  for f in base_run.json ckpt_k0.pt ckpt_k25.pt ckpt_k50.pt ckpt_k75.pt ckpt_k100.pt eval_A.pt eval_B.pt eval_P.pt; do
    [ -e "$STAGE/$f" ] && ln -sf "$STAGE/$f" "$STAGE/rep$i/$f"; done
  eval "$RIGCMD=$STAGE/rep$i .venv/bin/python scripts/stage18_kairos_mini.py --mode sweep --adapter-steps 300" >/dev/null 2>&1 || REF rep "replicate $i failed"
  echo "[d2] rep$i done"
done

# ---- band: metric copied from D1 correction #3 verbatim ----------------------------------------------
python3 - "$ROOT" <<'PY'
import glob, hashlib, json, os, sys
root = sys.argv[1]
curves = sorted(glob.glob(os.path.join(root, "artifacts/staging/drills/D2-C1band/rep*/sweep_sched_a.json")))
SPREAD = {}; rep_hashes = {cf: hashlib.sha256(open(cf, "rb").read()).hexdigest() for cf in curves}
for cf in curves:
    for arm in json.load(open(cf)).get("arms", []):
        cv = arm.get("curve", [])
        if len(cv) >= 2 and cv[1]["step"] - cv[0]["step"] == 50:
            SPREAD.setdefault((arm["k"], arm["r"]), []).append(round(cv[0]["Bval"] - cv[1]["Bval"], 6))
usable = {a: v for a, v in SPREAD.items() if len(v) >= 2}
per_arm = {f"k{a}r{b}": {"n": len(v), "spread": round(max(v)-min(v), 6), "decays": v} for (a,b), v in sorted(usable.items())}
band = max(d["spread"] for d in per_arm.values())
D1 = 0.003158
meta = dict(drill="D2-C1band", corpus="data/tiny_stories.txt via mount (pinned, four-ways verified at consumption)",
            reps_replicated=len(curves), arms_usable=len(per_arm), metric="identical to D1 correction #3",
            band_nats=band, d1_band_nats=D1, ratio_vs_d1=round(band/D1, 4),
            verdict_rule="D2 adopts over D1 if band > 2× D1 (register wording: 'materially exceeds'); this script prints, the chair's register postscript decides",
            per_arm=per_arm, curve_inputs={os.path.relpath(cf, root): h for cf, h in rep_hashes.items()})
out = os.path.join(root, "artifacts/results/D2-C1band_band.json")
open(out, "w").write(json.dumps(meta, indent=1) + "\n")
h = hashlib.sha256(open(out, "rb").read()).hexdigest()
print(f"[d2] BAND(treasure) = {band} nats vs D1 {D1} (ratio {band/D1:.2f}×) — {out} sha256 {h[:16]}…")
for k, d in per_arm.items(): print(f"[d2]   {k}: n={d['n']} spread={d['spread']}")
PY
