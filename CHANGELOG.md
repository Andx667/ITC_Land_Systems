# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- `hemtt publish` looks up the entry whose heading exactly matches the
current project version (see .hemtt/project.toml's [version] /
addons/main/script_version.hpp) -- so before publishing, rename
"[Unreleased]" below to "[X.Y.Z] - YYYY-MM-DD" matching that version, and
start a fresh empty [Unreleased] section above it. -->

## [Unreleased]

### Removed

- The smoke dispenser (`itc_land_smokedispenser`, `itc_land_smokeDispenser_mag`): hidden, carried by no vehicle and not deployable, despite the docs calling it a vehicle magazine. Smoke screens stay with the vanilla vehicles' smoke launchers.
- The remote frag grenade (`itc_land_remotefrag`, `ITC_Land_remoteFrag_mag`): a hand grenade placed and set off like an ACE explosive. Outside the mod's artillery scope; ACE has its own placeable charges. Missions that use it no longer find it.
- The Spike LR (`itc_land_spike`: the `itc_land_spikeLR` launcher and its missile, the missile camera and its CBA setting). ACE ships its own Spike LR (`ace_spike`), and the BWMod MELLS is based on the ITC one. Missions that use the ITC launcher no longer find it.

### Added

- GTK Boxer compatibility (`compat_gtk_boxer`), loaded only with the GTK Boxer: ITC versions of the Boxer RCH 155 (`itc_land_gtk_boxer_rch155`, `_sand`) with the Sholef 2's 155 mm L/52 gun and rounds, automatic loader, ammunition handler and mounted tablet for the commander (the RCH 155's gun seat), and the ITC sight readouts over the Boxer's optics. `.hemtt/launch.toml` has a `gtk` profile.

### Changed

