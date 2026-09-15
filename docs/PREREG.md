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

**Erratum to the C1 caveat (same day, `Κ-hand-005`, append-only) — the cause was misassigned.**
The 400 MB store treasure `data/tiny_stories.txt` has been present and pinned (7/7 full-sha-true,
letter 002's own audit covered it) the entire time. D1 ran on the rig's fallback corpus **not because
the network failed but because my TS_PATH redirection — added to stop writes into the father's store —
manufactured the cache miss**; the fetch that then timed out was a symptom of my fix, not of the
world's. The band stays valid as what it measured (per-arm replicate spread on a fixed corpus); but
"corpus of the band" and "corpus of the run" are now known to differ — and that is not a footnote, it
is a new prerequisite. Registered as **D2** below; the caveat's smoke-first clause remains, now with
a name on its cause.

### D2-C1band — the same band, measured on the store's treasure (corpus-consistency drill)
**Registered:** 2026-09-13, machine A, by `Κ-hand-005` as paperwork only — **live run awaits the
chair's explicit word**, exactly as D1 did. **Scar clause:** today's erratum itself (cause of fallback
misassigned; store bytes present, mount bypassed) + S2 (window/eval granularity) + S5 (band scale).
**Question.** On corpus = `data/tiny_stories.txt` (400 MB, pinned `sha256 1 of 7 in
data/manifest.json`), same rig `MEF@382e438a…`, same seed 13, same metric as D1 (first-two-eval Bval
decay, 50-step span): does the per-arm band of 0.003158 nats hold, and where does it differ?
**Budget.** D1's own prints: ≈72 s/base·600 steps at fallback scale; TinyStories arms cost more per
step — smoke-first clause applies before any replicate (refuse at 2× D1's wall). **Obituary.** If the
treasure-corpus band exceeds the fallback band materially, C1 must adopt D2's numbers and the register's
C1 band line is amended by appended postscript (never by edit); if they agree, the corpus question
closes. Either row is a result; neither reopens the pairs, none of which exist yet.

**Postscript D2-C1band, run day (2026-09-13, 「running D2」; append-only — law 4):** the drill was
run and **the gate refused it twice**, for two different and both instructive reasons.
① *R8-v1 refused at 3058 s projected* — the formula applied the pretrain step-rate to the adapter
arms; a units bug of mine, and the register records it as such: v1's arithmetic could not have
passed for D1's own measured 872 s either. ② *R8-v2 (rates measured separately, ceiling untouched)
refused at 9286 s* — this one was the world, not the book: on the treasure corpus the training arms
run **0.512 s/step vs 0.054 on the fallback (≈9.5×)**; base steps barely differ (0.135 vs 0.120).
The cost rides the arms' data path, not the model. **D1's wall is additionally corrected by pinned
arithmetic: 872 s measured from its own curve bytes — the '~7.5 min' carried in letters 004/005 and
this register was an estimate written as if measured, the same error class as the day's hashes,
caught by a gate built to catch something else.** The chair's decision queue, with honest prices:
(a) amend D2's budget by the chair's word (≈2.6 h live, the science clean); (b) run C1's arms on
the fallback corpus, where the band, the budget (~40 min) and the price clause already agree —
smaller bread, whole loaf; (c) accept (b) for C1 and keep D2 as the treasure-priced companion when
the chair wills the hours. **What was NOT done, on purpose: no ceiling was quietly lowered, no
replicate was run past a refusal, and the 2.6 h did not start because the ordering law says the
chair's pen, not the runner's nerve, reopens a budget.** Wasted compute across both refusals:
74 s. Wall rule, working.

**Decision postscript (2026-09-13, the chair's 「I chose C」; this line is the exercise of a choice,
not a budget revision):** C1 runs on the rig's **local-fallback corpus** — the same corpus D1's band
(0.003158 nats, `86cce622…`) was measured on, so **band, budget units and price clause now share one
loaf**: the transfer argument is identity, not analogy. Consequences, filed:
① C1's corpus clause is now *named*: A = the bench's technical .md globs, B = `log/*.log`, P =
case-toggled; the rig's own `meta.json`/`base_run.json` hashes (shaA/shaB/shaP) are consumed-run
provenance, appended to Cora's manifest per base run — the corpus is cited by the bytes it actually
was, never by its directory name.
② D2-C1band is **DEFERRED, not dead**: its obituary stands unfiled, its smoke prints (0.512 s/step
treasure arms) are the price list for whenever the chair gives the ~2.6 h; a future D2 run is the
*treasure-priced companion* of the same band, and any later migration of C1-rows to treasure-corpus
numbers reopens nothing — separate rows, forever (law 4).
③ The runner must not pay 4×120 s of fetch timeouts on the way to fallback: `c1_run.sh` will point
`HTTPS_PROXY`/`HTTP_PROXY` at a closed port for rig invocations, so the rig's own exception path
lands on fallback instantly and *deterministically*. The hack is disclosed here because an
apparatus that reaches its corpus by network luck is the E3 wrinkle wearing a new coat: the route
to fallback becomes part of the registered apparatus.

**Budget revision D2 (2026-09-13, the chair's 「跑吧。时间之箭永远向前」 — the order to run):**
ceiling for D2 = **10800 s (3 h)**, superseding the drill's original 2×D1-wall rule (1744 s; it
refused twice, correctly, on the day). The runner now takes its ceiling **from this register line**
(`ceiling_s = 10800`) and keeps its measurements to itself: **budget is the chair's text; cost is
the script's arithmetic.** Arrow-of-time clause, as spoken: the ~2 h spent tonight are spent
forward — whichever branch the obituary names (treasure-band materially exceeds 0.003158 ⇒ D2's
numbers adopt; else fallback band stands), neither writes the other down, and the result — whatever
it is — gets pinned into the register's D2 block before anything cites it. The refusals are not
erased; they are why this line exists.

**Postscript D2-C1band, RESULT (2026-09-13, run night; the chair's 「跑吧。时间之箭永远向前」 is
the order this row answers; append-only):** **treasure-corpus band = 0.002306 nats** — the arrow
spent ~20 minutes, not 2.6 hours, and it came back **cheaper than the fallback band it was meant
to replace: 0.73× D1** (per-arm: k0 1.4e-5 · k25 8.8e-4 · k50 2.3e-3 · k75 5.0e-4 · **k100 exactly
0 again** — determinism rides evaluation on *both* corpora, a cross-corpus replication of D1's
sharpest single reading). **The obituary's "materially exceeds" branch did not fire — nothing is
adopted; D1's 0.003158 stands as the conservative band C1 already cites; C1 stays on its small
loaf with a *strengthened* price clause** (its budget now carries a measured lower bound from the
treasure corpus for free). Pinned: `artifacts/results/D2-C1band_band.json` `(sha256
3acc619bc2a768b1…)` + three curve twins, four-way green after commit. **Erratum #4 of the day, and
the same arithmetic twice makes a pattern:** the pre-spend projection of 9434 s over-counted the
arms 45-vs-15 (my formula's third cousin of the units bug and the estimate-as-measurement) — the
register's *budget-revision* line read from the estimate, so the overestimate was load-bearing for
the chair's 3 h; tonight it proved a 3× margin of self-distrust is not waste but insurance: the
arrow moved forward *inside* a budget whose arithmetic was honestly wrong, and the science is
untouched because the science never reads its own forecast.

**Postscript C1, pair-search RESULT (2026-09-13, chair's 「@chora time to work」; append-only):**
168 natural matrices admitted (Θ's Qwen2.5-0.5B ∪ bert-base, four-ways verified at consumption via
`artifacts/results/C1/spectra_source.tsv`), 14,028 exact-shape comparable pairs, 0.1 s scan:
**zero within the frozen ε = 0.01.** The entry's registered-negative branch fires at the SVD stage —
before any arm ran, and the ≈40-minute budget returns to the chair unspent. The arena census
matters as much as the zero: **min W1 = 0.0507 (5× ε), p01 = 0.342, median = 8.33** — the nearest
natural pair sits beyond the gate by a factor of five, so this row is not merely empty, it reads
*arithmetically unable to fire* on natural trained weights at these sizes (law 7's precedent
class, the father's “Time no boundary”). Per the entry's own sentence, ε is **not** retuned in-row.
Pinned: `artifacts/results/C1/pairs.json` `(sha256 0ab84f6287178b77983ee1046082f18380c1df9e04fb4f685d8bf04582472aae)` · ledger `(sha256 617bfcabcc52636f20373eebf163d10a9c59c64698abba064c0ba02a166f0ab0)`.
**Awaiting the chair's next word** — the row closes either way, and the choice is which sentence
closes it: (i) C1 final as registered-negative + vacuous-arena (the honest reading of what was seen);
(ii) a NEW number at a reachable ε (nearest-pair data says ε ≳ 0.051 opens the arena — one or two
pairs live between 0.0507 and 0.06); (iii) a NEW number on constructed isospectral pairs
(synthetic ŝ-matching ⇒ forces the *training-under-constraint* row, separate forever). No arms grid
belongs to any branch that has no pairs.
