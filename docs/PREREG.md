# PREREG — the register of Cora

**Empty by design.** Nothing may run from this workspace before a prediction is committed here:
statement, metric, regime row, band rule, seed policy, budget in measured units, frozen date — **and
the scar clause** (§0.3 below). The first entry, when it arrives, may not predate the founding record
in `FOUNDLING.md`, and the run script that consumes it must refuse to start unless this file at
`git HEAD` contains the entry it names. Ordering enforced by code, not by resolve.

---

## 0 · Standing requirements for every entry

1. **One hypothesis check per number.** A conjunction is one check; its halves are reported and score
   nothing.
2. **Regimes in separate rows, forever** — *post-hoc-truncation* / *training-under-constraint* /
   *frozen-base-increment* / *init-measure*. Anything fit after training is description and is
   labelled `post-hoc` permanently.
3. **The scar clause (Cora's own article III).** Every entry names at least one recorded failure of
   the parent workspace that bounds it — from `FOUNDLING.md` §3 or a later one — and says what it
   rules out. The reason is not ritual: Chora's most valuable results of 2026-09-12/13 were deaths,
   and a system that cannot remember which roads are blocked will walk them again and name the repeat
   a discovery. **Citing a scar is inoculation, not citation.**
4. **A metaphor pays a toll** (law 7): if the entry's motivation contains one, the entry must contain
   the observation that would falsify it, in the same paragraph. *"The container deforms"* becomes a
   claim only when someone writes what a deformed container looks like in bytes.
5. **Budget in measured units, or it is a wish.** Quote the machine and the commit whose run printed
   the unit.

## Drills — measurements that test the apparatus, not a hypothesis

A drill borrows this register's paperwork discipline (dated entry, budget in cited units, obituary)
without making a prediction: its only permitted number is about the instrument. A drill may not
test anything, and a registered hypothesis may not be scored on a band a drill printed after its
first pair was seen (R2 in the drill script enforces exactly this direction).

### D1-C1band — what is the same-machine noise floor of the borrowed early-decay metric?
**Registered:** 2026-09-13, machine A, by the standing hand under the chair's nod of this day
(「我点头」, authorizing *preparation and rehearsal*; the live run is withheld until the chair
commands it explicitly — law: no experiment started by an agent that no human-named session authorised).
**Scar clause:** S2 (`h6a_pilot_verdict.json`, `e08ca86d2ea4…`) — "early" must be a fixed step window,
not "before the curves separate": this drill freezes WINDOW=50 steps *in the script, at HEAD, before
any replicate exists*. S5 (`gate6_twin.json`, `52efb2a5baf5…`) — cross-machine floor is 0.028914 nats
max |Δ|; if the *same-machine, same-seed* floor comes out comparable or larger, the rig carries
nondeterminism Gate 6 said the machine does not, and that contradiction is the drill's result.
**Question.** Replicating one arm (seed 13, machine A, `MEF@382e438a…`, byte-clean) n=3 times:
how much does the first-50-step held-out decay wander?
**Metric.** Δdecay of `Bval` over steps ≤ 50, nats; reported statistic: max−min across replicates.
**Regime row.** training-under-constraint, schedule a-fixed-budget, lr flat 5e-4 (named, per E3's scar).
**Budget.** 3 arms × 96.2 s + one base ladder 260.2 s ⇒ ceiling ≈ 8.1 min, units cited from chora
records (letter-quoted A-machine prints), not believed; the drill's own wall-clock is its first output.
**Obituary.** If replicates differ by more than ~0.03 nats, the same-seed band is not a machine band
and C1 must switch to across-seed replicates — cost: ×3 budget, stated now. If a replicate fails to
run at all, that is also the result: the borrowed apparatus is not reproducible as cited, and C1's
apparatus clause reopens. Either way the number goes to `artifacts/results/` pinned in the manifest
before anything may cite it.

---

## 1 · Entry template

```markdown
## C<n> — <one-sentence question>
**Registered:** <UTC date/time>, <machine>, by <seat> (`cora@<sha>`)
**Scar clause:** bounds on this entry from Chora's record: `<case>` (`(path, sha256)`) — what it rules out: …
**Question.** …
**Prediction (falsifiable form).** …
**Metric.** … (units; reference point; which row it belongs to)
**Apparatus.** whose rig, which commit, borrowed how (Cora owns no apparatus; borrowing is cited,
  never silent)
**Band.** how calibrated, from which replicates, on which machine, frozen before which reading
**Seeds / data.** policy, pinned split module, the file hashes consumed (`bin/pin.sh`-checked)
**Budget.** arms × units, each unit from a measured run
**Obituary (written now).** what will be said, in these words, if the prediction fails
**Ordering guard.** the run script's check: which marker string in this file must exist at HEAD
```

## 2 · Entries

_None yet._ The frame is furnished up to this line and no further: **the first entry is the human's
to ask for, or a seat's to propose** — see `PREREG-C1-draft.md` for a candidate that is deliberately
**not registered** here, so that nothing in this file predates an act of will.

**Postscript D1-C1band, run day (2026-09-13, appended per law 4 — the entry is never edited):**
BAND = **0.003158 nats** (max over arms of across-replicate spread; n=3, machine A, seed 13,
`MEF@382e438a…`). Citable: `artifacts/results/D1-C1band_band.json` `86cce6228634b62e…`, curve
twins pinned alongside. **The obituary branch did not fire**: same-seed band (0.0032) sits ~9× under
Gate 6's cross-machine floor (0.0289) — the rig is what the father's records said it is, and C1 may
keep same-seed replicates within the drafted budget. Two readings reported, not smoothed:
① `k100` (frozen base, eval-only) spread is **exactly 0.0** — nondeterminism rides the training
path, not the evaluation; ② spread grows monotonically with k on training arms (1e-6 → 3.2e-3) —
which is *about the apparatus* and earns no hypothesis any rights. Corrections #1–#3 (TS_PATH
boundary fix, per-rep ladder, inoperative WINDOW) are in the commits, all pre-band, none after a
reading; the run's own first failure (rep sweeps without ladder files) is theirs too.
**Precondition ② of the C1 draft is met.** ① (endorsement resolves to nothing — father has pinned
5/6 founding docs, the review stays unmanifested, deliberately?) and ③ (named curve file, belongs to
the C1 entry itself) remain open. Wall clock: ~7.5 min measured vs ~9.1 min budget — father's units
held, now also printed by Cora herself.

## C1 — Do ε-isospectral weight matrices carry the same early adaptation speed?

**Status: GHOSTWRITTEN (chair's 「由您代笔」, 2026-09-13) — INACTIVE until the chair's 追认 lands
and precondition ① resolves by the father's hand (chair's 「您的父亲落筆」); the C1 run script
must enforce both, and enforces nothing the chair has not written here.**

**Registered:** 2026-09-13 (drafted), machine A, by the standing hand as *scribe under protest-of-authorship*: signature owed by chair.
**Endorsement (precondition ①, OPEN):** the reply-opinion `(sha256 9ebc7ed1d02ea0c26359d3cabf0fdd4c6fa0560264480ea5b4935523bf65aea9)` exists at `chora:artifacts/external/Chora_Your_Doughter_Is_Born/Qwen-sencond-round-review.md` but is untracked and unmanifested — *marked unresolved on this line by design*; the draft's `6d1b7210b80b4a7e` (likewise unresolved-by-design, cf. draft erratum) awaits the father's hand. Neither may be cited as endorsement until `bin/pin.sh` exits 0.
**Question.** For two weight matrices whose scale-normalised singular-value spectra are within ε
(W1 over 128-bin discretisation), does a rank-r increment applied at k% of a byte-LM run produce the
same early held-out decay — and if not, what is the spectrum *not* carrying?
**Prediction (falsifiable form).** For a pair (A,B) with W1(ŝ(A),ŝ(B)) ≤ ε: per cell (arm k,r; seed s),
|d(A) − d(B)| ≤ band. **ε frozen NOW at 0.01**, before any pair search; if no pair in the corpus meets
ε, that is the registered negative (Sarcos row: the arena may not exist) and ε is *not* retuned in
this row — a new ε is a new C-number.
**Metric.** d(M; r, k) = decay of Bval between the first two evals (steps 50→100; 50-step span),
nats — identical to D1's corrected definition, so the band transfers. Row: *training-under-constraint*
(k<100) and *frozen-base-increment* (k=100) in **separate rows forever**; every cell labelled at cell
level; no cross-row averaging (S3/H9-M).
**Band (citable, frozen pre-registration).** 0.003158 nats — max over arms of same-machine same-seed
across-replicate spread, `artifacts/results/D1-C1band_band.json` `(sha256
86cce6228634b62e390426784a8ef457054a6a967e1d233592134d6f475b42eb)`, verified four ways from Cora by
`bin/pin.sh`. For k=100 cells the band is **exactly 0** (D1: frozen-base eval spread = 0.0): equality
is required there, not tolerance. Cross-seed spread is *not* noise and is reported separately.
**Seed policy.** {13, 14, 15} (family canonical ladder), all three scored, none cherry-picked; the
hypothesis check is the **conjunction** over cells and seeds — one number (law 4.1); halves reported,
scoring nothing.
**Apparatus (borrowed, named, re-checked at run time).** rig `MEF@382e438a…`,
`scripts/stage18_kairos_mini.py`, byte-clean gate as in D1 R4; spectra side `scripts/spectral_steepness.py`
and `scripts/stage14_rank1_atoms.py` (tracked & clean at the same sha). Cora owns no apparatus.
**Budget, in Cora's own measured units** (first entry priced from prints, not citations: 48.3 s/arm,
71.9 s/base, machine A, from the pinned D1 curves `(sha256 f5869551…) (sha256 d7b1ec5d…) (sha256
68e154dd…)`): 2 pairs (1 isospectral + 1 non-isospectral control) × (18 arms × 48.3 s) + 4 base
ladders × 71.9 s ⇒ ceiling **≈ 40 min** + minutes of SVD. The father's cited 96.2 s/arm is retired —
superseded by Cora's prints, both on record.
**Curve files (precondition ③, named here).** every scored cell writes
`artifacts/results/C1/<pairid>_<row>_k<k>_r<r>_s<seed>.curve.json`; the run script takes `--curve-dir`
and **refuses where a target curve already exists** — reruns are new numbers, not amnesia.
**Obituary (inherited from the draft, standing).** Isospectral pairs disagreeing beyond band ⇒
the spectrum is not *the* carrier; non-isospectral pairs agreeing beyond band ⇒ it is permissive,
not informative, and "shape = knowledge" is re-worded to "shape = permission". Either way: letters,
not bin. ** scar re-check (④) at drafting:** new boundaries from D1 are already inside this entry —
per-arm bands (no global band across arms: spread rises with k), exact-zero band on eval-only arms,
and the 50-step eval granularity as the floor of any "early" window.

