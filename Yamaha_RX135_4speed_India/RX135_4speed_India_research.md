# Yamaha RX135 — 4-speed — Indian Market — Verified Parameter Dataset

Folder: `Yamaha_RX135_4speed_India/`. Scope: Indian-market 4-speed RX135 (132 cc air-cooled two-stroke) only. The 5-speed variant is a SEPARATE dataset (see sibling folder `Yamaha_RX135_India/`) and is never merged/averaged with this one. Excluded: RX-King 135 (Indonesia), RX135 Thailand/SEA, RX-Z Malaysia, RX115, RX100, RX-Z India.

Sub-revisions treated as one 4-speed dataset: YEIS 1998–2000; cat-con 2001–2003; mini-cat 2003–2005 (no documented engine/porting change beyond catalytic-converter and cosmetic updates found).

Tiers: T1 = Yamaha factory manual/owner manual/parts catalogue/official archive; T2 = independent dyno/measured teardown/technical article; T3 = forum post with actual measurement/photo/part number by named user with date; T4 = blog/video/marketplace/unsourced. CORROBORATED = 2+ independent sources agree. Confidence <70% stated in-row. NOT FOUND = not located; no invented values.

---

## 1. Executive summary

**Solid:** identity, model years (3 sub-revisions), bore/stroke/displacement, factory power/torque (Yamaha T1), parts-catalogue part numbers (cyl head, piston, rings, crank, carb assy, exhaust, CDI magneto/unit, spark plug, reed valve, sprockets), carb jetting for two sub-variants (early 4TL1 round venturi; later 4TL1L7/4UU UCAL), gear ratios, primary/final drive, dimensions, tyres.

**Thin:** port timing (only generic RX-series numbers, variant unspecified), compression (only a T4 mention of ~22 cc chamber), ignition timing, exhaust dimensions.

**Missing:** connecting rod length, piston compression height, gudgeon pin Ø, deck height, gasket thicknesses, trapped CR, squish, service wear limits, torque specs, CDI part number (for later sub-variants), spark plug gap.

---

## 2. Parameter table (Variant A — 4-speed)

