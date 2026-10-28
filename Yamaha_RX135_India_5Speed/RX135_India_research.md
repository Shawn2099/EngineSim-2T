# Yamaha RX135 — Indian Market — Verified Parameter Dataset (research)

Folder: `Yamaha_RX135_India/`. Scope: Indian-market 132 cc air-cooled two-stroke only. Excluded: RX-King 135 (Indonesia), RX135 Thailand/SEA, RX-Z Malaysia, RX115, RX100, and any non-Indian RX135.

Variants investigated independently:
- **Variant A — RX135 4-speed** (Indian): YEIS 1998–2000, cat-con 2001–2003, mini-cat 2003–2005.
- **Variant B — RX135 5-speed** (Indian): 2000–2003, higher CR, different port dimensions, large catalytic-converter silencer.

Source tiers: T1 = Yamaha factory manual/owner manual/parts catalogue/official archive; T2 = independent dyno/measured teardown/technical article; T3 = forum post with actual measurement/photo/part number by named user with date; T4 = blog/video/marketplace/unsourced. CORROBORATED = two independent sources agree.

Confidence < 70% is stated in-row. NOT FOUND = not located; no invented values.

---

## 1. Executive summary

**Variant A (4-speed):** Solid: identity, model years, bore/stroke/displacement, official power/torque (Yamaha), parts catalogue part numbers (cylinder head, piston, rings, crank, carb assembly, exhaust, CDI magneto, CDI unit, spark plug, reed valve, sprockets), carb jetting for two sub-variants (early 4TL1 and later 4TL1L7/4UU), tyre size. Thin: port timing (only generic RX-series numbers, variant unspecified), compression (only a T4 mention of 22 cc chamber), ignition timing, exhaust dimensions, gear ratios. Missing: connecting rod length, piston compression height, gudgeon pin Ø, deck height, gasket thicknesses, trapped CR, squish, service wear limits, torque specs.

**Variant B (5-speed):** Solid: identity, model years, bore/stroke/displacement (same base), carb type (VM22 oval venturi), parts catalogue reference (4TL6). Thin: power (owner/magazine claims only, no factory spec found), port timing (generic/unverified), compression (higher CR stated but no number). Missing: all geometry beyond bore/stroke, carb jetting exact, CDI part numbers, ignition timing, exhaust dimensions, gear ratios, service limits.

**Do-not-use / recycled values:** See §7. The most dangerous circulating numbers are the RX-King/RX-Z power figures (17–18 PS) and Indonesian engine data, which are NOT the Indian 132 cc unit's spec; and the generic "190° exhaust / 125° transfer" port-timing figure whose variant attribution is unverified.

---

## 2. Parameter tables

### 2A — Variant A: RX135 4-speed (India)

