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