| Parameter | Value | Unit | STOCK/MOD | Tier | Source | Corrob.? |
|---|---|---|---|---|---|---|
| Model years (YEIS) | 1998–2000 | yr | STOCK | T1 | Wikipedia RX100 page | yes |
| Model years (cat-con) | 2001–2003 | yr | STOCK | T3 | xbhp 4 vs 5 thread | no |
| Model years (mini-cat) | 2003–2005 | yr | STOCK | T3 | xbhp 4 vs 5 thread | no |
| Engine code prefix | 1L5 (chrome silencer OE) / 4TL (cat silencer OE) | — | STOCK | T3 | xbhp post #89 | yes (parts cat 4TL1) |
| Parts line | 4TL (4TL1, 4TL2) | — | STOCK | T1 | safexbikes parts cat PDF | yes |
| Frame/VIN prefix | 4TL1 (parts cat) | — | STOCK | T1 | safexbikes parts cat | no |
| Cylinder block code | 4TL00 | — | STOCK | T3 | xbhp post #89 | yes |
| Cylinder head code | 4TL00 (chrome) / 4TL5 (cat) | — | STOCK | T3 | xbhp post #89 | — |
| Piston code | ART 4Y201 | — | STOCK | T3 | xbhp post #89 | yes |
| Carb code | 4TL 01 (Mikuni/UCAL Mikuni VM22) | — | STOCK | T3 | xbhp post #89 | — |
| Main jet | 165 | — | STOCK | T3 | xbhp post #89 | — |
| Pilot jet | 17.5 | — | STOCK | T3 | xbhp post #89 | — |
| Number of gears | 4 | — | STOCK | T3 | xbhp post #89 | yes |
| Claimed power | 12.0 PS (8.9 kW) @ 6500 (factory) / 12 BHP @ 7500 (bikeinfobd) | PS/BHP | STOCK | T1/T4 | global.yamaha; bikeinfobd | CONFLICT — report both |
| Claimed torque | 12.3 Nm @ 5500 (factory, 1996 RX135) / 10.0 Nm @ 6500 (bikeinfobd) | Nm | STOCK | T1/T4 | global.yamaha; bikeinfobd | CONFLICT — report both |
| Bore | 58.0 | mm | STOCK | T3 | xbhp #89 (computed to 132 cc) | yes (pdfcoffee "58×50") |
| Stroke | 50.0 | mm | STOCK | T3 | xbhp #89 | yes |
| Displacement | 132.16 (132) | cc | STOCK | T1/T3 | global.yamaha (132 cm³) | yes |
| Connecting rod (c-c) | NOT FOUND | mm | — | — | — | — |
| Crank throw | 25.0 (derived = stroke/2) | mm | DERIVED | — | derived | exact |
| Piston compression height | NOT FOUND | mm | — | — | — | — |
| Gudgeon pin Ø | NOT FOUND | mm | — | — | — | — |
| Deck height at TDC | NOT FOUND | mm | — | — | — | — |
| Base gasket thickness | NOT FOUND | mm | — | — | — | — |
| Head gasket/o-ring | "GASKET CYL. HEAD" p/n 4TL-E1181-00-00 | — | STOCK | T1 | safexbikes parts cat | no |
| Head gasket thickness | NOT FOUND | mm | — | — | — | — |
| Claimed CR (manual) | NOT FOUND (no number found) | — | — | — | — | — |
| Geometric CR | 10.1:1 (bikeinfobd, T4; factory T1 not stated) | — | STOCK? | T4 | bikeinfobd | single source |
| Trapped CR | NOT FOUND | — | — | — | — | — |
| Combustion chamber volume | ~22 (T4: "factory head is 22cc") | cc | STOCK? | T4 | Facebook compression discussion | no |
| Squish clearance / band | NOT FOUND | mm | — | — | — | — |
| Chamber/dome shape | NOT FOUND (photo needed) | — | — | — | — | — |
| Exhaust port type | NOT FOUND (assumed single, unverified) | — | — | — | — | — |
| Exhaust port height from cyl top | NOT FOUND for RX135 (RX100 G1 ~28, G3 ~30, G4 ~32 mm by Takumi, T3) | mm | — | T3 | Takumi FB (RX100 gens) | no (different model) |
| Exhaust port opening angle | 95° BTDC (generic RX port-map data; variant unspecified) | ° | UNKNOWN variant | T3/T4 | FB port-map quote | no |
| Exhaust port duration | 190 | crank ° | UNKNOWN variant | T3/T4 | FB port-map quote | no |
| Transfer port duration | 125 | crank ° | UNKNOWN variant | T3/T4 | FB port-map quote | no |
| Inlet type | Piston reed (reed valve) + YEIS, 7-port | — | STOCK | T1 | global.yamaha | yes |
| Carb make/model | Mikuni VM22 (early 4TL1, round venturi); UCAL Mikuni VM22 (later 4TL1L7/4UU) | — | STOCK | T1/T3 | Instagram carb sheet; parts cat | yes |
| Carb venturi | 22 | mm | STOCK | T3 | model designation VM22 | yes |
| Pilot jet (early 4TL1) | VM22 / 17.5 | — | STOCK | T3 | Instagram (kick_start_biker) | no |
| Main jet (early 4TL1) | Hex head / 165 | — | STOCK | T3 | Instagram | no |
| Needle jet (early) | #4J26 | — | STOCK | T3 | Instagram | no |
| Slide cutaway (early) | 2.0 | — | STOCK | T3 | Instagram | no |
| Pilot jet (later 4TL1L7/4UU) | VM20 / 15 | — | STOCK | T3 | Instagram | no |
| Main jet (later) | Hex head / 135 | — | STOCK | T3 | Instagram | no |
| Needle jet (later) | #5ZF6 | — | STOCK | T3 | Instagram | no |
| Carb assy p/n (early) | 4TL1-4101-01-00 (superseded 1L5-6500-00) | — | STOCK | T1 | safexbikes parts cat | no |
| Reed valve p/n | 2YA-E3610-00-00 (REED VALVE ASSY) | — | STOCK | T1 | safexbikes parts cat | no |
| CDI magneto p/n | 4TL-H5500-00-00 | — | STOCK | T1 | safexbikes parts cat | no |
| CDI unit p/n | 2YA-H5540-00-00 (superseded 1M1-3002-00) | — | STOCK | T1 | safexbikes parts cat | no |
| Spark plug | NGK BPR7HS | — | STOCK | T1 | safexbikes parts cat | no |
| Spark plug gap | NOT FOUND | mm | — | — | — | — |
| Static ignition timing | NOT FOUND | °BTDC / mm BTDC | — | — | — | — |
| Advance curve | NOT FOUND | — | — | — | — | — |
| Exhaust pipe assy p/n | 36LE-4611-00-00 | — | STOCK | T1 | safexbikes parts cat | no |
| Muffler p/n | 36LE-4710-10-00 (RX/RXG) | — | STOCK | T1 | safexbikes parts cat | no |
| Exhaust dimensions (header/diffuser/belly/stinger) | NOT FOUND | mm | — | — | — | — |
| Catalyser | Early YEIS: none; later cat-con / mini-cat | — | STOCK | T3 | Wikipedia/xbhp | yes |
| Autolube | Yes (oil pump fitted) | — | STOCK | T1 | safexbikes parts cat | yes |
| Stock premix ratio (pump disabled) | NOT FOUND | — | — | — | — | — |
| Recommended oil | 2T oil (grade NOT FOUND) | — | — | T4 | owner forums | no |
| Fuel octane | NOT FOUND | RON | — | — | — | — |
| Top speed (owner) | ~102–120 | km/h | STOCK | T4 | Team-BHP; bikeinfobd | no |
| Fuel consumption (owner) | 30–40 | kmpl | STOCK | T4 | owner forums | no |
| Primary reduction | 19 T / 74 T (bell) (unverified for 4-speed; from 5-speed) | T | STOCK? | T3 | xbhp post #89 | unverified for 4-speed |
| Gear ratios (4-speed) | 1st 35/11=3.182; 2nd 30/15=2.000; 3rd 26/19=1.368; 4th 23/23=1.000 | — | STOCK | T3 | xbhp post #89 | yes |
| Final drive sprockets | Front 15 teeth; rear p/n 4TL-F5437-00-00 | teeth | STOCK | T1 | safexbikes parts cat | no |
| Tyre size | F 2.75-18, R 2.75-18 (bikeinfobd) / F 2.75-18, R 3.00-18 (RX-King platform) | — | STOCK | T2/T4 | bikeinfobd; Wikipedia RX-King | conflict |
| Piston-to-bore clearance | NOT FOUND | mm | — | — | — | — |
| Ring end gap | NOT FOUND | mm | — | — | — | — |
| Bore wear limit | NOT FOUND | mm | — | — | — | — |
| Torque specs | NOT FOUND | N·m | — | — | — | — |
| Overall L×W×H | 1965 × 740 × 1050 | mm | STOCK | T1/T4 | global.yamaha; bikeinfobd | yes (W) |
| Wheelbase | 1240 | mm | STOCK | T4 | bikeinfobd | — |
| Ground clearance | 145 | mm | STOCK | T4 | bikeinfobd | — |
| Kerb weight | 106 | kg | STOCK | T4 | bikeinfobd/safexbikes | — |
| Fuel tank | 10.5 | L | STOCK | T4 | bikeinfobd | — |
| Oil tank (autolube) | 1.2 | L | STOCK | T4 | bikeinfobd | — |

