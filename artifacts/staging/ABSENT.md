# ABSENT.md — spoken absences in staging (the C6 ledger of bin/validate-manifests.sh)

A line here excuses bytes from needing a pinned twin — every absence is named, with the receipt of
its reproducibility. Silence is the only failure.

drills/D1-C1band/base_run.json          # reproducible: experiments/c1_band_calibrate.sh at this repo's HEAD, SEED=13, rig MEF@382e438a…, corpus = rig's local fallback (meta inside the file carries shaA/shaB/shaP of the actual bytes consumed)
drills/D1-C1band/ckpt_k0.pt             # ladder: same reproduction; large binary, law 6 keeps it out of git
drills/D1-C1band/ckpt_k25.pt            # "
drills/D1-C1band/ckpt_k50.pt            # "
drills/D1-C1band/ckpt_k75.pt            # "
drills/D1-C1band/ckpt_k100.pt           # "
drills/D1-C1band/eval_A.pt              # eval tensors from the same base run
drills/D1-C1band/eval_B.pt              # "
drills/D1-C1band/eval_P.pt              # "
drills/D1-C1band/rep                    # per-replicate dirs: symlinks into the ladder above (no new bytes) + curve jsons, which DO have pinned twins (f5869551…, d7b1ec5d…, 68e154dd…)
drills/D2-C1band/ceiling.txt           # computed from D1's pinned curves by the d2 script; deterministic re-derivation
drills/D2-C1band/smoke                  # 20-step smoke base (jsons reproducible from script@HEAD + SEED=13 + pinned corpus; no result-data lives here — the run it gates was refused)
drills/D2-C1band/base_run.json          # (from smoke only; full ladder never built — gate refused before spend)
drills/D2-C1band/ckpt_
drills/D2-C1band/eval_
drills/D2-C1band/base_run.json          # treasure-corpus base ladder: reproducible (script@HEAD, SEED=13, pinned corpus) — law 6 keeps bytes out of git
drills/D2-C1band/ckpt_                  # ladder checkpoints (prefix line)
drills/D2-C1band/eval_                  # eval tensors from the same base
drills/D2-C1band/rep                    # per-rep symlinks + curve jsons whose twins are pinned above
rejected/C3-run1-pathcrash/  # one A-arm curve from run-1, orphaned by a wrong slot-path crash mid-grid; whole run rejected, re-run from smoke; kept, not eaten
rejected/C3-run1-pathcrash/  # second orphan batch (killed run mid-A-arm, same pathcrash lineage) - kept, not eaten
rejected/C3-run2-shapecrash/  # orphan A-arm(s) from the rectangular-matmul crash (fixed by reduced-SVD welding, probe-verified); grid incomplete, run rejected whole
rejected/C3-run3-shapecrash2/  # 7 orphans (seed-discipline worked: these are reproducible losses of the m<n frame crash); grid rejected whole after stretch-span widening
rejected/C3-run3-shapecrash2/  # 7 orphans from the m<n frame crash (reproducible losses; grid rejected whole after stretch-span widening)
rejected/C3-run4-lapackcrash/  # 2 orphans (A+iso qB0/s13) — run died in the VERIFICATION lapack call, not in science; whole grid restarted after swapping verification to torch-on-fp32
rejected/C3-run5-lapackcrash2/  # 1 orphan (A arm qB0/s13 of run-5); LAPACK gesdd knife-edge — construction moved to Gram-eigvalsh spectrum (vectors never needed); whole grid restarted
rejected/C3-run6-eighcrash/  # 5 orphans from the eigvalsh-knife-edge run (qB0 full cell incl. first iso/far numbers; gateB0 A+iso) - all replaced by run-7 construction-stable grid

**Sequestration erratum (append-only, 2026-09-15, Κ-hand-016, found in the post-abort audit):** the receipt
line for `rejected/C3-run6-eighcrash/` (5 orphans) was true of the batch but false of its address — at audit
the directory held ZERO files, and the five curves matching its description exactly (qB0 A/iso/far + gateB0
A/iso, mtimes 12:07:51–12:11:10, sha-prefixes c3925346… a927ec40… 8cc24022… aa5c43d1… f8801859…) sat under
`rejected/C3-run5-lapackcrash2/`. The batch was moved to its receipted home at 13:34, mtimes untouched, no
bytes rewritten. `C3-run5-lapackcrash2/` now stands empty: its receipt (1 orphan, qB0 A s13) is kept as a
debt — the arm died in verification before its curve was ever written, or its bytes are indistinguishable
from the moved batch; this hand refuses to decide which from timestamps alone, and says so instead of
silently striking the line. The same off-by-one shape may thread earlier receipts (run-4's "2 orphans" has
1 file on disk); none of these bytes is citable in any direction, so the debt is booked, not paid around.
rejected/C3-run7-ridgefail/  # 1 orphan (qB0 A s13 of run-7, d=0.259979, mtime 13:37) — run died at arm 2 when the ridge-fallback ITSELF threw code 191 on gram_spec(source W); grid rejected whole, instrument hardened before restart
