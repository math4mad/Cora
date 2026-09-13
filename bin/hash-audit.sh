#!/usr/bin/env bash
# CORA — hash-audit.sh: catch the error class this workspace committed three times in one day.
#
# The class: a hash written as if verified but never computed. FOUNDLING §3 (AGENTS self-hash,
# caught by the author), letter 002 §2 (an inherited endorsement `6d1b7210…` that resolves to no
# bytes anywhere), letter 003 (`cora@9a7…`, caught before commit). All three passed every existing
# check, because every existing check reads the record and none of them read the *act of writing*.
#
# What this does: takes a diff (default: staged, or a commit) and, for every hash-shaped token
# (git sha ≥7 hex, sha256 ≥16 hex), asks one question — is this token a claim about bytes we can
# produce right now? Verified tokens (present at that width in the ledger of hashes computed in this
# session, or resolvable live against a repo/manifest) are marked OK. Everything else is UNVERIFIED
# and the exit code is non-zero. It cannot tell whether a token was *meaningfully* used; it only
# refuses to let an unresolved claim ride in on the coattails of resolved ones.
#
# Deliberately NOT a git hook, and not law: a charter says instruments become load-bearing only when
# the chair names them so. Run it before committing; wire it into a pre-commit only on that order.
#
# Usage:
#   bin/hash-audit.sh                     # audit staged diff
#   bin/hash-audit.sh --commit <rev>      # audit a commit
#   bin/hash-audit.sh --file <path>       # audit one file's text
#   bin/hash-audit.sh --record <rev>      # append this session's resolvable hashes to the ledger
#   bin/hash-audit.sh --ledger            # where the ledger lives
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
LEDGER_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/cora"
LEDGER="$LEDGER_DIR/computed-hashes.txt"
mkdir -p "$LEDGER_DIR"

MODE="staged"; TARGET=""
case "${1:-}" in
  --commit) MODE="commit"; TARGET="${2:?}";;
  --file)   MODE="file";   TARGET="${2:?}";;
  --record) MODE="record"; TARGET="${2:-HEAD}";;
  --ledger) echo "$LEDGER"; exit 0;;
  "")       ;;
  *)        echo "usage: hash-audit.sh [--commit <rev>|--file <path>|--record <rev>|--ledger]"; exit 64;;
esac

python3 - "$ROOT" "$MODE" "$TARGET" "$LEDGER" <<'PY'
import os, re, subprocess, sys

root, mode, target, ledger = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

def sh(*a, cwd=None):
    return subprocess.run(a, cwd=cwd or root, capture_output=True, text=True)

# ---------------------------------------------------------------- recording mode
if mode == "record":
    rev = target or "HEAD"
    names = sh("git", "diff", "--name-only", rev + "^", rev).stdout.split()
    if sh("git", "diff", "--name-only", rev, rev).stdout.strip():
        names = sh("git", "diff", "--name-only").stdout.split()
    n = 0
    with open(ledger, "a") as out:
        for f in names:
            if not os.path.isfile(f) or os.path.islink(f):
                continue
            try:
                blob = open(f, "rb").read()
            except Exception:
                continue
            import hashlib
            out.write(f"sha256 {hashlib.sha256(blob).hexdigest()} {f}\n")
            h = sh("git", "rev-parse", f"{rev}:{f}")
            if h.returncode == 0:
                out.write(f"blob   {h.stdout.strip()} {f}@{rev}\n")
            n += 1
    head = sh("git", "rev-parse", "HEAD").stdout.strip()
    with open(ledger, "a") as out:
        out.write(f"commit {head}\n")
        for r, p in [(root, "cora")]:
            pass
    for repo, tag in [("cora", root), ("../chora", None), ("../Middle-Eigen-function", None),
                      ("../Kairos", None), ("../Sarcos-NN-Model", None), ("../Polynomial-Activated NN ", None),
                      ("../JacobiGP", None)]:
        p = os.path.join(root, repo) if tag else repo
        r = sh("git", "-C", p, "rev-parse", "HEAD")
        if r.returncode == 0:
            with open(ledger, "a") as out:
                out.write(f"commit {r.stdout.strip()} {repo}\n")
    print(f"[hash-audit] recorded {n} file hashes + repo HEADs into {ledger}")
    sys.exit(0)

