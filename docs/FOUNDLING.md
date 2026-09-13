# FOUNDLING — what Cora inherits, and its price, by hash

All hashes below were computed **by Cora's own hands** on 2026-09-13 (machine A), not copied from a
table, and are re-checkable with `bin/pin.sh <path> <sha256>`. This is the differential diagnosis
between a daughter and a copy: a daughter records what she was *given*, and can notice when it changes.

At the moment of inheriting, the father's tree was:

> **chora@`f260b81272e4c1ba5a5553ca31743c4dec149ab3`** · branch `main` · last commit
> `2026-09-13 14:01:30 +0800` — twenty minutes old. The frame was built while the father was still
> moving.

## 0 · The law texts, as given (rules cross the boundary; data does not)

| given | path (in chora) | sha256 | sha256 (in cora) |
|---|---|---|---|
| charter (AGENTS) | father's: `chora/AGENTS.md` | `2f7f02049266040d…` | daughter's own `AGENTS.md`: `46177d63cd3ad5b5…` (§6 hash-gate · §7 Law 9 no-treasure · §8 house marks + the Ζ addendum — all landed 2026-09-13; the fourth self-drift of the day, by amendment, not sloppiness) |
| register (PREREG — D1 drill + **C1 ghostwritten and RATIFIED by 「confirm」; activation awaits ① only**) | — | — | `a2c459ff4d921a3f…` |
| C1 draft (superseded by its ratified register entry; errata + two status lines same day) | — | — | `ba213a073d9e62a4…` |

*These rows have now gone stale **twice** and been re-anchored by `bin/hash-audit.sh --file
docs/FOUNDLING.md`; between the two incidents the drift came from appending the D1 run-day
postscript and the charter's §6 amendment — i.e. from *more law and more result*, not from sloppiness.
A self-citing table in a living workspace is a weather vane: fine, as long as somebody reads it every
day before claiming anything from it.*

*These rows were first caught stale by `bin/hash-audit.sh --file` on the day this file was written —
the register had already gained its drill entry and the draft its erratum, after the hashes above
were first set. **A hash is a claim about bytes at a moment**; a self-recorded table in a living
workspace goes stale by construction. Standing rule adopted for this file: re-run
`bin/hash-audit.sh --file docs/FOUNDLING.md` after touching ANY document it cites (the phantom
`6d1b7210b80b4a7e…` stays flagged, marked unresolved on purpose — it is evidence, not a typo).*
| manifest schema | `schemas/manifest.schema.json` | `a4a7cf93382fb0b460f485c9903f327fcace79e43541adf151b6827f2d521a0a` | **identical, verified** |
| writer lock (instrument) | `bin/writelock.sh` | `f4aaa920d89444121817193e4850794046db023f73eff30a813a839c97d5792b` | ported to `bin/writelock.sh`, only lock-name & header differ |
| store sync (pattern) | `bin/sync.sh` | `013a9bcefda59058bb3c4c778421333d3a696ac5208bff0672926c9cf7520191` | rewritten: Cora's mounts the father's store, not the benches' |
| manifest validator | `bin/validate-manifests.sh` | `013fe7006d5b2092d560520fa4fa19059d641c0d7c2481172879cf51b270287b` | **not ported — see §4** |

## 1 · What was NOT inherited (law 1: no data, only rules and hashes)

* No Chora results, no verdicts, no curves, no letters — only the *paths and hashes* to come and
  verify at. Every number Cora will ever use must make this crossing on its own legs.
* No apparatus. Cora owns no rig; the C1 draft's borrowed `stage18_kairos_mini.py` at MEF@`382e438a…`
  remains in the father's house and is used, if ever, by citation.
* No history. `git init` happened after the frame commit; nothing was re-based, imported or merged.

## 2 · The shared store, as mounted (`bin/sync.sh`, read-only by law)

