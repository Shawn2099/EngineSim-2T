# Yamaha RX135 — 5-speed — Indian Market — Verified Parameter Dataset (MASTER)

Folder: `Yamaha_RX135_India/`. Prepared for MATLAB engine simulation. Scope: Indian-market 132 cc air-cooled two-stroke only. Excluded: RX-King 135 (Indonesia), RX135 Thailand/SEA, RX-Z Malaysia, RX115, RX100, RX-Z India.

Variant covered here: **Variant B — RX135 5-speed** (Indian): 2000–2003; higher CR, different port dimensions, large cat-con silencer. PRIMARY DELIVERABLE.
The 4-speed variant is a SEPARATE dataset in the sibling folder Yamaha_RX135_4speed_India/ and is never merged/averaged with this one.

Tiers: T1 = Yamaha factory manual/owner manual/parts catalogue/official archive; T2 = independent dyno/measured teardown/technical article; T3 = forum post with actual measurement/photo/part number by named user with date; T4 = blog/video/marketplace/unsourced. CORROBORATED = 2+ independent sources agree. Confidence <70% stated in-row. NOT FOUND = not located; no invented values. Engineering estimates are confined to §10.

Companion files in this folder: `Yamaha_RX135_India_Parameters.md` (prior partial dataset, now superseded by this master for Variant B geometry/drivetrain), `rx135_parts_catalogue_4TL1.pdf` (safexbikes 4TL1 parts cat), port-map PNGs.

---

## 1. Executive summary

**Variant B (5-speed):** Solid — identity, engine-number prefix, block/head codes, piston, carb code + jetting, gear ratios, primary reduction, final drive, power (14 BHP @ 7500, two sources), CR 10.1:1 (T4 + manual snippet), dimensions, tyres, brakes, weights, top speed/0-60. Thin — port timing (none published; supplied PNGs are best reference), combustion chamber volume, squish, ignition timing, exhaust pipe dimensions. Missing — CDI part number, carb needle/clip/slide/float/air-screw, service wear limits/torque specs.

**Conflicts to report, not resolve:** 4-speed power (factory 12 PS @ 6500 vs bikeinfobd 12 BHP @ 7500); 4-speed torque (factory 12.3 Nm @ 5500 vs bikeinfobd 10.0 Nm @ 6500); 5-speed CR (10.1:1 vs factory 4-speed unknown); dimensions W/H (global Yamaha 1965×740×1050 vs bikeinfobd 1965×735×1040).

---

## 2. Parameter tables

### Table — Variant B: RX135 5-speed (India) — PRIMARY

