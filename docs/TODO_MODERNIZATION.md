# Modernization TODO

Plan for bringing ITC Land Systems up to current Arma 3 modding standards.
The build/CI/code-structure side (HEMTT, CBA/ACE macros, PREP/XEH, function headers,
de-duplication into `common`) is already done. What remains:

Related: [TODO_LOCALITY.md](TODO_LOCALITY.md) (multiplayer/locality audit findings).

## 1. Localization (biggest gap)
- [ ] No stringtables exist (`hemtt check` reports "Checked 0 stringtables").
- [ ] ~186 hardcoded English `displayName` entries, plus UI text and the CIWS setting label.
- [ ] One `stringtable.xml` per addon (`STR_itc_land_<component>_...`).
- [ ] Configs use `$STR_...`, scripts use `LSTRING` / `localize`.
- [ ] English first, German optional.

## 2. Settings
- [ ] CIWS toggle is the only setting and uses legacy `CBA_Settings_fnc_init` (in postInit).
- [ ] Move to `CBA_fnc_addSetting` in an `initSettings.inc.sqf` per addon (preInit), with
      localized names, categories, and server/mission scope.
- [ ] Candidates: APS, datalink, tablet, ballistics tunables, debug logging.

## 3. Multiplayer / locality audit
- [ ] See [TODO_LOCALITY.md](TODO_LOCALITY.md). Pair with in-game regression issue #1.

## 4. Ballistics runtime performance
- [ ] `ballistics/fnc_calcShellTypeSolutions.sqf` and `tables/formattedBTab.sqf` use
      `compile preprocessFile` on every call (the only `call compile` left).
- [ ] Preprocess tables once (preInit, cached hashmap) or at build time.
- [ ] Audit PFH delays: no per-frame handlers where a delay suffices.
- [ ] Profile CIWS decoy-per-bullet entity creation.

## 5. Config hygiene
- [ ] Re-check `veh_defender` / `veh_rhea` `units[]` (older note about duplicate unit is stale).
- [ ] Finish or delete dormant pieces: `spike` CfgVehicles (commented out), `spike/fnc_reloaded`,
      `guidance/igm15x.sqf`, nonexistent `nim145` / `s750` guidance functions.
- [ ] `veh_uav06` `units[]` lists vanilla classes it does not define.
- [ ] Audit `requiredAddons` / `requiredVersion` against real dependencies.

## 6. Linting and CI
- [ ] `.hemtt/lints.toml` promoting key lints to errors.
- [ ] Script scanning for macros inside string literals (a bug class `hemtt check` misses).
- [ ] Replace Python checkers with HEMTT-native stringtable/config checks once stringtables exist.
- [ ] CI `hemtt build` job (binarization currently "Validated 0 files"), caching, signing key.
- [ ] `hemtt publish` for Steam, Dependabot for Actions, pinned CBA/ACE versions.

## 7. Testing
- [ ] Only one manual VR mission today.
- [ ] CBA unit tests for pure functions in `common` (getDeflection, gridToPos/posToGrid,
      simulateTrajectory, fuze resolution).
- [ ] Smoke missions for APS, CIWS, VLS.

## 8. Compatibility and polish
- [ ] Zeus Enhanced / ACE Zeus modules, editor categories and subcategories.
- [ ] ACE Arsenal / cargo sizes for packable items.
- [ ] Eden attributes for settings.
- [ ] Use newer commands where it helps (`getOrDefault`, etc.).
- [ ] Real Steam Workshop ID in README badges and `mod.cpp` (currently `id=0`); version is 0.1.0.

## 9. Documentation (after in-game testing, issue #1)
- [ ] Tracked as issue #2: accurate function headers + `Public: Yes` API marking,
      per-addon READMEs, MkDocs Material site on GitHub Pages.

## Suggested order
1. In-game test (#1) + locality audit fixes.
2. Stringtables (1) and settings (2) together.
3. Ballistics performance (4), config cleanup (5).
4. Lints/CI (6), tests (7).
5. Polish (8), docs (9).
