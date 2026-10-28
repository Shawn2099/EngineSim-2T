# Downloaded open-access research papers (references/)

## Successfully downloaded (PDF)

| File | Year | Title | Source |
|---|---|---|---|
| 1995_MODELLING_THE_SCAVENGING_PROCESS_IN_A_TWO_STROKE_I_C_ENGINE.pdf | 1995 | Modelling the Scavenging Process in a Two-Stroke I.C. Engine | Victoria University (vuir.vu.edu.au) |
| 2012_Simulation_of_the_Scavenging_Process_in_Two_Stroke_Engines.pdf | 2012 | Simulation of the Scavenging Process in Two-Stroke Engines | IntechOpen (OA) |
| 2016_Evaluations_of_Scavenge_Port_Designs_for_a_Boosted_Uniflow_S.pdf | 2016 | Evaluations of Scavenge Port Designs for a Boosted Uniflow Scavenged DI Gasoline Engine | Brunel (bura.brunel.ac.uk) |
| 2018_Development_of_an_extended_mean_value_engine_model_for_predi.pdf | 2018 | Development of an extended mean value engine model for predicting the marine two-stroke diesel engine | Strathclyde (strathprints) |
| 2022_Study_of_the_effects_of_trapped_compression_ratio_on_the_hea.pdf | 2022 | Study of the effects of trapped compression ratio on the heavy fuel operation of a spark ignition two-stroke engine | AUT open repository |
| 2025_Improving_the_energy_efficiency_of_a_two_stroke_engine_with.pdf | 2025 | Improving the energy efficiency of a two-stroke engine with crankcase scavenging for UAVs | Combustion Engines journal |
| Frontiers_2022_uniflow_scavenging.pdf | 2022 | Investigation of the scavenging process in two-stroke uniflow scavenging marine engines (Frontiers in Energy Research) | frontiersin.org |
| IOP_2024_scavenge_params.pdf | 2024 | Analysis of the interactive effects of scavenge parameters on spark ignition two-stroke diesel engines | IOP J. Phys: Conf. Ser. |

## Additional open-access sources retrieved 2026-10-28

Per-file text extracts are in `text/<same name>.txt` (PyMuPDF, page-marked).

| File | Year | Title | Source URL | Text extracted |
|---|---|---|---|---|
| 1938_Rogowski_Scavenging_Piston_Ported_Two_Stroke_Cylinder.pdf | 1938 | Scavenging a Piston-ported Two-stroke Cylinder (NACA TN-674) | https://ntrs.nasa.gov/citations/19930081490 | Yes — OCR layer, noisy |
| 1942_Schweitzer_Tracer_Gas_Charging_Efficiency_Two_Stroke.pdf | 1942 | The Tracer Gas Method of Determining the Charging Efficiency of Two-stroke-cycle Diesel Engines (NACA TN-838) | https://ntrs.nasa.gov/citations/19930081598 | Yes — OCR layer, noisy |
| 1956_Ku_Trimble_Scavenging_Characteristics_Skip_Cycle.pdf | 1956 | Scavenging Characteristics of a Two-Stroke-Cycle Engine as Determined by Skip-Cycle Operation (NBS RP 2721) | https://nvlpubs.nist.gov/nistpubs/jres/057/6/v57.n06.a02.pdf | Yes |
| 1981_Jones_Brown_Two_Stroke_Exhaust_Noise_Method_of_Characteristics.pdf | 1981 | Determination of Two-Stroke Engine Exhaust Noise by the Method of Characteristics (NASA TM-84061) | https://ntrs.nasa.gov/citations/19820005954 | Yes — OCR from microfiche, poor quality |
| 2017_Kamili_Zahidi_Two_Stroke_Poppet_Valve_Port_Flow.pdf | 2017 | The two-stroke poppet valve engine. Part 1: intake and exhaust ports flow experimental assessments | https://doi.org/10.1088/1757-899X/257/1/012023 | Yes |
| 2018_Jia_Free_Piston_Two_Stroke_Scavenging_Ports_Valves.pdf | 2018 | Analysis of the Scavenging Process of a Two-Stroke Free-Piston Engine Based on the Selection of Scavenging Ports or Valves | https://doi.org/10.3390/en11020324 | Yes |
| 2018_Qiao_Scavenging_Ports_Small_Aeroengine_Benson_Bradham.pdf | 2018 | Scavenging Ports' Optimal Design of a Two-Stroke Small Aeroengine Based on the Benson/Bradham Model | https://doi.org/10.3390/en11102739 | Yes |
| 2019_Foteinos_Three_Zone_Scavenging_Model_Uniflow.pdf | 2019 | A Three-Zone Scavenging Model for Large Two-Stroke Uniflow Marine Engines Using Results from CFD Scavenging Simulations | https://doi.org/10.3390/en12091719 | Yes |
| 2023_Climent_Heat_Transfer_1D_Uniflow_Scavenged.pdf | 2023 | In-Cylinder Heat Transfer Model Proposal Compatible with 1D Simulations in Uniflow Scavenged Engines | https://doi.org/10.3390/app13063996 | Yes |
| 2023_Ortenzi_1D_Model_High_Performance_Two_Stroke.pdf | 2023 | A One-Dimensional Numerical Model for High-Performance Two-Stroke Engines | https://doi.org/10.3390/en16134947 | Yes |
| 2023_Shao_Small_Two_Stroke_HFDI_Scavenging_Combustion.pdf | 2023 | Study of Scavenging and Combustion Processes for Small Two-Stroke Aviation Heavy Fuel Direct Injection Engines | https://doi.org/10.3390/pr11020583 | Yes |