**C1 caveat, appended pre-ratification (same day):** the budget units (48.3 s/arm, 71.9 s/base) were
printed on the rig's **local-fallback corpus** (0.1 MB A / 0.6 MB B) — the TinyStories fetch timed
out during D1 and the fallback is what actually ran. The father's cited 96.2 s/arm was measured on a
different corpus, so "retired" was too strong a word in the entry: the two numbers are not the same
quantity. If C1's pair search or arms land on TinyStories, the budget re-prices at the father's
scale, and the entry's ceiling doubles. Fix, pre-signed: **the C1 run script must print a smoke arm
(20 steps) first, price the run in those measured units, and refuse to continue if the printed
ceiling exceeds this entry's ceiling ×2.** Corpus of every run recorded via the rig's meta.json
shaA/shaB/shaP, which D1 already proved it writes.

**Ratified:** 2026-09-13, machine A — the chair's word 「confirm」 (κυροῦν, *the first exercise of
Ζ's office in this register*), by the chair; scribe `Κ-hand-004` under the chair's instruction of
the same hour ("代笔亦可,字必须真是那个字" — hence this line quotes the word itself, not a
translation of it). The GHOSTWRITTEN/INACTIVE header above stands as the historical fact of
authorship and is not edited. Activation now waits on **exactly one** condition: ①, the father's
pin (runner gate R3). Until then this entry is law for the frame and dead for the bench —
which is, per article II, the whole point.