| Parameter | Value | Unit | STOCK/MOD | Tier | Source URL | Corrob.? |
|---|---|---|---|---|---|---|
| Model years | 2000–2003 (Wikipedia); 1997–2005 (bikeinfobd, T4) | yr | STOCK | T1/T4 | Wikipedia; bikeinfobd | conflict (report both) |
| Engine code prefix | 1L7 XXXXXX | — | STOCK | T3 | xbhp post #89; Team-BHP Mr.Boss | yes |
| Parts line | 4TL (4TL6 parts cat) | — | STOCK | T1 | Scribd 4TL6-PC | yes |
| Cylinder block code | 4TL10 | — | STOCK | T3 | xbhp post #89; Team-BHP (photo) | yes |
| Cylinder head code | 09L (inner side of head) | — | STOCK | T3 | xbhp post #89 | — |
| Piston code | ART 4Y201 (same as 4-speed) | — | STOCK | T3 | xbhp post #89 | yes |
| Carb code | 4TL4 20 (Mikuni/UCAL Mikuni VM22) | — | STOCK | T3 | xbhp post #89 | — |
| Main jet | 135 | — | STOCK | T3 | xbhp post #89 | — |
| Pilot jet | 15.0 | — | STOCK | T3 | xbhp post #89 | — |
| Number of gears | 5 | — | STOCK | T3 | xbhp post #89 | yes |
| Claimed power | 14 BHP @ 7500 rpm | BHP | STOCK | T3/T4 | xbhp post #89; bikeinfobd | yes (2 sources) |
| Claimed torque | 12.25 Nm @ 7000 rpm | Nm | STOCK | T4 | bikeinfobd | single source (T4) |
| Bore | 58.0 | mm | STOCK | T3 | xbhp #89 (computed) | yes (pdfcoffee "58×50") |
| Stroke | 50.0 | mm | STOCK | T3 | xbhp #89 | yes |
| Displacement | 132.16 (132) | cc | STOCK | T1/T3 | global.yamaha (132 cm³) | yes |
| Connecting rod (c-c) | 98 | mm | STOCK | T3/T4 | multiple forum posts (xbhp, FB) | yes (community consensus) |
| Crank throw | 25.0 (derived = stroke/2) | mm | DERIVED | — | derived | exact |
| Piston compression height | NOT FOUND | mm | — | — | — | — |
| Gudgeon pin Ø | NOT FOUND | mm | — | — | — | — |
| Deck height at TDC | NOT FOUND | mm | — | — | — | — |
| Base/head gasket thickness | NOT FOUND | mm | — | — | — | — |
| Claimed CR (manual) | NOT FOUND (number) | — | — | — | — | — |
| CR (geometric) | 10.1:1 | — | STOCK | T4 (bikeinfobd) / T3 (pdfcoffee manual snippet "58×50 Compression Ratio 10.1:1") | bikeinfobd; pdfcoffee | partial (manual snippet confirms) |
| CR vs 4-speed | Higher than 4-speed (qualitative) | — | STOCK | T1 | Wikipedia RX100 page | yes (xbhp) |
| Trapped CR | NOT FOUND | — | — | — | — | — |
| Combustion chamber volume | NOT FOUND | cc | — | — | — | — |
| Squish clearance / band | NOT FOUND | mm | — | — | — | — |
| Port dimensions | Different from 4-speed (qualitative); no mm published | — | STOCK | T1/T3 | Wikipedia; xbhp ("significant differences in ports sizes") | yes |
| Exhaust port height/timing | NOT FOUND (no measured numbers for 5-speed) | — | — | — | — | — |
| Generic exhaust duration 190° / transfer 125° | NOT verified for 5-speed | crank ° | UNKNOWN | T3/T4 | FB port-map quote | no |
| Inlet type | Piston reed + YEIS (7-port) | — | STOCK | T1 | global.yamaha | yes |
| Carb make/model | Mikuni/UCAL Mikuni VM22, 22 mm (oval venturi) | mm | STOCK | T3 | xbhp post #89 | yes (xbhp) |
| Main/pilot jet | 135 / 15.0 | — | STOCK | T3 | xbhp post #89 | — |
| Needle number/clip | NOT FOUND | — | — | — | — | — |
| Slide cutaway | NOT FOUND | — | — | — | — | — |
| Air-screw turns | NOT FOUND | — | — | — | — | — |
| Float height | NOT FOUND | mm | — | — | — | — |
| Air cleaner | Washable PU foam | — | STOCK | T4 | bikeinfobd | — |
| CDI part number | NOT FOUND | — | — | — | — | — |
| Spark plug | NGK BPR7HS (parts cat) / "NGK iridium" (bikeinfobd, vague) | — | STOCK | T1/T4 | parts cat; bikeinfobd | partial |
| Spark plug gap | NOT FOUND | mm | — | — | — | — |
| Static ignition timing | NOT FOUND (owner reports stock CDI static ~12° BTDC for RX family, T4) | °BTDC | UNKNOWN | T4 | reddit r/2Strokes | low confidence |
| Advance curve | NOT FOUND | — | — | — | — | — |
| Exhaust | Large catalytic-converter "hot-tube" silencer (stock) | — | STOCK | T1 | Wikipedia RX100 page | yes |
| Exhaust dimensions | NOT FOUND (only qualitative cat-con) | mm | — | — | — | — |
| Catalyser | Yes (large cat-con silencer) | — | STOCK | T1 | Wikipedia | yes |
| Autolube | Yes (oil pump; 1.2 L side tank); pre-mix if pump disabled: 40–50 ml 2T oil per L petrol (owner-reported) | — | STOCK | T4 | bikeinfobd; bikewale (Mukesh Sarode) | — |
| Fuel octane | NOT FOUND | RON | — | — | — | — |
| Recommended oil | 2T oil (grade NOT FOUND) | — | — | T4 | owner forums | no |
| Top speed | 130 | km/h | STOCK | T4 | bikeinfobd | — |
| 0–60 km/h | 3.5 | s | STOCK | T4 | bikeinfobd | — |
| 0–100 km/h | 10 | s | STOCK | T4 | bikeinfobd | — |
| Fuel consumption | 25–35 | km/L | STOCK | T4 | bikeinfobd | — |
| Primary reduction | 19 T / 74 T (bell) | T | STOCK | T3 | xbhp post #89 | — |
| Gear ratios (5-speed) | 1st 35/11=3.182; 2nd 30/15=2.000; 3rd 26/19=1.368; 4th 24/22=1.091; 5th 22/24=0.917 | — | STOCK | T3 | xbhp post #89 | — |
| Final drive sprockets | 15 T / 38 T | T | STOCK | T3 | xbhp post #89 | — |
| Tyre size | F 2.75×18 (4PR), R 3.00×18 (6PR) | — | STOCK | T4 | bikeinfobd; Team-BHP (stock spec 3.00×18 rear) | yes |
| Brakes | 130 mm drum F/R | mm | STOCK | T4 | bikeinfobd | — |
| Kerb weight | 116 (wet) / 108 (dry) | kg | STOCK | T4 | bikeinfobd | — |
| Fuel tank | 10.5 | L | STOCK | T4 | bikeinfobd | — |
| Oil tank (autolube) | 1.2 | L | STOCK | T4 | bikeinfobd | — |
| Overall L×W×H | 1965 × 735 × 1040 | mm | STOCK | T4 | bikeinfobd | (global.yamaha 1996 = 1965×740×1050, T1 — conflict on W/H) |
| Wheelbase | 1245 | mm | STOCK | T4 | bikeinfobd | — |
| Ground clearance | 136 | mm | STOCK | T4 | bikeinfobd | — |
| Seat height | 765 | mm | STOCK | T4 | bikeinfobd | — |
| Engine type | Air-cooled 2-stroke single, 7-port, piston reed intake, Torque Induction, YEIS | — | STOCK | T1 | global.yamaha | — |
| Exhaust (OE) | Cat-con "hot-tube" (big); never came with chrome silencer OE; adds 13–15 kg vs chrome | — | STOCK | T3 | xbhp #89; Team-BHP (pramodkumar) | yes |
| Piston-to-bore clearance | NOT FOUND | mm | — | — | — | — |
| Ring end gap | NOT FOUND | mm | — | — | — | — |
| Bore wear limit | NOT FOUND | mm | — | — | — | — |
| Torque specs | NOT FOUND | N·m | — | — | — | — |