---

## 3. Evidence appendix (4-speed-relevant)

1. Yamaha global Communication Plaza (1996 RX135): "Engine type: Air-cooled, 2-stroke, single-cylinder, 132cm³" / "Maximum power output: 8.9kW (12.0PS) / 6,500r/min" / "Maximum torque: 12.3N·m (1.25kgf·m) / 5,500r/min" / "7-port piston reed intake valve" / "Torque Induction system" / "YEIS". URL: https://global.yamaha-motor.com/showroom/cp/collection/rx135/
2. xbhp post #89 (karthikdattag, 2018-06-08): "4-Speed - '4TL00' with OEM 'ART' STD piston '4Y201', Rating: 12BHP @ 6500RPM" / "4-Speed: '4TL 01' with Main Jet = 165 & Pilot Jet = 17.5" / "4-Speed: '4TL5' written on inner side (Top) of Head (For OE fitting Catalytic Converter type)" / "'4TL00' ... (Chrome Silencer)" / "Bore Dia = 58mm ... Stroke Length = 50mm" / gear ratios 4-speed. URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6
3. safexbikes parts cat (4TL1): cylinder head 4TL-E1111-10; piston STD 4TL-E1631-00; rings STD 4TL-E1603-00; crank 2YA-XE1400-00; CDI magneto 4TL-H5500-00-00; CDI unit 2YA-H5540-00-00 (superseded 1M1-3002-00); spark plug NGK BPR7HS; reed valve 2YA-E3610-00-00; exhaust pipe 36LE-4611-00-00; muffler 36LE-4710-10-00; carb assy 4TL1-4101-01-00; front sprocket 15 teeth; head gasket 4TL-E1181-00-00. URL: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local copy in folder).
4. Instagram carb spec sheet (kick_start_biker, 2024): RX135(1L3,1L5,4TL): Mikuni VM22, pilot VM22/17.5, main 4/042 hex head/165, needle jet #4J26, cutaway 2.0. RX135(1L7,4UU): UCAL Mikuni VM22, pilot VM20/15, main 4/042 hex head/135, needle jet #5ZF6, cutaway 2.0. URL: https://www.instagram.com/reel/C84rFIhhdA5/
5. Wikipedia RX100 page: model timeline RX 135 (YEIS) 1998–2000; RX 135 4 Speed (Cat-Con) 2001–2003; RX 135 4 Speed (Mini-Cat) 2003–2005. URL: https://en.wikipedia.org/wiki/Yamaha_RX_100
6. Facebook port-map quote (Takumi/RX100 Club Sri Lanka): "Based on the data provided by Yamaha in the port map, the duration of the exhaust is 190 degrees (the exhaust opens 95 degrees before the BDC) and the duration of the transfer is 125 degrees." Variant not stated. URL: https://www.facebook.com/groups/890982621655193/posts/2291144264972348/
7. Takumi RX Engineering FB post: G1 exhaust opening ~28 mm from cylinder top; G3 ~30 mm; G4 ~32 mm (vs ~27 mm on G1). RX100 generations, not RX135. URL: https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/
8. bikeinfobd (2026): "MAXIMUM POWER 12 BHP @ 7500 rpm (4 Speed)" / "MAXIMUM TORQUE 10.0 NM @ 6500 rpm (4 Speed)" / "Compression Ratio 10.1:1" / "Bore & Stroke 58.0 x 55.0 mm" (erroneous — see do-not-use). URL: https://www.bikeinfobd.com/2020/12/Yamaha-RX-135.html

