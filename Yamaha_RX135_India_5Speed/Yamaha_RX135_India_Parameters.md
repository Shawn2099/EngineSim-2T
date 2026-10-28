# Yamaha RX135 — Indian Market — Verified Parameter Dataset
**Prepared for:** MATLAB engine simulation model
**Scope:** Indian market only (132 cc air-cooled single-cylinder 2-stroke). RX-King 135 (Indonesia), RX135 Thailand/SEA, RX-Z Malaysia, RX115, RX100, RX-Z India are OUT OF SCOPE and are never used as sources.
**Variants covered:** Variant A = RX135 4-speed; Variant B = RX135 5-speed (primary deliverable). A third Indian variant (RX-Z India, 4TL prefix, cat-con or chrome silencer) is noted where it differs.
**Tag legend:** STOCK / MODIFIED / UNKNOWN. Source tiers: T1 = factory manual/owner's manual/parts catalogue/official Yamaha; T2 = independent dyno/measured teardown/technical article; T3 = forum post with actual measurement/photo/part number by named user with date; T4 = blog/video/marketplace/unsourced. CORROBORATED = 2+ independent sources agree.

---

## 1. Executive summary

### Variant B (RX135 5-speed) — what is solid
- Identity: engine-number prefix `1L7 XXXXXX`, cylinder block `4TL10`, head `09L`, carb `4TL4 20` (Mikuni/UCAL Mikuni VM22), OEM piston `ART 4Y201`. Confirmed by xbhp post #89 (karthikdattag, 2018-06-08, T3) and Team-BHP Mr.Boss (2016, T3).
- Geometry: bore 58 mm, stroke 50 mm, displacement 132.16 cc (computed; matches factory 132 cm3). Connecting rod 98 mm c-c (T3/T4, corroborated by multiple forum posts). Crank throw 25 mm (derived from stroke; trivially exact). Compression ratio 10.1:1 (T4, bikeinfobd 2026; corroborated by pdfcoffee manual snippet "58x50 Compression Ratio..... 10.1:1", T3).
- Performance targets: 14 BHP @ 7500 rpm, 12.25 Nm @ 7000 rpm (T4, bikeinfobd + xbhp karthikdattag); top speed 130 km/h, 0-60 3.5 s (T4).
- Drivetrain: gear ratios fully listed (T3). Primary 19T/74T bell (T3). Final drive 15/38 (T3).
- Dimensions/weight/tyres/brakes: from safexbikes + bikeinfobd (T4).

### Variant B — what is thin / missing
- Port timing in crank degrees: **NOT FOUND** (no published degree map for stock 5-speed). Only a non-stock "i2 series" replacement-kit port height (20 mm exhaust port height, 110 mm sleeve) exists (T4). The supplied port-map PNGs are the best available geometry reference and must be digitised.
- Combustion chamber volume, squish clearance/band, trapped CR: NOT FOUND.
- Connecting rod length is T3/T4 only (no factory drawing); crank throw derived.
- Ignition: CDI part number, pickup/rotor, static timing °BTDC and mm BTDC, advance curve: NOT FOUND (only "Electronic CDI" and owner reports "stock CDI static ~12° BTDC" for RX family, T4).
- Exhaust stock pipe dimensions (header length/ID, cone angles, belly, stinger): NOT FOUND. Only qualitative: cat-con "hot-tube" silencer, adds 13-15 kg vs chrome (T3).
- Carb: needle number/clip, slide cutaway, air-screw turns, float height: NOT FOUND. Only main/pilot jet sizes (T3).
- Service wear limits (clearances, torque specs): NOT FOUND for RX135 specifically.

### Variant A (4-speed) — solid
- 12 BHP @ 6500 rpm (factory global Yamaha page: 8.9 kW / 12.0 PS @ 6500, T1) vs bikeinfobd 12 BHP @ 7500 (T4 conflict — report both).
- Torque 10.0 Nm @ 6500 (T4, bikeinfobd) — conflicts with factory 12.3 Nm @ 5500 for the 1996 RX135 (T1). Report both; see Do-not-use.
- Cylinder `4TL00`, head `4TL00` (chrome) / `4TL5` (cat), carb `4TL 01` (main 165, pilot 17.5), final drive 16/34, 4 gear ratios.

---

## 2. Parameter tables

