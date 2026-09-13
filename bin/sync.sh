#!/usr/bin/env bash
# CORA — mount the shared store from Chora: read-only BY LAW, hash-checked before anything is linked.
#
# What "read-only by law" means in code: this script only ever creates symlinks INSIDE Cora; it does
# not write, touch, chmod, or "fix" a single byte inside ../chora. If a hash on disk disagrees with
# Chora's manifest, sync refuses the mount and says which file — a daughter that silently repairs
# its father's bytes is a copy with extra damage.
#
# Usage: bin/sync.sh            # mount models/ + data/ (idempotent); existence+length-checked
#        bin/sync.sh --check    # full sha256 of the whole store, link nothing (~7 GB, minutes)
# Full hashing on every boot would make this the instrument nobody runs; existence + byte-length
# already catches the recorded failure classes (a pin naming no bytes, a stale working-tree copy).
# --check is the deep audit, run it before registering anything that consumes the store.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
STORE="$(cd "$ROOT/../chora" && pwd)"
CHECK=0; [ "${1:-}" = "--check" ] && CHECK=1

t0=$(date +%s)
python3 - "$STORE" "$CHECK" <<'PY'
import hashlib, json, os, sys
store, deep = sys.argv[1], sys.argv[2] == "1"
bad = 0
for d in ("models", "data"):
    mf = os.path.join(store, d, "manifest.json")
    if not os.path.isfile(mf):
        print(f"[sync] FAIL: {store}/{d}/manifest.json missing — the store has no register; refusing"); sys.exit(1)
    files = json.load(open(mf)).get("files", [])
    for e in files:
        p = os.path.join(store, e["path"]); want = (e.get("sha256") or "").lower()
        if not os.path.isfile(p):
            print(f"[sync] FAIL: manifested but absent: {e['path']}  (pin names no bytes — Letter 021 §5 class)"); bad += 1; continue
        if not want or len(want) != 64:
            print(f"[sync] FAIL: entry with no usable sha256: {e['path']}"); bad += 1; continue
        n = os.path.getsize(p)
        if n != e.get("bytes"):
            print(f"[sync] FAIL: {e['path']}: bytes {n} != manifest {e.get('bytes')}"); bad += 1
        if deep:
            h = hashlib.sha256()
            with open(p, "rb") as fh:
                for blk in iter(lambda: fh.read(1 << 20), b""): h.update(blk)
            got = h.hexdigest()
            if got != want:
                print(f"[sync] FAIL: {e['path']}: disk {got[:12]}… != manifest {want[:12]}…  — refusing mount"); bad += 1
    print(f"[sync] {d}/: {len(files)} manifested entries, {'all true' if bad==0 else 'see failures'}")
sys.exit(1 if bad else 0)
PY
rc=$?; [ $rc -eq 0 ] || { echo "[sync] NOT mounted — store failed its own hash check ($rc). Cora runs nothing on unverified bytes."; exit $rc; }
[ $CHECK -eq 1 ] && { echo "[sync] --check done, nothing linked"; exit 0; }

for d in models data; do
  t="$ROOT/$d"
  if [ -e "$t" ] && [ ! -L "$t" ]; then echo "[sync] $d exists as a real dir — not touching; resolve by hand (never delete blind)"; continue; fi
  ln -sfn "../chora/$d" "$t"
  echo "[sync] $d -> ../chora/$d  (read-only by law 1: Cora writes nothing under the father's tree)"
done
echo "[sync] done in $(( $(date +%s) - t0 ))s"
