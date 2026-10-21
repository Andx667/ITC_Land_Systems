# TODO

Open work for ITC Land Systems. Merged from the earlier modernization and
locality TODO lists, now holding only the unfinished items (the finished ones
are in git history and `CHANGELOG.md`). Section numbers match the original
modernization plan.

## In-game verification (do first, with regression issue #1)

Changed by the locality fixes and only checked by `hemtt check` so far:

- [ ] COBRA on a dedicated server: the server receives fired shells; markers and
      engagements show on clients; a shell is counted once with two COBRAs; all
      players hear the sirens.
- [ ] SPH autoloader with gunner and driver on different clients.
- [ ] APS: two shooters at the same vehicle; ammo/reload state stays consistent.
      The elevation limit (10-40 deg) and the out-of-ammo check are now enforced,
      check that top-attack coverage is still acceptable.
- [ ] Spike fired by an AI unit (no camera on the AI's machine) and by a player.
- [ ] SAM-35 fired from a client explodes.
- [ ] Packing a deployed item drops the packed item where it stood.

## 1. Localization

Config strings (names, descriptions, dialog labels) and the visible script strings
(tablet apps, sights, SPH loader, packing, VLS) are in per-addon stringtables.

- [ ] Translations (English only so far; German first?).
- [ ] Remaining script strings not shown in normal UI: datalink ID validation errors,
      the `ballistics/formattedBTab` dev tool. Acronyms and product names (COBRA, AIFMS,
      DTV/HOT) were left untranslated on purpose.
- [ ] Some keys are named after generic control classes (`RscText_1006_Text`, ...);
      rename to meaningful names when touching those dialogs.
- [ ] 37 keys are unused (`hemtt check` L-L02U) because they come from config files
      that are never included (105 mm rounds, tablet UI prototypes, static Spike, SPH
      vehicle config). They go away or get used with the dormant-content decision (5).

## 2. Settings

- [ ] Further candidates: CIWS/COBRA arc and siren trigger distance, SPH loader
      timings, debug logging.

## 3. Multiplayer / locality (remaining low-priority audit items)

- [ ] CIWS decoy per bullet: each tracked round creates a networked vehicle + crew.
- [ ] CIWS Zeus hook runs once: `allCurators` handlers added at postInit only and
      broadcast from every machine; curators created later are missed.
- [ ] VLS launch data in two globals (`itc_land_target_test`, `itc_land_target_IAtest`)
      while the same data is already per vehicle (`itc_land_vls_targetPos`/`targetAngl`).
- [ ] Datalink: respawn leaves the registration on the old body. No live caller
      uses the datalink yet.

## 4. Ballistics runtime performance

- [ ] `ballistics/fnc_calcShellTypeSolutions.sqf` and `tables/formattedBTab.sqf` use
      `compile preprocessFile` on every call (the only `call compile` left).
- [ ] Preprocess tables once (preInit, cached hashmap) or at build time.
- [ ] Audit PFH delays: no per-frame handlers where a delay suffices.

## 5. Config hygiene

- [ ] Decide: finish or delete dormant pieces: `spike` CfgVehicles (static Spike LR,
      commented out), `spike/fnc_reloaded` (no-op, never registered),
      `guidance/igm15x.sqf` (dual GPS/laser guidance, never registered),
      `veh_weapons/fuzeProxFOV.sqf` (never registered).
- [ ] `common/CfgUI.hpp` and `tablet/UIConfig/ControlBaseClasses.hpp` both define
      the root classes `ITC_LAND_RscText`, `RscEdit`, `RscStructuredText`, `RscPicture`,
      `ScrollBar`, `RscListBox`, `RscComboBox`, `RscButton`; the tablet versions have no
      parent, so the engine merges both and drops the `RscText`/... base classes. Pick
      one definition (or rename the tablet ones) and check the tablet, VLS and SPH
      dialogs in game. `sphammohandler` and `vls` use these classes, so they depend on
      whichever definition loads last.

## 6. Linting and CI

Done: `.hemtt/lints.toml` (S04/S12/S13/S17/S29/S38, C12 and stringtable sorting are
errors), `tools/macro_in_string_checker.py` in the Validate workflow, Dependabot for
GitHub Actions, checks documented in `CONTRIBUTING.md`.

- [ ] Replace `tools/macro_in_string_checker.py` with a HEMTT TOML lint
      (`.hemtt/lints/*.toml`) once a HEMTT release after 1.22.0 supports them.
- [ ] Optional pedantic lints (`hemtt check -p`): ~12 unused variables (S14), 3 unneeded
      `!` in `if` (S11), 3 short-circuit hints (S26), 5 unnecessary `_this` in config
      calls (C13). Code-quality pass, not bugs.
- [ ] `hemtt publish` to Steam from CI (needs Steam credentials as repo secrets).
- [ ] The Python stringtable and config-style checkers stay: they check naming and style
      conventions HEMTT does not.

## 7. Testing

- [ ] CBA unit tests for pure functions in `common` (getDeflection, gridToPos/posToGrid,
      simulateTrajectory, fuze resolution).
- [ ] Smoke missions for APS, CIWS, VLS (only one manual VR mission today).

## 8. Compatibility and polish

- [ ] Zeus Enhanced / ACE Zeus modules, editor categories and subcategories.
- [ ] ACE Arsenal / cargo sizes for packable items.
- [ ] Eden attributes for settings.
- [ ] Use newer commands where it helps (`getOrDefault`, native hashmaps instead of
      CBA hashes, etc.).
- [ ] Real Steam Workshop ID in README badges and `mod.cpp` (currently `id=0`);
      version is 0.1.0.

## 9. Documentation (after in-game testing, issue #1)

- [ ] Tracked as issue #2: accurate function headers + `Public: Yes` API marking,
      per-addon READMEs, MkDocs Material site on GitHub Pages.
