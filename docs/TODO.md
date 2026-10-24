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
3. Test the fire direction work of 2026-10-23 (in-game verification below): fire data, orders
   and shot reports, the MLRS on the datalink, fuze settings, the delay fuze,
   muzzle origin and elevation limits, Russian mils, observer handoff and COBRA counter-fire.
4. Observers to fire direction, the rest (11): corrections during adjust fire over the datalink.
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
- [ ] ITC M1129 Stryker, still open: the smoke round and each HE fuze (proximity, time, delay burst with
      the 120 mm helper); preparing takes 1.5x without a loader; FIRE with no gunner gives the
      hint; 16 quick rounds, then TUBE HOT - COOLING holds to 4 a minute; multiplayer with loader
      and gunner on different machines; CUP's own M1129 is unchanged.
      Tested 2026-10-23: the M121 lays 808 to 1519 mils on flat ground (CQ and ACE agree with
      `elevationOffset = 50`, `elevationLimits[] = {45.45, 85.45}`); it links in the BCS, which
      gives solutions that hit; the full PREPARE → FIRE → next round cycle works; the IGS
      alignment guide works; STOW works; the Loader seat opens the handler and keeps a steady
      wide view. The 120 mm HE damage (hit 230, indirectHit 80, 21 m; CUP's stand-in is the
      155 mm's 340 / 125 / 30 m) stays until players say otherwise.
- [ ] BWMod compat (`hemtt launch default bwa3`, without the TTT mod's old ITC PzH 2000): the
      ITC PzH 2000 loads, fires and reloads automatically through the ammunition handler (with
      the reload animation), its tablet SPG app gives solutions that hit, the gun recoils and
      shows its muzzle flash; BCS solutions for the BWMod MRS120 hit for every charge.
- [ ] BCS Mk6 battery with the vanilla `8Rnd_82mm_*` rounds (ACE mortar ammunition handling off):
      solutions appear and hit, labelled with the mortar's mode names.
- [ ] CIWS decoys stay invisible on the other machines (`setObjectTexture` is local; the
      config's blank textures have to cover the rest, else use `setObjectTextureGlobal`).
- [ ] BCS fire data over the datalink: Battery Setup's Link gun lists the Sholef 2s (G155),
      LINK adds them with the right grid/elevation/direction and the ID in the gun list; moving
      a linked gun updates its data at the next calculation; SEND FFE puts each gun's MA/MQ in
      its sight (beep and hint for the crew, "FDC FM0001 FFE" in the SPG app) and the rounds
      hit; SEND ADJ only reaches the selected gun; CALC SLN on the gun replaces the FDC data; a
      Hammer 2 operator gets the hint; Link gun lists the M1129 for an M121 battery and never a
      D-30 or M119 (no tablet).
      Multiplayer: FDC and gun crews on different machines, and a crew joining mid-mission.
- [ ] BCS fire orders: Fuze and Count on the engagement page reach the gun; the FCI ORDERS
      panel appears on the Sholef 2 and PzH 2000 with the right round, charge, fuze and count
      (TOF for a time fuze, grid for a GPS round) and goes away at END MISSION or CALC SLN; FDC
      ORDERS in the ammunition handler fills in round, charge, fuze, count and GPS target, and
      the loaded rounds hit; the first shot starts SHOT/SPLASH on the FDC tablet (later shots
      and the other guns do not restart it); the solution page shows each gun's loader status.
- [ ] MLRS on the datalink: Link gun lists the Seara 2 / Zamak / CUP M270 for an
      M230 battery; SEND FFE lays them (guided rockets at 800 mils), the MLRS app shows "FDC" and
      FS, FDC ORDERS on its fuze page fills in round, fuze and GPS target; the MLRS sight's orders
      box (red, right side) shows and does not clip; the first rocket reports SHOT.
- [ ] Observer handoff and counter-fire: Ctrl+Shift+T in the Darter 2 / Greyhawk / GLTD /
      Strider optics puts the lased or aimed point into the FDC's Location Stores (TGT01) with a
      ping and the right grid and altitude, also while the FDC tablet is closed; an enemy-side
      FDC does not get it; COUNTER-FIRE on the COBRA data page opens the BCS at the engagement
      page of a new mission on the firing position, and the solutions hit it.
- [ ] Russian mils: the Sochor 2 sight shows `15-00`-style CA/MA/CQ/MQ and lays on target; a
      G152 or D-30 battery's BCS gun lines are in 6000 mils and an OT of `15-00` shifts the target
      the same way as 1600 in a NATO battery; with the setting off everything is 6400.
- [ ] Delay fuze (HE, LGM/PGM, M230 HE): a shell into open ground bursts once, just under the
      surface (small crater); one through a building roof bursts inside; no shell bursts twice.
- [ ] Muzzle origin and elevation limits: SPG app, MLRS app and BCS (linked guns) solutions
      start at the muzzle (a few metres higher and forward of the vehicle position) and still
      hit, low and high angle; the BCS offers no solution steeper than the battery type's guns can
      lay for hand-entered guns (e.g. D-30 battery), and the first BCS calculation of a battery
      type does not hitch noticeably (it scans CfgVehicles once).
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

- [ ] Datalink: a respawned FDC player gets a new ID when the BCS opens again, but the old
      body's node stays in the registry until the body is deleted. Harmless while only guns
      receive; matters once players receive (target handoff, phase 4 feedback).

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
      use a fixed `GUI_GRID_H` while boxes scale with the screen. Known; long-term rework
      (possibly as HTML pages, see the HTML tablet item in section 8).

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
  - rearm, vanilla and ACE compatible: spent charges are never refilled now (only a
    respawned or new vehicle has full modules). `vehicleInit` keeps each module's maximum;
    a rearm refills to it on the vehicle's owner and publishes the state like
    `onModuleFired`. Vanilla: rearming from an ammo truck/box has no event, so detect it
    (vehicle near an ammo source, or its own magazines refilling). ACE (`ace_rearm` loaded):
    hook ACE rearm, check what it exposes; partial refills are fine, as ACE rearms gradually.
    Work with both and with neither loaded. Optional: a refill cost/time per charge.
  - crew GUI for the APS state: a small overlay for the vehicle's crew showing the system
    state (READY / INCOMING DETECTED / DEFENDING, plus RELOADING and EMPTY) and each
    module's remaining charges, e.g. `TROPHY L 7/10`. Detection and interception run on the
    shooter's machine, so "incoming" and "defending" have to be sent to the crew (CBA event
    to the vehicle's crew), not read from local state. Hidden when the APS setting is off
    or the vehicle has no modules.
  - Zeus module and/or ACE interaction to fit an APS to a vehicle
  - document the config keys and the API for mod makers (with section 9)
- [ ] Datalink as a public API for other mods. It already works from outside (`connect`,
      `registerEvent`, `transmit` with free header/type strings, IDs public as
      `itc_land_datalink_id`, ID format in config), but nothing says it is supported. To do:
  - mark `connect`, `disconnect`, `transmit`, `registerEvent`, `unregisterEvent` and
    `validateID` `Public: Yes` and tidy their headers
  - a CBA event when an object gets its ID (e.g. `itc_land_datalink_connected`) and an optional
    callback on `connect`; today the ID arrives asynchronously, a refused registration only
    logs, and auto IDs only go to group `01`
  - a "Datalink" section in `docs/scripting.md`: transmission format
    `[destination, origin, header, type, data]`, handlers live on the machine that called
    `connect` (registering on a client for a server-connected object receives nothing),
    addressing (`GGNN`, `GG00` group, `0000` all), reserved headers (`fdc`,
    `object_register`), no reply/ack, and the trust model
  - optional: the server rejects a transmission whose origin ID is not registered to the
    sending machine (today only its format is checked, so any client can send as any origin)
  - optional: a server-side query for the registered nodes (only the server has the registry;
    the BCS scans vehicles for the public ID instead)
- [ ] Maybe: APS for the Puma and Boxer (researched 2026-10-23). Neither has a hard-kill APS
      in service.
  - Boxer: Trophy was integrated on a pre-series APC in September 2025, on a mission module, so
    the launchers are fixed to the hull. Live fire was announced but no results were found.
    StrikeShield (Rheinmetall) was also fitted to a Boxer for testing; it uses many small
    hull-wide modules, each breaking up the threat about 10 m out. The Bundeswehr reportedly
    plans StrikeShield + AVePS for wheeled vehicles, which vehicles is unconfirmed. Both fit
    the current module config: Trophy is `TROPHY_L`/`_R` without `turret[]`; StrikeShield is
    4-6 hull modules, `traverse` about 45, `range` about 10, short reload, few shots (guessed,
    no per-module figures are published). ITC has no Boxer APC yet, only the GTK RCH 155.
  - Puma: MUSS / MUSS 2.0 (Hensoldt) is soft kill only: warning sensors, an IR jammer that
    blinds guided missiles, and smoke. It has room for a hard-kill system, none ordered. It
    does not fit the current APS: it needs a soft-kill type that ignores unguided rockets,
    breaks guidance instead of detonating, and can fire smoke. The Puma itself comes from
    BWMod (`compat_bwa3`).
- [ ] Tablet in HTML (built 2026-10-23, setting "Tablet in HTML", on by default; then
      `tablet_fnc_open` opens `tablet_fnc_webOpen`, and `sphammohandler_fnc_open` (the vehicles'
      ammunition handler action) the handler as a panel of the same page, its view and actions in
      `sphammohandler_fnc_webView/webAction`): every tablet app in a CT_WEBBROWSER page
      (Arma 3 2.20, `tablet\html\tablet.html`), over the classic frame pictures (native, so they show
      at once while the browser starts; the night one fades in after dark): the browser has their
      size and a transparent page with the screen in the glass (measured on `screen.paa`), APP 1-2
      and Input Lock (home) as the app keys (APP 3 has no function), and a sidebar of pages. Only
      the COBRA map stays native (`RscMapControl` over the page's map slot, `tablet_fnc_webPlaceMap`,
      drawn by `tablet_fnc_cbrDrawMap`, shared with the classic map). The pages are described in SQF
      (`tablet_fnc_webView*`: fields, select boxes, buttons, lists, readouts, built with
      `tablet_fnc_webBlock/webField/webButton/webCheck`) and their actions run there
      (`tablet_fnc_webAction*`, every value checked, read with `tablet_fnc_webFormValue`); each
      app's view, actions, pages and start page are in `itc_land >> apps` (`tablet\CfgMisc.hpp`).
      What an action changes goes through functions the classic pages call as well, so the two
      cannot drift apart: the BCS (`tablet_fnc_bcsInit`, `bcsSetTarget`, `bcsSetEngagement`,
      `bcsAdjustTarget`, `bcsSendFireData`, `bcsEndMission`, `bcsSaveGun`, `bcsLinkGun`,
      `bcsSaveLocation`, `bcsNextId`), the FCI (`tablet_fnc_fcsCalculate`, `fcsStep`,
      `fcsApplyRocketSettings`), the ammunition handler (`sphammohandler_fnc_applyLoaderSettings`)
      and both (`common_fnc_setFuzeSelection`, `getFuzeConfig`, `setGpsTarget`, `getFdcOrders`).
      New work goes into those and the HTML pages; the classic pages only read their controls and
      call them. App and page are the vehicle's, so
      either tablet opens where the other left; CLASSIC TABLET on home opens the classic one.
      Checked in a headless browser: layout on the frame, typed text kept over state updates,
      buttons send the page's fields. To test in game, per app:
      - Home: APP 1-3 and Input Lock, CLASSIC TABLET, the night screen after dark, Esc and the X.
      - SPG / MLRS (mounted): CALC SLN, PRV/NXT reach the gunner sight; MLRS round, fuze mode
        (time field), GPS target, APPLY SETTINGS, FDC ORDERS; the status page; no SPG interface.
      - Usability pass (2026-10-23): one primary button per page, END/REMOVE pressed twice, inline
        checks (grid, numbers, laser codes) block the send, units, results as notices in the page,
        the status bar (FDC ID, battery, time), MTO line, fire command column order, the
        adjusting gun (click a gun line), ADJ one round, OT kept, Special-only sheaf fields, Quick
        Sheaf and Friendly as checkboxes (stored as before for the classic tablet), known point
        IDs AB0001 on, MLRS APPLY & CALCULATE, the handler's NOT APPLIED line and charge stepper.
      - BCS: settings save (and the invalid splash time hint), battery type, guns by hand and
        LINK, remove; location stores add/remove; a fire mission through all its pages (Grid,
        Shift, Polar, QuickLay, LOAD), the engagement (round changes the fuzes), solutions, SHOT
        and TTI, SEND ADJ (selected gun) / FFE, ADJUST, END and END & SAVE; observer targets and
        a respawned FDC (the datalink reconnects).
      - Ammunition handler (gunner and loader seats, PzH 2000 loader, M1129 mortar): round list
        and counts, charge -/+, fuze (time field), laser codes and GPS target, count, APPLY,
        LOAD / UNLOAD and the autoloader running, mortar PREPARE / FIRE / STOW, FDC ORDERS; the
        classic dialog open by another crew member at the same time shows the same.
      - COBRA: the map in its slot with the radars, firing positions and impacts, zoom and pan;
        Save to BCS and COUNTER-FIRE (opens the BCS engagement).
      - Which of the four whitelist spellings in `tablet\config.cpp` matched (drop the rest); the
        frame rate with and without Steam; a transparent page background around the frame.
      Notes: HEMTT does not know `ctrlWebBrowserAction` (missing from the arma3-wiki data), so it
      is compiled from a string in preInit (`tablet_webAction`); JSDialog/PageLoaded give two
      L-S02 warnings. When it holds up: default on, then drop the classic tablet.
- [ ] Battery fire solution distribution (planned 2026-10-22): the FDC computes a mission, sends
      it, and every gun of the battery gets its own firing data in the gunner sight, like a real
      fire direction system sending to the gun display.
  - Done (2026-10-23, phases 1 and 2): every ITC cannon with an ITC gunner sight connects to the
    datalink at init on the server (`bcs_fnc_gunInit`, ID public as `itc_land_datalink_id`);
    Battery Setup links them (**Link gun** / LINK, refreshed from the vehicle before each
    calculation, elevation-filtered per gun); the solution page matches each gun's line by
    charge and angle (NO SLN otherwise) and SEND ADJ (the gun selected in the list) / SEND FFE
    (all guns) transmit it to each gun's ID. The server-side handler (`bcs_fnc_onFireData`) makes
    it the gun's selected solution (`itc_land_tablet_fcs_solutions`/`_index`), stores the source
    in `itc_land_bcs_fireData` and alerts the crew; the SPG app shows "FDC FM0001 FFE" and
    redraws live. Changed from the plan: ADJ goes to the gun selected on the solution page, not
    to guns picked on the engagement page (which has no gun selection); each gun is sent to its
    own ID, not to a group broadcast.
  - Done (2026-10-23, phases 3 and 4): the engagement page has Fuze and Count, sent with the
    line (fire data = mission, phase, line, magazine, count, fuze mode, target position; stored
    on the gun as `itc_land_bcs_fireData` with its receive time). The IGS and overlay sights'
    FCI ORDERS panel appears with orders (`veh_sights_fnc_getFireOrdersText`; GPS rounds show the
    target grid, a time fuze the time of flight); the ammunition handler's FDC ORDERS button
    (`sphammohandler_fnc_applyFdcOrders`) pre-fills round, charge, fuze, count and GPS target.
    Feedback: every machine adds a Fired handler to the ITC guns, and where the gun is local the
    first shot of each fire data reports "fdc"/"shot" to the FDC's ID, which starts SHOT and
    the splash alert there (`tablet_fnc_bcsShot`, shared with the SHOT button); the solution
    page shows each linked gun's loader status; END MISSION sends "fdc"/"endMission", which
    clears the gun's orders. Changed from the plan: the loader status is in the solution page's
    gun list, not in Battery Setup's.
  - Done (2026-10-23): the MLRS (Seara 2, Zamak MRLi, CUP M270) link and get fire data like the
    guns: rocket battery types are linkable, guided rockets get `itc_land_fixedQuadrant` (800)
    in every solution, the MLRS app shows FDC data and FS live and has FDC ORDERS on its fuze
    page, and the MLRS sights have the orders panel.
  - By design: the towed guns (D-30, M119) are just the gun: no tablet, not on the datalink
    (`bcs_fnc_getGunBatteryType` needs `itc_land >> mountedTablet`); their crews work by voice and
    their sight shows only the current azimuth and quadrant. The FDC enters them by hand. The
    M1129 is an SPH like the others (2026-10-23).
  - Open: laser codes are not sent (they come from the observer).
  - Test: a test range station with two Sholef 2 (linked) and a D-30 (hand-entered); set up the battery on the FDC
    tablet, send, switch to the gunner seat. Then multiplayer: FDC and gun crews on different
    machines, and a player joining mid-mission.
- [ ] Realism, compared with real guns (2026-10-22):
  - Fuze setting: done (2026-10-23). `itc_land_burstHeight` per magazine (HE 15, smoke 100,
    ICM 400, FASCAM AT 300 / AP 400, illumination 600 m and aimed there); every solution carries
    the exact FS (`ballistics_fnc_calcFuzeSetting`, element 10), shown in the SPG app, the BCS
    gun lines and the orders panel and filled in by FDC ORDERS. Check the heights in game; the
    Extra/Falat cargo rounds keep `itc_land_timeModifier` (-5 s) for their carriers.
  - Delay fuze: done (2026-10-23). 0.05 s; `veh_weapons_fnc_fuze` removes the shell just before
    it hits (no burst on impact, which also ended a second explosion the old delay added) and
    bursts it after the delay half a metre into the ground or past a roof or wall, short of
    the ground beyond. Proximity bursts at the fuze's fixed `proxHOB` (9 m, realistic).
  - Russian 6000 mils: done (2026-10-23). `milSystem = 6000` on the Russian battery types
    (G152, RHS 2S1/2S3/D-30/2B14, CUP D-30); vehicles take the system of their weapon's battery
    type (`common_fnc_getMilSystem`). Display only (sights, orders panel, SPG app, BCS gun lines,
    `15-00` notation) plus the BCS mil inputs of those batteries; everything is computed in 6400.
    CBA setting `itc_land_common_russianMils` (on). The deflection is the converted US-style one
    (reference 30-00); check against the real Russian goniometer convention.

## 9. Documentation (after in-game testing, issue #1)

- [ ] Tracked as issue #2: accurate function headers + `Public: Yes` API marking,
      per-addon READMEs. The MkDocs Material user docs exist (`mkdocs.yml`, `docs/`);
      enable GitHub Pages (source: GitHub Actions) for the deploy workflow and re-check the
      pages against the game after in-game testing.

## 10. Known bugs

None open (2026-10-23: the BCS holds hand-entered guns and the battery solution to the battery
type's elevation limits, `bcs_fnc_getBatteryElevationLimits`; solutions start at the muzzle,
`common_fnc_getBarrel`).

## 11. Observers and the radar to fire direction

- [x] Target handoff (2026-10-23): "Send target to FDC" keybind (Ctrl+Shift+T) in the ITC UAV,
      GLTD and Strider optics (`veh_sights_fnc_sendTarget`) broadcasts "observer"/"target" over
      the datalink; FDCs that opened the BCS add it to the Location Stores (TGT01, ...). COBRA
      counter-fire (2026-10-23): COUNTER-FIRE on the COBRA data page opens a new BCS mission on
      the firing position at the engagement step (`itc_land_tablet_bcs_pendingTarget`).
- [ ] Still open: the observer's corrections during adjust fire over the datalink (today by
      voice into the adjustment page); sending from other observer devices (ACE Vector, laser
      rangefinders); targets reach every friendly FDC, not one picked FDC.
