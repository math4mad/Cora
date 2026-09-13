#!/usr/bin/env bash
# CORA · c1_run.sh — the C1 runner (Κ-hand). It cannot run C1 yet, and that is its main feature:
# the register's C1 entry is GHOSTWRITTEN/INACTIVE, and this script is the code half of article II
# ("ordering is enforced by the instrument, not by resolve").
#
# Gate ladder, in order; each refusal names the pen that must write its unlock:
#   R1  `## C1` present in docs/PREREG.md at git HEAD, carrying its authorship-protest header
#   R2  a `**Ratified:**` line inside the C1 block at HEAD               (pen: the CHAIR, 追认)
#   R3  precondition ① resolves: the reply-opinion passes bin/pin.sh     (pen: the FATHER, pin)
#   R4  writer lock, held by a named Κ-hand session                      (this hand)
#   R5  apparatus byte-clean at the cited sha: rig + both spectra tools  (re-checked, never remembered)
#   R6  the band Cora cites is still true four ways                      (self-audit of the register)
#   R7  spectra ledger + pairs file exist, every line pin-verifies       (search session pins before use)
#   R8  --curve-dir given, NO target curve exists there yet              (reruns are new numbers, not amnesia)
#   R9  smoke-first pricing: one 20-step arm prints s/arm in Cora's own units; projected
#       ceiling > 2× the entry's ⇒ refuse before the science, never after.
#
# Usage: experiments/c1_run.sh --session "Κ-hand-<n>" --curve-dir artifacts/results/C1/<runid> [--dry-run]
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
SESSION=""; CDIR=""; DRY=0
while [ $# -gt 0 ]; do case "$1" in
  --session) SESSION="${2:?}"; shift 2;; --curve-dir) CDIR="${2:?}"; shift 2;;
  --dry-run) DRY=1; shift;; *) echo "usage: $0 --session <Κ-hand-n> --curve-dir <path> [--dry-run]"; exit 64;;
esac; done
REF() { echo "[c1] REFUSE $1: $2"; [ -n "${3:-}" ] && echo "      unlock: $3"; exit 1; }
echo "[c1] C1 runner — gate ladder (every refusal names its pen)"

# ---- R1: registered at HEAD, with its authorship protest intact -----------------------------------
PREREG="$(git show HEAD:docs/PREREG.md)" || REF R1 "no PREREG at HEAD"
printf '%s\n' "$PREREG" | grep -q '^## C1 —' || REF R1 "docs/PREREG.md at HEAD carries no '## C1'"
printf '%s\n' "$PREREG" | sed -n '/^## C1 —/,/^## /p' | grep -q 'GHOSTWRITTEN' \
  || REF R1 "the C1 block at HEAD no longer carries its authorship protest — something rewrote the register; trust nothing, re-read everything before this script may trust it again"
echo "[c1] R1 ok: registered at HEAD, protest header intact"

# ---- R2: the chair's 追认 ---------------------------------------------------------------------------
printf '%s\n' "$PREREG" | sed -n '/^## C1 —/,/^## /p' | grep -q '^\*\*Ratified:\*\*' \
  || REF R2 "C1 is INACTIVE: no '**Ratified:**' line in the C1 block" \
       "the chair's own pen — a line '**Ratified:** <date>, 「追认」, by chair (cora@<sha>)' appended inside the C1 block by a session the chair names. This hand will not forge what it was told to keep."
echo "[c1] R2 ok: ratified by the chair"

# ---- R3: precondition ①, the father's pin ------------------------------------------------------------
REVIEW="artifacts/external/Chora_Your_Doughter_Is_Born/Qwen-sencond-round-review.md"
REVIEW_SHA="9ebc7ed1d02ea0c26359d3cabf0fdd4c6fa0560264480ea5b4935523bf65aea9"
if ! bin/pin.sh "$REVIEW" "$REVIEW_SHA" >/dev/null 2>&1; then
  REF R3 "precondition ① open: the endorsement's bytes fail the four-way check (untracked or unmanifested at the father's HEAD)" \
        "the father's hand: pin the review in a manifest at chora HEAD (letter 006 §2.3). If he instead produces the owner of 6d1b7210…, this gate is amended — by a commit that quotes both hashes, never by drift."
fi
echo "[c1] R3 ok: ① resolved by the father's pin"

# ---- R4: one writer ---------------------------------------------------------------------------------
[ -n "$SESSION" ] || REF R4 "--session required"
case "$SESSION" in Κ-hand-*) ;; *) REF R4 "sessions of this hand must carry the house mark (Κ-hand-<n>, FOUNDLING §6) — marks in signature slots only, and this is a signature slot";; esac
bin/writelock.sh acquire "$SESSION" --ttl 7200 >/dev/null 2>&1 \
  || { bin/writelock.sh status; REF R4 "writer lock held elsewhere"; }
trap 'bin/writelock.sh release >/dev/null 2>&1' EXIT
echo "[c1] R4 ok: lock held by $SESSION"