### Notes on this batch
- Web search was **not** quota-blocked this time; discovery mixed web search with the OpenAlex API (`api.openalex.org`, open, no key) and the NTRS API.
- `www.mdpi.com` returns **403** to scripted requests (Cloudflare), so MDPI PDFs were fetched from the publisher's own file CDN `mdpi-res.com/d_attachment/<journal>/<journal>-<vol>-<id>/article_deploy/...pdf`. Every file was opened with PyMuPDF and its title page checked against the intended article before being kept.
- **NACA TN-1198 is not a two-stroke paper.** NTRS lists it as *Some Investigations of the General Instability of Stiffened Metal Cylinders IX: Criterions for the Design of Stiffened Metal Cylinders Subject to General Instability Failures* (1947). Nothing was downloaded under that number. The genuine NACA two-stroke reports are TN-674 (retrieved here), TN-838 (retrieved here), and TM-446 / TM-516 / TM-732 / TM-776.
- A NTRS hit `19910015269` surfaced in search as a two-stroke scavenging-model report but is actually *Simulation of a Combined-Cycle Engine* (Van Gerpen); it was **not** kept.
- ~~Still the main gap: **no two-stroke-specific Wiebe correlation source**~~ — **closed**: the Galindo/Climent/Plá/Jiménez Wiebe paper was retrieved from HAL (`hal-00723971`) on 2026-10-28; see the targeted sweep section.

## Targeted DOI sweep — 2026-10-28 (repository APIs only)

Requested seven DOIs. Retrieved via OpenAlex / Unpaywall / HAL / RiuNet / BURA. Nothing was
taken from a publisher domain; no shadow-library source was used anywhere.

| File | Year | Title | Source URL | Text extracted |
|---|---|---|---|---|
| 2011_Galindo_Wiebe_Correlations_Two_Stroke.pdf | 2011 | Correlations for Wiebe function parameters for combustion simulation in two-stroke small engines | https://hal.science/hal-00723971 (HAL, accepted manuscript) | Yes — 34 pp., pp. 23-34 are image-only figures |
| 2014_Climent_Heat_Transfer_Exhaust_Systems_Two_Stroke.pdf | 2014 | Heat transfer modeling in exhaust systems of high-performance two-stroke engines | https://riunet.upv.es/bitstream/10251/49341/3/PR-2014-21%20aurtor%20climent.pdf (RiuNet/UPV) | Yes — 25 pp. |
| 2017_Brunel_Scavenge_Port_Designs_Exhaust_Valve_Profiles.pdf | 2017 | Analysis of scavenge port designs and exhaust valve profiles on the in-cylinder flow and scavenging performance in a 2-stroke boosted uniflow scavenged direct injection gasoline (BUSDIG) engine | https://bura.brunel.ac.uk/handle/2438/16373 (Brunel BURA, accepted manuscript) | Yes — 49 pp. |

Already present and verified against the requested DOIs (no re-download needed):

| File | DOI | Note |
|---|---|---|
| 2018_Jia_Free_Piston_Two_Stroke_Scavenging_Ports_Valves.pdf | 10.3390/en11020324 | MDPI gold OA, 14 pp. |
| 2023_Ortenzi_1D_Model_High_Performance_Two_Stroke.pdf | 10.3390/en16134947 | MDPI gold OA, 24 pp. |

### DOI corrections found during this sweep
- `10.1016/j.jaecs.2021.100118` **is not a registered DOI** — HTTP 404 from both Crossref and
  OpenAlex. The paper being described is almost certainly
  **10.1016/j.ecmx.2021.100086**, *Mathematical modeling of the two-stroke crankcase scavenged
  spark ignition engine working process*, Energy Conversion and Management: X (2021), Choe / Ryu /
  Kang / Ri. Still not downloadable: gold OA but hosted only on ScienceDirect (see below).
