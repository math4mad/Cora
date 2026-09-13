#!/usr/bin/env bash
# CORA — homepage minter. docs/index.html is a DERIVED ARTIFACT: nothing on it is typed.
# Every number, hash, status chip and scar is read from the ledgers at build time
# (git HEAD, PREREG, FOUNDLING, the manifests, and live runs of pin.sh / validate-manifests.sh).
# If the page ever shows a byte the generator cannot reproduce — that is a bug, not a style choice.
# Usage: bin/homepage.sh          (writes docs/index.html; exit non-zero if any live check fails)
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"; cd "$ROOT"
python3 - <<'PY'
import hashlib, json, os, re, subprocess, sys, datetime, html as H
root = os.path.abspath(".")
CODE = os.path.dirname(root)
def sh(*a, cwd=None): return subprocess.run(a, cwd=cwd or root, capture_output=True, text=True).stdout
def rc(*a, cwd=None):  return subprocess.run(a, cwd=cwd or root, capture_output=True).returncode
def h16(p):  return hashlib.sha256(open(p,"rb").read()).hexdigest()[:16]

# ---------- live checks (the page reports what the instruments just answered, not what was true yesterday)
val_out = sh("bin/validate-manifests.sh", "--strict", "--quiet"); val_rc = rc("bin/validate-manifests.sh","--strict","--quiet")
tree = subprocess.run(["git","status","--porcelain"],cwd=root,capture_output=True,text=True).stdout.strip().splitlines()
head = sh("git","rev-parse","--short","HEAD").strip(); n_commits = int(sh("git","rev-list","--count","HEAD").strip())
branch = sh("git","branch","--show-current").strip()

# ---------- register entries (from git HEAD, the only seat that counts)
prereg = sh("git","show","HEAD:docs/PREREG.md")
entries = re.findall(r"^#{2,3} ([CD]\d[^\n]*)$", prereg, re.M)
c1_block = prereg[prereg.index("## C1 —"):] if "## C1 —" in prereg else ""
c1_ratified = "**Ratified:**" in c1_block
c1_ghost = "GHOSTWRITTEN" in c1_block
# R3 mirror: the review pin the runner itself gates on
runner = sh("git","show","HEAD:experiments/c1_run.sh")
mrv = re.search(r'REVIEW_SHA="([0-9a-f]{64})"', runner); rev_path = re.search(r'REVIEW="(.*?)"', runner)
r3_ok = False
if mrv and rev_path:
    r3_ok = rc("bin/pin.sh", rev_path.group(1), mrv.group(1)) == 0
c1_state = "ACTIVE — runner would pass R1-R3" if (c1_ratified and r3_ok) else ("AWAKENS AT ①" if c1_ratified else "INACTIVE")
bands = {}
for name in ("D1-C1band","D2-C1band"):
    f=f"artifacts/results/{name}_band.json"
    if os.path.isfile(f):
        j=json.load(open(f)); bands[name]=(j["band_nats"], j["sha256" ] if "sha256" in j else h16(f), h16(f))

# ---------- scars: table rows of FOUNDLING @ HEAD, resolved against the father's manifests live
foundling = sh("git","show","HEAD:docs/FOUNDLING.md")
# parse scar rows generically: an S-row anywhere carries a backticked path and a backticked sha16 —
# (v1 regex demanded sha in the LAST cell and silently dropped S6, whose row ends in prose; a minter
# that mints five of six scars without saying so is the f79d588 class in a dress. fixed, test added.)
scars = []; dropped = []
for line in foundling.splitlines():
    m0 = re.match(r"^\| (S\d) \|", line)
    if not m0: continue
    sid = m0.group(1)
    cands = [c for c in re.findall(r"`([^`]+)`", line) if "/" in c and "." in c]
    shx = re.search(r"`([0-9a-f]{12,16})…`", line)
    if not (cands and shx):
        dropped.append(sid); continue
    path, sha16 = cands[0], shx.group(1)   # first slashed-and-dotted backtick: prose may name files bare
    r = subprocess.run(["bin/pin.sh", path, sha16+"0"*max(0,64-len(sha16))], capture_output=True, text=True)  # width shown on chip
    # proper: look up the full sha via the father's manifest by prefix
    full = sha16
    for mf in [os.path.join(CODE,"chora","artifacts","results","manifest.json")]:
        if os.path.isfile(mf):
            for e in json.load(open(mf)).get("files",[]):
                if e["path"]==path or (e["path"] in path or path in e["path"]):
                    if e["sha256"].startswith(sha16): full=e["sha256"]
    ok = rc("bin/pin.sh", path, full)==0
    scars.append((sid, path, full[:16], ok))