| Parameter | Value | Unit | STOCK/MODIFIED | Tier | Source URL | Corroborated? |
|---|---|---|---|---|---|---|
| Model years (YEIS) | 1998–2000 | yr | STOCK | T1 (Wikipedia, cited) | https://en.wikipedia.org/wiki/Yamaha_RX_100 | yes (multiple owner sources) |
| Model years (cat-con) | 2001–2003 | yr | STOCK | T3 | https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed | no |
| Model years (mini-cat) | 2003–2005 | yr | STOCK | T3 | https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed | no |
| Engine code / parts line | 4TL (4TL1, 4TL2) | — | STOCK | T1 | safexbikes parts catalogue PDF (local) | yes (parts cat) |
| Displacement | 132 | cc | STOCK | T1 | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | yes (Wikipedia) |
| Bore | 58.0 | mm | STOCK | T2 | https://en.wikipedia.org/wiki/Yamaha_RX-King_135 (Indian RX-135 variant) | yes |
| Stroke | 50.0 | mm | STOCK | T2 | https://en.wikipedia.org/wiki/Yamaha_RX-King_135 | yes |
| Connecting rod length (c-c) | NOT FOUND | mm | — | — | — | — |
| Crank throw | 25.0 (derived = stroke/2) | mm | DERIVED | — | derived from stroke | not measured |
| Piston compression height | NOT FOUND | mm | — | — | — | — |
| Gudgeon pin diameter | NOT FOUND | mm | — | — | — | — |
| Deck height at TDC | NOT FOUND | mm | — | — | — | — |
| Base gasket thickness | NOT FOUND | mm | — | — | — | — |
| Head gasket/o-ring | "GASKET CYL. HEAD" p/n 4TL-E1181-00-00 (4TL1) | — | STOCK | T1 | safexbikes parts catalogue | no |
| Head gasket thickness | NOT FOUND | mm | — | — | — | — |
| Claimed CR (manual) | NOT FOUND (no number printed found) | — | — | — | — | — |
| Geometric CR | NOT FOUND | — | — | — | — | — |
| Trapped CR | NOT FOUND | — | — | — | — | — |
| Combustion chamber volume | ~22 (T4 mention: "factory head is 22cc") | cc | STOCK? | T4 | Facebook group post (compression discussion) | no (single unsourced) |
| Squish clearance | NOT FOUND | mm | — | — | — | — |
| Squish band width | NOT FOUND | mm | — | — | — | — |
| Chamber/dome shape | NOT FOUND (photo needed) | — | — | — | — | — |
| Exhaust port type | NOT FOUND (assumed single, unverified) | — | — | — | — | — |
| Exhaust port height from cyl top | NOT FOUND for RX135 (RX100 G1 ~28, G3 ~30, G4 ~32 mm measured by Takumi, T3) | mm | — | T3 | https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/ (RX100 gens) | no (different model) |
| Exhaust port opening angle | 95° BTDC (generic RX port-map data; variant unspecified) | ° | UNKNOWN variant | T3/T4 | Facebook "port timing vs port size" posts | no |
| Exhaust port duration | 190 | crank ° | UNKNOWN variant | T3/T4 | Facebook port-map quote | no |
| Transfer port duration | 125 | crank ° | UNKNOWN variant | T3/T4 | Facebook port-map quote | no |
| Inlet type | Piston reed (reed valve) + YEIS, 7-port | — | STOCK | T1 | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | yes |
| Carb make/model | Mikuni VM22 (early 4TL1, round venturi); UCAL Mikuni VM22 (later 4TL1L7/4UU) | — | STOCK | T1/T3 | Instagram carb spec sheet; parts cat 4TL1 | yes |
| Carb venturi | 22 | mm | STOCK | T3 | carb model VM22 | yes (by model designation) |
| Pilot jet (early) | VM22 / 17.5 | — | STOCK | T3 | Instagram (kick_start_biker) | no |
| Main jet (early) | Hex head / 165 | — | STOCK | T3 | Instagram | no |
| Needle jet (early) | #4J26 | — | STOCK | T3 | Instagram | no |
| Slide cutaway (early) | 2.0 | — | STOCK | T3 | Instagram | no |
| Pilot jet (later) | VM20 / 15 | — | STOCK | T3 | Instagram (1L7/4UU) | no |
| Main jet (later) | Hex head / 135 | — | STOCK | STOCK | Instagram | no |
| Needle jet (later) | #5ZF6 | — | STOCK | T3 | Instagram | no |
| Carb assembly p/n (early) | 4TL1-4101-01-00 (superseded 1L5-6500-00) | — | STOCK | T1 | safexbikes parts cat | no |
| Reed valve p/n | 2YA-E3610-00-00 (REED VALVE ASSY) | — | STOCK | T1 | safexbikes parts cat | no |
| CDI magneto p/n | 4TL-H5500-00-00 | — | STOCK | T1 | safexbikes parts cat | no |
| CDI unit p/n | 2YA-H5540-00-00 (superseded 1M1-3002-00) | — | STOCK | T1 | safexbikes parts cat | no |
| Spark plug | NGK BPR7HS | — | STOCK | T1 | safexbikes parts cat | no |
| Spark plug gap | NOT FOUND | mm | — | — | — | — |
| Static ignition timing | NOT FOUND | °BTDC / mm BTDC | — | — | — | — |
| Advance curve | NOT FOUND | — | — | — | — | — |
| Exhaust pipe assembly p/n | 36LE-4611-00-00 | — | STOCK | T1 | safexbikes parts cat | no |
| Muffler p/n | 36LE-4710-10-00 (RX/RXG) | — | STOCK | T1 | safexbikes parts cat | no |
| Exhaust dimensions (header/diffuser/belly/stinger) | NOT FOUND | mm | — | — | — | — |
| Catalyser | Early YEIS: none; later cat-con / mini-cat | — | STOCK | T3 | Wikipedia/xbhp | yes |
| Autolube | Yes (oil pump fitted) | — | STOCK | T1 | safexbikes parts cat (oil pump) | yes |
| Stock premix ratio (if pump disabled) | NOT FOUND | — | — | — | — | — |
| Recommended oil | 2T oil (specific grade NOT FOUND) | — | — | T4 | owner forums | no |
| Fuel octane | NOT FOUND | RON | — | — | — | — |
| Claimed power | 8.9 kW (12 PS) @ 6500 rpm | kW/PS | STOCK (factory) | T1 | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | yes (Wikipedia RX100 page) |
| Claimed torque | 12.3 N·m @ 5500 rpm | N·m | STOCK | T1 | Yamaha official RX135 collection page | yes |
| Top speed (owner) | ~102 | km/h | STOCK | T4 | Team-BHP forum | no |
| Fuel consumption (owner) | 30–40 | kmpl | STOCK | T4 | owner forums | no |
| Primary reduction ratio | NOT FOUND | — | — | — | — | — |
| Gear ratios (4-speed) | NOT FOUND | — | — | — | — | — |
| Final drive sprockets | Front 15 teeth; rear p/n 4TL-F5437-00-00 | teeth | STOCK | T1 | safexbikes parts cat | no |
| Tyre size | F 2.75-18, R 3.00-18 | — | STOCK | T2 | Wikipedia RX-King (Indian variant) | yes |
| Piston-to-bore clearance | NOT FOUND | mm | — | — | — | — |
| Ring end gap | NOT FOUND | mm | — | — | — | — |
| Bore wear limit | NOT FOUND | mm | — | — | — | — |
| Torque specs | NOT FOUND | N·m | — | — | — | — |