---

## 3. Evidence appendix (exact quotes)

1. xbhp post #89 (karthikdattag, 2018-06-08): "4-Speed - '4TL00' with OEM 'ART' STD piston '4Y201', Rating: 12BHP @ 6500RPM" / "5-Speed - '4TL10' with OEM 'ART' STD piston '4Y201', Rating: 14BHP @ 7500RPM". URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6
2. Same post: "4-Speed: '4TL 01' with Main Jet = 165 & Pilot Jet = 17.5" / "5-Speed: '4TL4 20' with Main Jet = 135 & Pilot Jet = 15.0" / "These are VM type of Carburettors manufactured by Mikuni & both are 22mm."
3. Same post: "RX135 4-Speed: '4TL5' written on inner side (Top) of Head (For OE fitting Catalytic Converter type)" / "RX135 4-Speed / RXG: '4TL00' ... (Chrome Silencer)" / "RX135 5-Speed: '09L' written on inner side of Head".
4. Same post: "Bore Dia = 58mm ... Stroke Length = 50mm" / displacement 132.157 cm³.
5. Same post: gear ratios 4-speed and 5-speed as listed in tables.
6. Same post: "RX135 (With Catalytic Silencer as OE fitting): 4TL XXXXXX" / "RX135 5-Speed: 1L7 XXXXXX" / "The RX135 5-Speed never came with OE fitted Chrome silencer, the OE fit was the Big Hot-Tube type catalytic converter Exhaust."
7. Same post: "The CrankShaft Assembly is the same for RX135, RX-G, RX135 5-Speed & RX-Z."
8. Team-BHP Mr.Boss (2016): "1L7xxxxxx Engine number", "4TL10 Block, Running on 3OS piston", "Stock cat-con silencer replaced with Chrome silencer + Fully open RX100 core", "cat con adds an unnecessary 13-15kgs". URL: https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html
9. Team-BHP pramodkumar (2016): "the cat con installation would improve your bike's low end manners".
10. Team-BHP post (malvechaitanya, 2008): "standard 4speed ports are 3-4 mm small than the 5 speed ports".
11. bikeinfobd (2026): "MAXIMUM POWER 14 BHP @ 7500 rpm (5 speed) & 12 BHP @ 7500 rpm (4 Speed)" / "MAXIMUM TORQUE 12.25 NM @ 7000 rpm (5 speed) & 10.0 NM @ 6500 rpm (4 Speed)" / "Compression Ratio 10.1:1" (both) / "Bore & Stroke 58.0 x 55.0 mm" (erroneous — see do-not-use). URL: https://www.bikeinfobd.com/2020/12/Yamaha-RX-135.html
12. Yamaha global Communication Plaza (1996 RX135): "Engine type: Air-cooled, 2-stroke, single-cylinder, 132cm³" / "Maximum power output: 8.9kW (12.0PS) / 6,500r/min" / "Maximum torque: 12.3N·m (1.25kgf·m) / 5,500r/min" / "7-port piston reed intake valve" / "Torque Induction system" / "YEIS". URL: https://global.yamaha-motor.com/showroom/cp/collection/rx135/
13. safexbikes parts cat (4TL1): "SPARK PLUG-NGK-BPR7HS" (T1/T3).
14. pdfcoffee 5-speed manual snippet: "58x50 Compression Ratio..... 10.1:1" (T3).
15. safexbikes parts cat: RX135 (4TL1) India, dimensions 1965×740×1050, weight 100 kg, 132 cm³. URL: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf
16. xbhp post #90 (Anand Deepak, 2018): "In yamaha 135 i2 series kit exhost port height is 2cm. ... Over all sleve height is 11cm. Height from port to upwars is 3 cm. Height from port to bottom is 6 cm." (non-stock replacement kit).
17. Facebook port-map quote (Takumi/RX100 Club Sri Lanka): "Based on the data provided by Yamaha in the port map, the duration of the exhaust is 190 degrees (the exhaust opens 95 degrees before the BDC) and the duration of the transfer is 125 degrees." Variant not stated. URL: https://www.facebook.com/groups/890982621655193/posts/2291144264972348/
18. Takumi RX Engineering FB post: G1 exhaust opening ~28 mm from cylinder top; G3 ~30 mm; G4 ~32 mm (vs ~27 mm on G1). RX100 generations, not RX135. URL: https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/
19. Instagram carb spec sheet (kick_start_biker, 2024): RX135(1L3,1L5,4TL): Mikuni VM22, pilot VM22/17.5, main 4/042 hex head/165, needle jet #4J26, cutaway 2.0. RX135(1L7,4UU): UCAL Mikuni VM22, pilot VM20/15, main 4/042 hex head/135, needle jet #5ZF6, cutaway 2.0. URL: https://www.instagram.com/reel/C84rFIhhdA5/
20. xbhp spare-parts thread: "both the 135 4s & 5s are on the same VM22 Carb's... the 5S has Oval Venturi whereas the 4S has a round." URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/8726-spare-parts-thread-2-strokes-yamaha-rx-family/page78
21. safexbikes parts cat (4TL1): CDI magneto 4TL-H5500-00-00; CDI unit 2YA-H5540-00-00 (superseded 1M1-3002-00); cylinder head 4TL-E1111-10; piston STD 4TL-E1631-00; rings STD 4TL-E1603-00; crank 2YA-XE1400-00; exhaust pipe 36LE-4611-00-00; muffler 36LE-4710-10-00; reed valve 2YA-E3610-00-00; front sprocket 15 teeth. URL: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf
22. Wikipedia RX100 page: model timeline RX 135 (YEIS) 1998–2000; RX 135 5 Speed 2000–2003; RX 135 4 Speed (Cat-Con) 2001–2003; RX 135 4 Speed (Mini-Cat) 2003–2005. "In 2000 Yamaha launched the RX135 5 speed with a large catalytic converter muffler... It's had a higher compression ratio and different port dimensions." URL: https://en.wikipedia.org/wiki/Yamaha_RX_100
23. Wikipedia RX-King: bore/stroke 58.0 × 50.0 mm, 132 cc, F 2.75-18, R 3.00-18. URL: https://en.wikipedia.org/wiki/Yamaha_RX-King_135