- `10.1016/j.applthermaleng.2014.04.064` resolves to a **different paper** — Kim & Kim,
  *Thermodynamic performance analysis of a combined power cycle using low grade heat source and
  LNG cold energy*, ATE 70 (2014) 50-60. The intended two-stroke paper is
  **10.1016/j.applthermaleng.2014.04.045** (Luján, Climent, Olmeda, Jiménez, ATE 69 (2014) 96-104),
  which was retrieved above from RiuNet.

### Access failures in this sweep (no repository copy exists)
- `10.1016/j.cja.2020.07.015` — Unpaywall lists only ScienceDirect (hybrid OA). OSTI record
  1648368 holds metadata only, no full text. CORE search returned 403 / API 429.
  Best manual landing page: https://www.osti.gov/biblio/1648368
- `10.1016/j.ecmx.2021.100086` — Unpaywall lists only ScienceDirect (gold OA) plus a DOAJ record.
  It is free to read at the DOI, but scripted access to the publisher is blocked, so it was not
  fetched. Best manual landing page: https://doaj.org/article/2d6bc128d1ae4317890d9d4b04ed762a

## Could not auto-download (paywalled / blocked) — fetch manually via DOI

| Year | Title | DOI / URL |
|---|---|---|
| 2020 | Effect of scavenge port angles on flow distribution and performance of swirl-loop scavenging | 10.1016/j.cja.2020.07.015 — **still blocked.** No repository copy exists (Unpaywall: publisher only). OSTI 1648368 is metadata only. Manual: https://www.osti.gov/biblio/1648368 |
| ~~2017~~ | ~~Analysis of scavenge port designs and exhaust valve profiles~~ | **RETRIEVED 2026-10-28** from Brunel BURA — see targeted sweep above |
| ~~2010~~ | ~~Correlations for Wiebe function parameters~~ | **RETRIEVED 2026-10-28** from HAL hal-00723971 — see targeted sweep above |
| 2021 | Mathematical modeling of the two-stroke crankcase scavenged spark ignition engine | DOI as given is **invalid** (404). Correct: 10.1016/j.ecmx.2021.100086 — still only on ScienceDirect. Manual: https://doaj.org/article/2d6bc128d1ae4317890d9d4b04ed762a |
| 2008 | Crankcase analysis for two-stroke spark ignition engines | umpir.ump.edu.my/id/eprint/336 (UMP repo — HTTP 522) |
| 2014 | A quasi-dimensional spark ignition two stroke engine model | 10.6084/m9.figshare.9522845 (Loughborough thesis; figshare downloader — 403 bot block) |
| ~~2014~~ | ~~Heat transfer modeling in exhaust systems of high-performance two-stroke engines~~ | **RETRIEVED 2026-10-28** from RiuNet 10251/49341 — see targeted sweep above |
| 2010 | An investigation of squish generated turbulence in IC engines | hdl.handle.net/2429/25068 (UBC) |
| 2017 | Differential air/fresh charge demand, supply and utilisation in two-stroke spark ignition engines | 10.15282/ijame.14.4.2017.13.0374 (IJAME) |
| 1992 | On the Numerical Analysis of the Scavenging Flow in a Loop-Flow-Type Two-Stroke Engine | jstage.jst.go.jp (J-STAGE) — not yet located |
| 1990 | On the numerical analysis of the scavenging flow in a two-stroke-cycle gasoline engine | jstage.jst.go.jp (J-STAGE) — not yet located |
| 1961 | Scavenging Efficiency of a Crankcase-Scavenged Two-Stroke Gasoline Engine | jstage.jst.go.jp/article/kikai1938/27/183/27_183_1883 — PDF downloaded OK but **image-only scan, no text layer**; needs OCR before use |
| 1961 | On the Scavenging of Two-Stroke Diesel Engine: Scavenging Process in Cross-Scavenging System | jstage.jst.go.jp/article/jsme1958/4/16/4_16_699 — same: image-only scan, no text layer |

## Additional free sources to browse
- J-STAGE (jstage.jst.go.jp) — Japanese two-stroke scavenging papers, free PDFs (pre-1970 JSME items are image-only scans).
- OSTI.gov — reachable, but its API returned XML on the `format=json`-less query and no relevant two-stroke simulation record was retrieved; re-try manually.
- NTRS (nasa.gov) — NACA/NASA two-stroke reports: TN-674, TN-838, TM-446, TM-516, TM-732, TM-776. (NACA TN-1198 is a structures paper, not engines.)
- University repositories: VU, Strathclyde, Brunel, AUT, UBC, Loughborough, UMP, LIU (diva-portal).
- IntechOpen — free OA book chapters on engine simulation.