### 2B — Variant B: RX135 5-speed (India)

| Parameter | Value | Unit | STOCK/MODIFIED | Tier | Source URL | Corroborated? |
|---|---|---|---|---|---|---|
| Model years | 2000–2003 | yr | STOCK | T1 (Wikipedia) | https://en.wikipedia.org/wiki/Yamaha_RX_100 | yes (xbhp) |
| Engine code / parts line | 4TL (4TL6 parts catalogue) | — | STOCK | T1 | Scribd 4TL6-PC (parts cat) | yes |
| Displacement | 132 | cc | STOCK | T1 | Yamaha official / Wikipedia | yes |
| Bore | 58.0 | mm | STOCK | T2 | Wikipedia RX-King | yes |
| Stroke | 50.0 | mm | STOCK | T2 | Wikipedia RX-King | yes |
| Connecting rod length (c-c) | NOT FOUND | mm | — | — | — | — |
| Crank throw | 25.0 (derived) | mm | DERIVED | — | derived | not measured |
| Piston compression height | NOT FOUND | mm | — | — | — | — |
| Gudgeon pin diameter | NOT FOUND | mm | — | — | — | — |
| Deck height at TDC | NOT FOUND | mm | — | — | — | — |
| Base/head gasket thickness | NOT FOUND | mm | — | — | — | — |
| Claimed CR (manual) | NOT FOUND (number) | — | — | — | — | — |
| CR vs 4-speed | Higher than 4-speed (qualitative) | — | STOCK | T1 | Wikipedia RX100 page ("It's had a higher compression ratio and different port dimensions") | yes (xbhp) |
| Geometric/trapped CR | NOT FOUND | — | — | — | — | — |
| Combustion chamber volume | NOT FOUND | cc | — | — | — | — |
| Squish | NOT FOUND | mm | — | — | — | — |
| Port dimensions | Different from 4-speed (qualitative); no mm published | — | STOCK | T1/T3 | Wikipedia; xbhp ("significant differences in ports sizes") | yes |
| Exhaust port height / timing | NOT FOUND (no measured numbers for 5-speed) | — | — | — | — | — |
| Generic exhaust duration 190° / transfer 125° | NOT verified for 5-speed | crank ° | UNKNOWN | T3/T4 | Facebook port-map quote | no |
| Inlet type | Piston reed + YEIS (7-port) | — | STOCK | T1 | Yamaha official | yes |
| Carb make/model | Mikuni VM22 with oval venturi (vs round on 4-speed) | — | STOCK | T3 | xbhp spare-parts thread | no |
| Carb venturi | 22 | mm | STOCK | T3 | model designation | yes |
| Main/pilot jet, needle | NOT FOUND (jetting for 5-speed not published in sources found) | — | — | — | — | — |
| Air filter | NOT FOUND | — | — | — | — | — |
| CDI part number | NOT FOUND | — | — | — | — | — |
| Spark plug | NOT FOUND (likely NGK BPR7HS/BPR8HS, unverified) | — | — | — | — | — |
| Static ignition timing | NOT FOUND | °BTDC | — | — | — | — |
| Exhaust | Large catalytic-converter silencer (stock) | — | STOCK | T1 | Wikipedia RX100 page | yes |
| Exhaust dimensions | NOT FOUND | mm | — | — | — | — |
| Autolube | Yes | — | STOCK | T1 | parts cat 4TL6 (assumed) | unverified |
| Stock premix ratio (if pump disabled) | NOT FOUND | — | — | — | — | — |
| Claimed power (factory) | NOT FOUND (no official factory figure located) | kW/PS | — | — | — | — |
| Power (owner/magazine) | ~14 bhp (claimed); 15.2 bhp @ 8500 rpm, 13.5 N·m @ 8000 rpm | bhp/N·m | STOCK? | T4 | Facebook "rx 135 5 speed top speed"; xbhp | no |
| Top speed | NOT FOUND (owners report "quickest RX") | km/h | — | T4 | forums | no |
| Fuel consumption | NOT FOUND | kmpl | — | — | — | — |
| Primary reduction | NOT FOUND | — | — | — | — | — |
| Gear ratios (5-speed) | NOT FOUND | — | — | — | — | — |
| Final drive sprockets | NOT FOUND | teeth | — | — | — | — |
| Tyre size | F 2.75-18, R 3.00-18 (assumed same) | — | STOCK? | T2 | Wikipedia RX-King | unverified for 5-speed |
| Service wear limits | NOT FOUND | — | — | — | — | — |