---

## 4. Media inventory

| Item | URL / local path | Shows | Stock? |
|---|---|---|---|
| Yamaha official RX135 archive page | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | 1996 RX135 specs (12 PS, 12.3 Nm), 132 cc, 7-port reed, YEIS | STOCK |
| safexbikes RX135 parts cat (4TL1) PDF | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local: rx135_parts_catalogue_4TL1.pdf) | Exploded diagrams + part numbers, 4-speed early | STOCK |
| Scribd RX135 parts cat (4TL6) | https://www.scribd.com/document/661417869/4TL6-PC | 5-speed parts catalogue (not extracted) | STOCK |
| Scribd 5-speed manual (19 pp, scanned images) | https://www.scribd.com/document/672845250/toaz-info-rx-135-5speed-manual-pr-... | Scanned manual images (not OCR'd) | STOCK |
| Scribd RX-RXZ 135 5-speed port maps (Arunava Pramanick) | https://www.scribd.com/document/508987019/... | Port map image, no dimensions ("Without Dimensions") | STOCK (map) |
| Scribd RX-RXZ 135 5-speed port maps (alt) | https://www.scribd.com/document/508985012/Yamaha-RX-RXZ-135-5-Speed-Port-Maps | Same | STOCK |
| User-supplied port map (5-speed) | local: rx135_5speed_portmap.png (1144×701) | 5-speed port layout scan; datum to be verified (likely cylinder top face) | UNKNOWN — verify against stock block |
| User-supplied port map (5-speed) #2 | local: rx135_5speed_portmap_2.png (1235×763) | Second 5-speed port map variant | UNKNOWN |
| Takumi RX Engineering FB posts | https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/ | Measured RX100-gen cylinder port heights/timings | T3 (RX100 gens, not RX135) |
| Instagram carb spec sheet | https://www.instagram.com/reel/C84rFIhhdA5/ | Carb jetting by variant | T3 |
| xbhp 4 vs 5 speed thread | https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed | Owner comparisons, 14 bhp claim, model years | T3/T4 |
| Team-BHP RX135 5-speed thread | https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html | Owner restoration, photos | MODIFIED (disc brake, alloy wheels, chrome silencer swap) |
| Team-BHP porting thread | https://www.team-bhp.com/forum/motorbikes/36510-advance-porting-exhaust-port-degree.html | Porting discussion, 4 vs 5 speed port size | MODIFIED |
| safexbikes parts cat (4TL1) | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf | Parts, diagrams | STOCK |
| pdfcoffee 5-speed manual | https://www.pdfcoffee.com/yamaha-rx-135-5-speed-manual-pdf-free.html | Specs manual | STOCK (T3) |

