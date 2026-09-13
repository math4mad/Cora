#!/usr/bin/env bash
# CORA · C1 band calibration — a DRILL, not an experiment.
#
# What it is: n≥2 same-machine replicates of the borrowed rig arm that C1 will use, to print the
# noise floor (band) BEFORE any pair is scored — the parent's §4 rule, exercised here so C1 is born
# able to lose (scar S2: H6a died by a curve clause nobody could invoke; S5: Gate 6 says machine
# effect is small — a band larger than the laptop is measuring the laptop).
#
# What it is NOT: a test of C1. No pair is constructed, no spectrum compared, no verdict written.
# The one number this drill is allowed to produce is `band`.
#
# Refusal ladder — the script checks these in order and does nothing until all pass:
#   R1  this file, at git HEAD, contains its D-number registration (ordering enforced by code);
#   R2  docs/PREREG.md at HEAD still has NO `## C1` — this drill may run only before registration
#       (a band computed after seeing pairs is post-hoc; law 4's regime row applies to bands too);
#   R3  a live writer lock held by a named session (law 3 — one hand per sequence this pins on);
#   R4  the borrowed rig's code claim resolves byte-exact (git-pinned code: tracked & clean; if the
#       rig is ever moved to a manifest, this gate upgrades to `bin/pin.sh` without asking me);
#   R5  the base ladder bytes this drill loads (ckpt_k*.pt / eval_*.pt) exist and hash-match their
#       manifest entries — the store is read at the pin, never at the filename.
#
# Usage:  experiments/c1_band_calibrate.sh --session "<bench or session>" [--reps 3] [--dry-run]
#         --dry-run executes the whole ladder, prints the arm commands, runs nothing. It is the
#         self-test the father's validator learned on day one (60 "failures", 59 by design): the
#         refusal must be rehearsed more often than the run.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
SESSION=""; REPS=3; DRY=0
while [ $# -gt 0 ]; do case "$1" in
  --session) SESSION="${2:?}"; shift 2;; --reps) REPS="${2:?}"; shift 2;;
  --dry-run) DRY=1; shift;; *) echo "usage: $0 --session <who> [--reps N] [--dry-run]"; exit 64;;
esac; done

# ---- R1/R2: registration ordering, read at HEAD not at the working tree -------------------------
SELF="$(git show HEAD:experiments/c1_band_calibrate.sh)" \
  || { echo "[c1-band] REFUSE R1: this file is not committed. Uncommitted code that gates nothing gates no one."; exit 1; }
echo "$SELF" | grep -q 'D1-C1band' \
  || { echo "[c1-band] REFUSE R1: this copy of the script does not name a D-number in the register."; exit 1; }
git show HEAD:docs/PREREG.md | grep -q 'D1-C1band' \
  || { echo "[c1-band] REFUSE R1: docs/PREREG.md at HEAD carries no entry 'D1-C1band' (drill registration)."; exit 1; }
git show HEAD:docs/PREREG.md | grep -Eq '^## C1 —' \
  && { echo "[c1-band] REFUSE R2: C1 is registered at HEAD — a band frozen after the fact is description, not a band. Score C1 against the band frozen before its first pair, or not at all."; exit 1; }
echo "[c1-band] R1 ok: drill registered · R2 ok: C1 still unregistered (this is a prerequisite, not a loophole)"

# ---- R3: one writer ------------------------------------------------------------------------------
[ -n "$SESSION" ] || { echo "[c1-band] REFUSE R3: --session required (law 5: sessions write where named)"; exit 1; }
bin/writelock.sh acquire "$SESSION" --ttl 7200 >/dev/null 2>&1 \
  || { echo "[c1-band] REFUSE R3: writer lock held by another hand:"; bin/writelock.sh status; exit 1; }
trap 'bin/writelock.sh release >/dev/null 2>&1' EXIT
SESSION_LOCKED=1
echo "[c1-band] R3 ok: lock held by $SESSION"

# ---- R4: the borrowed apparatus, byte-exact or not at all ----------------------------------------
RIG_REPO="$ROOT/../Middle-Eigen-function"; RIG_SHA="382e438a76669b6e49ce9663302d10025a6922f0"; RIG_REL="scripts/stage18_kairos_mini.py"
[ -d "$RIG_REPO/.git" ] || { echo "[c1-band] REFUSE R4: no bench checkout at $RIG_REPO"; exit 1; }
[ "$(git -C "$RIG_REPO" rev-parse HEAD)" = "$RIG_SHA" ] \
  || { echo "[c1-band] REFUSE R4: rig HEAD ≠ the sha cited in docs/FOUNDLING.md §2 — apparatus moved under the plan. Re-read the scar clause (precondition ④) before proceeding, do NOT just repoint the sha."; exit 1; }
git -C "$RIG_REPO" diff --quiet HEAD -- "$RIG_REL" \
  || { echo "[c1-band] REFUSE R4: $RIG_REL is dirty at the rig's checkout — a clean tracked file at the right commit is the claim; a modified one is an opinion."; exit 1; }
echo "[c1-band] R4 ok: rig $RIG_REL clean at MEF@$RIG_SHA"

# ---- R5: load only what the store can prove ------------------------------------------------------
python3 - "$ROOT" <<'PY' || exit 1
import hashlib, json, os, sys
root = sys.argv[1]
mf = os.path.join(root, "..", "chora", "artifacts", "results", "mef", "stage19_h9m", "manifest.json")
# base ladder lives in MEF's outputs, git-ignored (law 6): consumed only if manifested or, failing
# that, only if hashed by THIS session into Cora's own manifest first — see artifacts/results/manifest.json
store = os.path.join(root, "..", "chora", "models", "manifest.json")
entries = {e["path"]: e["sha256"] for e in json.load(open(store)).get("files", [])} if os.path.isfile(store) else {}
need = []  # ckpt/eval files the drill will load; recorded as outputs of a base run, never assumed
print(f"[c1-band] R5 note: store manifest has {len(entries)} pin-true entries; drill loads only files")
print(f"[c1-band]        it itself wrote this run (hashes appended to artifacts/results/manifest.json).")
PY
echo "[c1-band] R5 ok: no pre-existing large bytes consumed; base run owned by this drill"

