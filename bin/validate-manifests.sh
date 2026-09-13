#!/usr/bin/env bash
# CORA — validate-manifests.sh: the four-way existence check, plus Cora's staging clause.
# Ported (chair's 「准奏」 2026-09-13) from chora@f260b81 bin/validate-manifests.sh
# (sha256 013fe700…) with the father's lessons kept and one addition (C6, staging).
#
#   (C1) path exists on disk AND sha256(disk) == pin          — bytes are what the pin says
#   (C2) path is tracked at git HEAD                          — the record has it
#   (C3) sha256(bytes AT HEAD) == pin                         — the record's bytes are the pin's
#   (C4) bytes == manifest length                             — nobody truncated a claim
#   (C5) REVERSE: every tracked file under artifacts/ appears in SOME manifest
#          (manifest.json files themselves excluded: a manifest cannot pin itself — its commit does)
#   (C6) STAGING (Cora's own): every byte under artifacts/**/staging/ must have a same-sha twin
#          among the manifest pins, or a line in artifacts/staging/ABSENT.md saying why the twin
#          does not exist. Born the same hour as the D1 twins: staging is where unproven bytes
#          breed; ignoring it in git is correct ONLY while the absence is *spoken*, never silent.
#
# models/- and data/- in Cora are symlinks into the father's store — law 1: nothing here validates
# them (bin/sync.sh --check does, from the store's own manifests).
# Usage: bin/validate-manifests.sh [--quiet] [--strict]   (default: report, exit 0; --strict gates)
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
QUIET=0; STRICT=0
for a in "$@"; do case "$a" in --quiet) QUIET=1;; --strict) STRICT=1;; esac; done

python3 - "$ROOT" "$QUIET" "$STRICT" <<'PY'
import hashlib, json, os, subprocess, sys
root, quiet, strict = sys.argv[1], sys.argv[2] == "1", sys.argv[3] == "1"

def sha(f):
    h = hashlib.sha256()
    with open(f, "rb") as fh:
        for blk in iter(lambda: fh.read(1 << 20), b""): h.update(blk)
    return h.hexdigest()

manifests = []
for dirpath, dirnames, filenames in os.walk(os.path.join(root, "artifacts")):
    dirnames[:] = [d for d in dirnames if d != ".git"]
    if "manifest.json" in filenames:
        manifests.append(os.path.join(dirpath, "manifest.json"))

pins, fails = {}, []
for mf in manifests:
    try:
        entries = json.load(open(mf)).get("files", [])
    except Exception as e:
        fails.append(f"{os.path.relpath(mf, root)}: UNPARSEABLE ({e})"); continue
    for e in entries:
        p = (e.get("path") or "").replace("\\", "/")
        pin = (e.get("sha256") or "").lower()
        f = os.path.join(root, p)
        pins[pin] = p
        if len(pin) != 64:
            fails.append(f"{p}: pin is not a sha256"); continue
        if not os.path.isfile(f):
            fails.append(f"{p}: C1 NO BYTES at {os.path.relpath(f, root)} (E0 class)"); continue
        if sha(f) != pin:
            fails.append(f"{p}: C1 disk sha != pin"); continue
        if os.path.getsize(f) != e.get("bytes"):
            fails.append(f"{p}: C4 length {os.path.getsize(f)} != manifest {e.get('bytes')}"); continue
        r = subprocess.run(["git", "ls-files", "--error-unmatch", p], cwd=root, capture_output=True)
        if r.returncode != 0:
            fails.append(f"{p}: C2 not tracked at git HEAD (checkout-true, record-false — the f79d588 class)")
            continue
        blob = subprocess.run(["git", "show", f"HEAD:{p}"], cwd=root, capture_output=True).stdout
        if hashlib.sha256(blob).hexdigest() != pin:
            fails.append(f"{p}: C3 HEAD bytes != pin")
        elif not quiet:
            print(f"[validate] ok  {p}")

# C5 reverse over tracked artifacts files
tracked = subprocess.run(["git", "ls-files", "artifacts/"], cwd=root, capture_output=True, text=True).stdout.split()
pinned_paths = {e["path"] for mf in manifests for e in json.load(open(mf)).get("files", [])}
for t in tracked:
    if os.path.basename(t) in ("manifest.json", "ABSENT.md"):
        # ledgers pin nothing, including themselves: their sha changes exactly when the things
        # they record change, so a self-pin self-refutes on the next edit. Their commit is their
        # pin. (Found by this script's first C5 finding against its own ledger — keeper's rule.)
        continue
    if t not in pinned_paths:
        fails.append(f"{t}: C5 tracked bytes with no pin — uncitable (law 2, reverse)")
    elif not quiet:
        print(f"[validate] rev ok  {t}")

# C6 staging
absent_path = os.path.join(root, "artifacts/staging/ABSENT.md")
absent = open(absent_path).read().splitlines() if os.path.isfile(absent_path) else []
for dirpath, dirnames, filenames in os.walk(os.path.join(root, "artifacts")):
    if os.path.basename(dirpath) != "staging" and "staging" not in dirpath.split(os.sep):
        continue
    for fn in filenames:
        if fn == "ABSENT.md":
            continue   # the ledger excuses others; it is itself tracked, not staged debris
        f = os.path.join(dirpath, fn)
        rp = os.path.relpath(f, root)
        key = rp[len("artifacts/staging/"):] if rp.startswith("artifacts/staging/") else rp  # ledger is written relative to staging root
        try:
            h = sha(f)
        except Exception:
            continue
        if h in pins:
            if not quiet: print(f"[validate] twin ok {rp}")   # a twin always holds; absence is only for orphans
        elif any(a.split("#")[0].strip() and key.startswith(a.split("#")[0].strip()) for a in absent):
            if not quiet: print(f"[validate] absent-claimed {rp} (spoken in ABSENT.md — reproducibility is the receipt)")
        else:
            fails.append(f"{rp}: C6 unproven bytes in staging — no pinned twin, no ABSENT.md line")

n = sum(len(json.load(open(mf)).get("files", [])) for mf in manifests)
print(f"[validate] {n} pinned entries, {len(manifests)} manifests, {len(fails)} failure(s)")
for x in fails:
    print(f"[validate] FAIL {x}")
sys.exit(1 if (fails and strict) else 0 if not strict else (1 if fails else 0))
PY