- BCS Alert To Splash: SPLASH now beeps (the vanilla firing drill timer, `FD_Timer_F`) and shows a hint with the mission and seconds to impact, also while the tablet is closed; before, only the word in the mission list changed. The default is 5 s (was 10), as the FDC calls splash 5 s before impact. Saving the settings with an Alert To Splash that is not a number above 0 is refused with a hint (before, it silently became 0 and SPLASH never showed).
- Panzerhaubitze 2000: the ammunition handler moved from the gunner to the loader (BWMod's gunner 2 seat). While the loader seat is empty, the gunner still opens it.
- Gunner sight of other mods' guns (Panzerhaubitze 2000, Boxer RCH 155, RHS 2S1/2S3/M109): it now shows the same information as the sight of the ITC guns. Added: heading, laser range, the round count of the current mission in the loader status, and the FCI orders panel (hidden like on the ITC guns until fire orders exist). Both sights now run on the same update loop, so they stay in step; only the look and the alignment guide of the ITC guns differ.

### Fixed

- SPG and MLRS tablet apps: solutions the gun cannot lay are no longer offered. The firing tables reach steeper than some guns (155 mm high angle to 80°, PzH 2000 72°, Boxer RCH 155 65°, Hammer 2 70°, Seara 2, Zamak and CUP M270 66°); the apps now drop solutions outside the gun turret's elevation limits.
- BCS: without opening Bty Setup first, the engagement page offered no ammunition, and the solution page then threw script errors. The ammunition now comes straight from the active battery type. The new fire mission and engagement pages also stay put and say what is missing when the target has no valid position (no or a malformed grid, Shift or Polar without a known point, QuickLay without guns) or no ammunition is selected; missions saved that way show NO SOLUTIONS.
- Gunner sight of the Panzerhaubitze 2000 and Boxer RCH 155: the loader status line was half height and clipped under the AUTOLOADER SETTINGS title.
- CUP compatibility: the M1129 config gave `Wheeled_APC_F`'s turrets a parent class they don't have, which re-parented the turrets of every wheeled APC as soon as CUP was loaded (RPT `Updating base class`).

## [0.1.0] - 2026-10-22

### Added

- Stringtables for every addon: vehicle, weapon and magazine names, dialog labels and script-generated UI text can now be translated. The SPH loader status is published as a stringtable key, so every crew member sees it in their own language.
- CBA settings under "ITC Land Systems": enable/disable APS, COBRA detection range and engagement window, Spike camera sensitivity (per player). The CIWS toggle moved to the same category.
- CUP M1129 Stryker mortar carrier: ITC versions (`itc_land_cup_m1129_desert`, `_woodland`) with firing tables for its three charges, a BCS battery type and the ITC sight. CUP's M1129 fires the vanilla ship cannon round, a 155 mm shell; the ITC version fires the new `itc_land_120mm_mortar` (120 mm mortar shell between the 82 mm and the 122 mm), CUP's own classes are unchanged.
- BWMod compatibility (`compat_bwa3`), loaded only with BWMod: the ITC Panzerhaubitze 2000 moved here from the TTT mod (class names unchanged) and now fires the ITC 155 mm L/52 rounds and tables like the Sholef 2 instead of copies of the M109 tables (whose charge 1 did not match its 92 m/s rounds); the ammunition handler moved from an XEH to the weapon, and the reload and muzzle flash animations follow the ITC gun. It now loads automatically (about 5 s per round) like the real gun, instead of the semi-automatic sequence. New: firing tables for the MRS120 mortar's three charges and a BCS battery type, so the BCS computes fire missions for BWMod's MRS120 (no ITC version: ACE covers mortars). `.hemtt/launch.toml` has a `bwa3` profile.
- CUP compatibility, loaded only with CUP: `compat_cup_units` adds ITC versions of the CUP D-30 and M119 (ITC sight, BCS battery types, firing tables shared with the vanilla AMOS), `compat_cup_vehicles` ITC versions of the CUP M270 MLRS set up like the Seara 2 (ITC 230 mm rockets, MLRS sight, mounted tablet). `.hemtt/launch.toml` has a `cup` profile.
- RHS compatibility moved into the mod as `compat_rhs_afrf` and `compat_rhs_usaf`, which load only when RHS: AFRF / USAF is loaded (`skipWhenMissingDependencies`); the standalone "ITC Land Systems - RHS AFRF/USAF Compatibility" mods are no longer needed. Class names are unchanged and the old addon names are kept, so existing missions still load. Fixed on the way: the D-30 used the M119's firing tables (wrong speeds and only 3 of its 6 charges) and has its own now; the M109 and 2S3 charge 1 rounds left the barrel at 92 m/s but were computed for 85 m/s; the 2S3 high-angle tables started at 15° and gave two answers per distance; the 2S1 fired 155 mm ammunition and now uses the ITC 122 mm rounds; the M109 config rewired RHS's own Paladin to the wrong parent class; the M252 gun bag was an M2 gun bag; the M252 battery type no longer offers the vanilla/ACE 82 mm rounds, whose tables are for the Mk6's charges; the 2S1, 2S3 and M109 lost their recoil and muzzle flash animations, which RHS ties to its own weapon. The ITC 2B14 and M252 mortars are hidden in Eden, Zeus and the Arsenal and only kept for old missions: ACE covers mortars, and the BCS works with the RHS originals through their firing tables and battery types. `.hemtt/launch.toml` has `rhs`, `rhs_afrf` and `rhs_usaf` profiles.
- Tablet: tooltips on the labels and readouts whose meaning or unit is not obvious (fire control, BCS setup, fire missions and solutions, rocket fuze and guidance, vehicle status, app interfaces). The new fire mission fields change their tooltip with the target type.
- BCS battery setup shows the active battery type (not just the one selected in the list), and each gun in the gun list carries the battery callsign it was saved with.
- Documentation site (MkDocs Material, `docs/`): every system with its vehicles and classnames, usage (tablets, interactions, settings), the RHS/CUP/BWMod compatibility, and a page for mission makers and modders.
- Test range mission (`.hemtt/missions/itc_land_vr_test.VR`, started by `hemtt launch`) with a station per section of the in-game checklist, a control board with teleports, scenarios and diagnostics, and `tools/debugMP.bat` with launch profiles for a local dedicated server and two clients.

### Fixed

- CIWS: Praetorian 2 and Spartan 2 placed by script or Zeus started with their radar off; the shell decoys are radar-only targets, so those CIWS never engaged incoming shells. Every one now switches its radar on at init.
- Falat: the first submunition used the second laser code and the second fell back to 1111; each now uses its own entered code.
- Tablet: panel backgrounds were transparent and controls overlapped on every tablet page (the shared base classes were not included, and layout macros sat inside strings); the BCS battery-type list crashed on Save Bty Type, and loading a known point with nothing selected errored.
- The mod logo was missing in the launcher, and packed items could not be unpacked (`itc_land_packableItem` was not defined in `CfgWeapons`).
- Clipped text: the GLTD and Strider optics' heading and grid readouts, the SPH sight's azimuth and quadrant readouts (they ran into the reticle), the ROVER no-connection hint and the Spike MANUAL label.
- The CIWS, Rhea, Defender and VLS addons declared the vanilla static turret base without its parent, so the RPT logged `Updating base class` notes against other addons.
- Mk6: the ACE illumination round (`ACE_1Rnd_82mm_Mo_Illum`) was given the wrong parent class (RPT `Updating base class`).
- Strider: the config gave the unarmed Strider (vanilla and ITC StriderRV) a second turret it doesn't have, and re-parented the HMG Strider's gun turret (RPT `Updating base class`).
- Tablet vehicle status page: numbered hitpoints (glass, wheels, ...) showed their raw class names. They are now named like in the ACE repair menu ("Glass", "Glass 2").
- SPG and MLRS tablet apps: CALC SLN without a target grid (or with a malformed one) computed a solution to the map's corner; it now shows no solution until a grid of 4 to 10 digits is entered.
- Firing solutions: low-angle fire at targets near the top of the trajectory (short range, or targets well above the gun) was off by up to hundreds of metres, and about one in ten reachable low-angle targets got no solution at all. Every gun and mortar now gets the exact solution (all ITC tables are computed without air friction) instead of an interpolation between the table's 100 m height steps.
- 105 mm: charge 5 HE, smoke and illumination rounds left the barrel at the charge 4 speed (320 m/s) while the fire control computed charge 5 for 400 m/s, so they landed kilometres short.
- COBRA: impact/engagement/siren timing used the per-machine `time` in some places and `cba_missionTime` in others; everything now uses `cba_missionTime` so clients agree with the host.
- SAM-35: proximity detonation only spawned on the server, so client-fired missiles disappeared without exploding.
- APS: the elevation limit was never enforced (`&&` instead of `||`); removed leftover debug chat output.
- CIWS: the Praetorian 2 radar, now always on, also detected ground vehicles out to 8 km and shared them over datalink, so AI-crewed VLS launchers fired cruise missiles at enemy artillery on their own. CIWS units are anti-air only: their radar and IR sensors no longer have ground bands.
- Gunner sight (Sholef 2, Sochor 2, Hammer 2): the alignment guide was switched off, compared the gun azimuth in degrees with the mission azimuth in mils, and had no quadrant mark. It is now shown while a solution is selected, with azimuth and quadrant marks on the crosshair (25 mils per dot) and arrows when the gun is more than 100 mils off.
- VLS: the launchers only fire on user input (gunner seat, launch dialog, scripts); AI gunners never launch by themselves. The ESSM launcher's AI ranges were set on the weapon, but the game reads them from its fire mode, so they never applied.
- APS: a module's traverse arc did not wrap across north, so depending on the vehicle's heading a module (e.g. the left Trophy on a north-facing Slammer) covered almost nothing. Incoming rounds are now checked every frame instead of every 0.05 s and are no longer tracked once killed (a second module could fire at the same dying round), and every lost rocket no longer resets time acceleration to 1.
- Packing a deployed item spawned the weapon holder at `[0,0,0]` and did nothing if the item was not local.
- Datalink: removed leftover debug chat output on client connect.
- SPH autoloader: with driver and gunner on different machines, the loading sequence finished but the round never reached the gun. Magazine changes are now applied to the main turret on the gunner's machine, where the turret is local (the vehicle itself is local to the driver).
- APS: module ammo/reload state is now applied by the vehicle's owner via an event instead of being overwritten by each shooter; modules with no ammo left no longer intercept, and joining clients no longer reset APS state.
- Spike: the seeker camera only starts for the player-controlled shooter, not for AI units local to the machine.
- COBRA: placing a second COBRA no longer wipes the first one's data, and a shell is no longer missed by one COBRA because another already consumed it. Sirens are now heard by all players, not only the host.
- Datalink: transmissions are delivered to the machine that connected the target (where its handlers are registered), and registry entries are removed when the object is deleted or its player disconnects.
- Addons that extend ACE config classes (interaction menus, items, explosives, HuntIR, missile guidance) now list those ACE addons in `requiredAddons`, so the load order is guaranteed.
- `veh_uav06` no longer claims the vanilla AL-6 classes in its `units[]`.
- BCS: the vanilla 82 mm mortar rounds had no firing tables (only the ACE single rounds did), so the Mk6 battery type gave no solution for them. The tables now sit on the vanilla rounds, which also covers every other mod's mortar built on `mortar_82mm` and its rounds (e.g. the CUP 2B14, M252, L16A2).
- Ballistics: the vanilla AMOS tables (`b_155`, 810 m/s, the five `mortar_155mm_AMOS` charges) start at -9° elevation instead of 0° and are labelled with the game's fire mode names; the RHS M119 uses them instead of its own copy.
- Ammunition handler and tablet SPG app: the gun is now taken from the main turret instead of the first of the vehicle's weapons, which on vehicles with a hull weapon (the RHS M109's smoke generator) could be the wrong one: no firing solutions, and loading cycled the wrong weapon.
- Firing solutions: the deflection counted the wrong way round. It now follows the US convention, 3200 along the gun's set direction, more to the left and less to the right (a target 200 mils left read 3000 instead of 3400).
- BCS: the M230 battery type was labelled 227 mm; the rockets are 230 mm.
- SPH autoloader: after a shot, the next round is loaded on the vehicle that fired, not on the vehicle of the player on the gunner's machine, so automatic reloading also works with an AI gunner on the server or a headless client.
- COBRA: sirens near a predicted impact did not sound on high ground. The impact position is ASL but the siren search read it as AGL, so the 500 m trigger radius shrank with terrain height and nothing triggered above 500 m ASL.
- Spike: the lead on moving targets and the minimum target distance used an ASL target position as AGL, so on high ground the missile over-led its target. The launcher sight also threw a script error every frame while a locked target was off screen.
- ROVER and Spike camera clocks now show minutes with two digits (14:05 instead of 14:5).
- Defender and Rhea magazines no longer reference guidance functions that never existed.
- CIWS: decoys for incoming shells no longer leave their AI crew and group behind. Zeus-placed radar vehicles get their radar switched on also for curators created mid-mission, on the machine that owns the vehicle.
- VLS: guidance reads the launch target from the vehicle instead of two shared globals, and an AI-fired round without a target flies unguided instead of erroring.
- SPH loader: loading and fuzing now use the applied settings; changing the ammo, charge or fuze selection afterwards no longer changes the loaded round or its fuze until Apply is pressed again. Dual-laser rounds now keep laser code 1.
- Tablet: opening a different tablet no longer resumes an app that tablet doesn't have, app buttons without an app return to the home screen, and the tablet stops cleanly when closed or when the player dies.
- Gunner sights no longer leave a per-frame handler running every time the player leaves the vehicle.
- Spike: the missile camera and its screen effects are always removed when the player dies, switches weapon or the missile hits, and a camera left over from an earlier flight is removed before the next one starts.
- BCS page buttons work while controlling a UAV; the BCS target-type labels are translatable.
- ROVER tablet: 51 control positions used layout macros inside quoted strings, so the game received undefined names instead of numbers; the controls now sit where they were designed to.
- Tablet: the BCS new/engage fire mission pages, the BCS solution page and the MLRS page no longer share control IDs with other pages, so showing or hiding a control by ID can no longer hit the wrong page.
- Saved list selections (SPH ammo/fuze, VLS impact angle, MLRS fuze) restore correctly, including the last entry; the MLRS round-type page shows the applied PGM grid and altitude.