---

## 3. Evidence appendix (non-obvious values)

- **Power/torque 4-speed (T1):** Yamaha Communication Plaza RX135 page: "Maximum power output: 8.9kW (12.0PS) / 6,500r/min; Maximum torque: 12.3N·m (1.25kgf·m) / 5,500r/min." URL: https://global.yamaha-motor.com/showroom/cp/collection/rx135/. Also Wikipedia RX100 page cites "RX135 was launched in 1998 with the same engine as the RXZ but using the same chassis as the RX 100... RX135 saw moderate success." — T1 (official Yamaha archive).

- **5-speed higher CR / different ports (T1):** Wikipedia RX100: "In 2000 Yamaha launched the RX135 5 speed with a large catalytic converter muffler (silencer). It's had a higher compression ratio and different port dimensions." URL: https://en.wikipedia.org/wiki/Yamaha_RX_100.

- **5-speed 14 bhp (T3/T4):** xbhp forum user abhimanyu31: "RX135 5 speed has significant differences in its ports sizes vis-a-vis the RX135 4 speed. Therefore, it makes more power (no paper its 14bhp)." URL: https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed. Dated 2011.

- **Port map 190° exhaust / 125° transfer (T3/T4):** Facebook post (Takumi RX Engineering / RX100 Club Sri Lanka): "Based on the data provided by Yamaha in the port map, the duration of the exhaust is 190 degrees (the exhaust opens 95 degrees before the BDC) and the duration of the transfer is 125 degrees." Variant not stated; may be RX100-generation data. URL: https://www.facebook.com/groups/890982621655193/posts/2291144264972348/.

- **Exhaust port heights from cylinder top (RX100 gens, T3):** Takumi RX Engineering Facebook post: G1 exhaust opening ~28 mm from cylinder top; G3 ~30 mm; G4 ~32 mm (vs ~27 mm on G1). These are RX100-generation cylinders, NOT RX135; cited only as method precedent. URL: https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/.

- **Carb jetting (T3):** Instagram post by kick_start_biker (Charan Kumar), 2024: RX135(1L3,1L5,4TL): Mikuni VM22, pilot VM22/17.5, main 4/042 hex head/165, needle jet #4J26, cutaway 2.0. RX135(1L7,4UU): UCAL Mikuni VM22, pilot VM20/15, main 4/042 hex head/135, needle jet #5ZF6, cutaway 2.0. URL: https://www.instagram.com/reel/C84rFIhhdA5/.