---

## 4. Media inventory (4-speed-relevant)

| Item | URL / local path | Shows | Stock? |
|---|---|---|---|
| Yamaha official RX135 archive page | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | 1996 RX135 specs (12 PS, 12.3 Nm), 132 cc, 7-port reed, YEIS | STOCK |
| safexbikes RX135 parts cat (4TL1) PDF | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local: rx135_parts_catalogue_4TL1.pdf) | Exploded diagrams + part numbers, 4-speed early | STOCK |
| Scribd RX135 parts cat (4TL1) | https://www.scribd.com/document/202485946/Yamaha-Rx135-Rx-135-Illustrated-Parts-List-Diagram-Manual | 50 pp parts list | STOCK |
| Takumi RX Engineering FB posts | https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/ | Measured RX100-gen cylinder port heights/timings | T3 (RX100 gens, not RX135) |
| Instagram carb spec sheet | https://www.instagram.com/reel/C84rFIhhdA5/ | Carb jetting by variant | T3 |
| xbhp 4 vs 5 speed thread | https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed | Owner comparisons, model years | T3/T4 |
| safexbikes parts cat (4TL1) | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf | Parts, diagrams | STOCK |

---

## 5. 4-speed vs 5-speed delta (sourced) — see sibling folder `Yamaha_RX135_India/` for the full 5-speed dataset

1. Power: 4-speed factory 12 PS @ 6500; 5-speed owner-claimed ~14 bhp with higher revs (8500 rpm). Source: Yamaha official (4s) + xbhp/Facebook (5s).
2. Compression ratio: 5-speed has higher CR than 4-speed (qualitative). Source: Wikipedia RX100 page (T1).
3. Port dimensions: 5-speed has "significant differences in ports sizes" vs 4-speed; 4-speed was detuned for fuel economy after 5-speed. Source: xbhp (T3).
4. Carburettor: 4-speed round venturi VM22; 5-speed oval venturi VM22. Source: xbhp (T3).
5. Exhaust: 5-speed has large catalytic-converter silencer; 4-speed later has cat-con/mini-cat. Source: Wikipedia (T1).
6. Gearing: 5-speed has 5 ratios; 4-speed has 4. Top-gear ratio reportedly similar (owner, unverified). Source: xbhp (T4).
7. Model years: 4-speed 1998–2005 (with revisions); 5-speed 2000–2003 only. Source: Wikipedia (T1).

No measured port-height or CR numbers for the 4-speed were found.

---

## 6. Gap list (ranked by simulation impact) — 4-speed

