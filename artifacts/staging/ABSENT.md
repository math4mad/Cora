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