- **VM22 oval vs round venturi (T3):** xbhp spare-parts thread: "both the 135 4s & 5s are on the same VM22 Carb's... the 5S has Oval Venturi whereas the 4S has a round." URL: https://www.xbhp.com/talkies/thumpers-2-stroke-and-exotics/8726-spare-parts-thread-2-strokes-yamaha-rx-family/page78.

- **Spark plug (T1):** safexbikes parts catalogue: "SPARK PLUG-NGK-BPR7HS" (4TL1). URL: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf.

- **CDI (T1):** safexbikes parts catalogue 4TL1: CDI magneto 4TL-H5500-00-00; CDI unit 2YA-H5540-00-00 (superseded 1M1-3002-00). Same source.

- **Cylinder head / piston p/n (T1):** safexbikes parts catalogue 4TL1: cylinder head 4TL-E1111-10; piston STD 4TL-E1631-00; piston rings STD 4TL-E1603-00; crank assy 2YA-XE1400-00. Same source.

- **Exhaust p/n (T1):** safexbikes parts catalogue 4TL1: pipe exhaust assy 36LE-4611-00-00; muffler 36LE-4710-10-00. Same source.

- **Tyre size (T2):** Wikipedia RX-King: F 2.75-18, R 3.00-18. Applied to Indian RX135 as same platform (unverified for 5-speed).

- **Front sprocket (T1):** safexbikes parts catalogue 4TL1: "SPROCKET DRIVE 15 TEETH" p/n 1L5-8000-01 / 36LE-7461-50-00. Same source.

- **Model year timeline (T1/T3):** Wikipedia RX100 page lists: RX 135 (YEIS) 1998–2000; RX 135 5 Speed 2000–2003; RX 135 4 Speed (Cat-Con) 2001–2003; RX 135 4 Speed (Mini-Cat) 2003–2005. URL: https://en.wikipedia.org/wiki/Yamaha_RX_100.

---

## 4. Media inventory

| Item | URL / local path | Shows | Stock? |
|---|---|---|---|
| Yamaha official RX135 archive page | https://global.yamaha-motor.com/showroom/cp/collection/rx135/ | 1996 RX135 specs (12 PS, 12.3 Nm), 132 cc, 7-port reed, YEIS | STOCK |
| safexbikes RX135 parts catalogue (4TL1) PDF | https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf (local copy: temp) | Full parts diagrams + part numbers, 4-speed early | STOCK |
| Scribd RX135 parts catalogue (4TL6) | https://www.scribd.com/document/661417869/4TL6-PC | 5-speed parts catalogue (not extracted) | STOCK |
| Scribd 5-speed manual (19 pages, scanned images) | https://www.scribd.com/document/672845250/toaz-info-rx-135-5speed-manual-pr-... | Scanned manual images (not OCR'd) | STOCK |
| Scribd RX-RXZ 135 5-speed port maps (Arunava Pramanick) | https://www.scribd.com/document/508987019/... | Port map image, no dimensions ("Without Dimensions") | STOCK (map) |
| Scribd RX-RXZ 135 5-speed port maps (alt) | https://www.scribd.com/document/508985012/Yamaha-RX-RXZ-135-5-Speed-Port-Maps | Same | STOCK |
| User-supplied port map (5-speed) | local: `rx135_5speed_portmap.png` | 5-speed port map (not visually interpreted by agent) | unknown (likely stock trace) |
| User-supplied port map (5-speed) #2 | local: `rx135_5speed_portmap_2.png` | 5-speed port map #2 | unknown |
| Takumi RX Engineering Facebook posts | https://www.facebook.com/people/Takumi-RX-Engineering/61590450432191/ | Measured RX100-gen cylinder port heights/timings | T3 (RX100 gens, not RX135) |
| Instagram carb spec sheet | https://www.instagram.com/reel/C84rFIhhdA5/ | Carb jetting by variant | T3 |
| xbhp 4 vs 5 speed thread | https://www.xbhp.com/talkies/what-bike/12939-yamaha-rx-135-4-speed-or-5-speed | Owner comparisons, 14 bhp claim, model years | T3/T4 |

---

## 5. 4-speed vs 5-speed delta (sourced)

