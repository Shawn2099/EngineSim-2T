# Yamaha RX135 — 5-Speed — Indian Market — Verified Parameter Dataset
**Primary deliverable for the MATLAB simulation model.** Variant B (RX135 5-speed, Indian).
Scope: Indian-market 132 cc air-cooled single-cylinder 2-stroke only. EXCLUDED and never used as sources: RX-King 135 (Indonesia), RX135 Thailand/SEA, RX-Z (Malaysia), RX115, RX100, and any non-Indian RX135.
A separate Variant A (4-speed) table is included for the delta section only; values are never transferred between variants.
Tag legend: STOCK / MODIFIED / UNKNOWN / DERIVED. Tiers: T1 factory manual/owner manual/parts catalogue/official Yamaha archive; T2 independent dyno/measured teardown/technical article; T3 forum post with actual measurement/photo/part number by named user with date; T4 blog/video/marketplace/unsourced. CORROBORATED = 2+ independent sources agree. Confidence < 70% is stated in-row. NOT FOUND = genuinely not located; no invented values.

---

## 1. Executive summary

**Variant B (RX135 5-speed) — solid:**
- Factory owner's manual (Escorts Yamaha, 19 pp) now captured via Wayback Machine (T1): CR 10.4:1, 14.0 BHP @ 7,500 rpm, 1.25 kgm @ 7,000 rpm, 58×50, 132 cc, tyres, frame, suspension, spark plug BPR 7HS, capacities, gear ratios, periodic-maintenance schedule.
- Identity: engine-number prefix `1L7 XXXXXX`, cylinder block `4TL10` (parts line `4TL6`), head `09L`, carb `4TL4 20` (Mikuni/UCAL Mikuni VM22 oval venturi), OEM piston `ART 4Y201`. Confirmed by xbhp (karthikdattag, T3) and Team-BHP (Mr.Boss, T3).
- Model years: 2000–2003 (Wikipedia RX100 page, T1).
- Geometry: bore 58 mm, stroke 50 mm, displacement 132.16 cc (computed; matches factory 132 cm³). Connecting rod 98 mm c-c (T3/T4 community consensus). Crank throw 25 mm (derived). Compression ratio 10.4:1 (factory owner's manual, T1).
- Rated power: 14.0 BHP @ 7,500 rpm (factory owner's manual, T1). Torque 1.25 kgm (12.26 Nm) @ 7,000 rpm (T1).
- Drivetrain: primary 19 T / 74 T bell, final drive 15 / 38, 5 gear ratios listed (xbhp T3).
- Carb jetting: main 135, pilot 15.0, needle jet #5ZF6, slide cutaway 2.0 (Instagram T3, 2024).
- CDI (4-speed equivalent, T1): magneto `4TL-H5500-00-00`, CDI unit `2YA-H5540-00-00` (superseded `1M1-3002-00`); 5-speed-specific p/n NOT FOUND.
- Spark plug: NGK BPR7HS (parts catalogue T1). Gap NOT FOUND.
- Exhaust: large catalytic-converter "hot-tube" silencer (stock); adds 13–15 kg vs chrome (Team-BHP T3).
- Dimensions/tyres/brakes: factory owner's manual (T1) now confirms 1965×780×1040 mm, GC 136 mm, tyres F 2.75×18-4PR / R 3.00×18-6PR, frame double cradle, suspension. Dry weight NOT FOUND in capture (bikeinfobd T4 says 108 kg).

**Variant B — thin / missing:**
- Port timing in crank degrees: NOT FOUND for stock 5-speed. Only a non-stock "i2 series" replacement-kit port height (20 mm) and a generic Facebook quote ("190° exhaust / 125° transfer", variant unspecified) exist. The supplied port-map PNGs are the best available geometry reference and must be digitised.
- Combustion chamber volume, squish clearance/band, trapped CR: NOT FOUND. The factory owner's manual (T1, 19 pp) contains NO head volume, squish, or port-timing data; no service/workshop manual was found online in text-extractable form. The only head-volume mention is an unsourced Facebook post ("~22 cc factory head", T4) — kept in do-not-use, not used.
- Ignition: static timing (°BTDC and mm BTDC), advance curve: NOT FOUND (only owner reports "stock CDI static ~12° BTDC" for RX family, T4). Ignition type field exists in owner's manual but value illegible in capture.
- Exhaust stock pipe dimensions (header, cones, belly, stinger): NOT FOUND.
- Service wear limits (clearances, ring end gap, torque specs): NOT FOUND.
- Full power/torque curve: only discrete points.

---

## 2. Parameter table — Variant B: RX135 5-speed (Indian) (PRIMARY)

| Parameter | Value | Unit | STOCK/MODIFIED | Tier | Source URL | Corroborated? |
|---|---|---|---|---|---|---|
| Model years (Indian) | 2000–2003 | yr | STOCK | T1 | https://en.wikipedia.org/wiki/Yamaha_RX_100 | yes (xbhp) |
| Engine number prefix | 1L7 XXXXXX | — | STOCK | T3 | xbhp (karthikdattag #89) + Team-BHP Mr.Boss | yes |
| Parts catalogue line | 4TL (4TL6) | — | STOCK | T1 | Scribd 4TL6-PC | yes |
| Cylinder block part code | 4TL10 | — | STOCK | T3 | xbhp #89 + Team-BHP photo | yes |
| Cylinder head part code | 09L (inner side of head) | — | STOCK | T3 | xbhp #89 | — |
| Piston part code | ART 4Y201 (same as 4-speed) | — | STOCK | T3 | xbhp #89 | yes |
| Carb part code | 4TL4 20 (Mikuni/UCAL Mikuni VM22) | — | STOCK | T3 | xbhp #89 | — |
| Main jet | 135 (hex head 4/042) | — | STOCK | T3 | xbhp #89 + Instagram (kick_start_biker, 2024) | yes |
| Pilot jet | 15.0 (VM20) | — | STOCK | T3 | xbhp #89 + Instagram | yes |
| Needle jet | #5ZF6 | — | STOCK | T3 | Instagram (kick_start_biker) | single |
| Slide cutaway | 2.0 | — | STOCK | T3 | Instagram | single |
| Carb venturi | 22 (oval venturi) | mm | STOCK | T3 | xbhp spare-parts thread (VM22 round vs oval) | yes |
| CDI magneto p/n | 4TL-H5500-00-00 | — | STOCK | T1/T3 | safexbikes parts cat (4TL1) + xbhp #187 (same ignition kit 4 & 5 speed) | corroborated (T3 confirms shared) |
| CDI unit p/n | 2YA-H5540-00-00 (superseded 1M1-3002-00) | — | STOCK | T1/T3 | safexbikes parts cat (4TL1) + xbhp #187 | corroborated (T3 confirms shared) |
| Spark plug (parts cat 4TL1) | NGK BPR7HS | — | STOCK | T1 | safexbikes parts cat (4TL1) | superseded by owner's manual BPR 7HS (NGK) or equivalent |
| Spark plug gap | NOT FOUND | mm | — | — | — | — |
| Reed valve p/n (4-speed equivalent) | 2YA-E3610-00-00 | — | STOCK? | T1 | safexbikes parts cat (4TL1) | unverified for 5-speed |
| Number of gears | 5 | — | STOCK | T3 | xbhp #89 | yes |
| Claimed power (factory) | NOT FOUND (no official factory figure located) | kW/PS | — | — | — | — |
| Claimed power (factory, owner's manual) | 14.0 BHP @ 7,500 rpm | BHP | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual, §VIII Technical Specifications | yes (xbhp T3 + bikeinfobd T4 agree) |
| Power (owner, conflicting) | 15.2 bhp @ 8500 rpm, 13.5 Nm @ 8000 rpm | bhp/Nm | MODIFIED? | T4 | Facebook "rx 135 5 speed top speed" | no (do not use as factory) |
| Claimed torque (factory, owner's manual) | 1.25 kgm (12.26 Nm) @ 7,000 rpm | Nm | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual, §VIII Technical Specifications | yes (bikeinfobd 12.25 Nm agrees) |
| Bore | 58 | mm | STOCK | T2/T3 | Wikipedia RX-King; xbhp #89 (computed to 132 cc) | yes (pdfcoffee manual "58x50") |
| Stroke | 50 | mm | STOCK | T2/T3 | Wikipedia RX-King; xbhp #89 | yes |
| Displacement | 132.16 (132) | cc | STOCK | T1/T3 | global.yamaha (132 cm³); xbhp | yes |
| Connecting rod length (c-c) | 98 | mm | STOCK? | T3/T4 | multiple forum posts (xbhp, facebook carb size guide, spare parts thread) | yes (community consensus); NOT in factory owner's manual (T1) — unverified; cheapest close: measure a stock rod with calipers |
| Crank throw | 25 | mm | STOCK | DERIVED (stroke/2) | — | exact |
| Piston compression height | NOT FOUND | mm | — | — | — | — |
| Gudgeon pin diameter | NOT FOUND | mm | — | — | — | — |
| Deck height at TDC | NOT FOUND | mm | — | — | — | — |
| Base/head gasket thickness | NOT FOUND | mm | — | — | — | — |
| Head gasket/o-ring (4-speed equivalent) | "GASKET CYL. HEAD" p/n 4TL-E1181-00-00 (4TL1) | — | STOCK? | T1 | safexbikes parts cat | unverified for 5-speed |
| Claimed CR (manual) | 10.4:1 | — | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual, §VIII Technical Specifications | yes (manual prints "Compression Ratio .... .10.4:4") |
| Compression ratio (geometric) | 10.4:1 | — | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual (scribd 25643028), §VIII Technical Specifications | yes (manual snippet "58x50 Compression Ratio..... 10.1:1" was a T4/OCR error; factory manual says 10.4:1) |
| Trapped CR | NOT FOUND | — | — | — | — | — |
| Combustion chamber volume | NOT FOUND (~22 cc cited once, T4, unsourced) | cc | — | T4 | Facebook compression discussion | no (single, unverified) |
| Squish clearance / band | NOT FOUND | mm | — | — | — | — |
| Chamber/dome shape | NOT FOUND (photo needed) | — | — | — | — | — |
| Exhaust port type | NOT FOUND (assumed single, unverified) | — | — | — | — | — |
| Exhaust port height from cyl top | NOT FOUND for stock 5-speed | mm | — | — | — | — |
| Exhaust port height (non-stock "i2 series" replacement kit) | 20 mm port height; 110 mm sleeve; 30 mm above / 60 mm below port | mm | MODIFIED (Yamaha India replacement kit, not OE 5-speed stock) | T3/T4 | xbhp post #90 (Anand Deepak, 2018) | single |
| Exhaust port opening angle | NOT FOUND for stock 5-speed (generic quote 95° BTDC, variant unspecified) | °BTDC | UNKNOWN | T3/T4 | Facebook port-map quote | no |
| Exhaust port duration | NOT FOUND for stock 5-speed (generic quote 190°, variant unspecified) | crank ° | UNKNOWN | T3/T4 | Facebook port-map quote | no |
| Transfer port duration | NOT FOUND for stock 5-speed (generic quote 125°, variant unspecified) | crank ° | UNKNOWN | T3/T4 | Facebook port-map quote | no |
| Inlet type | Piston reed (reed valve) + YEIS, 7-port | — | STOCK | T1 | global.yamaha RX135 page | yes |
| Carb make/model | Mikuni VM22, oval venturi (vs round on 4-speed) | — | STOCK | T3 | xbhp spare-parts thread | yes |
| Air cleaner | Washable PU foam | — | STOCK | T4 | bikeinfobd | — |
| Final drive sprockets | 15 T / 38 T | T | STOCK | T3 | xbhp #89 | — |
| Gear ratios (5-speed) | 1st 35/11=3.182; 2nd 30/15=2.000; 3rd 26/19=1.368; 4th 24/22=1.091; 5th 22/24=0.917 | — | STOCK | T3 | xbhp #89 | — |
| Primary reduction | 19 T / 74 T (bell) | T | STOCK | T3 | xbhp #89 | — |
| Tyres (stock) | Front 2.75×18-4PR (ribbed), Rear 3.00×18-6PR (universal) | — | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual, §VIII Technical Specifications | yes (bikeinfobd agrees) |
| Brakes | 130 mm drum F/R | mm | STOCK | T4 | bikeinfobd | — |
| Kerb weight | 116 wet / 108 dry | kg | STOCK | T4 | bikeinfobd | — |
| Fuel tank | 10.5 | L | STOCK | T4 | bikeinfobd | — |
| Side oil (autolube) tank | 1.2 | L | STOCK | T4 | bikeinfobd | — |
| Top speed | 130 | km/h | STOCK? | T4 | bikeinfobd | — |
| 0-60 km/h | 3.5 | s | STOCK? | T4 | bikeinfobd | — |
| 0-100 km/h | 10 | s | STOCK? | T4 | bikeinfobd | — |
| Mileage | 25-35 | km/L | STOCK? | T4 | bikeinfobd | — |
| Overall L×W×H | 1965 × 780 × 1040 | mm | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual, §VIII Technical Specifications | yes (bikeinfobd width 735 was wrong; factory says 780) |
| Wheelbase | 1245 | mm | STOCK | T4 | bikeinfobd | — |
| Ground clearance | 136 | mm | STOCK | T4 | bikeinfobd | — |
| Seat height | 765 | mm | STOCK | T4 | bikeinfobd | — |
| Frame type | Double Cradle | — | STOCK | T1 | Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual, §VIII Technical Specifications | — |
| Front suspension | Ceriani type Telescopic Fork, oil damped | — | STOCK | T1 | Wayback capture, §VIII | — |
| Rear suspension | Swinging Arm, Coil Spring, oil damped | — | STOCK | T1 | Wayback capture, §VIII | — |
| Spark plug | BPR 7HS (NGK) or equivalent | — | STOCK | T1 | Wayback capture, §VIII Technical Specifications | yes (parts cat NGK BPR7HS) |
| Gearbox oil | Multigrade 20W/40, 0.65 L | L | STOCK | T1 | Wayback capture, §VI Periodic Maintenance | — |
| Engine oil (2T) | YAMALUBE 2T or 2T oil meeting JASO FC / API TC | — | STOCK | T1 | Wayback capture, §VIII Lubricant Specifications | — |
| Gearbox oil (general) | Multigrade 20W/40 of superior quality | — | STOCK | T1 | Wayback capture, §VIII | — |
| Fuel tank | 10.5 | L | STOCK | T1/T4 | Wayback capture (10.5 Ltr) + bikeinfobd | yes |
| Catalytic converter | Fitted (stock, hot-tube) | — | STOCK | T1 | Wayback capture, §IX Facts Related With Emission Control | yes |
| Engine type | Air-cooled 2-stroke single, 7-port, piston reed intake, Torque Induction, YEIS | — | STOCK | T1 | global.yamaha RX135 page | yes |
| Exhaust (OE) | Catalytic "hot-tube" silencer (big); never came with chrome silencer OE; adds 13–15 kg vs chrome | — | STOCK | T3 | xbhp #89 + Team-BHP (pramodkumar) | yes |
| Exhaust part numbers (4-speed equivalent) | pipe 36LE-4611-00-00; muffler 36LE-4710-10-00 | — | STOCK? | T1 | safexbikes parts cat (4TL1) | unverified for 5-speed |
| Exhaust stock pipe dimensions | NOT FOUND (only qualitative cat-con) | — | — | — | — | — |
| Autolube | Yes (oil pump; 1.2 L side tank) | — | STOCK | T1 | parts cat (assumed) | unverified for 5-speed |
| Stock premix ratio (if pump disabled) | NOT FOUND (owner reports 40-50 ml 2T oil per litre petrol) | — | STOCK? | T4 | bikewale owner (Mukesh Sarode) | single |
| Recommended oil | 2T oil (grade NOT FOUND) | — | — | T4 | owner forums | no |
| Fuel octane | NOT FOUND | RON | — | — | — | — |
| Static ignition timing | NOT FOUND (owner reports stock CDI static ~12° BTDC for RX family) | °BTDC / mm BTDC | UNKNOWN | T4 | reddit r/2Strokes | low confidence |
| Advance curve | NOT FOUND | — | — | — | — | — |
| Ignition timing (official) | NOT FOUND | — | — | — | — | — |

---

## 3. Evidence appendix (non-obvious values)

1. xbhp #89 (karthikdattag, 2018-06-08): "5-Speed - '4TL10' with OEM 'ART' STD piston '4Y201', Rating: 14BHP @ 7500RPM"; "5-Speed: '4TL4 20' with Main Jet = 135 & Pilot Jet = 15.0"; "RX135 5-Speed: '09L' written on inner side of Head"; "Bore Dia = 58mm ... Stroke Length = 50mm"; displacement 132.157 cm³; gear ratios; "RX135 5-Speed: 1L7 XXXXXX"; "The RX135 5-Speed never came with OE fitted Chrome silencer, the OE fit was the Big Hot-Tube type catalytic converter Exhaust." URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6
2. Team-BHP Mr.Boss (2016): "1L7xxxxxx Engine number", "4TL10 Block", "Stock cat-con silencer replaced with Chrome silencer + Fully open RX100 core", "cat con adds an unnecessary 13-15kgs". URL: https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html
3. Team-BHP pramodkumar (2016): "the cat con installation would improve your bike's low end manners."
4. Team-BHP (malvechaitanya, 2008): "standard 4speed ports are 3-4 mm small than the 5 speed ports."
5. bikeinfobd (2026): "MAXIMUM POWER 14 BHP @ 7500 rpm (5 speed)" / "MAXIMUM TORQUE 12.25 NM @ 7000 rpm (5 speed)" / "Compression Ratio 10.1:1" / "Bore & Stroke 58.0 x 55.0 mm" (erroneous — see do-not-use). URL: https://www.bikeinfobd.com/2020/12/Yamaha-RX-135.html
6. Yamaha global Communication Plaza (1996 RX135): "Engine type: Air-cooled, 2-stroke, single-cylinder, 132cm³" / "Maximum power output: 8.9kW (12.0PS) / 6,500r/min" / "Maximum torque: 12.3N·m (1.25kgf·m) / 5,500r/min" / "7-port piston reed intake valve" / "Torque Induction system" / "YEIS". URL: https://global.yamaha-motor.com/showroom/cp/collection/rx135/
7. parts catalogue (safexbikes, 4TL1): "SPARK PLUG-NGK-BPR7HS"; CDI magneto 4TL-H5500-00-00; CDI unit 2YA-H5540-00-00 (superseded 1M1-3002-00); cylinder head 4TL-E1111-10; piston STD 4TL-E1631-00; rings STD 4TL-E1603-00; crank assy 2YA-XE1400-00; exhaust pipe 36LE-4611-00-00; muffler 36LE-4710-10-00; reed valve 2YA-E3610-00-00; head gasket 4TL-E1181-00-00; front sprocket 15 T. URL: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local copy included)
8. pdfcoffee 5-speed manual snippet: "58x50 Compression Ratio..... 10.1:1".
9. Wikipedia RX100 page: "In 2000 Yamaha launched the RX135 5 speed with a large catalytic converter muffler (silencer). It's had a higher compression ratio and different port dimensions." / timeline: RX135 (YEIS) 1998–2000; RX135 5 Speed 2000–2003; RX135 4 Speed (Cat-Con) 2001–2003; RX135 4 Speed (Mini-Cat) 2003–2005. URL: https://en.wikipedia.org/wiki/Yamaha_RX_100
10. xbhp (abhimanyu31, 2011): "RX135 5 speed has significant differences in its ports sizes vis-a-vis the RX135 4 speed. Therefore, it makes more power (no paper its 14bhp)." URL: https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed
11. Instagram (kick_start_biker / Charan Kumar, 2024): RX135 (1L7, 4UU): UCAL Mikuni VM22, pilot VM20/15, main 4/042 hex head/135, needle jet #5ZF6, cutaway 2.0. URL: https://www.instagram.com/reel/C84rFIhhdA5/
12. xbhp spare-parts thread: "both the 135 4s & 5s are on the same VM22 Carb's... the 5S has Oval Venturi whereas the 4S has a round." URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/8726-spare-parts-thread-2-strokes-yamaha-rx-family/page78
13. xbhp post #90 (Anand Deepak, 2018): "In yamaha 135 i2 series kit exhost port height is 2cm. ... Over all sleve height is 11cm. Height from port to upwars is 3 cm. Height from port to bottom is 6 cm." (non-stock replacement kit).
14. Facebook port-map quote (Takumi / RX100 Club Sri Lanka): "Based on the data provided by Yamaha in the port map, the duration of the exhaust is 190 degrees (the exhaust opens 95 degrees before the BDC) and the duration of the transfer is 125 degrees." Variant not stated. URL: https://www.facebook.com/groups/890982621655193/posts/2291144264972348/
15. Takumi RX Engineering Facebook: RX100 G1 exhaust opening ~28 mm from cylinder top; G3 ~30 mm; G4 ~32 mm. (RX100 gens, not RX135 — method precedent only.) URL: https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/
16. Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual (scribd doc 25643028, uploaded by mithunmiranda, 19 pp, "Copyright © Public Domain"): §VIII Technical Specifications prints: "Overall Length (mm) 1965; Overall Width (mm) 780; Overall Height (mm) 1040; Min. Ground Clearance (mm) 136 (Min); Bore and Stroke (mm×mm) 58×50; Compression Ratio 10.4:4; Piston Displacement (cc) 132; Starting System Kick; Maximum Power (BHP) 14.0 at 7,500 rpm; Maximum Torque (kgm) 1.25 at 7,000 rpm; Lubrication Autolube (separate oil pump); Clutch Type Wet, Multiple Disc; Gear Box Type 5-Speed, constant mesh; Gear Ratio 1st 35/11(3.181), 2nd 30/15(2.000), 3rd 26/19(1.368), 4th 24/22(1.091), 5th 22/24(0.917); Frame Double Cradle; Front Tyre Size 2.75" × 18"-4PR (Ribbed); Rear Tyre Size 3.00" × 18"-6PR (Universal); Front Suspension Ceriani type Telescopic Fork, oil damped; Rear Suspension Swinging Arm, Coil Spring, oil damped; Spark Plug BPR 7HS (NGK) or equivalent; Fuel Tank 10.5 Ltr; Gear Box Oil 0.65 Ltr (Multigrade 20W/40); 2T Oil YAMALUBE 2T or JASO FC/API TC." Also §VI Periodic Maintenance: chain slackness 20-30 mm; remove carbon from cylinder/cylinder head/piston rings/exhaust port every 5,000 km; replace spark plug every 10,000 km. Capture URL: https://web.archive.org/web/20251126184451/https://www.scribd.com/document/25643028/rx-135-5speed-manual
17. xbhp spare-parts thread (karthikdattag, 2010-2011): "Crank shaft assembly (with '2YA' connecting rod) - RX135 (4 & 5 Speed)/RXG/RX-Z (4 & 5 Speed)" (confirms same crank/rod across variants); "Head Assembly (09L) - RX135 5-Speed"; "Ignition kit [90/100 Kit] (Includes the Magnet, CDI, RR Unit & Base) - RX100/RX135/RXG/RX-Z (4 & 5-Speed versions)" (confirms CDI shared 4 & 5 speed); "2-T Oil Pump assembly (Big & Small)" (big = 4-speed/early, small = 5-speed). URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/8726-spare-parts-thread-2-strokes-yamaha-rx-family/page13 (post #187).
16. Wayback capture of Escorts Yamaha RX-135 5-Speed Owner's Manual (scribd doc 25643028, uploaded by mithunmiranda, 19 pp, "Copyright © Public Domain"): §VIII Technical Specifications prints: "Overall Length (mm) 1965; Overall Width (mm) 780; Overall Height (mm) 1040; Min. Ground Clearance (mm) 136 (Min); Bore and Stroke (mm×mm) 58×50; Compression Ratio 10.4:4; Piston Displacement (cc) 132; Starting System Kick; Maximum Power (BHP) 14.0 at 7,500 rpm; Maximum Torque (kgm) 1.25 at 7,000 rpm; Lubrication Autolube (separate oil pump); Clutch Type Wet Multiple Disc; Gear Box Type 5-Speed constant mesh; Gear Ratio 1st 35/11 (3.181), 2nd 30/15 (2.000), 3rd 26/19 (1.368), 4th 24/22 (1.091), 5th 22/24 (0.917); Frame Double Cradle; Front Tyre Size 2.75" × 18"-4PR (Ribbed); Rear Tyre Size 3.00" × 18"-6PR (Universal); Front Suspension Ceriani type Telescopic Fork oil damped; Rear Suspension Swinging Arm, Coil Spring, oil damped; Spark Plug BPR 7HS (NGK) or equivalent; Fuel Tank 10.5 Ltr; Gear Box Oil (Multigrade 20W/40) 0.65 Ltr; 2T oil YAMALUBE 2T or JASO FC/API TC." Also §VI Periodic Maintenance: chain slackness 20-30 mm; gearbox oil Multigrade 20W40 0.65 L; remove carbon from cylinder/cylinder head/piston rings/exhaust port every 5000 km; replace spark plug every 10000 km. Capture URL: https://web.archive.org/web/20251126184451/https://www.scribd.com/document/25643028/rx-135-5speed-manual

---

## 4. Media inventory

| Item | URL / local path | Shows | Stock? |
|---|---|---|---|
| Port map (user-supplied) | local: `rx135_5speed_portmap.png` (1144×701) | 5-speed port layout scan; datum to be verified (likely cylinder top face) | UNKNOWN — verify against stock block |
| Port map (user-supplied) #2 | local: `rx135_5speed_portmap_2.png` (1235×763) | Second 5-speed port map variant | UNKNOWN |
| Escorts Yamaha RX-135 5-Speed Owner's Manual (19 pp, scanned) | Wayback capture: https://web.archive.org/web/20251126184451/https://www.scribd.com/document/25643028/rx-135-5speed-manual ; original scribd: https://www.scribd.com/document/25643028/rx-135-5speed-manual | Factory owner's manual: §VIII Technical Specifications (CR 10.4:1, 14.0 BHP @ 7500, 1.25 kgm @ 7000, 58×50, 132 cc, tyres, frame, suspension, spark plug BPR 7HS, capacities), §VI periodic maintenance, emission control | STOCK |
| Yamaha official RX135 archive page | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | 1996 RX135 specs (12 PS, 12.3 Nm), 132 cc, 7-port reed, YEIS | STOCK |
| Parts catalogue RX135 (4TL1) | local: `rx135_parts_catalogue_4TL1.pdf` (also https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf) | Full parts diagrams + part numbers, 4-speed early | STOCK |
| Scribd RX135 parts catalogue (4TL6) | https://www.scribd.com/document/661417869/4TL6-PC | 5-speed parts catalogue (not extracted) | STOCK |
| Scribd 5-speed manual (scanned images) | https://www.scribd.com/document/672845250/toaz-info-rx-135-5speed-manual-pr-... | Scanned manual images (not OCR'd) | STOCK |
| Scribd RX/RXZ 135 5-speed port maps (Arunava Pramanick) | https://www.scribd.com/document/508987019/... | Port map image, no dimensions ("Without Dimensions") | STOCK (map) |
| Scribd RX/RXZ 135 5-speed port maps (alt) | https://www.scribd.com/document/508985012/Yamaha-RX-RXZ-135-5-Speed-Port-Maps | Same | STOCK |
| Scribd 5-speed manual (earlier) | https://www.scribd.com/document/25643028/rx-135-5speed-manual | Owner's manual (19 pp, scanned) — now captured via Wayback; contains specs, service schedule, emission control; NO port timing, head volume, or squish data | STOCK |
| Service/workshop manual (RX135 5-speed) | NOT FOUND online in text-extractable form (scribd/pdfcoffee copies are scanned images; emanuals.com is paywalled) | — | — |
| Scribd 5-speed specs manual | https://www.scribd.com/document/608461041/RX-135-5-SPEED-Specs-Manual | Specs | STOCK |
| Scribd 4 vs 5 speed comparison | https://www.scribd.com/document/246200975/Bare-kit | Component differences (includes modified bike) | Mixed |
| xbhp differences thread | https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/12279-differences-similarities-between-135cc-rx-series/page6 | Karthikdattag's component delta (T3) | STOCK |
| xbhp 4 vs 5 speed thread | https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed | Owner comparisons, 14 bhp claim, model years | T3/T4 |
| Team-BHP RX135 5-speed thread | https://www.team-bhp.com/forum/motorbikes/180408-rx-madness-continues-my-yamaha-rx135-5-speed.html | Owner restoration, photos | MODIFIED (disc brake, alloy wheels, chrome silencer swap) |
| Team-BHP porting thread | https://www.team-bhp.com/forum/motorbikes/36510-advance-porting-exhaust-port-degree.html | Porting discussion, 4 vs 5 speed port size | MODIFIED |
| YouTube porting/restoration | https://www.youtube.com/watch?v=-32ZACaTIBs | RX135 porting teardown | MODIFIED |
| Instagram port-timing reel | https://www.instagram.com/reel/C76h_jWhghq/ | Port timing basics | Unknown |
| Instagram carb spec sheet | https://www.instagram.com/reel/C84rFIhhdA5/ | Carb jetting by variant | T3 |
| Facebook Takumi workshop | https://www.facebook.com/groups/yamahaenthusiasts/posts/27419532214408731/ | Measured port heights/timing (not accessible) | UNKNOWN |
| Facebook Takumi RX Engineering | https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/ | Measured RX100-gen cylinder port heights/timings | T3 (RX100 gens, not RX135) |
| safexbikes parts catalogue (4TL1) | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf | Parts, diagrams | STOCK |

---

## 5. 4-speed vs 5-speed delta (sourced)

| Item | 4-speed (Variant A) | 5-speed (Variant B) | Source |
|---|---|---|---|
| Model years | YEIS 1998–2000; cat-con 2001–2003; mini-cat 2003–2005 | 2000–2003 | Wikipedia (T1) |
| Cylinder block | 4TL00 | 4TL10 | xbhp #89 |
| Cylinder head | 4TL00 (chrome) / 4TL5 (cat) | 09L | xbhp #89 |
| Carb (code) | 4TL 01 | 4TL4 20 | xbhp #89 |
| Main jet | 165 | 135 | xbhp #89 + Instagram |
| Pilot jet | 17.5 (VM22) | 15.0 (VM20) | xbhp #89 + Instagram |
| Needle jet | #4J26 | #5ZF6 | Instagram |
| Carb venturi | 22 (round) | 22 (oval) | xbhp spare-parts thread |
| Rated power | 12 BHP @ 6500 (factory: 12 PS @ 6500) | 14 BHP @ 7500 | xbhp #89; global.yamaha |
| Rated torque | 10.0 Nm @ 6500 (bikeinfobd) / 12.3 Nm @ 5500 (factory 1996) | 12.25 Nm @ 7000 | bikeinfobd; global.yamaha |
| Ports | 4-speed ports 3-4 mm smaller than 5-speed | larger ports | Team-BHP 2008 |
| Compression ratio | 10.1:1 (bikeinfobd, T4) | 10.1:1 (bikeinfobd + manual snippet); higher than 4-speed qualitatively | bikeinfobd; Wikipedia |
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
| Autolube | Yes | Yes | — |
| Spark plug | NGK BPR7HS | NGK BPR7HS (assumed) | parts cat |
| CDI | 4TL-H5500-00-00 / 2YA-H5540-00-00 | likely same family; not confirmed | parts cat (4TL1) |
| Exhaust p/n | 36LE-4611-00-00 / 36LE-4710-10-00 | not published (4TL6 not extracted) | parts cat |

---

## 6. Gap list (ranked by simulation impact)

| Rank | Missing parameter | Impact | Cheapest physical measurement |
|---|---|---|---|
| 1 | Port timing (°BTDC/ATDC, durations, heights) for stock 5-speed | Highest | Digitise supplied port-map PNGs with calibrated datum (cylinder top face / gasket face); measure port top-edge heights with depth gauge on stock barrel |
| 2 | Exhaust port type (single/dual/bridged) + auxiliary port geometry | High | Visual inspection + port map trace |
| 3 | Combustion chamber volume (cc) and squish clearance/band | High (CR verification) | Burette (volume) + feeler gauge (squish) on stock head/piston at TDC |
| 4 | Connecting rod length confirmation (98 mm) | Medium | Direct measurement of a stock rod |
| 5 | Ignition static timing (°BTDC and mm BTDC) + advance curve | Medium | Strobe timing light on stock bike at idle; degree wheel + dial gauge |
| 6 | CDI part number (5-speed specific, 4TL6) | Medium | Read part number off stock CDI unit |
| 7 | Carb needle/clip/slide cutaway/float height/air-screw (already have needle jet #5ZF6 and cutaway 2.0; need clip position, float height, air-screw turns) | Medium | Disassemble stock carb, read stamped numbers |
| 8 | Exhaust stock pipe dimensions (header, cones, belly, stinger) | Medium-High (pipe "comes on" rpm) | Measure a stock cat-con silencer with tape/calipers |
| 9 | Piston compression height, gudgeon pin Ø, deck height, base/head gasket thickness | Medium | Measure stock piston and gaskets |
| 10 | Service wear limits (clearances, ring end gap, torque specs) | Low-Medium | Factory manual (not yet accessed in text-extractable form) |
| 11 | Trapped CR | Medium | Compute from port timing once available |
| 12 | Full power/torque curve (not just discrete points) | Medium (validation) | Dyno a stock 5-speed |

---

## 7. Do-not-use list (demonstrably wrong / recycled)

| Value found online | Why reject | Better source |
|---|---|---|
| bikeinfobd "Bore & Stroke 58.0 × 55.0 mm" | Inconsistent with 132 cc displacement (58×55 = ~145 cc); contradicts xbhp/pdfcoffee/factory manual "58×50" | xbhp #89 + factory owner's manual (T1) |
| bikeinfobd "Compression Ratio 10.1:1" | Factory owner's manual (T1) states 10.4:1; 10.1 was a T4/OCR error | Wayback capture of Escorts Yamaha owner's manual |
| bikeinfobd "Overall Width 735 mm" | Factory owner's manual (T1) states 780 mm | Wayback capture of Escorts Yamaha owner's manual |
| bikeinfobd 4-speed "12 BHP @ 7500 rpm" | Factory (global Yamaha) states 12.0 PS @ 6500 rpm; xbhp #89 states 12 BHP @ 6500 | global.yamaha-motor.com (T1) |
| bikeinfobd torque line "12.2 PS @ 7500 rpm" | Nonsense (PS is power, not torque); torque is 12.25 Nm @ 7000 | bikeinfobd's own "12.25 NM @ 7000" line |
| Factory global page torque 12.3 Nm @ 5500 for "1996 RX135" | Likely 4-speed/early unit; do not apply to 5-speed (5-speed torque 12.25 Nm @ 7000) | bikeinfobd + xbhp for 5-speed |
| "VM26 carb stock on Indian RX135" | Indian stock is VM22 (4TL 01 / 4TL4 20); VM24/VM26 are SEA/South America and aftermarket | xbhp #89 |
| "RX135 makes 14 bhp @ 6500" | 5-speed is 14 BHP @ 7500, not 6500 | xbhp #89 |
| "98 mm rod" applied to RX100/RX135 interchangeably | Rod length consensus is 98 mm for RX135; RX100 differs (shorter stroke) — do not transfer geometry | — |
| RX-King 135 (Indonesia) power 17.5–18.5 PS @ 8750–9000 rpm | Indonesian market, different engine lineage; do NOT apply to Indian RX135 | Wikipedia RX-King (out of scope) |
| "190° exhaust / 125° transfer" as if RX135-specific | Cited from a generic Yamaha port-map quote; variant (RX100 vs RX135, and which generation) is not stated | Facebook port-map quote (T3/T4) |
| RX100 port heights (28/30/32 mm from cylinder top) applied to RX135 | Measured on RX100 G1/G3/G4 cylinders by Takumi; RX135 has a different (132 cc) cylinder | Takumi Facebook (T3) |
| 5-speed power "15.2 bhp @ 8500 rpm, 13.5 Nm @ 8000 rpm" | Facebook owner claim, no factory source; conflicts with "14 bhp" forum claim | Facebook (T4) |
| Chamber volume "22 cc" | Single unsourced Facebook mention; treat as unverified | Facebook (T4) |
| Top-gear ratio "same between 4s and 5s" | Owner speculation on xbhp | xbhp (T4) |
| Tyre size for 5-speed | Assumed from RX-King; not confirmed for Indian 5-speed | T2 (platform assumption) |
| "NGK iridium" as stock plug | Parts catalogue specifies NGK BPR7HS (copper); iridium is aftermarket | parts catalogue (T1) |
| "Stock RX135 exhaust port opens at X° BTDC" values from ported builds | Modified; Team-BHP 2008 post describes porting to 5-speed spec then lifting ports further — not stock | — |

---

## 8. Query log (searches run)

Factory / manuals:
1. "Yamaha RX135 Indian service manual PDF 132cc"
2. "Yamaha RX135 India parts catalogue cylinder head piston part number"
3. "Yamaha RX135 4 speed vs 5 speed India engine differences"
4. "Yamaha RX135 India engine code frame prefix VIN"
5. "Yamaha RX135 India model years 4-speed 5-speed launched discontinued"
6. "archive.org Yamaha RX 135 service manual workshop"
7. "manualslib.com Yamaha RX135 service manual"
8. Fetched safexbikes parts catalogue PDF: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local copy included)
9. Fetched Yamaha official RX135 archive page: https://global.yamaha-motor.com/showroom/cp/collection/rx135/
10. Fetched Wikipedia RX100 page
11. Fetched Wikipedia RX-King page

Port timing / porting:
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

Compression:
22. "Yamaha RX135 compression ratio trapped geometric cc chamber volume"

Carburetion:
23. "RX135 Indian carburetor Mikuni model jetting main pilot needle"
24. "RX135 5-speed carburetor VM22 oval venturi main jet pilot jet"
25. Fetched Instagram carb spec sheet (kick_start_biker)
26. Fetched xbhp spare-parts thread (VM22 round vs oval)

Ignition:
27. "RX135 5-speed CDI part number ignition timing degrees BTDC"
28. "Yamaha RX135 India ignition timing specification degrees BTDC"
29. "Yamaha RX135 service manual ignition timing"

Exhaust:
30. "RX135 stock pipe dimensions header diffuser belly stinger" (no results; covered via parts cat)

Performance / drivetrain:
31. "Yamaha RX135 5-speed power 14 bhp 7000 rpm official"
32. Fetched xbhp "RX 135 4 speed or 5 speed" thread
33. Fetched Wikipedia RX100 (timeline, 5-speed CR/ports)
34. "RX135 Indian service manual gear ratios primary reduction" (no results)

Scribd / port maps:
35. Fetched Scribd 5-speed manual page (images only)
36. Fetched Scribd Arunava port maps page
37. Fetched Scribd 4TL6 parts catalogue page
38. Fetched Scribd bare-kit 4 vs 5 speed comparison page

Additional:
39. "RX135 Indian parts catalogue 4TL6 5-speed"
40. "Yamaha RX135 engine number series Indian models"
41. "RX135 4-speed cat-con mini-cat differences"
42. "Yamaha RX135 service manual ignition timing mm BTDC"

Note: web search engines (Google/Bing/DuckDuckGo) returned challenge pages for several queries late in the session; those queries were re-run via the websearch tool where possible. All URLs above were actually fetched or returned as search hits.

---

## 9. Notes for the MATLAB model (Variant B)

- Use bore 58 mm, stroke 50 mm, rod 98 mm, CR 10.4:1 (factory T1) as the baseline geometry. Confirm rod length by physical measurement before finalising rod ratio (currently T3/T4 consensus). Chamber volume still NOT FOUND — burette the head to derive trapped CR.
- Port timing is the dominant unknown: the supplied port-map PNGs must be digitised (measure port top-edge heights from cylinder top face and from BDC) to derive opening angles. Do not use the non-stock "i2 series" 20 mm port height or the generic "190°/125°" quote as stock.
- Stock exhaust is the heavy cat-con (hot-tube) unit; if the simulation targets a stock bike, model the cat-con (13–15 kg extra, low-end favouring). If modelling a "chrome silencer" build, that is a MODIFIED configuration.
- Power validation target: 14.0 BHP @ 7,500 rpm (T1, factory owner's manual), 1.25 kgm (12.26 Nm) @ 7,000 rpm, top speed 130 km/h (T4), 0-60 3.5 s (T4).
- Ignition: model as static ~12° BTDC (owner-reported, T4) pending measurement; advance curve NOT FOUND.
- Carb jetting baseline: main 135, pilot 15.0, VM22 oval, needle jet #5ZF6, cutaway 2.0. Clip position, float height, air-screw turns NOT FOUND — measure a stock carb.
- Autolube stock; if simulating pre-mix, use 40-50 ml 2T oil per litre petrol (owner-reported, T4).
- CDI: use 4-speed equivalent (2YA-H5540-00-00) only as a placeholder; confirm against the 4TL6 parts catalogue or a physical unit.
- Service (from owner's manual, T1): chain slackness 20-30 mm; gearbox oil Multigrade 20W40, 0.65 L; remove carbon from cylinder/cylinder head/piston rings/exhaust port every 5,000 km; replace spark plug every 10,000 km; periodic maintenance every 3,000 km (clean air filter, tune carb, check/adjust clutch, front/rear brakes, throttle cable, telescopic fork, steering, wheel spokes, electricals, tyre pressure, lubricate pivots, check CO at idle, check oil pump operation & bleeding, check/clean fuel tank). Preventive: S.No. 1-2-6 & 26 every 3,000 km; S.No. 22 & 7 every 5,000 km; S.No. 23 & 24 every 6,000 km; S.No. 25 every 12,000 km. Tyre pressure: single rider front 22 psi? (OCR garbled — 1.55 kg/cm²) / rear 32 psi? (OCR garbled); double rider rear 32 psi? (OCR garbled). Values present in manual but transcription unreliable — verify from a clean copy.

---
*End of dataset. All values tagged; NOT FOUND entries are intentional and must not be filled from rules of thumb.*
