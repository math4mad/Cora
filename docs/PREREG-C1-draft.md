# C1 — DRAFT, NOT REGISTERED: does the *shape* of a weight spectrum predict early adaptation speed?

**Status: a candidate, deliberately kept out of `PREREG.md`.** Registering it is an act of will
belonging to a human-named session; this file exists so that act has something to bite on. Nothing
here has been run, and nothing here may be cited as a prediction while it lives outside the register
(law 4, and Cora's article II).

**Origin.** The reply-opinion on the Cora fork asked for one thing to be converted from metaphor into
observation: *"if the container deforms, say what a deformed container looks like in bytes."* Its own
example was the same-spectrum / same-early-decay claim, and Chora already carries the two halves of
that claim in separate places — which is what makes it worth testing in a daughter rather than
patching in the father.

---

## The question, in one sentence

For two weight matrices whose **singular-value spectra have the same shape** (after scale
normalisation), does a rank-limited increment applied to one behave like the same increment applied
to the other **in its early loss decay** — and if not, what is the shape *not* carrying?

## The prediction, in falsifiable form

Let $s(M)$ be the normalised spectrum of a matrix ($\sigma_i / \sum_j \sigma_j^2$) and let
$d(M; r, k)$ be the early decay of held-out loss under a rank-$r$ increment injected at $k$ % of a
run, measured over a fixed short window. Take a pair $(A,B)$ with
$\mathrm{W}_1\big(\tilde s(A),\tilde s(B)\big) \le \varepsilon$ (L1 distance between discretised,
scale-normalised spectra).

> **C1 (candidate).** If two matrices are $\varepsilon$-isospectral, then
> $|d(A) - d(B)| \le \mathrm{band}$ — **within regime row and within schedule**, and where both arms
> sit beyond their own noise. If a pair violates this either way, the violation is the result: the
> spectrum shape is *not* the carrier of early adaptation speed, or not the only one.

Three things are deliberately *inside* the statement because Chora's record put them there.

## Scar clause (article III) — what the parent's failures rule out, each by name

| scar, as recorded | what it forbids in C1 |
|---|---|
| **MEF killed the σ-axis as a *location* axis at fine scale** (NEXT.md §2, the merged negative) | C1 may not ask "which singular directions sit where" and may not be scored on final loss; only on **early decay**, as a *shape→dynamics* claim |
| **Sarcos killed the middle-band hypothesis** on a pre-registered small-net test | no "the middle band carries it" fallback is allowed if the pair disagrees — the negative is already paid for |
| **H6c: a good fit with the wrong measure** — evidence path walked to the $\alpha,\beta\to-1$ corner because the object handed to it was a raw count vector (`h6c_verdict.json`, `c51e001a3b1d…`) | the measure must be stated in units and amplitude before any fit; normalise by rule, name the rule, freeze it in the entry |
| **H6a: right dial, wrong timing** — separation S = 7.880 yet dead by the curve clause (`h6a_pilot_verdict.json`, `e08ca86d2ea4…`) | "early" must be defined as a **window with a fixed number of steps**, not as "before the curves separate", or C1 re-drowns in the same clause |
| **H9-M: the regime changed with the variable** — a whole-ladder trend crossed moving-base and frozen-base rows, and the control row had to be invented to see it (`PREREG_H9M.md` §2.4, `verdict.json 32d7cc58732a…`) | every C1 cell is labelled by regime *at the cell level*; no averaging across rows; the same-k reference is the only reference |
| **E3's constant-lr wrinkle** — a schedule signature cannot be adjudicated where nothing decayed (`e3_summary.json`, `05264ddefe9b…`) | C1 claims nothing about schedules; lr is fixed, flat, and named |
| **The thirteen pins** — a merge resolution that was valid JSON with correct hashes and had dropped 13 of the sibling's entries (Letter 021 §3) | C1's inputs are pinned before use and re-hashed at run time; no "consolidated" table that is not a manifest |
| **`E0_seed14_pretrain.log`** — a pin whose bytes exist nowhere, and a baseline that checked survival, not satisfiability (Letter 021 §5) | existence is checked four ways, and forward-only checks are not checks |
| **Gate 6** — the twins met only on 2026-09-13: same seed, two laptops, floors max |Δ| 0.028914 nats, 0.000000 at k=0 (`gate6_twin.json`) | machine effect is *known and small* — so C1's band must be at least as small, or C1 is measuring the laptop |

## Apparatus, borrowed and named

Cora owns no rig. The candidate borrows, cited by sha: the SVD side is `Middle-Eigen-function`'s
existing spectra tooling (the `iso-spectrality` row is already blocked on A's untracked E3 outputs —
that unblock is the cheapest dependency in the programme), and the training side is
`scripts/stage18_kairos_mini.py`'s byte-LM at `MEF@<sha>`, whose 15-arm k×r grid shape and per-arm
units are already measured (**96.2 s/arm on A, 260.2 s/base**). Nothing new is written before the
entry is registered.

## Budget, in units already printed somewhere

Pair construction from existing spectra: minutes, no training. Then per pair: 3 ranks × 2 regimes ×
3 seeds of *short-window* arms ≈ 18 arms ≈ **29 min**, plus 4 base ladders ≈ **17 min** ⇒ ceiling
**≈ 46 min**, with the SVD side free. Units are cited, not believed.

## Obituary, written now (so the shape of the failure is known before the failure)

If $\varepsilon$-isospectral pairs differ beyond band in early decay, **then the spectrum is not the
carrier**: the claim that "the shape of the weight holds the learning" narrows to *a* shape and not
*the* shape, and NEXT.md's three-knob table loses its honest right to speak of σ-position at fine
scale — where MEF already buried it once. If non-isospectral pairs agree beyond band, the claim is
equally wounded from the other side: the spectrum would then be *permissive* rather than
*informative*, and "shape = knowledge" would have to be re-worded as "shape = permission". **Either
outcome is a result, and both go in the letters, not the bin.**

## What must exist before this may be registered

1. A human-named session for the workspace and the borrowed bench (rules 3 and 5: writing is
   permissioned, reading is not).
2. A band — same-machine replicates, `n ≥ 2`, frozen before the first pair is scored (the parent's
   §4 rule, applied here so that C1 is not born unable to lose).
3. A named curve file. Chora's H6a/H6b queue still waits on exactly this: *the run script must refuse
   to start without a named curve file* — no re-registration of a hope.
4. The scar clause re-checked against whatever the parent has learned since this draft was written.

*Drafted 2026-09-13 by the chair's hand at the human's word; endorsed-in-form by the reply-opinion's
§5.2 example `(sha256 6d1b7210b80b4a7e…)`. **Unregistered on purpose**: a frame is not a decision.*

---

**Erratum, 2026-09-13 (appended, not edited — law 4: no quiet correction).** The footer above cites
the reply-opinion's endorsement at `(sha256 6d1b7210b80b4a7e…)`. That hash resolves to **no bytes in
either workspace** (searched: files, manifests, git history — cf. letter 002 §2). The reply-opinion's
current bytes are `9ebc7ed1d02ea0c2…` at `chora:artifacts/external/Chora_Your_Doughter_Is_Born/
Qwen-sencond-round-review.md`, untracked and therefore *still uncitable* until the father pins it.
**Registration precondition ① now reads:** replace this endorsement with a pin that resolves — either
the pinned review, or the original source of `6d1b7210…` if it surfaces. C1 stays unregistered; the
obituary stands; the failure mode caught here is S6's own class, caught by this workspace's own
instrument on its own document. That is the immunisation working, and it is logged as a result.

**Erratum follow-through (same appended section, second entry):** the phantom token
`6d1b7210b80b4a7e…` in the footer above stays in the text *marked unresolved* — what would resolve
it: either the chair produces the bytes it was read from (then: pin them, and the endorsement
stand), or Chora pins `Qwen-sencond-round-review.md` (`9ebc7ed1…`, letter 002 §4) and precondition ①
is rewritten to point at that. Until one of the two happens, this draft's endorsement clause is
**open debt**, and `bin/hash-audit.sh` will keep refusing to let it read as verified.

**Status line, 2026-09-13 (append-only):** precondition ② **met by drill D1-C1band** — band
0.003158 nats, pinned at `artifacts/results/D1-C1band_band.json` `(sha256
86cce6228634b62e390426784a8ef457054a6a967e1d233592134d6f475b42eb)`, register postscript carries the
readings. ① and ③ still open; the draft remains unregistered.

**Status line, 2026-09-13 (second, append-only):** registered as C1 by the chair's 「由您代笔」 and
**ratified** the same day by the chair's 「confirm」 (scribe-line `Κ-hand-004` in the register).
① remains the only open precondition; ② band pinned, ③ curve files named in-entry, ④ scar re-check
landed with the D1 readings.
