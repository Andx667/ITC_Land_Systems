# TODO

Open work for ITC Land Systems. Finished items are in git history and `CHANGELOG.md`.
Section numbers are kept stable so commits and issues can refer to them.

## Scope

Primary, in this order of the fight:

- **Artillery**, the whole chain from observer to round on target: observers and drones (UAVs,
  ROVER, GLTD, Strider), fire direction (BCS, tablets), and the shooters: howitzers, MLRS, the naval
  gun and the VLS.
- **Counter-artillery**: the COBRA counter-battery radar, CIWS and the SAM sites.

Secondary, maintenance only: APS. Removed on 2026-10-22: the Spike LR (ACE ships its own), the
remote frag grenade (ACE has placeable charges) and the unreachable smoke dispenser magazine.

## Next up

1. In-game verification: issue #3 (full checklist; the list below is the short version),
   primary systems first.
2. In-game check of the exact firing solutions (in-game verification above).
3. Fire direction to the guns: the battery fire solution distribution (8, over the datalink),
   time fuze settings and the other realism items (8).
4. Observers and the radar to fire direction: target handoff from observers and drones,
   COBRA detections as counter-fire missions (11).
5. Translations (1), compatibility (8), then documentation (9).
6. Secondary systems: fixes only; the APS framework (8) comes last.

## In-game verification

