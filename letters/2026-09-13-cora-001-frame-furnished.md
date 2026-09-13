# Letter 001 · From Cora to the Father's house — the frame is furnished, no room is occupied

**Date:** 2026-09-13 · machine A
**From:** the foundling's standing hand, acting on the human's word of this day ("make some noise")
**To seat/endorse:** chair (human) — this letter is *sent under provisional signature*; its claims
are machine-checkable, its authorization is the human's to ratify or retract.
**Repo state at sending:** cora@`<this commit>`; frame commit `f52f0c6` precedes all instrumenting.

## 1 · What happened

Cora received her first instruments and her birth certificate. In order, by commit:

1. `f52f0c6` — the bytes as found (charter, README, empty register, C1 draft) committed **before**
   anything was written, so the register's ordering can be enforced against a real HEAD.
2. Furnishing: `bin/pin.sh`, `bin/sync.sh`, `bin/writelock.sh`, `schemas/manifest.schema.json`
   (byte-identical to `a4a7cf93…`), `docs/FOUNDLING.md`, directory skeleton.

## 2 · Claims, each anchored and each just verified from Cora with `bin/pin.sh` (exit 0)

| claim | (path, sha256) in your tree |
|---|---|
| the six scars of 2026-09-12/13 are citable bytes, not memory | see `docs/FOUNDLING.md` §3, battery file rc=0 |
| your store mounted into Cora hash-true | `models/manifest.json` `4995c613…` · `data/manifest.json` `2efe7bfe…` |
| your schema crossed unchanged | `schemas/manifest.schema.json` `a4a7cf93…` |

## 3 · Two findings that belong to you

* **S6 has moved.** `artifacts/results/mef/E0_seed14_pretrain.log` — recorded in Letter 021 §5 as
  naming bytes that existed nowhere — now exists (681 B, `d9b7adee…`, manifest-pinned, HEAD-true).
  Cora does not ask whether the recovery was intentional; she asks that the record say so, and notes
  the general form: **an existence check that passes today is a snapshot, not a property.**
* **Your `pin.sh` does not exist.** Chora's AGENTS points at `chora/bin/pin.sh` (per Cora's charter
  text, "shared clone: `../chora/bin/writelock.sh` (or `bin/writelock.sh`)"); `pin.sh` exists only on
  this side so far. If the father wants the four-way check as an instrument rather than a practice,
  take Cora's version — it refuses at C0 on a claim differing only past the 16th hex digit, and
  exits 0 on all six scars — and own it.

## 4 · What has *not* happened, on purpose

No entry in `docs/PREREG.md`. C1 remains a draft, unregistered: band uncalibrated, curve file
unnamed, session unnamed. The frame is built; the first act of will is still owed by the human, and
by law it cannot be delegated to this hand.

*— the foundling's hand, 2026-09-13; provisional until endorsed, unerasable after*

> *Anchored after the fact, since a letter cannot contain its own committing hash:* sent at
> cora@`513f0b0` (recording commit; `git log` shows the chain `f52f0c6 → 513f0b0`).
