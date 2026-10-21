# TODO

Open work for ITC Land Systems. Finished items are in git history and `CHANGELOG.md`.
Section numbers are kept stable so commits and issues can refer to them.

## Next up

1. In-game verification (below), together with regression issue #1.
2. Decide on the dormant content (5).
3. Fix the duplicate UI base classes (5), it needs the in-game check anyway.
4. Tests (7).
5. Translations (1), compatibility (8), then documentation (9).

## In-game verification

Only checked by `hemtt check` so far.

Locality fixes:

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
- [ ] CIWS: Zeus-placed radar vehicles have their radar on, also with a curator created
      mid-mission; a long barrage leaves no orphan AI units or groups.
- [ ] VLS: launches from the dialog still hit; an AI-fired VLS round flies unguided
      without script errors.
- [ ] MOF35 Mod3 (Falat) rounds release their submunitions at the set fuze time.
- [ ] Tablet: switching apps/pages still works (scripts now cached); first firing
      solution per shell type may hitch once while its tables compile.

Settings, localization and dependencies:

- [ ] CBA settings show under "ITC Land Systems" and can be forced by the server;
      COBRA range/engagement window and APS/CIWS toggles take effect.
- [ ] No raw `STR_itc_land_...` keys anywhere: tablet apps, sights, SPH loader dialog,
      VLS dialog, Arsenal/editor names, ACE interaction menus.
- [ ] SPH loader status text shows correctly for the other crew members.
- [ ] RPT at startup has no missing-class or `Updating base class` warnings (the
      second confirms the duplicate UI classes in 5).

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

## 3. Multiplayer / locality (remaining low-priority audit items)

- [ ] CIWS decoys: every interceptable shell (artillery/mortar/rocket, not every
      bullet) spawns a networked decoy vehicle with an AI crew so CIWS AI sees a
      hostile target. The crew leak is fixed; profile a large barrage in MP to see
      whether the per-shell vehicle/group creation is acceptable.

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
  - 105 mm howitzer magazines (`veh_weapons/CfgMagazines_105mm.hpp`, never included),
    122 mm howitzer (not mounted), 155 APF round
  - CIWS RIM-116 launcher (not mounted)
  - static Spike LR (`spike/CfgVehicles.hpp` include commented out), `spike/fnc_reloaded`
    (no-op, never registered)
  - SPH ammo handler on the vanilla Scorcher/Sochor (`sphammohandler/CfgVehicles.hpp`,
    never included)
  - remote-frag detonator item (CfgWeapons commented out)
  - tablet: SADL app, handheld MLRS tablet (no action), UI prototypes
    (`fcs_manualmode`, `missileConfigRework1`, `engageFiremission2`), the unregistered
    helpers `functions/util/arrayToPage.sqf` and `vehicleHasInterface.sqf`
  - UAV02/UAV05 custom UI (includes of missing files)
  - `guidance/igm15x.sqf` (dual GPS/laser guidance), `veh_weapons/fuzeProxFOV.sqf`,
    `vls` getGuidanceOptions (never registered)
  - the datalink system (see 3)
- [ ] `common/CfgUI.hpp` and `tablet/UIConfig/ControlBaseClasses.hpp` both define the
      root classes `ITC_LAND_RscText`, `RscEdit`, `RscStructuredText`, `RscPicture`,
      `ScrollBar`, `RscListBox`, `RscComboBox`, `RscButton`; the tablet versions have no
      parent, so the engine merges both and drops the `RscText`/... base classes. Pick
      one definition (or rename the tablet ones) and check the tablet, VLS and SPH
      dialogs in game. `sphammohandler` and `vls` use these classes, so they depend on
      whichever definition loads last.

## 6. Linting and CI

Done: `.hemtt/lints.toml` sets S04/S12/S13/S29/S38, C12 and stringtable sorting to
errors (verified by planting violations; S17 is set too but did not fire on a test
global), `tools/macro_in_string_checker.py` runs in the Validate workflow, Dependabot
covers GitHub Actions, checks are documented in `CONTRIBUTING.md`. The Python
stringtable and config-style checkers stay, they check conventions HEMTT does not.

- [ ] Replace `tools/macro_in_string_checker.py` with a HEMTT TOML lint
      (`.hemtt/lints/*.toml`) once a HEMTT release after 1.22.0 supports them.
- [ ] Optional pedantic lints (`hemtt check -p`): ~12 unused variables (S14), 3 unneeded
      `!` in `if` (S11), 3 short-circuit hints (S26), 5 unnecessary `_this` in config
      calls (C13). Code-quality pass, not bugs.
- [ ] `hemtt publish` to Steam from CI (needs Steam credentials as repo secrets).

## 7. Testing

- [ ] CBA unit tests for pure functions in `common` (getDeflection, gridToPos/posToGrid,
      simulateTrajectory, fuze resolution).
- [ ] Smoke missions for APS, CIWS, VLS (only one manual VR mission today).

## 8. Compatibility and polish

- [ ] Zeus Enhanced / ACE Zeus modules, editor categories and subcategories.
- [ ] ACE Arsenal / cargo sizes for packable items.
- [ ] Use newer commands where it helps (`getOrDefault`, `countType`, ...).
- [ ] Real Steam Workshop ID in README badges and `mod.cpp` (currently `id=0`);
      version is 0.1.0.

## 9. Documentation (after in-game testing, issue #1)

- [ ] Tracked as issue #2: accurate function headers + `Public: Yes` API marking,
      per-addon READMEs, MkDocs Material site on GitHub Pages.