# ---- R5: apparatus, byte-clean or silent --------------------------------------------------------------
RIG="$ROOT/../Middle-Eigen-function"; SHA="382e438a76669b6e49ce9663302d10025a6922f0"
[ "$(git -C "$RIG" rev-parse HEAD 2>/dev/null)" = "$SHA" ] || REF R5 "rig HEAD ≠ cited sha"
for f in scripts/stage18_kairos_mini.py scripts/spectral_steepness.py scripts/stage14_rank1_atoms.py; do
  git -C "$RIG" diff --quiet HEAD -- "$f" || REF R5 "$f dirty at the rig's checkout"
  [ -f "$RIG/$f" ] || REF R5 "$f missing"
done
echo "[c1] R5 ok: rig + spectra tools clean at MEF@$SHA"

# ---- R6: the band still true --------------------------------------------------------------------------
BANDSHA="86cce6228634b62e390426784a8ef457054a6a967e1d233592134d6f475b42eb"
bin/pin.sh artifacts/results/D1-C1band_band.json "$BANDSHA" >/dev/null 2>&1 \
  || REF R6 "the band Cora cites (86cce622…) no longer verifies four ways — the register's frozen number has drifted; nothing scores against a moved band"
echo "[c1] R6 ok: band 0.003158 nats verified at run time, not remembered"

# ---- R7: inputs the search session must have pinned ----------------------------------------------------
LEDGER="$ROOT/artifacts/results/C1/spectra_source.tsv"; PAIRS="$ROOT/artifacts/results/C1/pairs.json"
[ -f "$LEDGER" ] || REF R7 "no spectra-corpus ledger yet — the pair-search session writes (path<TAB>sha256) lines and pins them BEFORE the runner consumes any"
[ -f "$PAIRS" ]  || REF R7 "no pairs.json — ε=0.01 search must run, its output pinned, its negatives logged"
while IFS=$'\t' read -r p s; do
  case "$p" in ''|\#*) continue;; esac
  bin/pin.sh "$p" "$s" >/dev/null 2>&1 || REF R7 "ledger line fails pin.sh: $p"
done < "$LEDGER"
echo "[c1] R7 ok: corpus ledger and pairs pinned"

# ---- R8: curve files named and unwritten ----------------------------------------------------------------
[ -n "$CDIR" ] || REF R8 "--curve-dir required (entry names the pattern <pairid>_<row>_k<k>_r<r>_s<seed>.curve.json)"
case "$CDIR" in artifacts/results/C1/*) ;; *) REF R8 "curve dir must live under artifacts/results/C1/ (sessions write where named)";; esac
[ -z "$(find "$CDIR" -name '*.curve.json' 2>/dev/null | head -1)" ] \
  || REF R8 "curve files already exist in $CDIR — a rerun gets a new <runid>; amnesia is not a mode of this house"
echo "[c1] R8 ok: curve dir named, empty"

# ---- R9: smoke-first pricing, then the science ----------------------------------------------------------
STAGE="$ROOT/artifacts/staging/runs/$(basename "$CDIR")"; mkdir -p "$STAGE"
CEILING_ENTRY_S=2400   # entry: ≈40 min, plus the entry's own 2× clause
if [ "$DRY" = "1" ]; then
  echo "[c1] DRY-RUN: all gates green would reach here; would smoke (20 steps, one arm), price, then:"
  echo "      2 pairs × 18 arms + 4 bases, seeds {13,14,15}, rows separate, conjunction scored once."
  echo "[c1] DRY-RUN: nothing executed."; exit 0
fi
SMOKE="cd $RIG && SEED=13 TS_PATH=$STAGE/../D1-C1band/tiny_stories.txt OUT_DIR=$STAGE/smoke .venv/bin/python scripts/stage18_kairos_mini.py --mode pretrain --steps 20"
echo "[c1] smoke: $SMOKE"; eval "$SMOKE" || REF R9 "smoke arm failed — apparatus is clean of bytes but not of will; logged, not dropped"
python3 - "$STAGE" "$CEILING_ENTRY_S" <<'PY'
import json, glob, sys, os
stage, ceil = sys.argv[1], int(sys.argv[2])
b = json.load(open(os.path.join(stage, "smoke", "base_run.json")))
secs = b["curve"][-1]["secs"] / b["steps"]              # s/step, Cora's own print, this run, this corpus
arms, bases = 36, 4
proj = int(arms * 300 * secs * 1.3 + bases * 600 * secs * 1.3)   # +30% margin over measured rate
print(f"[c1] smoke print: {secs:.3f} s/step · projected ceiling ≈ {proj} s (entry ceiling {ceil} s, cap ×2 = {2*ceil})")
sys.exit(0 if proj <= 2*ceil else 1)
PY
[ $? -eq 0 ] || REF R9 "projected ceiling exceeds 2× the entry's — the entry's corpus clause says re-price, so the entry (or the corpus choice) reopens with the chair's pen; the runner does not renegotiate alone"
echo "[c1] R9 ok: priced inside the entry's own clause — science may proceed; the full arm grid follows below in the registered pattern"
echo "[c1] NOTE (honest): arm-grid execution code is deliberately absent until pairs.json exists —"
echo "[c1]       writing 'run over pairs' before the pairs are pinned would be code about nothing."