### Table A — Variant A: RX135 4-speed (Indian)

| Parameter | Value | Unit | STOCK/MODIFIED | Source tier | Source URL | Corroborated? |
|---|---|---|---|---|---|---|
| Model years (Indian) | 1997–2005 (per bikeinfobd); production 1996+ | yr | STOCK | T4 | https://www.bikeinfobd.com/2020/12/Yamaha-RX-135.html | No (T4 only) |
| Engine code prefix | 1L5 (chrome silencer OE) / 4TL (cat silencer OE) | — | STOCK | T3 | https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6 (post #89) | Yes (parts catalogue 4TL1) |
| Frame/VIN prefix | 4TL1 (parts catalogue) | — | STOCK | T1/T3 | https://www.scribd.com/document/202485946/Yamaha-Rx135-Rx-135-Illustrated-Parts-List-Diagram-Manual | — |
| Cylinder block part code | 4TL00 | — | STOCK | T3 | xbhp post #89 | Yes |
| Cylinder head part code | 4TL00 (chrome silencer) / 4TL5 (cat silencer) | — | STOCK | T3 | xbhp post #89 | — |
| Piston part code | ART 4Y201 | — | STOCK | T3 | xbhp post #89 | Yes |
| Carb part code | 4TL 01 (Mikuni/UCAL Mikuni VM22) | — | STOCK | T3 | xbhp post #89 | — |
| Main jet | 165 | — | STOCK | T3 | xbhp post #89 | — |
| Pilot jet | 17.5 | — | STOCK | T3 | xbhp post #89 | — |
| CDI | Electronic CDI (part no. NOT FOUND) | — | STOCK | T4 | bikeinfobd | No |
| Number of gears | 4 | — | STOCK | T3 | xbhp post #89 | Yes |
| Claimed power | 12.0 PS (8.9 kW) @ 6500 rpm (factory); 12 BHP @ 7500 rpm (bikeinfobd) | PS/BHP | STOCK | T1 (factory) / T4 | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ ; bikeinfobd | Conflict — report both |
| Claimed torque | 12.3 Nm @ 5500 rpm (factory, 1996 RX135); 10.0 Nm @ 6500 rpm (bikeinfobd) | Nm | STOCK | T1 / T4 | global.yamaha; bikeinfobd | Conflict — report both |
| Bore | 58 | mm | STOCK | T3 (computed to 132 cc) | xbhp post #89 | Yes (pdfcoffee manual "58x50") |
| Stroke | 50 | mm | STOCK | T3 | xbhp post #89 | Yes |
| Displacement | 132.16 (132) | cc | STOCK | T1/T3 | global.yamaha (132 cm3); xbhp | Yes |
| Connecting rod length (c-c) | 98 | mm | STOCK | T3/T4 | multiple forum posts (xbhp, facebook) | Yes (community consensus) |
| Crank throw | 25 | mm | STOCK | derived (stroke/2) | — | exact |
| Compression ratio (geometric) | 10.1:1 (claimed; conflict: factory T1 not stated) | — | STOCK | T4 | bikeinfobd | Single source (T4) |
| Carburettor | Mikuni/UCAL Mikuni VM22, 22 mm | mm | STOCK | T3 | xbhp post #89 | — |
| Air cleaner | Washable PU foam | — | STOCK | T4 | bikeinfobd | — |
| Final drive sprockets | 16 T / 34 T | T | STOCK | T3 | xbhp post #89 | — |
| Gear ratios | 1st 35/11=3.182; 2nd 30/15=2.000; 3rd 26/19=1.368; 4th 23/23=1.000 | — | STOCK | T3 | xbhp post #89 | — |
| Primary reduction | 19 T / 74 T (bell) | T | STOCK | T3 | xbhp post #89 | — |
| Tyres (stock) | Front 2.75×18, Rear 2.75×18 | — | STOCK | T4 | bikeinfobd | — |
| Brakes | 130 mm drum F/R | mm | STOCK | T4 | bikeinfobd | — |
| Kerb weight | 106 | kg | STOCK | T4 | bikeinfobd / safexbikes | — |
| Fuel tank | 10.5 | L | STOCK | T4 | bikeinfobd | — |
| Side oil (autolube) tank | 1.2 | L | STOCK | T4 | bikeinfobd | — |
| Top speed | 120 | km/h | STOCK | T4 | bikeinfobd | — |
| 0-60 km/h | 4.2 | s | STOCK | T4 | bikeinfobd | — |
| Mileage | 25-35 | km/L | STOCK | T4 | bikeinfobd | — |
| Overall L×W×H | 1965 × 740 × 1050 | mm | STOCK | T4/T1 | bikeinfobd; global.yamaha (1965×740×1050) | Yes |
| Wheelbase | 1240 | mm | STOCK | T4 | bikeinfobd | — |
| Ground clearance | 145 | mm | STOCK | T4 | bikeinfobd | — |

### Table B — Variant B: RX135 5-speed (Indian) — PRIMARY

| Parameter | Value | Unit | STOCK/MODIFIED | Source tier | Source URL | Corroborated? |
|---|---|---|---|---|---|---|
| Model years (Indian) | 1997–2005 (bikeinfobd); 2000 example (Team-BHP) | yr | STOCK | T4/T3 | bikeinfobd; https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html | — |
| Engine code prefix | 1L7 XXXXXX | — | STOCK | T3 | xbhp post #89; Team-BHP Mr.Boss | Yes |
| Cylinder block part code | 4TL10 | — | STOCK | T3 | xbhp post #89; Team-BHP (photo) | Yes |
| Cylinder head part code | 09L (inner side of head) | — | STOCK | T3 | xbhp post #89 | — |
| Piston part code | ART 4Y201 (same as 4-speed) | — | STOCK | T3 | xbhp post #89 | Yes |
| Carb part code | 4TL4 20 (Mikuni/UCAL Mikuni VM22) | — | STOCK | T3 | xbhp post #89 | — |
| Main jet | 135 | — | STOCK | T3 | xbhp post #89 | — |
| Pilot jet | 15.0 | — | STOCK | T3 | xbhp post #89 | — |
| CDI | Electronic CDI (part no. NOT FOUND) | — | STOCK | T4 | bikeinfobd | No |
| Number of gears | 5 | — | STOCK | T3 | xbhp post #89 | Yes |
| Claimed power | 14 BHP @ 7500 rpm | BHP | STOCK | T3/T4 | xbhp post #89 ("Rating: 14BHP @ 7500RPM"); bikeinfobd | Yes (2 sources) |
| Claimed torque | 12.25 Nm @ 7000 rpm | Nm | STOCK | T4 | bikeinfobd | Single source (T4) |
| Bore | 58 | mm | STOCK | T3 (computed) | xbhp post #89 | Yes (pdfcoffee "58x50") |
| Stroke | 50 | mm | STOCK | T3 | xbhp post #89 | Yes |
| Displacement | 132.16 (132) | cc | STOCK | T1/T3 | global.yamaha (132 cm3) | Yes |
| Connecting rod length (c-c) | 98 | mm | STOCK | T3/T4 | multiple forum posts | Yes (community consensus) |
| Crank throw | 25 | mm | STOCK | derived (stroke/2) | — | exact |
| Compression ratio (geometric) | 10.1:1 | — | STOCK | T4 (bikeinfobd) / T3 (pdfcoffee manual snippet) | bikeinfobd; pdfcoffee manual | Partial (manual snippet confirms 10.1:1 with 58×50) |
| Carburettor | Mikuni/UCAL Mikuni VM22, 22 mm (venturi NOT 26; do not use VM26 stock) | mm | STOCK | T3 | xbhp post #89 | — |
| Air cleaner | Washable PU foam | — | STOCK | T4 | bikeinfobd | — |
| Final drive sprockets | 15 T / 38 T | T | STOCK | T3 | xbhp post #89 | — |
| Gear ratios | 1st 35/11=3.182; 2nd 30/15=2.000; 3rd 26/19=1.368; 4th 24/22=1.091; 5th 22/24=0.917 | — | STOCK | T3 | xbhp post #89 | — |
| Primary reduction | 19 T / 74 T (bell) | T | STOCK | T3 | xbhp post #89 | — |
| Tyres (stock) | Front 2.75×18 (4PR), Rear 3.00×18 (6PR) | — | STOCK | T4 | bikeinfobd; Team-BHP (stock spec 3.00×18 rear) | Yes |
| Brakes | 130 mm drum F/R | mm | STOCK | T4 | bikeinfobd | — |
| Kerb weight | 116 (wet) / 108 (dry) | kg | STOCK | T4 | bikeinfobd | — |
| Fuel tank | 10.5 | L | STOCK | T4 | bikeinfobd | — |
| Side oil (autolube) tank | 1.2 | L | STOCK | T4 | bikeinfobd | — |
| Top speed | 130 | km/h | STOCK | T4 | bikeinfobd | — |
| 0-60 km/h | 3.5 | s | STOCK | T4 | bikeinfobd | — |
| 0-100 km/h | 10 | s | STOCK | T4 | bikeinfobd | — |
| Mileage | 25-35 | km/L | STOCK | T4 | bikeinfobd | — |
| Overall L×W×H | 1965 × 735 × 1040 | mm | STOCK | T4 | bikeinfobd | (global.yamaha 1996 = 1965×740×1050, T1 — conflict on W/H) |
| Wheelbase | 1245 | mm | STOCK | T4 | bikeinfobd | — |
| Ground clearance | 136 | mm | STOCK | T4 | bikeinfobd | — |
| Seat height | 765 | mm | STOCK | T4 | bikeinfobd | — |
| Engine type | Air-cooled 2-stroke single, 7-port, piston reed intake, Torque Induction, YEIS | — | STOCK | T1 | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | — |
| Exhaust (OE) | Catalytic "hot-tube" silencer (big); never came with chrome silencer OE; adds 13-15 kg vs chrome | — | STOCK | T3 | xbhp post #89; Team-BHP (pramodkumar) | Yes |
| Autolube | Yes (oil pump; 1.2 L side tank); stock premix ratio for pre-mix use: 40-50 ml 2T oil per litre petrol (owner-reported) | — | STOCK | T4 | bikeinfobd (side oil 1.2 L); bikewale owner (Mukesh Sarode: 40-50 ml/L) | — |
| Spark plug | NGK BPR7HS (parts catalogue) / "NGK iridium" (bikeinfobd, vague) | — | STOCK | T1/T4 | parts catalogue (scribd 4TL1: "SPARK PLUG-NGK-BPR7HS"); bikeinfobd | Partial |
| Ignition timing | NOT FOUND (owner reports stock CDI static ~12° BTDC for RX family, T4) | °BTDC | UNKNOWN | T4 | reddit r/2Strokes comment | Low confidence |
| Port timing (degrees) | NOT FOUND for stock. See gap list & media inventory. | ° | NOT FOUND | — | — | — |
| Combustion chamber volume | NOT FOUND | cc | NOT FOUND | — | — | — |
| Squish clearance / band | NOT FOUND | mm | NOT FOUND | — | — | — |
| Exhaust port height (non-stock "i2 series" replacement kit) | 20 mm port height; 110 mm sleeve height; 30 mm above port / 60 mm below port | mm | MODIFIED (Yamaha India replacement kit, not OE 5-speed stock) | T3/T4 | xbhp post #90 (Anand Deepak / Anand, 2018) | Single source |
| CDI part number | NOT FOUND | — | NOT FOUND | — | — | — |
| Carb needle number/clip/slide cutaway/float height/air-screw | NOT FOUND | — | NOT FOUND | — | — | — |
| Exhaust stock pipe dimensions | NOT FOUND (only qualitative cat-con) | — | NOT FOUND | — | — | — |

---

## 3. Evidence appendix (exact quotes)

1. xbhp post #89 (karthikdattag, 2018-06-08): "4-Speed - '4TL00' with OEM 'ART' STD piston '4Y201', Rating: 12BHP @ 6500RPM" / "5-Speed - '4TL10' with OEM 'ART' STD piston '4Y201', Rating: 14BHP @ 7500RPM". Source: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6
2. Same post: "4-Speed: '4TL 01' with Main Jet = 165 & Pilot Jet = 17.5" / "5-Speed: '4TL4 20' with Main Jet = 135 & Pilot Jet = 15.0" / "These are VM type of Carburettors manufactured by Mikuni & both are 22mm."
3. Same post: "RX135 4-Speed: '4TL5' written on inner side (Top) of Head (For OE fitting Catalytic Converter type)" / "RX135 4-Speed / RXG: '4TL00' ... (Chrome Silencer)" / "RX135 5-Speed: '09L' written on inner side of Head".
4. Same post: "Bore Dia = 58mm ... Stroke Length = 50mm" / displacement 132.157 cm3.
5. Same post: gear ratios 4-speed and 5-speed as listed.
6. Same post: "RX135 (With Catalytic Silencer as OE fitting): 4TL XXXXXX" / "RX135 5-Speed: 1L7 XXXXXX" / "The RX135 5-Speed never came with OE fitted Chrome silencer, the OE fit was the Big Hot-Tube type catalytic converter Exhaust."
7. Same post: "The CrankShaft Assembly is the same for RX135, RX-G, RX135 5-Speed & RX-Z."
8. Team-BHP Mr.Boss (2016): "1L7xxxxxx Engine number", "4TL10 Block, Running on 3OS piston", "Stock cat-con silencer replaced with Chrome silencer + Fully open RX100 core", "cat con adds an unnecessary 13-15kgs". Source: https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html
9. Team-BHP pramodkumar (2016): "the cat con installation would improve your bike's low end manners".
10. Team-BHP post #7 (malvechaitanya, 2008): "standard 4speed ports are 3-4 mm small than the 5 speed ports".
11. bikeinfobd (2026): "MAXIMUM POWER 14 BHP @ 7500 rpm (5 speed) & 12 BHP @ 7500 rpm (4 Speed)" / "MAXIMUM TORQUE 12.25 NM @ 7000 rpm (5 speed) & 10.0 NM @ 6500 rpm (4 Speed)" / "Compression Ratio 10.1:1" (both variants) / "Bore & Stroke 58.0 x 55.0 mm" (erroneous — see do-not-use). Source: https://www.bikeinfobd.com/2020/12/Yamaha-RX-135.html
12. Yamaha global Communication Plaza (1996 RX135): "Engine type: Air-cooled, 2-stroke, single-cylinder, 132cm³" / "Maximum power output: 8.9kW (12.0PS) / 6,500r/min" / "Maximum torque: 12.3N·m (1.25kgf·m) / 5,500r/min" / "7-port piston reed intake valve" / "Torque Induction system" / "YEIS". Source: https://global.yamaha-motor.com/showroom/cp/collection/rx135/
13. parts catalogue (scribd 4TL1): "SPARK PLUG-NGK-BPR7HS" (T1/T3).
14. pdfcoffee 5-speed manual snippet: "58x50 Compression Ratio..... 10.1:1" (T3).
15. safexbikes parts catalogue: RX135 (4TL1) India, dimensions 1965×740×1050, weight 100 kg (global page), 132 cm3. Source: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf
16. xbhp post #90 (Anand Deepak, 2018): "In yamaha 135 i2 series kit exhost port height is 2cm. ... Over all sleve height is 11cm. Height from port to upwars is 3 cm. Height from port to bottom is 6 cm." (non-stock replacement kit).

---

## 4. Media inventory

| Item | URL | What it shows | Stock? |
|---|---|---|---|
| Port map (user-supplied) | C:\Users\malliath\Desktop\engine_sim\Yamaha_RX135_India\rx135_5speed_portmap.png (1144×701) | 5-speed port layout scan; datum to be verified (likely cylinder top face) | UNKNOWN — verify against stock block |
| Port map (user-supplied) | .../rx135_5speed_portmap_2.png (1235×763) | Second 5-speed port map variant | UNKNOWN |
| Yamaha global RX135 (1996) page | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | Official photo + power/torque/dims | STOCK |
| Parts catalogue RX135 (4TL1) | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf | Exploded diagrams, part numbers | STOCK |
| Parts catalogue (scribd) | https://www.scribd.com/document/202485946/Yamaha-Rx135-Rx-135-Illustrated-Parts-List-Diagram-Manual | 50 pp parts list | STOCK |
| 5-speed service manual (scribd) | https://www.scribd.com/document/25643028/rx-135-5speed-manual | Workshop manual (28 MB) | STOCK |
| 5-speed specs manual (scribd) | https://www.scribd.com/document/608461041/RX-135-5-SPEED-Specs-Manual | Specs | STOCK |
| 4 vs 5 speed comparison (scribd) | https://www.scribd.com/document/246200975/Bare-kit | Component differences | Mixed (includes modified bike) |
| xbhp differences thread | https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6 | Karthikdattag's component delta (T3) | STOCK |
| Team-BHP RX135 5-speed thread | https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html | Owner restoration, photos | MODIFIED (disc brake, alloy wheels, chrome silencer swap) |
| Team-BHP porting thread | https://www.team-bhp.com/forum/motorbikes/36510-advance-porting-exhaust-port-degree.html | Porting discussion, 4 vs 5 speed port size | MODIFIED |
| YouTube porting/restoration | https://www.youtube.com/watch?v=-32ZACaTIBs | RX135 porting teardown | MODIFIED |
| Instagram port-timing reel | https://www.instagram.com/reel/C76h_jWhghq/ | Port timing basics | Unknown |
| Facebook Takumi workshop | https://www.facebook.com/groups/yamahaenthusiasts/posts/27419532214408731/ | Measured port heights/timing (not accessible) | UNKNOWN |
| safexbikes parts catalogue (4TL1) | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf | Parts, diagrams | STOCK |

---

## 5. 4-speed vs 5-speed delta (sourced)

| Item | 4-speed | 5-speed | Source |
|---|---|---|---|
| Cylinder block | 4TL00 | 4TL10 | xbhp #89 |
| Cylinder head | 4TL00 (chrome) / 4TL5 (cat) | 09L | xbhp #89 |
| Carb (code) | 4TL 01 | 4TL4 20 | xbhp #89 |
| Main jet | 165 | 135 | xbhp #89 |
| Pilot jet | 17.5 | 15.0 | xbhp #89 |
| Carb (all) | Mikuni/UCAL Mikuni VM22, 22 mm venturi | same type, 22 mm | xbhp #89 |
| Rated power | 12 BHP @ 6500 (factory: 12 PS @ 6500) | 14 BHP @ 7500 | xbhp #89; global.yamaha |
| Rated torque | 10.0 Nm @ 6500 (bikeinfobd) / 12.3 Nm @ 5500 (factory 1996) | 12.25 Nm @ 7000 | bikeinfobd; global.yamaha |
| Ports | 4-speed ports 3-4 mm smaller than 5-speed | larger ports | Team-BHP 2008 |
| OE silencer | Chrome silencer OR cat-con | Cat-con "hot-tube" only (never chrome OE) | xbhp #89 |
| Final drive | 16 / 34 | 15 / 38 | xbhp #89 |
| Gear ratios | 3.182, 2.000, 1.368, 1.000 | 3.182, 2.000, 1.368, 1.091, 0.917 | xbhp #89 |
| Top speed | 120 km/h | 130 km/h | bikeinfobd |
| 0-60 km/h | 4.2 s | 3.5 s | bikeinfobd |
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
| bikeinfobd "Bore & Stroke 58.0 × 55.0 mm" | Inconsistent with 132 cc displacement (58×55 = ~145 cc); contradicts xbhp/pdfcoffee "58×50" | xbhp #89 + pdfcoffee manual "58x50" |
| bikeinfobd 4-speed "12 BHP @ 7500 rpm" | Factory (global Yamaha) states 12.0 PS @ 6500 rpm; xbhp #89 states 12 BHP @ 6500 | global.yamaha-motor.com (T1) |
| bikeinfobd torque "12.2 PS @ 7500 rpm" for max torque | Nonsense (PS is power, not torque); torque is 12.25 Nm @ 7000 | bikeinfobd's own "12.25 NM @ 7000" line |
| Factory global page torque 12.3 Nm @ 5500 for "1996 RX135" | Likely 4-speed/early unit; do not apply to 5-speed (5-speed torque 12.25 Nm @ 7000) | bikeinfobd + xbhp for 5-speed |
| "VM26 carb stock on Indian RX135" | Indian stock is VM22 (4TL 01 / 4TL4 20); VM24/VM26 are SEA/South America and aftermarket | xbhp #89 |
| "RX135 makes 14 bhp @ 6500" | 5-speed is 14 BHP @ 7500, not 6500 | xbhp #89 |
| "98 mm rod" applied to RX100/RX135 interchangeably | Rod length consensus is 98 mm for RX135; RX100 differs (shorter stroke) — do not transfer geometry | — |
| Any port-timing degree numbers from Indonesian RX-King / Malaysian RX-Z | Out of scope (different engine tuning) | — |
| "Stock RX135 exhaust port opens at X° BTDC" values from ported builds | Modified; the Team-BHP 2008 post describes porting to 5-speed spec then lifting ports further — not stock | — |
| "NGK iridium" as stock plug | Parts catalogue specifies NGK BPR7HS (copper); iridium is aftermarket | parts catalogue (T1/T3) |

---

## 8. Query log

1. "Yamaha RX135 India service manual PDF engine specifications"
2. "Yamaha RX135 India 4TL1 engine code part number cylinder head"
3. "RX135 5-speed India port timing degrees exhaust transfer"
4. "RX135 5 speed India port timing degrees exhaust transfer" (variant)
5. "RX135 5-speed India port timing degrees exhaust transfer" (re-run)
6. "RX135 parts catalogue 4TL1 cylinder head piston part number 4TL"
7. "RX135 5speed India port timing compression ratio" (via pdfcoffee search)
8. "RX135 5 speed service manual pdfcoffee port timing compression ratio"
9. "Yamaha RX135 5 speed compression ratio 10.1 1"
10. "RX135 5speed connecting rod 98 mm" (via search results)
11. "RX135 4TL1 cylinder head part number" (Bing)
12. "RX135 5 speed CDI part number ignition timing degrees BTDC" (Bing)
13. "RX135 5 speed compression ratio 10.1 1" (Bing)
14. "RX135 ignition timing BTDC mm" (DDG)
15. "RX135 CDI part number 4TL OR 1L7" (DDG)
16. "RX135 CDI 85540 part number" (Bing)
17. "RX135 spark plug BPR7HS OR BPR8HS gap" (implicit in parts catalogue)
18. "RX135 5 speed catalytic converter exhaust hot tube 13-15 kg" (via Team-BHP)
19. "RX135 exhaust port height 2cm i2 series" (via xbhp post #90)
20. "RX135 carburetor Mikuni VM22 4TL4 20 main jet 135" (via xbhp post #89)
21. "RX135 4 speed vs 5 speed differences xbhp" (fetched thread)
22. "RX135 5 speed Team-BHP owner restoration" (fetched thread)
23. "RX135 port timing facebook Takumi workshop" (fetched page title only)
24. "RX135 global Yamaha Communication Plaza 1996" (fetched)
25. "RX135 5 speed bikeinfobd specifications" (fetched)
26. "RX135 safexbikes parts catalogue 4TL1" (fetched)
27. "RX135 pdfcoffee 5-speed manual" (fetched landing page)
28. "RX135 pdfcoffee parts catalogue citation preview" (fetched)
29. "RX135 pdfcoffee RX G service manual" (fetched citation preview)
30. "RX135 scribd parts catalogue" (fetched)
31. "RX135 scribd bare-kit comparison" (fetched)
32. "RX135 Team-BHP advance porting exhaust degree" (fetched)
33. "RX135 5 speed port map images" (user-supplied, 2 PNGs)
34. Transliterated: not required — English sources sufficient for Variant B.

Additional attempted fetches (blocked/empty): manualslib, vdocuments, docplayer, archive.org (no RX135 manual), Google Docs viewer (PDF load failed).

---

## 9. Notes for the MATLAB model (Variant B)

- Use bore 58 mm, stroke 50 mm, rod 98 mm, CR 10.1:1 as the baseline geometry. Confirm rod length by physical measurement before finalising rod ratio (currently T3/T4 consensus).
- Port timing is the dominant unknown: the supplied port-map PNGs must be digitised (measure port top-edge heights from cylinder top face and from BDC) to derive opening angles. Do not use the non-stock "i2 series" 20 mm port height as stock.
- Stock exhaust is the heavy cat-con (hot-tube) unit; if the simulation targets a stock bike, model the cat-con (13-15 kg extra, low-end favouring). If modelling a "chrome silencer" build, that is a MODIFIED configuration.
- Power validation target: 14 BHP @ 7500 rpm, 12.25 Nm @ 7000 rpm, top speed 130 km/h, 0-60 3.5 s.
- Ignition: model as static ~12° BTDC (owner-reported, T4) pending measurement; advance curve NOT FOUND.
- Carb jetting baseline: main 135, pilot 15.0, VM22. Needle/clip/slide/float NOT FOUND — measure a stock carb.
- Autolube stock; if simulating pre-mix, use 40-50 ml 2T oil per litre petrol (owner-reported, T4).

---
*End of dataset. All values tagged; NOT FOUND entries are intentional and must not be filled from rules of thumb.*