1. **Power:** 4-speed factory 12 PS @ 6500; 5-speed owner-claimed ~14 bhp with higher revs (8500 rpm) (T4). Source: Yamaha official (4s) + xbhp/Facebook (5s).
2. **Compression ratio:** 5-speed has higher CR than 4-speed (qualitative). Source: Wikipedia RX100 page (T1).
3. **Port dimensions:** 5-speed has "significant differences in ports sizes" vs 4-speed; 4-speed was detuned for fuel economy after 5-speed. Source: xbhp (T3).
4. **Carburettor:** 4-speed round venturi VM22; 5-speed oval venturi VM22. Source: xbhp (T3).
5. **Exhaust:** 5-speed has large catalytic-converter silencer; 4-speed later has cat-con/mini-cat. Source: Wikipedia (T1).
6. **Gearing:** 5-speed has 5 ratios; 4-speed has 4. Top-gear ratio reportedly similar (owner, unverified). Source: xbhp (T4).
7. **Model years:** 4-speed 1998–2005 (with revisions); 5-speed 2000–2003 only. Source: Wikipedia (T1).

No measured port-height or CR numbers for either variant were found.

---

## 6. Gap list (ranked by simulation impact)

1. **Port timing angles (exhaust/transfer/inlet open & close, durations) per variant** — highest impact for a two-stroke sim. Cheapest close: measure with a degree wheel on a stock cylinder (user has portmap images; needs physical measurement). 
2. **Combustion chamber volume & CR (geometric + trapped)** — needed for combustion model. Cheapest close: cc the head with a burette (stock head).
3. **Connecting rod length (c-c) & piston compression height** — needed for kinematics. Cheapest close: teardown measurement with calipers.
4. **Ignition static timing & advance curve** — needed for combustion phasing. Cheapest close: timing light + degree wheel on stock bike.
5. **Exhaust pipe dimensions** — needed for wave dynamics. Cheapest close: caliper/measure tape on stock pipe.
6. **Gear ratios & primary reduction** — needed for drivetrain/load. Cheapest close: count teeth on gears or service manual.
7. **Service wear limits & torque specs** — needed for validation, lower impact. Cheapest close: service manual.

---

## 7. Do-not-use list

- **RX-King 135 (Indonesia) power 17.5–18.5 PS @ 8750–9000 rpm, 13.4–13.6 kW** — Indonesian market, different engine lineage (imported Y1/Y2 then locally built). Do NOT apply to Indian RX135. Source: Wikipedia RX-King (T1, but out of scope).
- **"190° exhaust / 125° transfer" as if it were RX135-specific** — cited from a generic Yamaha port-map quote; variant (RX100 vs RX135, and which generation) is not stated. Do not enter into the model without variant confirmation. Source: Facebook (T3/T4).
- **RX100 port heights (28/30/32 mm from cylinder top) applied to RX135** — measured on RX100 G1/G3/G4 cylinders by Takumi; RX135 has a different (132 cc) cylinder. Do not transfer. Source: Facebook (T3).
- **5-speed power "15.2 bhp @ 8500 rpm, 13.5 Nm @ 8000 rpm"** — Facebook owner claim, no factory source; conflicting with "14 bhp" forum claim. Do not treat as factory spec. Source: Facebook (T4).
- **Chamber volume "22 cc"** — single unsourced Facebook mention; treat as unverified. Source: Facebook (T4).
- **Top-gear ratio "same between 4s and 5s"** — owner speculation on xbhp. Source: xbhp (T4).
- **Tyre size for 5-speed** — assumed from RX-King; not confirmed for Indian 5-speed. Source: T2 (platform assumption).

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
8. Fetched safexbikes parts catalogue PDF: https://safexbikes.com/parts_catalog/yamaha%20rx135.pdf
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

## 9. Notes on variant scope

- Third Indian variant? Wikipedia lists RX135 4-speed (Cat-Con) 2001–2003 and (Mini-Cat) 2003–2005 as distinct factory revisions of the 4-speed, plus RX135 (YEIS) 1998–2000. These are treated as sub-revisions of Variant A (4-speed), not separate datasets, because no evidence of a distinct engine/porting change beyond the catalytic-converter and cosmetic updates was found. If a catalyser/Euro-norm version with different porting/CR is documented, it should be split out — NOT FOUND as such.
- RX-Z (India) is a separate model (sportier chassis, same 132 cc engine family) and is out of scope per hard rule 1 for RX135, though it shares the engine; its data must not be merged into RX135.

---

*End of dataset. Values tagged NOT FOUND are genuinely not located in the sources searched; they require physical measurement or the factory service manual (not located online in text-extractable form).*