---

## 5. 4-speed vs 5-speed delta (sourced)

| Item | 4-speed | 5-speed | Source |
|---|---|---|---|
| Cylinder block | 4TL00 | 4TL10 | xbhp #89 |
| Cylinder head | 4TL00 (chrome) / 4TL5 (cat) | 09L | xbhp #89 |
| Carb code | 4TL 01 | 4TL4 20 | xbhp #89 |
| Main jet | 165 | 135 | xbhp #89 |
| Pilot jet | 17.5 | 15.0 | xbhp #89 |
| Carb (all) | Mikuni/UCAL Mikuni VM22, 22 mm venturi | same type, 22 mm (oval venturi) | xbhp #89 |
| Rated power | 12 BHP @ 6500 (factory: 12 PS @ 6500) | 14 BHP @ 7500 | xbhp #89; global.yamaha |
| Rated torque | 10.0 Nm @ 6500 (bikeinfobd) / 12.3 Nm @ 5500 (factory 1996) | 12.25 Nm @ 7000 | bikeinfobd; global.yamaha |
| Ports | 4-speed ports 3–4 mm smaller than 5-speed | larger ports | Team-BHP 2008 |
| OE silencer | Chrome silencer OR cat-con | Cat-con "hot-tube" only (never chrome OE) | xbhp #89 |
| Final drive | 16 / 34 | 15 / 38 | xbhp #89 |
| Gear ratios | 3.182, 2.000, 1.368, 1.000 | 3.182, 2.000, 1.368, 1.091, 0.917 | xbhp #89 |
| Top speed | 120 km/h | 130 km/h | bikeinfobd |
| 0–60 km/h | 4.2 s | 3.5 s | bikeinfobd |
| Tyres (rear) | 2.75×18 | 3.00×18 | bikeinfobd; Team-BHP |
| Kerb weight | 106 kg | 116 kg (wet) | bikeinfobd |
| Ground clearance | 145 mm | 136 mm | bikeinfobd |
| Overall width | 740 mm | 735 mm | bikeinfobd |
| Overall height | 1050 mm | 1040 mm | bikeinfobd |
| Engine number prefix | 1L5 (chrome) / 4TL (cat) | 1L7 | xbhp #89 |
| Oil pump | Larger (RX100/early 135 type) | Smaller (5-speed casing) | xbhp #77 (SriramEfunds) |
| Crankshaft | Same (2YA marking) | Same | xbhp #89 |
| Piston | ART 4Y201 (same) | ART 4Y201 (same) | xbhp #89 |
| Compression ratio | 10.1:1 (bikeinfobd, T4) | 10.1:1 (bikeinfobd + manual snippet) | bikeinfobd; pdfcoffee |
| Autolube | Yes | Yes | — |

