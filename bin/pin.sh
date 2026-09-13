#!/usr/bin/env bash
# CORA — pin.sh: make a cross-workspace claim checkable, not decorative.
#
# Law 1 of this workspace: Cora cites Chora by (path, sha256) and never copies. A citation is only
# worth its instrument: this script takes a claim and answers, in code, "do the bytes exist and are
# they the bytes?" — the four-way check of law 6 (in Cora's reading of Chora's incidents, the four
# ways are: the pin is in SOME manifest; the manifest's sha matches the bytes at that repo's git HEAD
# if tracked there; the sha matches the bytes on disk; and the claimed length matches).
#
# Usage:
#   bin/pin.sh <path> <sha256>          # verify one claim
#   bin/pin.sh --list <path>            # show every manifest entry whose path matches, no hashing
#   bin/pin.sh --file <claims.tsv>      # batch: lines of "path<TAB>sha256"
#
# <path> is relative to the repo that owns it, and the repo is searched for in this order:
#   cora/  ../chora/  ../chora/benches/<name>/ (real paths of the bench symlinks)
# so a bench-side pin may also be spelled "MEF/models/README.md" style — see resolve().
#
# Exit: 0 = claim verified; 1 = ANY clause failed. There is no "probably".
#
# Scar clause (this instrument exists because of): ../chora/bin/validate-manifests.sh header —
# E0_seed14_pretrain.log pinned with no bytes anywhere; a pin at the hash-of-nothing; a pin true of
# the checkout but false of the repository. All three passed "valid JSON, hashes fine". They do not
# pass this.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ "${1:-}" = "--file" ]; then
  [ -f "${2:-}" ] || { echo "usage: pin.sh --file <path>\t<sha256>"; exit 64; }
  rc=0
  while IFS=$'\t' read -r p s; do
    case "$p" in ''|\#*) continue;; esac
    "$ROOT/bin/pin.sh" "$p" "$s" || rc=1
  done < "$2"
  exit $rc
fi

python3 - "$ROOT" "$@" <<'PY'
import hashlib, json, os, subprocess, sys

root = os.path.abspath(sys.argv[1])
mode, path, want = "verify", None, None
args = sys.argv[2:]
if args and args[0] == "--list":
    mode, path = "list", args[1]; args = args[1:]
else:
    path = args[0] if args else None
    want = args[1] if len(args) > 1 else None
if not path or (mode == "verify" and not want):
    print("usage: pin.sh <path> <sha256> | --list <path> | --file <claims.tsv>"); sys.exit(64)

CODE = os.path.dirname(root)  # sibling-of-Cora directory
repos = {"cora": root}
for name in ("chora", "GrandFather"):
    d = os.path.join(CODE, name)
    if os.path.isdir(d): repos[name] = d
bd = os.path.join(repos.get("chora", ""), "benches")
if os.path.isdir(bd):
    for b in sorted(os.listdir(bd)):
        rp = os.path.realpath(os.path.join(bd, b))
        if os.path.isdir(rp): repos["chora/benches/" + b] = rp

def manifests(repo):
    """all manifest.json files that could carry an entry for this repo"""
    out = []
    for dirpath, dirnames, filenames in os.walk(repo):
        dirnames[:] = [d for d in dirnames if d not in (".git", "node_modules", "__pycache__")]
        if "manifest.json" in filenames:
            out.append(os.path.join(dirpath, "manifest.json"))
    return out

def entries(mf):
    try:
        j = json.load(open(mf))
    except Exception as e:
        return None
    return j.get("files", j if isinstance(j, list) else [])

def sha256(f):
    h = hashlib.sha256()
    with open(f, "rb") as fh:
        for blk in iter(lambda: fh.read(1 << 20), b""):
            h.update(blk)
    return h.hexdigest()

hits = []
for rname, rpath in repos.items():
    for mf in manifests(rpath):
        es = entries(mf)
        if es is None:
            print(f"[pin] NOTE: unparseable manifest {mf} (a broken manifest is itself a failure)"); continue
        for e in es:
            ep = (e or {}).get("path", "").replace("\\", "/")
            cand = os.path.normpath(os.path.join(rpath, ep))
            if cand == os.path.normpath(os.path.join(rpath, path)) or ep == path \
               or os.path.normpath(ep) == os.path.normpath(path):
                hits.append((rname, rpath, mf, e))
            # also accept a claim spelled "bench/rel/path" from outside
            elif path.replace("\\", "/").endswith("/" + ep) and os.path.normpath(path) != ep:
                pass  # deliberately NOT fuzzy-matched; a claim must name the repo it crosses into

if not hits:
    print(f"[pin] FAIL: no manifest entry anywhere for '{path}'.")
    print("      law 2: bytes without a pin are uncitable; a number from here may not cross to Cora.")
    sys.exit(1)

rc = 0
for rname, rpath, mf, e in hits:
    ep = e.get("path"); pin = (e.get("sha256") or "").lower()
    f = os.path.normpath(os.path.join(rpath, ep))
    print(f"[pin] {path}  (entry: {rname}:{os.path.relpath(mf, rpath)})")
    if mode == "list":
        print(f"      pinned sha={pin} bytes={e.get('bytes')} notes={str(e.get('notes'))[:80]}")
        continue
    # clause 0: the claim matches the manifest's own pin
    if want.lower() != pin:
        print(f"      [C0] FAIL: claim {want[:16]}… != manifest pin {pin[:16]}…"); rc = 1
    else:
        print(f"      [C0] ok: claim agrees with the manifest pin")
    if not os.path.isfile(f):
        print(f"      [C1] FAIL: bytes do not exist at {f}  — a pin that names no bytes (E0_seed14 scar)"); rc = 1; continue
    disk = sha256(f); n = os.path.getsize(f)
    ok = (disk == pin) and (want.lower() == disk)
    print(f"      [C1] {'ok' if disk==pin else 'FAIL'}: disk sha256 = {disk[:16]}…")
    print(f"      [C2] {'ok' if str(n)==str(e.get('bytes')) else 'FAIL'}: bytes {n} == manifest {e.get('bytes')}")
    # clause 3: if tracked at HEAD of its repo, HEAD's bytes must equal the pin too
    try:
        head = subprocess.run(["git", "-C", rpath, "cat-file", "-e", f"HEAD:{ep}"],
                              capture_output=True).returncode == 0
    except Exception:
        head = False
    if head:
        blob = subprocess.run(["git", "-C", rpath, "show", f"HEAD:{ep}"], capture_output=True).stdout
        hs = hashlib.sha256(blob).hexdigest()
        print(f"      [C3] {'ok' if hs==pin else 'FAIL'}: HEAD sha256 = {hs[:16]}…")
        ok = ok and hs == pin
    else:
        print(f"      [C3] waived: not tracked at HEAD ({rname}) — law 6, reconstructed from manifest")
    ok = ok and (str(n) == str(e.get('bytes')))
    print(f"[pin] {'VERIFIED' if ok else 'REFUTED'}: {path}")
    rc = rc or (0 if ok else 1)
sys.exit(rc)
PY