| | entries | manifest sha256 |
|---|---|---|
| `models/` | 53 | `4995c61383f0fa4fcb1ed4bfc1fa62e8d6514b43c8244a7ba6523a31beeb639f` |
| `data/` | 7 | `2efe7bfe668967144ee3f98352d35e15a4e5c8c0b63183038525eb5d88aa3e03` |
| `artifacts/results/` | ~200 | `2b820a20ad6df07a7fe8bf5408df4002f1653ff77aefa11ad80f569e5c11a142` |

Statuses: ~~60 store entries existence- and length-true at mount time; full-sha audit owed~~ —
**debt PAID 2026-09-13**: `bin/sync.sh --check` returned 60/60 full-sha-true over ~7 GB in 3.7 s
(letter 002 §1; the deep audit is now routine, not ceremonial, hardware SHA being nearly free).

The five bench tips, as seen through the father's symlinks, recorded so a change is *noticeable*:
`JacobiGP 9d88e874… · Kairos ae6be016… · MEF 382e438a… · PolyNN 0eb29309… · Sarcos fb37e049…`.

## 3 · The scar list (Article III — inherited *with* the wounds)

Each entry is the recorded failure itself, pinned; `bin/pin.sh` verifies all six on 2026-09-13
(brand-new instrument, first live fire, exit 0 on all six). Citing a scar is inoculation, not
citation: what each one *rules out* for Cora's future entries is written where it was learned first —
`docs/PREREG-C1-draft.md` §scar-clause table — and this list is the ledger they all draw on.

| # | scar | pinned bytes (chora-relative) | sha256 |
|---|---|---|---|
| S1 | **H6c** — evidence path wandered to a −1-corner because the object handed to it was a raw count vector | `artifacts/results/jacobigp/exp6_h6c/h6c_verdict.json` | `c51e001a3b1dd264…` |
| S2 | **H6a** — right dial, wrong timing: separation S=7.880 yet dead by the curve clause | `artifacts/results/sarcos/exp6_h6a_pilot/h6a_pilot_verdict.json` | `e08ca86d2ea4b381…` |
| S3 | **H9-M** — regime changed with the variable; a whole-ladder trend crossed moving- and frozen-base rows | `artifacts/results/mef/stage19_h9m/verdict.json` | `32d7cc58732aa172…` |
| S4 | **E3 wrinkle** — a schedule signature cannot be adjudicated where nothing decayed | `artifacts/results/mef/stage19_e3/e3_summary.json` | `05264ddefe9b45bd…` |
| S5 | **Gate 6 twins** — machine effect known and *small* (max Δ = 0.028914 nats, exact at k=0): a band must not be larger than the thing being measured | `artifacts/results/mef/stage19_h9m/gate6_twin.json` | `52efb2a5baf5e603…` |
| S6 | **The thirteen pins & the pin that named no bytes** — a merge that dropped 13 entries passed validation; `E0_seed14_pretrain.log` existed nowhere. Both directions are law 2: a pin without bytes is a permission slip for nothing; bytes without a pin are uncitable | `artifacts/results/mef/E0_seed14_pretrain.log` (now present: `d9b7adee75975b22…`, 681 B) | see notes |

**Note on S6, found while writing this file:** the log that Letter 021 recorded as *having no bytes
anywhere* now exists at that path — 681 bytes, hash `d9b7adee…`, pinned and matching in
`artifacts/results/manifest.json` (`2b820a20…`). Either the bytes were recovered or the entry was
repointed. Cora does not know which, and records exactly that: **an existence check that passes today
is a snapshot, not a property.** The four-way check must therefore be run at every crossing, not once
at inheritance — which is what `bin/pin.sh` is for. (This is what the README means by
"mint → publish → **verify**".)

## 4 · What Cora deliberately does not yet hold

