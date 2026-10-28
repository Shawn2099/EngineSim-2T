# Existing ports of Gordon Blair's two-stroke simulation programs

Research date: 2026-10-29
Question: has anyone reimplemented Blair's BASIC programs (R-104, 1990; R-161, 1996) in a modern language?

---

## Bottom line

**No.** There is no usable open-source port of Blair's *engine simulation* programs —
neither the full cycle model (`Prog 5.1`, "ENGINE MODEL No.1", the MOC/GPB
cylinder–pipe–crankcase solver) nor the individual gas-dynamics listings
(`ProgList 2.1 EXHAUST`, `2.2 INDUCTION`, `2.3 CYLINDER-PIPE FLOW`, `3.2 BLAIR
SCAVENGING MODEL`).

What does exist is:

- two independent ports of **one subroutine** — the squish velocity calculation
  (Blair 1996, pp. 325–330) — one in Python (GPL-3.0), one in Node/Electron (MIT);
- a handful of **from-scratch 0D / geometry calculators** that cite Blair as a
  reference but are not transcriptions of his listings;
- one **commercial, closed-source** implementation of the full method
  (Vannik EngMod2T), built on Blair's GPB method, still sold and maintained.

Nothing implements the method-of-characteristics pipe solver or the full
multi-zone engine cycle in an open repository.

---

## Candidates found

### 1. `elmerilaakkonen/squish-velocity-py` — Python, GPL-3.0 — **usable**

- URL: https://github.com/elmerilaakkonen/squish-velocity-py
- Implements: **squish velocity only.** Port of Blair's squish velocity method,
  explicitly cited as *"Design and Simulation of Two-Stroke Engines", 1996, p. 325-330*.
  Computes squish velocity vs. crank angle, peak squish velocity, associated
  kinetic energy; Tk GUI + matplotlib plot.
- Language: Python 3 (single file, ~300 lines, Tkinter + matplotlib)
- Licence: GPL-3.0
- Status: usable, small, self-contained. Last commit 2018. Limitation noted by the
  author: works for non-negative squish angles only.
- Relevance: this is Blair's squish-velocity design routine, **not** the engine model.
  It is a genuine, faithful port of one listing, which makes it the most useful
  reference in this whole list for how Blair's formulas translate to modern code.

### 2. `andraelang/squish-velocity-1` — JavaScript/Node (Electron), MIT — **usable**

- URL: https://github.com/andraelang/squish-velocity-1
- Implements: **same squish velocity program**, independently ported to NodeJS and
  packaged with Electron (prebuilt macOS/Windows binaries).
- Language: JavaScript (Node + Electron)
- Licence: MIT
- Status: usable. Last commit 2018. README explicitly cross-references the Python
  version above — the two are independent ports of the same Blair routine.

### 3. `alegarciadelrio/garale` — Java, GPL-3.0 — **partially usable, not a simulation**

- URL: https://github.com/alegarciadelrio/garale
- Implements: a suite of **two-stroke mechanical design calculators**, not a cycle
  simulation. Modules (from `src/ventana/`): transfer port height, displacement,
  carburettor sizing, reed/flapper area, compression ratio, cylinder head decking,
  time-area, expansion chamber, YEIS bottle volume and operating rpm.
- Language: Java (Swing, Eclipse project; compiled `.class` files also committed)
- Licence: GPL-3.0
- Status: usable as a calculator, but it is a set of empirical/geometric formulas,
  not Blair's gas-dynamics or thermodynamic model. Started 2011 on a Spanish
  karting forum (CiclosArgentinos); published to GitHub 2024.
- Relevance: useful if you want Blair's *design* formulas (Chapter 6 territory),
  useless if you want `Prog 5.1`.

### 4. `mallwhcre/2stroke_Sim` — C, **no licence** — early stage, not a port

- URL: https://github.com/mallwhcre/2stroke_Sim
- Implements: a **0D thermodynamic simulator** for a 2005 Yamaha YZ125 — in-cylinder
  pressure and piston kinematics per crank angle, plus a reed-valve model and a
  separate `therm.c`. README cites Blair's *Design and Simulation of Two-Stroke
  Engines* as the reference and says "the standard starting point ... is the approach
  used throughout Blair's textbook".