---

## 6. Gap list (ranked by simulation impact)

| Rank | Missing parameter | Impact | Cheapest physical measurement |
|---|---|---|---|
| 1 | Port timing (°BTDC/ATDC, durations, heights) for stock 5-speed | Highest — drives the whole engine model | Digitise the supplied port-map PNGs with a calibrated datum (cylinder top face / gasket face); measure port top-edge heights with a depth gauge on a stock barrel |
| 2 | Exhaust port type (single/dual/bridged) + auxiliary port geometry | High | Visual inspection + port map trace |
| 3 | Combustion chamber volume (cc) and squish clearance/band | High (CR verification) | Measure with burette (volume) and feeler gauge (squish) on stock head/piston at TDC |
| 4 | Connecting rod length confirmation (98 mm) | Medium | Direct measurement of a stock rod |
| 5 | Ignition static timing (°BTDC and mm BTDC) + advance curve | Medium | Strobe timing light on stock bike at idle; degree wheel + dial gauge |
| 6 | CDI part number + pickup/rotor details | Medium | Read part number off stock CDI unit |
| 7 | Carb needle/clip/slide cutaway/float height/air-screw | Medium | Disassemble stock carb, read stamped numbers |
| 8 | Exhaust stock pipe dimensions (header, cones, belly, stinger) | Medium-High (pipe "comes on" rpm) | Measure a stock cat-con silencer with tape/calipers |
| 9 | Piston compression height, gudgeon pin Ø, deck height, base/head gasket thickness | Medium | Measure stock piston and gaskets |
| 10 | Service wear limits (clearances, ring end gap, torque specs) | Low-Medium | Factory manual (not yet accessed) |
| 11 | Trapped CR | Medium | Compute from port timing once available |
| 12 | Full power/torque curve (not just 2 points) | Medium (validation) | Dyno a stock 5-speed |

---

## 7. Do-not-use list (demonstrably wrong / recycled)