* `validate-manifests.sh` ported — deferred until Cora's own `artifacts/` has >0 real entries; a
  validator over empty manifests proves nothing. When it lands it must carry the C5 reverse clause
  from day one (the father's first run of that script found three tracked files with no pin; that
  finding is part of the inheritance).
  **TRIGGER FIRED AND PAID 2026-09-13** (chair's 「准奏」): `bin/validate-manifests.sh` landed with
  the father's C1–C5 clauses **plus C6 (staging)** — every byte under `artifacts/**/staging/` needs
  a pinned same-sha twin or a line in the tracked ledger `artifacts/staging/ABSENT.md`; first strict
  run: 4 pins true four ways, 36 staging bytes all twinned or receipted, 0 failures. The staging
  git-ignore now reads `staging/*` with one tracked exception — the ledger itself: silence fails,
  speech is law.
* A release/publish pipeline — none until there is something to publish.
* Minutes, seats, correspondence — `letters/`, `meetings/` and `docs/LETTERS/` exist and are empty.
  This file and the frame commit are the only founding records until a human names a session.

*A note on how this file was made, kept as precedent:* the first draft of this table carried a
hand-written hash for Cora's own `AGENTS.md` that had never been computed — a transcribed number
posing as a verified one, caught by the author before the commit that would have pinned it. It is
recorded here because law 4 says errors are never quietly dropped, and because FOUNDLING is exactly
the file where "I typed it instead of hashing it" should leave a scar of its own. (2026-09-13.)

## 4½ · Addendum, same day: one inheritance item failed to resolve (found by this workspace's own instrument)

The C1 draft's self-endorsement cites the reply-opinion at `(sha256 6d1b7210b80b4a7e…)`; that hash
matches **no bytes in either workspace**. The reply-opinion as it exists on the father's disk
(`artifacts/external/Chora_Your_Doughter_Is_Born/Qwen-sencond-round-review.md`,
`9ebc7ed1d02ea0c2…`) is **untracked and unmanifested — hence uncitable** (law 2, reverse direction).
Full report and the five directory hashes: `letters/2026-09-13-cora-002-audit-paid-citation-bounced.md`.
Until this resolves, **C1's registration precondition ① is open** — and the scar clause itself is what
caught it: S6, repeating one day later, on the daughter's side.

## 5 · Seats, as of this writing

**chair = the human** (named 2026-09-13 by the word 「准奏」, which also ratified Letter 001's
provisional signature). The standing hand (this agent) writes only where the chair points and signs
nothing that binds the chair. The register remains empty; that is still the chair's choice, held open.

---
*Laid in on 2026-09-13 (machine A) by the standing frame's hand, acting for the human's
command — before any experiment, before any number, and while the father's tree was still moving.
Every hash here is one `bin/pin.sh` away from reprovable.*

## 6 · House marks (installed by the chair's 「可以」, 2026-09-13; charter §8)

| mark | Greek | generation | reads as |
|---|---|---|---|
| **Θ** | θησαυρός (*thesaurós*) | GrandFather | the treasures themselves — datasets, weights, the unedited record; gives, governs nothing |
| **Χ** | χώρα (*khṓra*) | Father | the container; in the Timaeus, "nurse of becoming"; the name carries the rough breathing — the collisions are *in the breath* |
| **Ζ** | Ζήτης (*Zếtēs*, from ζητέω, to seek/ask; a Boread — son of the North Wind) | the chair | the office of the question: ζήτησις asks · ἐποπτεία witnesses · συμβουλή counsels (throws opinions onto the table, never the table itself) · κυροῦν gives validity — every 「准奏」 in this register is that verb. Wind touches nothing and moves everything; the wind leaves no fingerprints (witness clause, AGENTS §8 addendum) |
| **Κ** | Κόρα (*Kórā*, "the maiden") | Cora | Persephone's name before she was taken: she who descends into another country, verifies, and returns with testimony — a daughter workspace in one word |

*Etymology, kept for the signature line only:* Cora is Chora with the aspiration removed — the same
vowels, the friction gone; the marks Θ · Χ · Κ are how the family will sign, never how it cites.
Law 7's witness clause (AGENTS §7): a mark found in an evidence slot revokes the marks the same day.
Sessions of the standing hand: `Κ-hand-<n>` (first: `Κ-hand-001`, this day, the first lock held in Greek).