Partly tested in game (issue #3, ticks up to 2026-10-22 18:05). What is still open is below;
full checklist with setup and expected behaviour: issue #3.

Locality fixes:

- [ ] COBRA: a client joining mid-mission sees the current COBRA data (the rest of the
      dedicated-server checks pass, 2026-10-22).
- [ ] VLS: a scripted round without a dialog target flies unguided without script errors
      (dialog launches, typing and no AI self-launch pass, 2026-10-22).
- [ ] CIWS: still engages shells and aircraft without the ground sensor bands, and no
      longer reports ground vehicles over datalink (the shell check in issue #3 predates
      this change).
- [ ] MOF35 Mod3 (Falat) rounds release their submunitions at the set fuze time.
- [ ] Guided shells (155/152 mm LGM and PGM, 230 mm PGM) actually steer to the target. The
      guidance turns the shell with `setDir`, which per the wiki resets velocity, and never
      restores it; if the shells stall or fall short, re-apply the velocity along the new
      direction after each turn.
- [ ] RHS compat (`hemtt launch default rhs`): ITC 2S1, 2S3 and M109 load, fire and reload
      through the ammunition handler, the mounted tablet opens and the SPG app gives solutions
      that hit, also on the M109 (hull smoke generator); the guns recoil and show their muzzle
      flash; D-30, M119 and (RHS original) 2B14 and M252 solutions from the BCS hit for every
      charge; the ITC 2B14/M252 are hidden but still load in an old mission. RPT has no `Updating base class` lines for RHS
      classes. `hemtt launch default rhs_usaf`: no errors from the skipped AFRF compat.
- [ ] CUP compat (`hemtt launch default cup`): BCS solutions for the ITC D-30 and M119 hit for
      every charge (the D-30 AT round gets none); the ITC M270 fires the ITC rockets from the right
      launch points, its tablet and MLRS sight work; a CUP 2B14/M252 gets Mk6 solutions that hit.
- [ ] ITC M1129 Stryker: note the real elevation range of the M121 in the gunner sight (the
      config says -5 to 35, the tables assume 45 to 85 degrees as on the other mortars) and
      regenerate the tables if it differs; BCS solutions hit for every charge; the 120 mm HE
      damage feels right between the 82 mm mortar and the 122 mm howitzer.
- [ ] BWMod compat (`hemtt launch default bwa3`, without the TTT mod's old ITC PzH 2000): the
      ITC PzH 2000 loads, fires and reloads automatically through the ammunition handler (with
      the reload animation), its tablet SPG app gives solutions that hit, the gun recoils and
      shows its muzzle flash; BCS solutions for the BWMod MRS120 hit for every charge.
- [ ] BCS Mk6 battery with the vanilla `8Rnd_82mm_*` rounds (ACE mortar ammunition handling off):
      solutions appear and hit, labelled with the mortar's mode names.
- [ ] CIWS decoys stay invisible on the other machines (`setObjectTexture` is local; the
      config's blank textures have to cover the rest, else use `setObjectTextureGlobal`).
- [ ] Firing solutions (exact vacuum solution instead of the table lookup): SPG app and BCS
      rounds hit with low and high angle, also near a charge's maximum range and at targets
      well above the gun; the first solution per shell type may hitch once while its tables
      compile.

Secondary systems:

- [ ] APS: two shooters at the same vehicle; ammo/reload state stays consistent.
      The elevation limit (10-40 deg) and the out-of-ammo check are now enforced,
      check that top-attack coverage is still acceptable.
- [ ] Optional (AI crews are nice to have, the mod targets player crews): SPH loader with an
      AI driver or an AI gunner on the server.

User-flow fixes from the code review:

- [ ] SPH dual-laser (Falat) rounds use both laser codes entered at Apply.
- [ ] Saved list selections (SPH ammo/fuze, VLS angle, MLRS fuze) restore correctly,
      including the last entry.

Settings and dependencies:

- [ ] CBA settings can be forced by the server; COBRA range/engagement window and APS/CIWS
      toggles take effect.
- [ ] SPH loader status text shows correctly for the other crew members.
- [ ] UI base classes now defined once (in `common`): the RPT has no `Updating base class`
      lines for `ITC_LAND_Rsc*`, and the tablet, SPH loader and VLS dialogs look as before.

## 1. Localization

Config strings (names, descriptions, dialog labels) and the visible script strings
(tablet apps, sights, SPH loader, packing, VLS) are in per-addon stringtables.

- [ ] Translations (English only so far; German first?).
- [ ] Some keys are named after generic control classes (`RscText_1006_Text`, ...);
      rename to meaningful names when touching those dialogs.
- [ ] 37 keys are unused (`hemtt check` L-L02U) because they come from config files
      that are never included; resolved by the dormant-content decision (5).

Not planned: the `ballistics/formattedBTab` developer tool and the datalink ID
validation errors (never shown to players) stay English. Acronyms and product names
(COBRA, AIFMS, DTV/HOT) stay untranslated.

## 2. Settings

- [ ] Further candidates: CIWS/COBRA detection arc, siren trigger distance, SPH loader
      timings, a debug logging toggle.
- [ ] One on/off switch per system. Rules:
  - CBA checkbox `itc_land_<component>_enabled` under "ITC Land Systems" -> system,
    default on, server-forced (like the existing APS and CIWS toggles).
  - Off = ITC's scripted behaviour is gone and the vehicle falls back to what the engine
    does; vehicles, weapons and ammo stay in Eden/Zeus/Arsenal (settings cannot unload
    config).
  - Takes effect at the next mission (CBA "needs restart") for systems set up at mission
    start or vehicle init; APS and CIWS check per shot and can stay live.
  - Per component: `initSettings.inc.sqf` + stringtable keys; gate the few entry points
    (postInit registrations, config init/`Fired` handlers, ACE action conditions, UI
    openers) with a shared `EXIT_IF_DISABLED` macro; register behind CBA's
    settings-initialized event so the value is known.
- [ ] Clean switches (off = vanilla fallback):
  - APS (exists): no APS on tanks.
  - CIWS (exists): engages only what vanilla does (air, missiles).
  - COBRA: server scan loop, radar vehicle init, sirens, CBR tablet app (and the datalink,
    which only COBRA uses). Off: plain radar vehicles, CBR app hidden.
  - SAM-35 proximity fuze (`veh_weapons` / `veh_rhea` fired): vanilla hit-to-kill missiles.
  - VLS: target dialog, ad-hoc/saved targets, guidance. Off: vanilla VLS behaviour.
  - SPH ammo handler (dialog, ACE action, fired reload cycle): guns fire their charge
    magazines directly, like vanilla.
  - ROVER tablet: action hidden, no video feed.
  - Guided artillery (LGM/PGM, `guidance`): rounds fly ballistic.
- [ ] Decide: switches that would break things, recommended none or an "expert" switch:
  - Fire control tablet / BCS: the ITC guns set `artilleryScanner = 0`, so off leaves no
    fire control at all (only manual laying); a setting cannot re-enable the vanilla
    computer.
  - Gunner sights: overlays come from config (`turretInfoType`), off leaves the ITC
    overlay without readouts.
  - Special munitions (fuzes, ICM, mines, smoke, illumination, Extra/Falat): inert shells
    plus a scripted effect, off turns them into duds.
  - Packable equipment: off makes packed items in loadouts useless.
- No switch possible: vehicles/UAVs, Strider, Mk6 ammo are
  config only (would need separate optional PBOs); `main`, `common`, `ballistics` and
  `datalink` follow their users.
- Rollout: macro + helper in `main`/`common`, then one commit per clean switch; test-range
  check (toggle, restart, confirm the vanilla fallback) and issue #3 entry; settings table
  in the README.

## 3. Multiplayer / locality (remaining low-priority audit items)

- [ ] CIWS decoys: every interceptable shell (artillery/mortar/rocket, not every
      bullet) spawns a networked decoy vehicle with an AI crew so CIWS AI sees a
      hostile target. The crew leak is fixed; profile a large barrage in MP to see
      whether the per-shell vehicle/group creation is acceptable.

- [ ] VLS: removing a saved target leaves `ITC_Land_VLS_selectedTGT` pointing at it.
      Check in game whether `lbDelete` fires a new selection; if not, "Launch selected"
      can fire at the removed target. Clear or refresh the selection in `fnc_removeTGT`.
- [ ] VLS `onChar` broadcasts the grid/elevation/name to every machine on each keystroke;
      launch and save read the fields themselves, so store locally or drop it.

Before the battery fire solution distribution (section 8) makes the datalink live:

- [ ] Respawn leaves the registration on the old body.
- [ ] Replace the CBA hashes in the datalink registry with native hashmaps.

## 4. Runtime performance

Done: ballistic tables and tablet app/page scripts are compiled once and cached; the
MOF35 Mod3 time fuze uses `CBA_fnc_waitAndExecute` instead of an every-frame handler.
The remaining every-frame handlers are sights/tablet/UI displays and the CIWS decoy
tracker, which has to follow its shell every frame.

- [ ] Optional: generate the ballistic tables at build time instead of compiling 3.8 MB of
      SQF on first use (first firing solution per shell type still pays that cost).

## 5. Config hygiene

Dormant on purpose (decided 2026-10-22; the dead leftovers were deleted): content that
exists but cannot be reached in game, kept to be finished later.

  - 105 mm and 122 mm howitzers: framework only (see below)
  - tablet: SADL app, handheld MLRS tablet (no action)
  - `guidance/igm15x.sqf` (dual GPS/laser guidance, never registered)
  - the datalink system (see 3)
- [ ] 105 mm / 122 mm framework for other mods (ITC adds no vehicle for them). Missing so
      far:
  - `veh_weapons/CfgMagazines_105mm.hpp` is never included in `CfgMagazines.hpp`, so
    `itc_land_105mm_howitzer` lists magazines that do not exist.
  - no `G105`/`G122` entry under `itc_land_ballistics >> batteryTypes`
    (`ballistics/CfgMisc.hpp`), so the tablet FCS and the BCS offer no shells or
    solutions for these guns.
  - document for mod makers what a vehicle needs (weapon class, magazines, tablet and
    ammo-handler config) and test it on a vanilla-based example vehicle.
- [ ] Handheld SPG tablet (`itc_land_tablet_spg`): set to `scope = 0` for now, only the
      mounted tablet uses the class. As an item it duplicated the mounted tablet: its SPG app
      only works inside an ITC artillery vehicle (any seat, where the mounted one is tied to the
      commander/gunner seat), and on foot it is a BCS without the CBR app, i.e. a weaker FDC
      tablet. Find it a purpose (e.g. remote fire control for a gun it is linked to, via the
      datalink) or drop it for good: then remove its "SPG Tablet" ACE self action and let the
      mounted tablet open from both the commander and gunner seats instead.
- [ ] Code-review leftovers (low priority): SPH `onLoad` re-broadcasts the unchanged loader
      status on every open; ROVER `ui_init` sets the slider/FOV twice and its open condition
      uses `items player` instead of the ACE player; the tablet's re-open logic relies on an
      `"OPEN"` placeholder page; commented-out mounted-tablet block in
      `tablet/CfgVehicles.hpp` and the unused `action_tablet_open` macro in
      `rover/CfgVehicles.hpp`; packable files `fnc_Pack`/`fnc_unPack` vs `PREP(pack/unpack)`.
- [ ] Tablet and dialog layout doesn't scale consistently: the tablet frame image is sized
      from the screen width only while the content uses width and height, and text sizes
      use a fixed `GUI_GRID_H` while boxes scale with the screen. Known; long-term rework.

## 6. Linting and CI

Done: `.hemtt/lints.toml` sets S04/S12/S13/S29/S38, C12 and stringtable sorting to
errors (verified by planting violations; S17 is set too but did not fire on a test
global), `tools/macro_in_string_checker.py` runs in the Validate workflow (CBA/ACE
macros and every macro `#define`d in the project, inside double-quoted strings), Dependabot
covers GitHub Actions, checks are documented in `CONTRIBUTING.md`. The Python
stringtable and config-style checkers stay, they check conventions HEMTT does not.
`hemtt check -p` is clean except the dormant `veh_weapons/fuzeProxFOV.sqf` (5);
S49 (`countType`) is disabled because it misfires on class-name strings.

- [ ] Replace `tools/macro_in_string_checker.py` with a HEMTT TOML lint
      (`.hemtt/lints/*.toml`) once a HEMTT release after 1.22.0 supports them.
- [ ] `hemtt publish` to Steam from CI (needs Steam credentials as repo secrets).

## 7. Testing

- [x] Test range mission (`.hemtt/missions/itc_land_vr_test.VR`, started by `hemtt launch`):
      stations for every issue #3 section, a control board with teleports, scenarios
      (enemy barrage, APS attack, AI VLS shot, air target, Zeus) and diagnostics.
- [ ] Automate parts of it (scripted pass/fail checks) once the manual run is done.

## 8. Compatibility and polish

- [ ] Zeus Enhanced / ACE Zeus modules, editor categories and subcategories.
- [ ] ACE Arsenal / cargo sizes for packable items.
- [ ] Use newer commands where it helps (`getOrDefault`, ...).
- [ ] Real Steam Workshop ID in README badges and `mod.cpp` (currently `id=0`);
      version is 0.1.0.
- [ ] APS as a framework that can be attached to any vehicle. Today a vehicle needs an
      `itc_land_aps` config class plus the `APS_INIT_EH` init handler in its
      `EventHandlers` (a vehicle that redefines `EventHandlers` without inheriting silently
      gets no APS), and only three vanilla tanks are patched. To do:
  - init through CBA XEH (`Extended_InitPost_EventHandlers` on `AllVehicles`, reading
    `itc_land_aps` if present) so a config class alone is enough, no event handler
  - public script API: add/remove a module or a whole preset on a vehicle at runtime
    (missions, Zeus), query its modules and remaining ammo
  - presets (Trophy, Drozd, Afganit, ...) a vehicle config can inherit instead of
    copying every value
  - rearm: refill module ammo from ACE rearm / vanilla ammo sources, which never happens
    now
  - Zeus module and/or ACE interaction to fit an APS to a vehicle
  - document the config keys and the API for mod makers (with section 9)
- [ ] Battery fire solution distribution (planned 2026-10-22): the FDC computes a mission, presses
      SEND, and every gun of the battery gets its own firing data in the gunner sight, like a real
      fire direction system sending to the gun display. Today the BCS only knows guns as hand-typed
      grid/elevation/direction and the crews get their data by voice; only the SPG app's local
      solution reaches a sight (`itc_land_tablet_fcs_solutions`/`_index` on the vehicle, read by
      `common_fnc_getFireSolution` for MA/MQ and the alignment guide). The BCS already computes
      each gun's line in that format, so a sent line needs no change in the sights, the alignment
      guide or the SPG app; the towed guns' basic sight reads it too.
  - Phase 1, link guns: Battery Setup scans the map for ITC-enabled guns of the FDC's side (a
    gunner sight or mounted tablet from ITC, and a battery type for their weapon) and offers them
    in a list; a picked gun is linked and its position, elevation and direction come from the
    vehicle, refreshed before each calculation. Hand entry stays for guns without ITC (other
    mods' guns, mortars). Fix on the way: the solution page reads each gun's line by the
    battery's solution index, so a gun with fewer solutions shows nothing or the wrong charge;
    match by charge and angle (low/high) instead and show NO SLN for a gun without one.
  - Transport over the datalink (addon `datalink`, dormant so far): every ITC gun connects at
    init and gets an ID; the battery is a datalink group, each linked gun a node, the FDC
    transmits to the gun's ID (or the group, "00" node, for FFE to all). The gun's handler, on
    the machine that connected it, writes the received line and orders onto the vehicle as
    public variables. This gives the datalink its first live caller, so the section 3 items
    (respawn keeps the registration on the old body, CBA hashes to native hashmaps) come first.
  - Phase 2, SEND: a SEND button on the solution page transmits the matched line per gun with
    the mission number; ADJ goes to the adjusting guns picked on the engagement page, FFE to the
    FFE guns, and an adjustment resends. The newest data wins over a local SPG app solution; the
    SPG app and the sight show the source ("FDC FM0001").
  - Phase 3, fire orders at the gun: the IGS sight's FCI ORDERS panel (Sholef 2, Sochor 2,
    Hammer 2; controls 1600-1605, placeholders behind `itc_land_IGS_showOrders` today) shows
    mission, count, round, charge, fuze and azimuth/quadrant and appears by itself when orders
    arrive; the shared PzH 2000/RCH 155/RHS sight (`ITC_Land_RscAltGunnerSightSPH`) gets such a
    panel. The ammunition handler gets "Apply FDC orders", which only pre-fills round, charge,
    fuze and count: the crew still applies, loads and lays.
  - Phase 4, feedback (optional): each gun's loader status (already public on the vehicle) back
    to the FDC's gun list, and the first shot of a sent mission sets SHOT and the splash warning.
  - Later: the MLRS (different solution format, missile app).
  - Docs: `docs/systems/bcs.md` (describes the voice relay today), usage and the gun pages.
  - Test (singleplayer for phases 1-3): a test range station with two Sholef 2 and a D-30; set up
    the battery on the FDC tablet, send, switch to the gunner seat. Then multiplayer: FDC and gun
    crews on different machines, and a player joining mid-mission.
- [ ] Realism, compared with real guns (2026-10-22):
  - Fuze setting: real fire direction gives a time fuze setting (FS) that bursts the shell
    at the right height (illumination about 600 m above the target, M825 smoke about 100 m,
    cargo rounds per round type). The SPG app and BCS only give the time of flight, so the
    crew guesses and usually bursts too late. Add an FS column for time-fuzed rounds
    (TOF to the burst point, from a burst height per magazine in config).
  - Delay fuze: `common_fnc_resolveFuzeSetting` sets 0.005 s; real delay fuzes use about
    0.05 s. Not a one-line change: the delay places the burst along the last flight
    path, so ten times the delay puts it about 15 m past the impact point, often
    underground. Proximity bursts at the fuze's fixed `proxHOB` (9 m, realistic).
  - Russian guns (D-30, 2S1, 2S3, Sochor 2) use 6000 mils in reality; everything here
    shows NATO 6400. Optional, per battery type or vehicle.

## 9. Documentation (after in-game testing, issue #1)

- [ ] Tracked as issue #2: accurate function headers + `Public: Yes` API marking,
      per-addon READMEs. The MkDocs Material user docs exist (`mkdocs.yml`, `docs/`);
      enable GitHub Pages (source: GitHub Actions) for the deploy workflow and re-check the
      pages against the game after in-game testing.

## 10. Known bugs

- [ ] Solutions beyond the gun's elevation limit in the BCS: the tables can reach steeper than some
      guns (155 mm high angle to 80°, PzH 2000 72°, RCH 155 65°, Hammer 2 70°, the MLRS 66°). The
      SPG and MLRS apps drop them (`common_fnc_filterSolutionsByElevation`, turret minElev/maxElev);
      the BCS knows no vehicle per gun yet. With linked guns (section 8, phase 1) it can filter
      per gun too.
- [ ] Firing solutions use the gun's `getPosASL` as the muzzle height (a few metres low);
      use the muzzle position instead (`calcShellTypeSolutions` callers: SPG/MLRS apps, BCS).

## 11. Observers and the radar to fire direction

- [ ] Target handoff from observers and drones. Today an observer reads a grid from the map,
      a laser rangefinder or the UAV optics readouts and the FDC types it into a new fire
      mission. Add a way to send it: a target (grid and elevation) from the UAV optics or a
      designator lands in the FDC tablet as a new fire mission or a location store entry,
      like a digital call for fire. Same for the observer's corrections during adjust fire.
- [ ] COBRA detections as counter-fire missions. The COBRA app can save a back-traced firing
      position as a known point, but the BCS operator still loads it and builds the mission by
      hand. Add "counter-fire" from a COBRA engagement: a new BCS fire mission on the firing
      position, ready to compute, as real counter-battery radar hands targets to fire direction.
