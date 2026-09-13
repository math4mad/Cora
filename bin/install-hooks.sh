#!/usr/bin/env bash
# CORA — install versioned hooks from bin/git-hooks/ into .git/hooks/. Idempotent, diffing.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
changed=0
for h in "$ROOT"/bin/git-hooks/*; do
  name="$(basename "$h")"; tgt="$ROOT/.git/hooks/$name"
  if ! cmp -s "$h" "$tgt" 2>/dev/null; then cp "$h" "$tgt"; chmod +x "$tgt"; changed=1; echo "[hooks] installed $name"; fi
done
[ $changed -eq 0 ] && echo "[hooks] up to date"
exit 0
