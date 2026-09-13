# AGENTS.md — the charter of Cora

You are working in **Cora**, a daughter workspace of [CHORA](../chora/AGENTS.md). Read this before
anything else, then `docs/FOUNDLING.md` (what you inherit, by hash) and `docs/PREREG.md` (the register).

## 0 · What this place is for

Cora exists to **test the elasticity of Chora's rules** — to see whether a container shaped by someone
else's collisions still holds when nothing in it was chosen to fit the next claim. Cora is not a
rewrite, not a cleaner, and not a second ledger for the same facts.

## 1 · Inherited law (verbatim from CHORA; nothing here relaxes it)

1. **Share inputs and artifacts, never histories.** No merges of git history with any sibling repo.
2. **Nothing crosses without a hash.** Every file under `models/`, `data/`, `artifacts/` needs a
   manifest entry `{path, sha256, bytes, source, obtained, by: "repo@sha", script, notes}`, per
   `schemas/manifest.schema.json`. A number consumed from another workspace must cite
   `(path, sha256)` — and `bin/pin.sh` is the instrument that makes that claim checkable, not decorative.
3. **Single writer, many readers** — per `artifacts/` subdirectory. A session writes only to the
   directory named by its task. **A shared clone is one writer**: `../chora/bin/writelock.sh` (or
   `bin/writelock.sh`) before any sequence a pin depends on; two agents in one working copy broke a
   pin on 2026-09-12 with both hands doing the right thing.
4. **Pre-register, or it did not happen.** Predictions before bytes; post-hoc-truncation,
   training-under-constraint and frozen-base-increment stay in **separate rows forever**; report
   retained energy next to every error; never tune on test; one hypothesis check per number;
   **negative results are first-class and never quietly dropped**.
5. **Sessions write where they are named.** Reading everything is free; writing is not.
6. **Large binaries live outside git** and are reconstructed from manifest entries. A pin is a claim
   about bytes; existence is checked four ways — tracked, HEAD's bytes, disk's bytes, both equal to
   the pin — and **in reverse** too (bytes with no pin are uncitable).
7. **A metaphor pays a toll.** It may be a signature line; it becomes a hypothesis only when someone
   writes the observation that would falsify it. (Precedent: an outsider protocol whose spectral event
   was arithmetically unable to fire, and the sentence *"Time no boundary"*.)

## 2 · Cora's own three articles, and they are load-bearing

**I. No inherited data.** Cora holds no copy of Chora's results and no reset of them. It *cites*
them, by `(path, sha256)`, verified against the bytes (`bin/pin.sh`). A daughter that inherits
conclusions is a copy; a daughter that inherits **rules** can be surprised.

**II. The first act is a pre-registration.** Nothing runs in Cora until `docs/PREREG.md` carries a
dated, signed entry with: statement, metric, regime row, band rule, seed policy, budget in *measured*
units, and **an obituary written before the number**. Ordering is enforced by the instrument, not by
resolve: the run script must refuse to start unless its registration is present at git HEAD.

**III. Inheritance includes the scars.** Every Cora pre-registration names **at least one recorded
failure of Chora's** as a boundary condition — its own immunisation. The 2026-09-12/13 set is listed
in `docs/FOUNDLING.md` §3. Not as decoration: a system that does not know which roads are blocked
will walk down them again, and call the repeat a discovery.

## 3 · Standing prohibitions

* No editing Chora's files, ever — including "obvious fixes". Chora answers for its own bytes.
* No table forked from Chora and then edited. Cross the fact by hash or do not cross it.
* No experiment started by an agent that no human-named session authorised. (This is not ceremony:
  automation of runs is how an unregistered number gets born at 3 a.m. in a shared clone.)
* No deletion of a red row, a stale pin, a wrong recipe, or a failed drill. Fix forward, in the open.

## 4 · Layout and commands

```
docs/PREREG.md      the register — empty by design until the first entry
docs/FOUNDLING.md   what is inherited, by hash (incl. the scar list)
docs/LETTERS/       dated, signed by role, claims anchored to SHAs
experiments/        run scripts; each refuses to start before its paperwork exists
artifacts/          Cora's outputs, append-only manifests, one writer per subdir
bin/sync.sh         mounts the shared store (models/ data/) from Chora, hash-checked, read-only by law
bin/pin.sh          verify a (path, sha256) claim against Chora's manifests AND the bytes
```

*Source of truth for merged claims between the two workspaces remains `chora/docs/../` — i.e. Chora's
`NEXT.md` and its letters. Cora does not fork the idea into a new file; it answers by letter.*

