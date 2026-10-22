# TODO

Open work for ITC Land Systems. Finished items are in git history and `CHANGELOG.md`.
Section numbers are kept stable so commits and issues can refer to them.

## Next up

1. In-game verification: issue #3 (full checklist; the list below is the short version).
2. Decide on the dormant content (5).
3. Fix the duplicate UI base classes (5), it needs the in-game check anyway.
4. Tests (7).
5. Translations (1), compatibility (8), then documentation (9).

## In-game verification

Partly tested in game (issue #3, ticks up to 2026-10-21 21:14). What is still open is below;
full checklist with setup and expected behaviour: issue #3.

Locality fixes:

- [ ] COBRA on a dedicated server: the server receives fired shells; markers and
      engagements show on clients; a shell is counted once with two COBRAs; all
      players hear the sirens.
- [ ] SPH autoloader with gunner and driver on different clients.
- [ ] APS: two shooters at the same vehicle; ammo/reload state stays consistent.
      The elevation limit (10-40 deg) and the out-of-ammo check are now enforced,
      check that top-attack coverage is still acceptable.
- [ ] Spike fired by an AI unit (no camera on the AI's machine).
- [ ] VLS: launches from the dialog still hit; a scripted VLS round without a dialog
      target flies unguided without script errors (AI gunners no longer launch).
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
      ITC PzH 2000 loads, fires and reloads through the ammunition handler, its tablet SPG app
      gives solutions that hit, the gun recoils and shows its muzzle flash; BCS solutions for the
      BWMod MRS120 hit for every charge.
- [ ] BCS Mk6 battery with the vanilla `8Rnd_82mm_*` rounds (ACE mortar ammunition handling off):
      solutions appear and hit, labelled with the mortar's mode names.
- [ ] CIWS decoys stay invisible on the other machines (`setObjectTexture` is local; the
      config's blank textures have to cover the rest, else use `setObjectTextureGlobal`).
- [ ] Tablet: firing solutions match the ones before caching; the first solution per shell
      type may hitch once while its tables compile.

User-flow fixes from the code review:

- [ ] SPH dual-laser (Falat) rounds use both laser codes entered at Apply.
- [ ] Saved list selections (SPH ammo/fuze, VLS angle, MLRS fuze) restore correctly,
      including the last entry.

Settings and dependencies:

- [ ] CBA settings can be forced by the server; COBRA range/engagement window and APS/CIWS
      toggles take effect.
- [ ] SPH loader status text shows correctly for the other crew members.
- [ ] Record the startup RPT's `Updating base class` lines for `ITC_LAND_Rsc*` in issue #3;
      the duplicate UI classes fix (5) needs them.

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
  - Spike LR camera seeker (`fired`, `selectSpike`): missile flies as configured.
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
- No switch possible: vehicles/UAVs, Strider, remote frag, smoke dispenser, Mk6 ammo are
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

Only if the datalink gets a live caller (nothing uses it today):

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

- [ ] Decide per item: finish, keep dormant, or delete. Inventory of content that
      exists but cannot be reached in game (from 2026-09-29, re-verify before deleting):
  - 105 mm and 122 mm howitzers: decided, framework only (see below)
  - 155 APF round, CIWS RIM-116 launcher (not mounted): dropped from the roadmap, not
    planned; candidates for deletion
  - static Spike LR (`spike/CfgVehicles.hpp` include commented out), `spike/fnc_reloaded`
    (no-op, registered but never called)
  - SPH ammo handler on the vanilla Scorcher/Sochor (`sphammohandler/CfgVehicles.hpp`,
    never included)
  - remote-frag detonator item (CfgWeapons commented out)
  - tablet: SADL app, handheld MLRS tablet (no action), UI prototypes
    (`fcs_manualmode`, `missileConfigRework1`, `engageFiremission2`), the unregistered
    helpers `functions/util/arrayToPage.sqf` and `vehicleHasInterface.sqf`
  - UAV02/UAV05 custom UI (includes of missing files)
  - `veh_uav01/fnc_drawCompass.sqf` (3D compass ticks via `drawIcon3D`): never registered,
    its only caller (`itc_land_veh_darter_fnc_drawCompass` in `rover/fnc_ui_draw`) is commented out
  - registered but never called: `ballistics/fnc_getVehicleShellType` (reads
    `fcs >> tableList`, which nothing else uses), `rover/fnc_ui_curPlane`
  - `guidance/igm15x.sqf` (dual GPS/laser guidance), `veh_weapons/fuzeProxFOV.sqf`,
    `vls` getGuidanceOptions (never registered)
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
- [ ] `common/CfgUI.hpp` and `tablet/UIConfig/ControlBaseClasses.hpp` both define the
      root classes `ITC_LAND_RscText`, `RscEdit`, `RscStructuredText`, `RscPicture`,
      `ScrollBar`, `RscListBox`, `RscComboBox`, `RscButton`; the tablet versions have no
      parent, so the engine merges both and drops the `RscText`/... base classes. The
      tablet file is marked "VESTIGIAL: to be removed following retesting" by its author.
      Pick one definition (or rename the tablet ones) and check the tablet, VLS and SPH
      dialogs in game. `sphammohandler` and `vls` use these classes, so they depend on
      whichever definition loads last.
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

- [ ] CBA unit tests for pure functions in `common` (getDeflection, gridToPos/posToGrid,
      simulateTrajectory, fuze resolution).
- [x] Test range mission (`.hemtt/missions/itc_land_vr_test.VR`, started by `hemtt launch`):
      stations for every issue #3 section, a control board with teleports, scenarios
      (enemy barrage, APS attack, AI Spike/VLS shots, air target, Zeus) and diagnostics.
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
- [ ] BCS battery solutions to the gunner sights. Today only the SPG app's local solution
      reaches a gun's sight (it writes `itc_land_tablet_fcs_solutions`/`_index` on the vehicle,
      which `common_fnc_getFireSolution` reads for MA/MQ and the alignment guide). The BCS
      cannot write anything: a gun in Battery Setup is just a number with a hand-typed grid,
      elevation and direction, not a vehicle, so its per-gun solutions stay on the tablet and
      are relayed by voice. To do:
  - Battery Setup: "add gun" links a real ITC artillery vehicle (the one you sit in, or one
    picked from nearby ones) and fills its grid, elevation and direction from it; keep manual
    entry for guns without a link (e.g. other mods' guns, vanilla mortars).
  - Solution page: a SEND button that writes each linked gun's line of the battery solution to
    its own vehicle (public variables, works in MP), in the format of
    `ballistics_fnc_calcShellTypeSolutions` so the sight, the alignment guide and the SPG app
    need no change. Decide what happens to a local solution already on the vehicle (newest
    wins is the simplest) and whether SLN+/SLN- on the FDC resends.
  - Optional: preset the shell, charge, fuze and count of the mission in the gun's ammunition
    handler.
  - Update the BCS docs (`docs/systems/bcs.md`), which describe the voice relay.

## 9. Documentation (after in-game testing, issue #1)

- [ ] Tracked as issue #2: accurate function headers + `Public: Yes` API marking,
      per-addon READMEs. The MkDocs Material user docs exist (`mkdocs.yml`, `docs/`);
      enable GitHub Pages (source: GitHub Actions) for the deploy workflow and re-check the
      pages against the game after in-game testing.

## 10. Known bugs

- [ ] MLRS calculates a firing solution when no input grid is given; it should refuse (or
      show no solution) until a target grid is entered.
- [ ] Artillery tablet status page: some glass hitpoints still show the raw class name because
      ACE Repair has no `STR_ACE_Repair_<hitpoint>` string for them; add own strings or a mapping.
- [ ] Fire solutions are wrong for targets near the top of the trajectory (low-angle fire at
      short/medium range, or targets high above the gun): `ballistics_fnc_calcBtabSolution`
      interpolates linearly between 100 m height slices, but range follows a square-root curve
      near the apex, and the generator (`tables\calcBallistics.sqf`) stores the apex itself as an
      extra slice that the lookup reads as the next 100 m gate. Measured against exact
      ballistics: ch2 LA 1000 m / +30 m misses by -85 m, ch3 LA 1500 m / +40 m by -166 m, ch4 LA
      2500 m / +60 m by +390 m; 9-13 % of reachable ch2/ch3 LA targets wrongly get "no
      solution". High-angle fire and targets well below the apex are fine (1-10 m).
      Fix: every table uses `airFriction = 0`, so replace the table lookup with the exact vacuum
      solution and drop the tables:
      `tan q = (v^2 -/+ sqrt(v^4 - g (g R^2 + 2 h v^2))) / (g R)` (- low angle, + high angle;
      no solution if the root is negative), `TOF = R / (v cos q)`,
      `impact speed = sqrt(v^2 - 2 g h)`, `impact angle = atan((v sin q - g TOF) / (v cos q))`,
      `max ordinate = (v sin q)^2 / (2 g)`, with `g = 9.80665`, `v` = the charge magazine's
      `initSpeed`, `R` = horizontal distance, `h` = target height minus muzzle height. Keep the
      output format of `calcBtabSolution`. Also use the muzzle position instead of
      `getPosASL _vehicle` for the gun height (a few metres). Revisit if shells ever get drag.