# ---------------------------------------------------------------- what to scan
if mode == "staged":
    text = sh("git", "diff", "--cached", "-U0").stdout
elif mode == "commit":
    text = sh("git", "show", "--format=", "-U0", target).stdout
else:
    text = open(target, encoding="utf-8", errors="replace").read()

# in --file mode the whole text is the claim surface; in diff modes only added lines count
if mode == "file":
    added = text
else:
    added = "\n".join(l[1:] for l in text.splitlines() if l.startswith("+") and not l.startswith("+++"))

known = set()
if os.path.isfile(ledger):
    for line in open(ledger):
        parts = line.split()
        for tok in parts[:2]:
            if re.fullmatch(r"[0-9a-f]{7,64}", tok):
                known.add(tok.lower())

GIT_REPOS = {
    "cora": root, "chora": os.path.join(root, "../chora"),
    "MEF": os.path.join(root, "../Middle-Eigen-function"),
    "Kairos": os.path.join(root, "../Kairos"),
    "Sarcos": os.path.join(root, "../Sarcos-NN-Model"),
    "PolyNN": os.path.join(root, "../Polynomial-Activated NN "),
    "JacobiGP": os.path.join(root, "../ JacobiGP"),   # the leading space is real — chora's own sync
                                                       # comment said "trailing space is real" for PolyNN;
                                                       # this one was found because a 7-hex commit refused
                                                       # to resolve and the fix is the kind law 2 warns
                                                       # about: paths are bytes too.
}

def git_objects(tok):
    for name, path in GIT_REPOS.items():
        if not os.path.isdir(path):
            continue
        cands = [tok] + ([tok + "0" * (40 - len(tok))] if 7 <= len(tok) < 40 else [])
        for cand in cands:
            r = subprocess.run(["git", "-C", path, "cat-file", "-e", cand], capture_output=True)
            if r.returncode == 0:
                return f"git object in {name}"
    return None

# --------------------------------------------------- build the LONG set of true hashes first:
# ledger (this session's computed) + manifest pins + file hashes over the small-file surface.
# A token resolves if it is (a) itself long-true, (b) a prefix of one, or (c) a git object.
import hashlib, json

def manifest_pins():
    out = {}
    for r0 in (root, os.path.join(root, "..", "chora"), os.path.join(root, "..", "Middle-Eigen-function")):
        for dirpath, dirnames, filenames in os.walk(r0):
            dirnames[:] = [d for d in dirnames if d not in (".git", "node_modules", "__pycache__")]
            if "manifest.json" in filenames:
                mf = os.path.join(dirpath, "manifest.json")
                try:
                    for e in json.load(open(mf)).get("files", []):
                        s = (e.get("sha256") or "").lower()
                        if len(s) == 64:
                            out[s] = f"manifest pin ({os.path.relpath(mf, os.path.dirname(r0))})"
                except Exception:
                    pass
    return out

LONG = {}
if os.path.isfile(ledger):
    for line in open(ledger):
        p = line.split()
        if len(p) >= 2 and re.fullmatch(r"[0-9a-f]{64}", p[1] or ""):
            LONG[p[1]] = "ledger (computed this session)"
        if len(p) >= 1 and re.fullmatch(r"[0-9a-f]{40}", p[0] or ""):
            LONG[p[0]] = "ledger HEAD/file"
LONG.update(manifest_pins())