| Rank | Missing parameter | Impact | Cheapest physical measurement |
|---|---|---|---|
| 1 | Port timing (°BTDC/ATDC, durations, heights) for stock 4-speed | Highest | Digitise a port-map trace; measure port top-edge heights with a depth gauge on a stock barrel |
| 2 | Exhaust port type (single/dual/bridged) + auxiliary port geometry | High | Visual inspection + port map trace |
| 3 | Combustion chamber volume (cc) and squish clearance/band | High | Burette volume + feeler gauge squish on stock head/piston at TDC |
| 4 | Connecting rod length | Medium | Direct measurement of a stock rod |
| 5 | Ignition static timing (°BTDC and mm BTDC) + advance curve | Medium | Strobe timing light; degree wheel + dial gauge |
| 6 | CDI part number + pickup/rotor details (later sub-variants) | Medium | Read part number off stock CDI unit |
| 7 | Carb needle/clip/slide cutaway/float height/air-screw (4-speed) | Medium | Disassemble stock carb, read stamped numbers |
| 8 | Exhaust stock pipe dimensions | Medium-High | Measure a stock silencer with tape/calipers |
| 9 | Piston compression height, gudgeon pin Ø, deck height, base/head gasket thickness | Medium | Measure stock piston and gaskets |
| 10 | Service wear limits (clearances, ring end gap, torque specs) | Low-Medium | Factory manual (not yet accessed) |
| 11 | Trapped CR | Medium | Compute from port timing once available |
| 12 | Full power/torque curve (not just 2 points) | Medium (validation) | Dyno a stock 4-speed |

---

## 7. Do-not-use list (4-speed-relevant)

| Value found online | Why reject | Better source |
|---|---|---|
| bikeinfobd "Bore & Stroke 58.0 × 55.0 mm" | Inconsistent with 132 cc displacement (58×55 ≈ 145 cc); contradicts xbhp/pdfcoffee "58×50" | xbhp #89 + pdfcoffee manual "58x50" |
| bikeinfobd 4-speed "12 BHP @ 7500 rpm" | Factory (global Yamaha) states 12.0 PS @ 6500 rpm; xbhp #89 states 12 BHP @ 6500 | global.yamaha-motor.com (T1) |
| Factory global page torque 12.3 Nm @ 5500 for "1996 RX135" | Likely 4-speed/early unit; do not apply to 5-speed | global.yamaha (T1) for 4-speed early |
| "VM26 carb stock on Indian RX135" | Indian stock is VM22 (4TL 01 / 4TL4 20); VM24/VM26 are SEA/South America and aftermarket | xbhp #89 |
| "NGK iridium" as stock plug | Parts catalogue specifies NGK BPR7HS (copper); iridium is aftermarket | parts catalogue (T1/T3) |
| RX-King 135 (Indonesia) power 17.5–18.5 PS | Indonesian market, different engine lineage. Do NOT apply to Indian RX135 | Wikipedia RX-King (T1, out of scope) |
| "190° exhaust / 125° transfer" as 4-speed-specific | Generic Yamaha port-map quote; variant not stated. Do not enter without variant confirmation | Facebook (T3/T4) |
| RX100 port heights (28/30/32 mm from cylinder top) applied to RX135 | Measured on RX100 G1/G3/G4 cylinders; RX135 has a different (132 cc) cylinder. Do not transfer | Facebook (T3) |
| Chamber volume "22 cc" | Single unsourced Facebook mention; treat as unverified | Facebook (T4) |
| Top-gear ratio "same between 4s and 5s" | Owner speculation on xbhp | xbhp (T4) |
| Tyre size for 4-speed (R 2.75 vs 3.00) | Conflicting sources; not resolved | bikeinfobd vs RX-King platform |

---

## 8. Query log