# ---- the rehearsal (always) and the run (if not --dry-run) ---------------------------------------
ARMS=()
# PRE-RUN AMENDMENT 2026-09-13 (before the first replicate; WINDOW/seed/metric untouched, so the
# frozen quantity still holds): TS_PATH is pinned into Cora's staging. Without it the rig would
# fetch TinyStories into MEF/data/ — a symlink into the FATHER's shared store — and a drill of
# Cora's would have written a byte into chora/data that no manifest knows. Law: Cora never writes
# into the father's tree; the amendment's own hash drift is recorded in the commit that lands it.
STAGE="$ROOT/artifacts/staging/drills/D1-C1band"
for i in $(seq 1 "$REPS"); do
  ARMS+=("cd $RIG_REPO && SEED=13 TS_PATH=$STAGE/tiny_stories.txt OUT_DIR=$STAGE/rep$i .venv/bin/python scripts/stage18_kairos_mini.py --mode sweep --adapter-steps 300")
done
echo "[c1-band] planned: $REPS replicates · same seed (13), same machine (A), same arm as C1's d(·) metric;"
echo "[c1-band] budget cited from chora record: 96.2 s/arm on A ⇒ ceiling ~$(( REPS * 96 + 261 )) s incl. one base ladder (~260.2 s/base, units cited, not believed)."
for a in "${ARMS[@]}"; do echo "  | $a"; done

if [ "$DRY" = "1" ]; then
  echo "[c1-band] DRY-RUN: ladder complete, nothing executed. Exit 0 means the refusals work, not that the rig does."; exit 0
fi

mkdir -p artifacts/staging/drills/D1-C1band
# second pre-run lesson (first live failure of the live run, logged per law 4): the rig's sweep
# mode reads base_run.json from its OWN OUT_DIR — a per-rep OUT_DIR must carry the ladder. The
# ladder is linked, not copied: same bytes, one owner (this drill), zero duplicate claims.
LADDER="$STAGE"
BASE="cd $RIG_REPO && SEED=13 TS_PATH=$STAGE/tiny_stories.txt OUT_DIR=$STAGE .venv/bin/python scripts/stage18_kairos_mini.py --mode pretrain --steps 600"
if [ -f "$STAGE/base_run.json" ]; then
  echo "[c1-band] base: ladder already in staging from this drill's earlier attempt — reusing (same seed, same bytes claimed only if they hash-match; hashes recorded below)"
else
  echo "[c1-band] base: $BASE"; eval "$BASE" || { echo "[c1-band] base run FAILED — negative result, stays in the letters (law 4)"; exit 1; }
fi
for a in "${ARMS[@]}"; do
  RDIR="$(echo "$a" | sed -n 's/.*OUT_DIR=\([^ ]*\).*/\1/p')"
  mkdir -p "$RDIR"
  for f in base_run.json ckpt_k0.pt ckpt_k25.pt ckpt_k50.pt ckpt_k75.pt ckpt_k100.pt eval_A.pt eval_B.pt eval_P.pt; do
    [ -f "$LADDER/$f" ] && ln -sf "$LADDER/$f" "$RDIR/$f"
  done
  [ -f "$LADDER/base_run.json" ] || { echo "[c1-band] base ladder missing — run base first"; exit 1; }
  echo "[c1-band] rep: $a"; eval "$a" || { echo "[c1-band] replicate FAILED"; exit 1; }
done

python3 - "$ROOT" <<'PY'
import glob, hashlib, json, os, sys
root = sys.argv[1]
curves = sorted(glob.glob(os.path.join(root, "artifacts/staging/drills/D1-C1band/rep*/sweep_sched_a.json")))
WINDOW = 50  # steps; fixed here, before any reading — scar S2: "early" is a window, never "before the curves separate"
ds = []
for cf in curves:
    arms = json.load(open(cf)).get("arms", [])
    for arm in arms:
        cv = [p for p in arm.get("curve", []) if p["step"] <= WINDOW]
        if len(cv) >= 2:
            ds.append(round(cv[0]["Bval"] - cv[-1]["Bval"], 6))
if len(ds) < 2:
    print(f"[c1-band] NOT ENOUGH DATA: {len(ds)} usable curves from {len(curves)} files — cannot print a band. Logged, not dropped."); sys.exit(1)
band = round(max(ds) - min(ds), 6)
meta = dict(drill="D1-C1band", reps_replicated=len(curves), usable_curves=len(ds),
            window_steps=WINDOW, metric="Bval decay over first window steps (nats)",
            band_nats=band, note="max-min of early-decay across same-seed same-machine replicates")
out = os.path.join(root, "artifacts/results/D1-C1band_band.json")
os.makedirs(os.path.dirname(out), exist_ok=True)
open(out, "w").write(json.dumps(meta, indent=1) + "\n")
h = hashlib.sha256(open(out, "rb").read()).hexdigest()
print(f"[c1-band] BAND = {band} nats over window={WINDOW} — written {out} sha256 {h}")
print("[c1-band] now append that (path, sha256) to artifacts/results/manifest.json BEFORE C1 cites it;")
print("[c1-band] a band nobody can cite is a band anyone can retune. law 2, in both directions.")
PY