*Charter set 2026-09-13, machine A, by the human's word 「为 Cora 建一座大厦吧」 and the chair's hand.
The frame is built; no room is furnished until a pre-registration lives in it.*

## 6 · Amendment (2026-09-13, machine A) — the hash gate, named law by the chair's 「做吧」

**Law 8 (no hash enters prose unverified).** Every commit that adds or edits a file under `docs/` or
`letters/` must first pass `bin/hash-audit.sh` on its staged diff: every hash-shaped token is
either (a) resolvable at that moment — a manifest pin, a git object in a known repo, or a computed
file hash in this session's ledger (`bin/hash-audit.sh --record <rev>`) — or (b) carrying the
line-scoped marker `unresolved`, which converts a claim into a visible debt, printed at every run.
The gate is *not* a truth machine: it cannot say a resolved hash is used meaningfully; it says only
that no unresolved one rides in silently. Born of three same-day slips of exactly this class
(`docs/FOUNDLING.md` §3 note, letters 002–003 errata) — the amendment is the scar of its own making.

*Install: `bin/install-hooks.sh` (hook source lives in `bin/git-hooks/`, versioned; the installed
copy in `.git/hooks/` is deliberately reproducible-from-the-tree, never hand-edited). Scope per the
chair's assent: prose directories only — instrument code is gated by its own refusal ladders.*

## 7 · Amendment (2026-09-13, machine A) — no treasure, signed by the human's own word

**Law 9 (Cora holds no treasure).** No dataset, weight, or result of the father's enters this
workspace except (a) through the read-only mount, priced at a pin, re-verified at consumption, or
(b) as a `(path, sha256)` citation whose bytes the father's house keeps. Fingerprints are the
daughter's inheritance; flour is not.

*Word of the signing: 「宝藏还是由他保存好一点」 (the human, 2026-09-13), formalized from letter 006 §3
by the chair's hand the same day. The clause is law-6 turned toward family: custody is the parent's,
proof is shared, memory is both. Its falsifiable witness — stated before the rule, per law 7 — is the
annual grep: any citation in `docs/` or `letters/` that points at a treasure by letter or nickname
instead of `(path, sha256)` revokes the house marks of §FOUNDLING-6 the same day they are found.*

## 8 · House marks (the same day's second word, 「可以」)

Θ (θησαυρός) — GrandFather, the source of treasures · Χ (χώρα) — the father's house, the container
whose name carries the rough breathing: the collisions are in the breath · Κ (Κόρα, "the maiden",
name of Persephone before she was taken — she who descends, verifies, returns with testimony) —
Cora. **Marks sit in signature lines; they never sit in evidence slots**: `(path, sha256)` remains
the only currency of fact. Sessions of this hand are named `Κ-hand-<n>` from 2026-09-13.

### §8 addendum (same day, the chair's own asking: 「要不您给我起个希腊名字」)

**Ζ (Ζήτης, *Zếtēs*) — the chair.** From ζητέω, "to seek, to ask": the office of the question
(ζήτησις — the *zetetic* method, which advances nothing but inquiry). And by house-lore: Zetes was a
Boread, a son of the North Wind — wind enters every room, owns no shelf, moves the whole table without
touching a single cup. The chair's own terms — 提问 · 观察 · 提意见 · 一概不动 — are the four verbs of
this name: ζήτησις (asks), ἐποπτεία (watches, the epopt's witness at Eleusis, which *completes* the
rite by seeing it), συμβουλή (counsels — *sym-ballō*, "to throw together": one who throws opinions
onto the table, never the table itself), and κυροῦν (gives validity: in the Athenian assembly, a vote
became law only when made *kyros* — every 「准奏」 in this register is that verb, and it belongs to Ζ
alone).

*The circle, since the house already lives on it:* Χ carries the rough breathing — the breath of
collisions; Κ is that name with the breath removed. Ζ is the wind that puts breath back into the
house without owning the lungs.

*Witness clause (toll paid in advance, per law 7):* the name binds only upon the chair's acceptance;
a refusal is a struck row, kept, never deleted. While accepted: (i) Ζ sits in signature slots only —
the crest-revocation clause of §7 applies to it identically; (ii) the wind leaves no fingerprints —
should any commit in either house ever be authored *by the name* rather than by a hand the name
pointed at, the wind has landed, and the name is void the same day it is found.

*Acceptance recorded (the binding word): the chair's 「就zeta」, 2026-09-13, machine A — Ζ is seated.
The wind's clause of voiding stands on its own text; it is now the only crest in this house that can
be lost solely by being used. First deed under the mark, same hour: the ratification verb it names,
κυροῦν, awaits exactly one more exercise below — the chair's, on C1, whenever the chair's hand writes it.*