1. "Yamaha RX135 Indian service manual PDF 132cc"
2. "Yamaha RX135 India parts catalogue cylinder head piston part number"
3. "Yamaha RX135 4 speed vs 5 speed India engine differences"
4. "Yamaha RX135 India engine code frame prefix VIN"
5. "Yamaha RX135 India model years 4-speed 5-speed launched discontinued"
6. "archive.org Yamaha RX 135 service manual workshop"
7. "manualslib.com Yamaha RX135 service manual"
8. Fetched safexbikes parts catalogue PDF: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf
9. Fetched Yamaha official RX135 archive page: https://global.yamaha-motor.com/showroom/cp/collection/rx135/
10. Fetched Wikipedia RX100 page
11. Fetched Wikipedia RX-King page
12. "Yamaha RX135 port timing exhaust opens degrees BTDC stock India"
13. "RX135 5 speed port map cylinder port heights mm"
14. "RX135 Indian port timing differences transfer exhaust degrees port map"
15. "exhaust opens 95 degrees before the BDC RX135 port timing"
16. "duration of the exhaust is 190 degrees Yamaha RX 135"
17. "RX135 port map exhaust port height from top cylinder"
18. Fetched Takumi RX Engineering Facebook post (RX100 cylinder generations)
19. Fetched Facebook "port timing vs port size in Yamaha RX engines" (quote 190°/125°)
20. Fetched team-bhp "advance porting exhaust port degree" thread
21. "Yamaha RX135 compression ratio trapped geometric cc chamber volume"
22. "RX135 Indian carburetor Mikuni model jetting main pilot needle"
23. Fetched Instagram carb spec sheet (kick_start_biker)
24. Fetched xbhp spare-parts thread (VM22 round vs oval)
25. "RX135 5-speed CDI part number ignition timing degrees BTDC"
26. "Yamaha RX135 India ignition timing specification degrees BTDC"
27. "Yamaha RX135 service manual ignition timing"
28. "RX135 stock pipe dimensions header diffuser belly stinger" (no results; via parts cat)
29. "Yamaha RX135 5-speed power 14 bhp 7000 rpm official"
30. Fetched xbhp "RX 135 4 speed or 5 speed" thread
31. Fetched Wikipedia RX100 (timeline, 5-speed CR/ports)
32. "RX135 Indian service manual gear ratios primary reduction" (no results)
33. Fetched Scribd 5-speed manual page (images only)
34. Fetched Scribd Arunava port maps page
35. Fetched Scribd 4TL6 parts catalogue page
36. Fetched Scribd bare-kit 4 vs 5 speed comparison page
37. "RX135 Indian parts catalogue 4TL6 5-speed"
38. "Yamaha RX135 engine number series Indian models"
39. "RX135 4-speed cat-con mini-cat differences"
40. "Yamaha RX135 service manual ignition timing mm BTDC"
41. "RX135 5 speed India port timing compression ratio" (via pdfcoffee search)
42. "RX135 5speed connecting rod 98 mm" (via search results)
43. "RX135 4TL1 cylinder head part number" (Bing)
44. "RX135 5 speed CDI part number ignition timing degrees BTDC" (Bing)
45. "RX135 5 speed compression ratio 10.1 1" (Bing)
46. "RX135 ignition timing BTDC mm" (DDG)
47. "RX135 CDI part number 4TL OR 1L7" (DDG)
48. "RX135 CDI 85540 part number" (Bing)
49. "RX135 spark plug BPR7HS OR BPR8HS gap" (implicit in parts cat)
50. "RX135 5 speed catalytic converter exhaust hot tube 13-15 kg" (via Team-BHP)
51. "RX135 exhaust port height 2cm i2 series" (via xbhp post #90)
52. "RX135 carburetor Mikuni VM22 4TL4 20 main jet 135" (via xbhp post #89)
53. "RX135 4 speed vs 5 speed differences xbhp" (fetched thread)
54. "RX135 5 speed Team-BHP owner restoration" (fetched thread)
55. "RX135 port timing facebook Takumi workshop" (fetched page title only)
56. "RX135 global Yamaha Communication Plaza 1996" (fetched)
57. "RX135 5 speed bikeinfobd specifications" (fetched)
58. "RX135 safexbikes parts catalogue 4TL1" (fetched)
59. "RX135 pdfcoffee 5-speed manual" (fetched landing page)
60. "RX135 pdfcoffee parts catalogue citation preview" (fetched)
61. "RX135 pdfcoffee RX G service manual" (fetched citation preview)
62. "RX135 scribd parts catalogue" (fetched)
63. "RX135 scribd bare-kit comparison" (fetched)
64. "RX135 Team-BHP advance porting exhaust degree" (fetched)
65. "RX135 5 speed port map images" (user-supplied, 2 PNGs)
66. Transliterated Hindi/Malayalam/Tamil/Telugu: not required — English sources sufficient.

---

## 9. Notes for the MATLAB model (4-speed)

- Use bore 58 mm, stroke 50 mm, CR 10.1:1 (T4, unverified) as baseline. Rod length NOT FOUND — measure before finalising.
- Port timing is the dominant unknown: no published stock degree map for the 4-speed. Digitise a port-map trace.
- Stock exhaust: early YEIS has no catalyser; later sub-revisions have cat-con/mini-cat. Model the correct sub-revision.
- Power validation target: 12 PS @ 6500 (factory) or 12 BHP @ 7500 (bikeinfobd) — report both; do not silently pick.
- Ignition: static timing NOT FOUND; model pending measurement.
- Carb jetting baseline: early 4TL1 round-venturi VM22 (main 165, pilot 17.5, needle #4J26, cutaway 2.0); later 4TL1L7/4UU UCAL VM22 (main 135, pilot 15, needle #5ZF6).
- Autolube stock.

---

*End of 4-speed dataset. All values tagged; NOT FOUND entries are intentional. The 5-speed variant is a separate dataset in `Yamaha_RX135_India/` and must not be mixed with this one.*
---

## 12. Workshop / service / owner manuals & parts catalogues found online

Note: most of these are scanned-image PDFs on Scribd (not text-extractable). They are the best available sources for torque specs, clearances, and port geometry; download and OCR/measure by hand.

| # | Title | URL | Pages | Type | Text-extractable? |
|---|---|---|---|---|---|
| 1 | RX 135 5speed Manual (user manual) | https://www.scribd.com/document/25643028/rx-135-5speed-manual | 19 | User manual | No (scanned images) |
| 2 | RX 135 5 SPEED Specs Manual | https://www.scribd.com/document/608461041/RX-135-5-SPEED-Specs-Manual | 17 | Specs manual | No (scanned images) |
| 3 | Yamaha RX 135 Engine Manual PDF Guide | https://www.scribd.com/document/466606861/contest-usatodayhss-com-Yamaha-Rx-135-Engine-Manual | 5 | Engine manual | No (scanned images) |
| 4 | Yamaha RX 135 User Manual PDF | https://www.scribd.com/document/457170958/yamaha-rx-135-user-manual-pdf | 2 | User manual | No |
| 5 | Yamaha RX 100 Workshop Manual (family reference) | https://www.scribd.com/doc/42685035/Yamaha-RX-100-Workshop-Manual | 92 | Workshop manual | Partial (RX100, not RX135) |
| 6 | RX135 4TL1 Parts Catalogue (safexbikes mirror) | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local copy in folder) | 51 | Parts catalogue | Yes (extracted) |
| 7 | RX135 4TL1 Parts Catalogue (scribd) | https://www.scribd.com/document/241900520/RX135-4TL1 | 51 | Parts catalogue | No (scanned) |
| 8 | RX135 4TL4 Parts Catalogue (scribd) | https://www.scribd.com/document/241900661/RX135-4TL4 | 52 | Parts catalogue | No (scanned) |
| 9 | RX135 4TL6 Parts Catalogue (scribd) | https://www.scribd.com/document/241900764/RX135-4TL6 | 52 | Parts catalogue (5-speed) | No (scanned) |
| 10 | RX 135 Parts Catalogue (4TL6) (scribd) | https://www.scribd.com/document/661417869/4TL6-PC | 52 | Parts catalogue (5-speed) | No (scanned) |
| 11 | RX135 4TL5 Compress (scribd) | https://www.scribd.com/document/1048205403/Rx135-4tl5-Compress | 52 | Parts catalogue (cat-con head) | No (scanned) |
| 12 | Yamaha RX 135 Parts Catalogue (scribd, 50 pp) | https://www.scribd.com/document/202485946/Yamaha-Rx135-Rx-135-Illustrated-Parts-List-Diagram-Manual | 50 | Parts catalogue | No (scanned) |
| 13 | 4TL1 Final 14 Apr 09 RX 135 PDF (scribd) | https://www.scribd.com/document/347293646/4TL1-Final-14-apr-09-rx-135-pdf | 51 | Parts catalogue (final revision) | No (scanned) |
| 14 | RX135 4TL6 (scribd) | https://www.scribd.com/document/756031506/4TL6 | 52 | Parts catalogue (5-speed) | No (scanned) |
| 15 | RX 135 Parts Catalogue (scribd, 50 pp, alt) | https://www.scribd.com/document/423122932/manual-rxz135 | 50 | Parts catalogue | No (scanned) |
| 16 | RX 135 Parts Catalogue (4TL6) (alt) | https://www.scribd.com/document/202485946/Yamaha-Rx135-Rx-135-Illustrated-Parts-List-Diagram-Manual | 50 | Parts catalogue | No (scanned) |
| 17 | Similarity & Difference in Yamaha Rx 100 & Rx135 Indian (scribd) | https://www.scribd.com/document/255211514/Similarity-Difference-in-Yamaha-Rx-100-Rx135-Indian | 3 | Comparison note (text) | Yes (extracted) |
| 18 | RX135 4-Speed vs 5-Speed Comparison (scribd) | https://www.scribd.com/document/246200975/Bare-kit | 5 | Comparison (mixed stock/modified) | No (scanned) |
| 19 | RX-RXZ 135 5-Speed Port Maps (Arunava Pramanick) (scribd) | https://www.scribd.com/document/508987019/Yamaha-RX-RXZ-135-5-Speed-Port-Maps-Arunava-Pramanick | 1 | Port map (no dimensions) | No (image) |
| 20 | RX-RXZ 135 5-Speed Port Maps (alt) (scribd) | https://www.scribd.com/document/508985012/Yamaha-RX-RXZ-135-5-Speed-Port-Maps | 1 | Port map | No (image) |
| 21 | Yamaha RXZ135 2001 SP (scribd) | https://www.scribd.com/document/360381225/Yamaha-RXZ135-2001-SP-pdf | 25 | RX-Z manual (related family) | No (scanned) |
| 22 | Yamaha RX 100 Workshop Manual (scribd) | https://www.scribd.com/doc/42685035/Yamaha-RX-100-Workshop-Manual | 92 | Workshop manual (RX100) | Partial |
| 23 | Yamaha global Communication Plaza RX135 (1996) | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | 1 | Official spec page | Yes (web page) |

Recommendation: download the 5-speed specs manual (#2) and the 4TL1 final parts catalogue (#13) first; they are the most likely to contain torque specs, clearances, and port dimensions. The safexbikes 4TL1 PDF (local copy) is the only text-extractable parts catalogue already in the folder.

---

## 13. Connecting rod length search result

Searched all located workshop/service/owner manuals and parts catalogues (Scribd, pdfcoffee, safexbikes, etc.) for "connecting rod", "con rod", "rod length", "98 mm". **Result: NOT FOUND in any text-extractable source.** Every located RX135 manual/parts catalogue is a scanned-image PDF (Scribd image pages) with no OCR'd text stating the connecting rod centre-to-centre length.

- **4-speed:** Connecting rod length remains NOT FOUND. Must be measured from a stock rod.
- **5-speed:** Only available value is 98 mm (T3/T4, community consensus from multiple xbhp/Facebook posts). Not confirmed by any manual. Treat as unverified until physically measured; do not enter into the MATLAB model as factory data.

To close this gap: download the 5-speed specs manual (https://www.scribd.com/document/608461041/RX-135-5-SPEED-Specs-Manual) and the RX 135 5speed manual (https://www.scribd.com/document/25643028/rx-135-5speed-manual), then visually inspect the scanned pages / measure a stock connecting rod with calipers.

---

## 14. Reed valve (stock) — search result

Stock reed valve assembly part number: **2YA-E3610-00-00** (REED VALVE ASSY) — from the safexbikes RX135 (4TL1) parts catalogue (T1). Same reed valve assembly is listed for RX135 4-speed and 5-speed (xbhp post #89: "The CrankShaft Assembly is the same for RX135, RX-G, RX135 5-Speed & RX-Z"; reed valve assembly part number shared across 4TL variants).

Stock reed valve details (petal count, material, dimensions, opening pressure): **NOT FOUND** in any text-extractable manual or parts catalogue. The parts catalogue only lists the assembly part number, not dimensions.

Stock reed valve (per user): "HTA 5014" is reported by the user as the stock RX135 reed valve (not an aftermarket Shogun upgrade). Dimensions/petal count/material/opening pressure for HTA 5014: NOT FOUND in any text-extractable online source (parts catalogues list only the assembly part number 2YA-E3610-00-00). Treat HTA 5014 as stock (user-provided, T4) until verified against a parts catalogue or physical part. Source: user note (T4); no online source located.

To close this gap: disassemble a stock reed valve assembly and measure petal count, thickness, material, and reed stop height; or consult the scanned 5-speed specs manual pages.

---

## 15. Simulation assets (MATLAB)

Folder: `matlab/` next to this file.

- `params_rx135_4s.m` (or `_4s.m`) - single source of truth for verified stock parameters (NOT-FOUND = NaN).
- `engine_model_4s.m` (or `_4s.m`) - simplified 0D analytic surrogate for sensitivity screening (NOT a full thermodynamic model).
- `sensitivity_study_4s.m` (or `_4s.m`) - one-at-a-time (OAT) sweep + tornado plot of % power change. Outputs CSV + MAT in the same folder.

Toolboxes used: Simscape + Simscape Fluids (target full model), Simulink, Model-Based Calibration Toolbox, Curve Fitting, Signal Processing, Statistics & ML, Symbolic Math, MATLAB Coder.

Key NOT-FOUND inputs that dominate model uncertainty: compression ratio (4s), squish volume, connecting rod length, port heights/timing (derive from port-map PNGs), ignition timing.