- Language: C (Makefile, ~6 source files, a few hundred lines total)
- Licence: **none** (no LICENSE file — all rights reserved by default)
- Status: usable-ish but very incomplete and openly unverified (crankcase volume and
  reed geometry are estimates). Rewritten from scratch against Blair's *approach*,
  not transcribed from his listings. No Method of Characteristics, no pipe solver.
- Relevance: closest thing to an open-source *engine* model that cites Blair, but it
  is a 0D single-zone model, i.e. it skips exactly the part of Blair's method that is
  hard to reimplement (the unsteady pipe gas dynamics).

### 5. Vannik **EngMod2T** — commercial, closed source — the real thing, but not free

- URL: https://vannik.co.za/EngMod2T.htm (author page: https://vannik.co.za/About.htm)
- Implements: **full multi-cylinder two-stroke cycle simulation** — gas dynamics in
  pipes/ducts/ports/plenums "using the GPB-method for pipe flows", two-zone
  combustion with Wiebe burn rate, Blair's scavenging model, Cd maps for all ports
  and discontinuities.
- Language: native Windows application (closed)
- Licence: commercial, paid, trial available
- Status: **the only faithful full implementation of Blair's method I could find**,
  and it is proprietary. Author Neels van Niekerk states he wrote it originally with
  the homentropic MOC and converted it to Blair's non-homentropic GPB method when
  Blair published it in 1991. Still updated (2T last update June 2025).
- Relevance: this is what a port would be competing with. It also demonstrates that
  nobody has bothered to redo it openly — the demand is served commercially.

### 6. Prof Blair & Associates — commercial, four-stroke only

- URL: http://profblairandassociates.com/
- The authors' own company, formed to "create and distribute software relating to the
  design of reciprocating internal combustion engines". Sells `4stHEAD` and `4stSOFT`;
  `4stSOFT` is described as "an enhanced and expanded version of the original
  SAE-marketed software" for the four-stroke book.
- Status: relevant as a **negative** finding — the commercially maintained descendant
  of the SAE software is four-stroke only. There is no two-stroke product on the site.
  Blair died in 2010; the two-stroke code line effectively ended with the books.

---

## Adjacent work that is NOT a port of Blair

Listed so the boundary is clear; none of these transcribe Blair's listings.

