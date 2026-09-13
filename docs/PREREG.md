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
