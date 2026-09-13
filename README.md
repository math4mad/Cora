# Cora — daughter workspace of CHORA (χώρα)

> **The shape of the container is the knowledge.**
> *to see the world — we choose the bounds, and the evidence chooses them, never the hand.*

Cora is not a rewrite of [CHORA](../chora/README.md). It is a **second vessel**: same laws, same
discipline, same instruments, **no inherited data**. It exists so that a claim can be made in a
container that has never been adjusted to fit a previous claim — and so that the container itself can
be audited by comparing the two.

```
chora/  ← the father: five benches, ~200 manifested artifacts, 26+ letters, every negative on record
cora/   ← the daughter: empty by design. Its first act must be a pre-registration (docs/PREREG.md).
```

## The two laws that make Cora different, and why they cannot be relaxed

1. **No inherited data.** Cora holds no copy of Chora's results, and it does not "reset" them either.
   It *cites* them: `(path, sha256)` read out of Chora's manifests, verified by `bin/pin.sh`. A
   daughter that inherits conclusions is not a daughter, it is a copy; a daughter that inherits
   *rules* can be surprised.
2. **Its first act is a pre-registration.** No experiment runs in Cora before `docs/PREREG.md` holds
   a dated, signed statement with a metric, a regime row, a band rule, a seed policy, a budget in
   measured units and an obituary. This is Chora's own law 4 — made *structural* here, because Cora
   has no history to lean on and must not lean on someone else's.

Everything else is inherited verbatim: the five laws of the workspace, the seat/contract idea behind
`meetings/CAST.md`, the four-clause existence check, the writer lock, the cadence
"mint → publish → **verify**", and the rule that a metaphor pays a toll before it becomes a
hypothesis.

## Layout

| path | what lives here |
|---|---|
| `docs/PREREG.md` | the register. Empty by design; the template is inside it |
| `docs/FOUNDLING.md` | **what Cora inherits, by hash** — Chora's HEAD, the six bench tips, the law texts, the offline restore point |
| `docs/LETTERS/` | correspondence, dated, signed by role, claims anchored to SHAs |
| `letters/`, `meetings/` | the same two instruments, starting empty — no inherited minutes |
| `experiments/` | joint run scripts; every one refuses to start before its paperwork exists |
| `artifacts/` | Cora's own outputs, `manifest.json` append-only, one writer per subdirectory |
| `schemas/manifest.schema.json` | the contract, byte-identical to Chora's (hash in `FOUNDLING.md`) |
| `bin/sync.sh` | mounts the shared store (`models/`, `data/`) **read-only by convention** and refuses to run on a hash mismatch |
| `bin/pin.sh` | `bin/pin.sh <path> <sha256>` → checks a claim against Chora's manifests *and* the bytes |

## What Cora must never become

* **not a fresh start without the obituaries.** Chora's 2026-09-12/13 losses (H6c wandering negative,
  H6a dead-by-curve-clause, H9-M flat in k, Sarcos's no-arena, thirteen pins nearly dropped by a
  merge, a pin that named no bytes, a restore recipe that named a nonexistent tag) are the reason the
  rules look like this. Deleting them from the daughter's memory would be the one unforgivable
  inheritance: the parents' habits, without the parents' scars.
* **not a second ledger for the same facts.** One record, shared by hash. If Cora produces a number
  that touches Chora's, it crosses as a letter plus a manifest entry, never as a forked table.

*Founded 2026-09-13 by the human's word — 「为 Cora 建一座大厦吧」 — with the chair's hand on the
first stones. The building is a frame: no room is finished until something is registered in it.*