### Changed

- No more `remoteExec`, `spawn`, `sleep` or `waitUntil`: everything runs unscheduled through CBA events and timers, so servers with a `CfgRemoteExec` whitelist need no entries for ITC.
- The handheld SPG tablet (`itc_land_tablet_spg`) is hidden for now (scope 0): its SPG app only works inside an ITC artillery vehicle, which carries the mounted tablet anyway.
- Spike: slower default camera sensitivity.
- Marked as beta (0.1.0) in the README, `mod.cpp` and the Workshop text.
- The base dialog controls (`ITC_LAND_RscText`, `RscButton`, ...) are defined once, in `itc_land_common`. They were defined twice, and the tablet's versions silently replaced the common ones (RPT `Updating base class`), so the SPH loader and VLS dialogs depended on the tablet loading last. The controls are the ones the game used before, nothing looks different.
- Sholef 2 and Sochor 2 load automatically (about 5 s per round) instead of semi-automatically (11 to 17 s); the vanilla guns they are built on reload in 7 s. The Hammer 2 mod. 0 and the ITC versions of the RHS guns stay semi-automatic, the Hammer 2 mod. 1 automatic.
- Ballistic tables are compiled once and cached instead of on every firing solution (BCS computed them per gun).
- Tablet app and page scripts are compiled once and cached instead of on every app/page switch (recompiled each time when `DISABLE_COMPILE_CACHE` is set).
- The MOF35 Mod3 time fuze waits with `CBA_fnc_waitAndExecute` instead of checking every frame.
- CI: key HEMTT lints are now errors, a new check rejects macros inside string literals (CBA/ACE macros and the project's own defines), and Dependabot keeps the GitHub Actions up to date.
- COBRA is now server-authoritative: only the server tracks shells and runs the scan, and it publishes COBRAs, firing positions, engagements and predicted impacts to clients (previously every machine ran its own simulation).
- Rebuilt the repo on HEMTT with modern CI/CD, replacing the old build tooling.

### Removed

- `itc_land >> fcs >> tableList` in vehicle configs: the fire control never read it, the tables come from the magazine's `itc_land_btabListFile`.
- BCS settings: the Voice Warning option, which had no function behind it.
- The empty `itc_land_towedAmmoHandling` addon.