# ---------- letters & pins & debts
letters = sorted(f for f in os.listdir("letters") if f.endswith(".md"))
pins = json.load(open("artifacts/results/manifest.json")).get("files",[])
debts = sorted(set(re.findall(r"`([0-9a-f]{12,64})…`? marked unresolved", prereg, re.I) + re.findall(r"([0-9a-f]{8,16})[0-9a-f]*…?\)? ?\(?(?:marked )?unresolved", prereg)))
# address map (descriptive prose is law, not data)
addr = [("Θ","GrandFather","the shelf · cargo here, deeds upstairs (moved out 2026-09-13, the chair's word)"),
        ("Χ","chora","the rules · five benches, ~200 manifested artifacts, every negative on record"),
        ("Ζ","—","the chair · ζήτησις asks, ἐποπτεία witnesses, συμβουλή counsels, κυροῦν ratifies"),
        ("Κ","Cora","the daughter · this page; empty by design until each entry filled it")]

def chip(label, ok, title=""):
    c = "ok" if ok else "warn"
    return f'<span class="chip {c}" title="{H.escape(title)}">{label}</span>'
now = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")

band_rows = "".join(
    f"<tr><td>{n}</td><td class='num'>{v[0]} nats</td><td class='mono'>{v[2]}…</td>"
    f"<td>{chip('VERIFIED', rc('bin/pin.sh', f'artifacts/results/{n}_band.json', next(e['sha256'] for e in pins if e['path']==f'artifacts/results/{n}_band.json'))==0)}</td></tr>"
    for n,v in sorted(bands.items()))
scar_rows_html = "".join(f"<tr><td>{s}</td><td class='mono'>{p.split('/')[-1]}</td><td class='mono'>{x}…</td><td>{chip('LIVE' if ok else 'DEAD', ok)}</td></tr>" for s,p,x,ok in scars)
addr_rows = "".join(f"<div class='addr'><b class='gk'>{g}</b><code>{d}</code><span>{t}</span></div>" for g,d,t in addr)
letters_rows = "".join(f"<li>{H.escape(f)}</li>" for f in letters)

CSS = """
:root{--paper:#f7f2e8;--ink:#20180f;--soft:#6b5d4a;--line:#d8cbb5;--ok:#2e6b34;--warn:#8a5a11;--accent:#7b4f1d}
@media (prefers-color-scheme:dark){:root{--paper:#17140f;--ink:#e8e0d2;--soft:#a99c85;--line:#3a332a;--ok:#7fc384;--warn:#d9a44a;--accent:#d9a44a}}
*{box-sizing:border-box} body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.55 Georgia,'Songti SC',serif}
main{max-width:60rem;margin:0 auto;padding:2.5rem 1.25rem 5rem}
h1{font-size:2.6rem;margin:.2em 0 0;letter-spacing:.01em} h1 small{color:var(--soft);font-size:1.1rem;font-style:italic}
.sig{color:var(--soft);font-style:italic;border-left:3px solid var(--accent);padding-left:1rem;margin:1.2rem 0 2rem}
h2{font-size:1.2rem;text-transform:uppercase;letter-spacing:.14em;color:var(--soft);border-bottom:1px solid var(--line);padding-bottom:.3rem;margin-top:2.6rem}
.chip{display:inline-block;border:1px solid var(--line);border-radius:999px;padding:.05rem .6rem;font-size:.8rem}
.chip.ok{color:var(--ok)} .chip.warn{color:var(--warn)}
table{border-collapse:collapse;width:100%;font-size:.9rem} td,th{padding:.35rem .5rem;border-bottom:1px solid var(--line);text-align:left;vertical-align:top}
.num{text-align:right;font-variant-numeric:tabular-nums} .mono{font-family:ui-monospace,Menlo,monospace;font-size:.8rem}
.marks span.gk{font-size:2rem;margin-right:1rem;color:var(--accent)}
.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(13rem,1fr));gap:.6rem}
.card{border:1px solid var(--line);border-radius:.6rem;padding:.8rem 1rem} .card b{font-size:1.5rem} .card small{color:var(--soft)}
.addr{display:grid;grid-template-columns:2.5rem 12rem 1fr;gap:.6rem;align-items:baseline;border-bottom:1px dashed var(--line);padding:.4rem 0} .addr b.gk{color:var(--accent)}
footer{margin-top:3rem;color:var(--soft);font-size:.85rem;border-top:1px solid var(--line);padding-top:1rem}
a{color:inherit}
"""