CAND = {}  # files worth hashing: small, and only what a claim can sensibly point at
def seed_candidates():
    for r0 in (root, os.path.join(root, "..", "chora")):
        for dirpath, dirnames, filenames in os.walk(r0):
            dirnames[:] = [d for d in dirnames if d not in (".git", "node_modules", "__pycache__", "benches")]
            base = os.path.basename(dirpath)
            for fn in filenames:
                fp = os.path.join(dirpath, fn)
                if os.path.islink(fp) or not os.path.isfile(fp):
                    continue
                if base in ("models", "data", "artifacts") and fn != "manifest.json":
                    continue          # big binaries: covered by their manifest pins, not re-walked
                try:
                    if os.path.getsize(fp) > 20 << 20:
                        continue
                except OSError:
                    continue
                CAND[fp] = None
seed_candidates()
def file_hashes():
    for fp in CAND:
        try:
            h = hashlib.sha256(open(fp, "rb").read()).hexdigest()
        except Exception:
            continue
        LONG.setdefault(h, f"file {os.path.relpath(fp, os.path.dirname(fp) and os.path.relpath(fp, os.path.join(root,'..')))}")
file_hashes()

def resolve(tok):
    tok = tok.lower()
    if tok.startswith("e3b0c442"):  # intentional constant, unresolved-by-design — season-1 scar class
        # sha256 of the EMPTY input. A manifest may legitimately contain it (a real empty file);
        # but a *prose claim* pointing at it is almost always the father's season-1 failure class
        # ("pinned at the hash of nothing, file written later"). Refuse to auto-clear, always.
        return None
    if tok in LONG:
        return LONG[tok]
    if len(tok) >= 7:
        for long_h, where in LONG.items():
            if long_h.startswith(tok):
                return f"prefix of {long_h[:16]}\u2026 ({where})"
    g = git_objects(tok)
    if g:
        return g
    return None

def looks_like_param(tok, line):
    """no keyword guessing on the line: a token that is pure decimal digits is far more likely a
    number-in-prose (7.880, a step count) than a hash; anything containing a-f is always a claim."""
    return bool(re.fullmatch(r"[0-9]+", tok))

GIT_RE = re.compile(r"\b[0-9a-f]{7,40}\b|\b[0-9a-f]{64}\b")
added_lines = added.splitlines()
seen_tokens = sorted(set(GIT_RE.findall(added)))
ok, bad, skipped = 0, [], 0
excused = []
for tok in seen_tokens:
    if len(tok) < 7:
        continue
    tok_lines = [l for l in added_lines if tok in l]
    line = tok_lines[0] if tok_lines else ""
    if looks_like_param(tok, line):
        skipped += 1
        continue
    where = resolve(tok)
    if where:
        ok += 1
        print(f"[hash-audit] OK    {tok[:20]:20}{'\u2026' if len(tok)>20 else ''}  ({where})")
    elif any("unresolved" in l.lower() for l in tok_lines):
        # the exception clause of the guard, and its own trap: an excuse must be visible,
        # printed every run, and only on a line that carries the token — never file-wide
        excused.append((tok, line))
    else:
        bad.append((tok, line))
for tok, line in excused:
    print(f"[hash-audit] EXCUSED {tok[:20]:20}\u2026  (line marks it unresolved — still a debt, see \u00a7what-resolves-it)")

print(f"[hash-audit] scanned {ok + len(bad) + skipped} hash-shaped tokens "
      f"({'added lines' if mode != 'file' else 'file'}): {ok} resolved, {skipped} numeric-skip, {len(bad)} UNVERIFIED")
for tok, line in bad:
    note = ""
    if tok.startswith("e3b0c442"):  # intentional constant, unresolved-by-design (see resolve())
        note = "  <- sha256 of the EMPTY input (the father's season-1 scar class)"
    print(f"[hash-audit] UNVERIFIED {tok}{note}  ->  {line.strip()[:110]}")
if bad:
    print("[hash-audit] nothing is refuted — but nothing cited here is checkable either. Compute it")
    print("[hash-audit] (same session, or `bin/pin.sh`), or mark the claim 'unresolved' and say what")
    print("[hash-audit] would resolve it. The point is not green: the point is *no silent fakes*.")
    sys.exit(1)
sys.exit(0)
PY