| Repo | Language | What it is | Licence |
|---|---|---|---|
| [HughF/pipegen](https://github.com/HughF/pipegen) | C (SDL2) | Two-stroke expansion chamber designer: 3D design/bending, flat patterns to DXF/PDF | none stated |
| [Dryrtan/Pipe](https://github.com/Dryrtan/Pipe) | Python | Expansion chamber dimension calculator | none stated |
| [rahman-wq/2stroke-calc](https://github.com/rahman-wq/2stroke-calc) | JavaScript/React | Expansion chamber + port timing + "ECU optimizer" web calculator (scaffold-stage) | none stated |
| [zolaski333/EngineLab](https://github.com/zolaski333/EngineLab) | C++20 / JUCE | Real-time 1-D gas-dynamics engine sim with audio; has a piston-ported two-stroke mode with crankcase pumping. Own model, not Blair's | see repo |
| [jiajingy/TwoStrokeEngineSimulator](https://github.com/jiajingy/TwoStrokeEngineSimulator) | C# | Toy piston/cylinder/spark-plug kinematics, no thermodynamics | none |
| [frankpicon/2StrokeEngineSimulator](https://github.com/frankpicon/2StrokeEngineSimulator) | C# | Console kinematics demo | none |
| [xenaxara/Two-Stroke_Engine](https://github.com/xenaxara/Two-Stroke_Engine) | Arduino C++ | Single `.ino` sketch, 2★, no docs | none |

---

## The SAE companion diskette / original listings

**Not archived anywhere I could find.**

- archive.org has one item, `TheBasicDesignOfTwoStrokeEngines` (uploaded 2017,
  unofficial). Its file list is **book scan artefacts only** — PDF, EPUB, DJVU text,
  JP2, scandata. **No disk image, no `.BAS` files, no software of any kind.** The
  upload is also only 347 pages, i.e. an incomplete copy of the book, so even the
  printed appendix listings are truncated. (I read the metadata only; I did not
  download the scan.)
- archive.org searches for `mediatype:software` + `"two stroke"`, and for
  `"two-stroke" AND diskette`, return nothing relevant.
- No GitHub repo contains the string `ProgList` or `ENGINE MODEL No.1` (searched via
  GitHub repository search and Sourcegraph; see caveat below).
- No `.BAS` transcription of the R-104/R-161 appendix appears on SourceForge, GitLab,
  Bitbucket or Codeberg.

Consequence: **the only surviving source of the listings is the printed appendix in
the books themselves** (pages 405+ in R-104; the Chapter 5 program appendix in R-161).
The diskette's contents were, as far as the public record shows, never dumped.

---

## Where I searched, and what came up empty

- **GitHub repository search** (API, ~20 queries): `two-stroke engine simulation`,
  `two stroke engine model`, `blair two stroke`, `momentum exchange two stroke`,
  `two stroke tuned pipe simulation`, `engine simulation method of characteristics`,
  `two stroke scavenging simulation`, `squish velocity`, `expansion chamber two stroke`,
  `two stroke matlab`, `two stroke julia`, `two stroke BASIC listing`, `R-104 Blair`,
  `2stroke`, `blair "two-stroke" in:readme`. Only the items above are relevant.
- **GitHub code search**: the web UI (`github.com/search?type=code`) now hard-requires
  sign-in, and this session has no authenticated browser. **This is the one real gap
  in coverage** — a code-only match (e.g. a private-ish repo with a `prog51.py` and no
  README mention) would have been missed. Repository search does index READMEs, which
  mitigates but does not eliminate this.
- **Sourcegraph** public search (`"ENGINE MODEL No.1"`, literal): 0 matches. Further
  queries timed out; Sourcegraph only indexes a slice of public repos anyway.
- **grep.app**: blocked (Cloudflare challenge / HTTP 429).
- **GitLab** (`/api/v4/projects?search=two-stroke`): one irrelevant hit.
- **Codeberg** (`/api/v1/repos/search`): 0 hits for `two-stroke`, `engine simulation`.
- **SourceForge** directory search: HTTP 403 (blocked); no SourceForge project surfaced
  in any web search either.
- **Bitbucket**: nothing surfaced.
- **MATLAB File Exchange**: no two-stroke engine simulation submission. Searches for
  `two-stroke` on File Exchange return only unrelated turbojet/gas-turbine cycle
  submissions. (File Exchange itself returned 403 to direct fetch; checked via search.)
- **Theses**: Queen's University Belfast's own repository (pure.qub.ac.uk) holds the
  ancestral MOC work — e.g. Cahoon, *Unsteady gas flow through a naturally aspirated
  two stroke internal combustion engine*, PhD 1971, whose Appendix 2 documents a
  "THROUGH FLOW" program; and Kee 1988. These are **algorithm descriptions and flow
  diagrams in old reports, not modern-language code**, and nothing newer in the
  repository reproduces Blair's listings. No PhD/MSc anywhere was found shipping a
  Blair-derived MOC implementation.
- **Forums**: the sci.engr.mech thread "Blair's The Basic Design of Two-Stroke Engines
  Software" could not be retrieved (Google Groups is JS-only and the thread does not
  surface in web search); nothing on Eng-Tips, Reddit, Physics Forums, KartPulse or
  DIY Go Kart describing a working reimplementation. Discussion of Blair's books is
  common; discussion of porting the code is not.

---

## Practical read

If the goal is a working model of a specific engine, the honest options are:

1. **Transcribe from the printed appendix yourself.** Nothing exists to copy. The
   squish-velocity repo shows the formulas translate cleanly; the MOC pipe solver
   (`ProgList 2.3`) is the hard part and has no prior art in the open.
2. **Buy EngMod2T** if you need validated results and not code.
3. **Start from a from-scratch open simulator** (`mallwhcre/2stroke_Sim` for a 0D
   skeleton, `EngineLab` for a 1-D duct network) rather than from Blair's listings —
   they will get you to a running program faster than a literal BASIC transcription,
   but they will not reproduce Blair's calibration or his published validation cases.

The gap is real and, as of this search, unfilled.