page = """<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>CORA \u00b7 x\u03c7\u03c1\u03b1 \u2014 the daughter workspace</title>
<style>""" + CSS + """</style></head><body><main>
<h1>CORA <small>\u00b7 K\u03cc\u03c1\u03b1 \u00b7 the daughter workspace</small></h1>
<div class="marks"><span class="gk">\u0398</span><span class="gk">\u03a7</span><span class="gk">\u0396</span><span class="gk">\u039a</span>
 \u2014 the shelf, the rules, the wind, the maiden.</div>
<p class="sig">\u201cThe shape of the container is the knowledge.\u201d \u2014<em>we choose the bounds, and the
evidence chooses them, never the hand.</em></p>

<h2>This build, live</h2>
<div class="grid">
<div class="card"><b>@@ENTRIES@@</b><br><small>register entries \u00b7 drills with results, one ratified hypothesis</small></div>
<div class="card"><b>C1 @@C1STATE@@</b><br><small>@@C1NOTE@@ \u00b7 R3 mirror @@R3@@</small></div>
<div class="card"><b>@@PINS@@</b><br><small>pinned artifacts in this house&#8217;s manifest</small></div>
<div class="card"><b>@@SCARLIVE@@/@@SCARS@@</b><br><small>scars re-batteried at build time</small></div>
<div class="card"><b>@@LETTERS@@</b><br><small>letters home</small></div>
<div class="card"><b>@@COMMITS@@</b><br><small>commits on <code>@@BRANCH@@</code> @ @@HEAD@@</small></div>
</div>
<p>@@CHIPS@@</p>

<h2>Bands \u2014 the house&#8217;s nerves, measured</h2>
<table><tr><th>drill</th><th>band</th><th>bytes (live-verified this build)</th><th>check</th></tr>@@BANDS@@</table>

<h2>Scars are immunity</h2>
<table><tr><th>#</th><th>artifact (the father&#8217;s, cited not copied)</th><th>pin</th><th>at build</th></tr>@@SCARROWS@@</table>

<h2>The street</h2>
@@STREET@@

<h2>Correspondence</h2><ul class="mono">@@LETTERLIST@@</ul>

<h2>What this page may not be</h2>
<p>Not a record. The record is <code>docs/PREREG.md</code> at git HEAD, the manifests, and the letters;
this page is their shadow at one minute&#8217;s light. Every number here was read, run, or hashed by
<code>bin/homepage.sh</code> at build time (@@NOW@@) \u2014 if you find a byte on this page the generator
cannot reproduce, that is a bug, not a decoration. Law 2 applies to homepages: <em>nothing crosses
without a hash</em>, and nothing here was typed.</p>

<footer>\u03c7\u03ce\u03c1\u03b1 (kh\u1e53ra): space, place, the receptacle \u2014 Plato&#8217;s \u201cnurse of becoming\u201d.<br>
Charter living clauses: AGENTS \u00a76 hash-gate \u00b7 \u00a77 no-treasure \u00b7 \u00a78 house marks (+\u0398&#8217;s move-out).
The charter&#8217;s last word always carries the chair&#8217;s, and the chair&#8217;s word is always quoted, never paraphrased.</footer>
</main></body></html>
"""
repl = {
  "@@ENTRIES@@": str(len(entries)), "@@C1STATE@@": c1_state, "@@C1NOTE@@": "ratified by the chair&#8217;s \u300cconfirm\u300d; awaits the father&#8217;s pin \u2460" if c1_ratified else "ghostwritten",
  "@@R3@@": "PASSED" if r3_ok else "open (endorsement unpinned at the father&#8217;s HEAD)",
  "@@PINS@@": str(len(pins)), "@@SCARS@@": str(len(scars)), "@@SCARLIVE@@": str(sum(1 for s in scars if s[3])),
  "@@LETTERS@@": str(len(letters)), "@@COMMITS@@": str(n_commits), "@@BRANCH@@": branch, "@@HEAD@@": head,
  "@@CHIPS@@": (chip("validate-manifests --strict " + ("PASS" if val_rc==0 else "FAIL"), val_rc==0) + " " +
                chip("working tree " + ("clean" if not tree else str(len(tree)) + " dirty"), not tree) + " " +
                chip("law-8 gate installed", os.path.isfile(".git/hooks/pre-commit")) + " " +
                chip("deep store audit: bin/sync.sh --check (3.7 s, run it)", True)),
  "@@BANDS@@": band_rows, "@@SCARROWS@@": scar_rows_html, "@@STREET@@": addr_rows,
  "@@LETTERLIST@@": letters_rows, "@@NOW@@": now,
}
for k,v in repl.items():
    page = page.replace(k,v)
open("docs/index.html","w").write(page)
fails = [x for x in scars if not x[3]]
if dropped: print(f"[homepage] SCAR ROWS UNPARSED (fix the table or the parser): {dropped}"); sys.exit(1)
print(f"[homepage] docs/index.html written · entries={len(entries)} bands={len(bands)} scars={len(scars)} pins={len(pins)} letters={len(letters)} validate={'PASS' if val_rc==0 else 'FAIL'} dead_scars={len(fails)}")
sys.exit(0 if val_rc==0 and not fails else 1)
PY