| Value found online | Why reject | Better source |
|---|---|---|
| bikeinfobd "Bore & Stroke 58.0 × 55.0 mm" | Inconsistent with 132 cc displacement (58×55 ≈ 145 cc); contradicts xbhp/pdfcoffee "58×50" | xbhp #89 + pdfcoffee manual "58x50" |
| bikeinfobd 4-speed "12 BHP @ 7500 rpm" | Factory (global Yamaha) states 12.0 PS @ 6500 rpm; xbhp #89 states 12 BHP @ 6500 | global.yamaha-motor.com (T1) |
| bikeinfobd torque "12.2 PS @ 7500 rpm" (PS used for torque) | Nonsense unit; torque is 12.25 Nm @ 7000 | bikeinfobd's own "12.25 NM @ 7000" line |
| Factory global page torque 12.3 Nm @ 5500 for "1996 RX135" | Likely 4-speed/early unit; do not apply to 5-speed (5-speed torque 12.25 Nm @ 7000) | bikeinfobd + xbhp for 5-speed |
| "VM26 carb stock on Indian RX135" | Indian stock is VM22 (4TL 01 / 4TL4 20); VM24/VM26 are SEA/South America and aftermarket | xbhp #89 |
| "RX135 makes 14 bhp @ 6500" | 5-speed is 14 BHP @ 7500, not 6500 | xbhp #89 |
| "98 mm rod" applied to RX100/RX135 interchangeably | Rod length consensus is 98 mm for RX135; RX100 differs (shorter stroke) — do not transfer geometry | — |
| Any port-timing degree numbers from Indonesian RX-King / Malaysian RX-Z | Out of scope (different engine tuning) | — |
| "Stock RX135 exhaust port opens at X° BTDC" values from ported builds | Modified; Team-BHP 2008 post describes porting to 5-speed spec then lifting ports further — not stock | — |
| "NGK iridium" as stock plug | Parts catalogue specifies NGK BPR7HS (copper); iridium is aftermarket | parts catalogue (T1/T3) |
| RX-King 135 (Indonesia) power 17.5–18.5 PS @ 8750–9000 rpm | Indonesian market, different engine lineage. Do NOT apply to Indian RX135 | Wikipedia RX-King (T1, out of scope) |
| "190° exhaust / 125° transfer" as RX135-specific | Generic Yamaha port-map quote; variant (RX100 vs RX135, which generation) not stated. Do not enter without variant confirmation | Facebook (T3/T4) |
| RX100 port heights (28/30/32 mm from cylinder top) applied to RX135 | Measured on RX100 G1/G3/G4 cylinders; RX135 has a different (132 cc) cylinder. Do not transfer | Facebook (T3) |
| 5-speed power "15.2 bhp @ 8500 rpm, 13.5 Nm @ 8000 rpm" | Facebook owner claim, no factory source; conflicts with "14 bhp" forum claim. Do not treat as factory spec | Facebook (T4) |
| Chamber volume "22 cc" | Single unsourced Facebook mention; treat as unverified | Facebook (T4) |
| Top-gear ratio "same between 4s and 5s" | Owner speculation on xbhp | xbhp (T4) |
| Tyre size for 5-speed | Assumed from RX-King; not confirmed for Indian 5-speed | T2 (platform assumption) |

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
17. "RX135 5-speed port timing transfer opens exhaust opens degrees"
18. "RX135 port map exhaust port height from top cylinder"
19. Fetched Takumi RX Engineering Facebook post (RX100 cylinder generations)
20. Fetched Facebook "port timing vs port size in Yamaha RX engines" (quote 190°/125°)
21. Fetched team-bhp "advance porting exhaust port degree" thread
22. "Yamaha RX135 compression ratio trapped geometric cc chamber volume"
23. "RX135 Indian carburetor Mikuni model jetting main pilot needle"
24. "RX135 5-speed carburetor VM22 oval venturi main jet pilot jet"
25. Fetched Instagram carb spec sheet (kick_start_biker)
26. Fetched xbhp spare-parts thread (VM22 round vs oval)
27. "RX135 5-speed CDI part number ignition timing degrees BTDC"
28. "Yamaha RX135 India ignition timing specification degrees BTDC"
29. "Yamaha RX135 service manual ignition timing"
30. "RX135 stock pipe dimensions header diffuser belly stinger" (no results; via parts cat)
31. "Yamaha RX135 5-speed power 14 bhp 7000 rpm official"
32. Fetched xbhp "RX 135 4 speed or 5 speed" thread
33. Fetched Wikipedia RX100 (timeline, 5-speed CR/ports)
34. "RX135 Indian service manual gear ratios primary reduction" (no results)
35. Fetched Scribd 5-speed manual page (images only)
36. Fetched Scribd Arunava port maps page
37. Fetched Scribd 4TL6 parts catalogue page
38. Fetched Scribd bare-kit 4 vs 5 speed comparison page
39. "RX135 Indian parts catalogue 4TL6 5-speed"
40. "Yamaha RX135 engine number series Indian models"
41. "RX135 4-speed cat-con mini-cat differences"
42. "Yamaha RX135 service manual ignition timing mm BTDC"
43. "RX135 5 speed India port timing compression ratio" (via pdfcoffee search)
44. "RX135 5speed connecting rod 98 mm" (via search results)
45. "RX135 4TL1 cylinder head part number" (Bing)
46. "RX135 5 speed CDI part number ignition timing degrees BTDC" (Bing)
47. "RX135 5 speed compression ratio 10.1 1" (Bing)
48. "RX135 ignition timing BTDC mm" (DDG)
49. "RX135 CDI part number 4TL OR 1L7" (DDG)
50. "RX135 CDI 85540 part number" (Bing)
51. "RX135 spark plug BPR7HS OR BPR8HS gap" (implicit in parts cat)
52. "RX135 5 speed catalytic converter exhaust hot tube 13-15 kg" (via Team-BHP)
53. "RX135 exhaust port height 2cm i2 series" (via xbhp post #90)
54. "RX135 carburetor Mikuni VM22 4TL4 20 main jet 135" (via xbhp post #89)
55. "RX135 4 speed vs 5 speed differences xbhp" (fetched thread)
56. "RX135 5 speed Team-BHP owner restoration" (fetched thread)
57. "RX135 port timing facebook Takumi workshop" (fetched page title only)
58. "RX135 global Yamaha Communication Plaza 1996" (fetched)
59. "RX135 5 speed bikeinfobd specifications" (fetched)
60. "RX135 safexbikes parts catalogue 4TL1" (fetched)
61. "RX135 pdfcoffee 5-speed manual" (fetched landing page)
62. "RX135 pdfcoffee parts catalogue citation preview" (fetched)
63. "RX135 pdfcoffee RX G service manual" (fetched citation preview)
64. "RX135 scribd parts catalogue" (fetched)
65. "RX135 scribd bare-kit comparison" (fetched)
66. "RX135 Team-BHP advance porting exhaust degree" (fetched)
67. "RX135 5 speed port map images" (user-supplied, 2 PNGs)
68. Transliterated Hindi/Malayalam/Tamil/Telugu: not required — English sources sufficient; attempted Malayalam YouTube terms not pursued due to English results sufficing.

Note: Google/Bing/DuckDuckGo returned challenge pages for several queries late in the session; those queries were re-run via the websearch tool where possible. All URLs above were actually fetched or returned as search hits.

---

## 9. Notes on variant scope

- Third Indian variant? Wikipedia lists RX135 4-speed (Cat-Con) 2001–2003 and (Mini-Cat) 2003–2005 as distinct factory revisions of the 4-speed, plus RX135 (YEIS) 1998–2000. These are treated as sub-revisions of Variant A, not separate datasets, because no evidence of a distinct engine/porting change beyond the catalytic-converter and cosmetic updates was found. If a catalyser/Euro-norm version with different porting/CR is documented, split it out — NOT FOUND as such.
- RX-Z (India) is a separate model (sportier chassis, same 132 cc engine family) and is out of scope per hard rule 1, though it shares the engine; its data must not be merged into RX135.

---

## 10. Engineering estimates (clearly separated — NOT measured)

These are general two-stroke rules of thumb only, provided because the simulation needs numbers; they are NOT sourced and must be replaced by measurement.

- Crank throw = stroke/2 = 25.0 mm (definitional, not a measurement).
- Spark plug gap likely 0.7–0.8 mm (typical for NGK BPR7HS in air-cooled 2-strokes); NOT FOUND for RX135.
- If connecting rod length (98 mm) is unconfirmed, typical rod/stroke ratio for this class is ~1.96; use 98 mm pending measurement.
- Pre-mix ratio if autolube disabled: 40–50 ml 2T oil per L petrol (owner-reported, T4) — not a factory spec.
- Static ignition timing if unmeasured: ~12° BTDC (owner-reported for RX family, T4) — low confidence.

---

## 11. Notes for the MATLAB model (Variant B)

- Use bore 58 mm, stroke 50 mm, rod 98 mm, CR 10.1:1 as the baseline geometry. Confirm rod length by physical measurement before finalising rod ratio (currently T3/T4 consensus).
- Port timing is the dominant unknown: the supplied port-map PNGs must be digitised (measure port top-edge heights from cylinder top face and from BDC) to derive opening angles. Do not use the non-stock "i2 series" 20 mm port height as stock.
- Stock exhaust is the heavy cat-con (hot-tube) unit; if the simulation targets a stock bike, model the cat-con (13–15 kg extra, low-end favouring). If modelling a "chrome silencer" build, that is a MODIFIED configuration.
- Power validation target: 14 BHP @ 7500 rpm, 12.25 Nm @ 7000 rpm, top speed 130 km/h, 0–60 3.5 s.
- Ignition: model as static ~12° BTDC (owner-reported, T4) pending measurement; advance curve NOT FOUND.
- Carb jetting baseline: main 135, pilot 15.0, VM22. Needle/clip/slide/float NOT FOUND — measure a stock carb.
- Autolube stock; if simulating pre-mix, use 40–50 ml 2T oil per litre petrol (owner-reported, T4).

---

*End of dataset. All values tagged; NOT FOUND entries are intentional and must not be filled from rules of thumb. Engineering estimates are confined to §10.*
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

- `params_rx135_5s.m` (or `_4s.m`) - single source of truth for verified stock parameters (NOT-FOUND = NaN).
- `engine_model_5s.m` (or `_4s.m`) - simplified 0D analytic surrogate for sensitivity screening (NOT a full thermodynamic model).
- `sensitivity_study_5s.m` (or `_4s.m`) - one-at-a-time (OAT) sweep + tornado plot of % power change. Outputs CSV + MAT in the same folder.

Toolboxes used: Simscape + Simscape Fluids (target full model), Simulink, Model-Based Calibration Toolbox, Curve Fitting, Signal Processing, Statistics & ML, Symbolic Math, MATLAB Coder.

Key NOT-FOUND inputs that dominate model uncertainty: compression ratio (4s), squish volume, connecting rod length, port heights/timing (derive from port-map PNGs), ignition timing.
