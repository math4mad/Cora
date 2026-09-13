# experiments/

Empty by Cora's article II. When a script lands here it must, before doing anything else:

1. refuse to start unless `docs/PREREG.md` **at git HEAD** contains the entry it names
   (`git show HEAD:docs/PREREG.md | grep -q "## C<n>"` — the check runs against HEAD, not the
   working tree, because the working tree is where optimism lives);
2. acquire `bin/writelock.sh` for its named session;
3. re-run `bin/pin.sh` on every cross-workspace input it consumes, and abort on any REFUTED.

Test your refusal before you trust it: run the script today, with an empty register, and watch it
say no.
