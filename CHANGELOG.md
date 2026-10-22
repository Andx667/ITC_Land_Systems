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

### Added

- Stringtables for every addon: vehicle, weapon and magazine names, dialog labels and script-generated UI text can now be translated. The SPH loader status is published as a stringtable key, so every crew member sees it in their own language.
- CBA settings under "ITC Land Systems": enable/disable APS, COBRA detection range and engagement window, Spike camera sensitivity (per player). The CIWS toggle moved to the same category.
- Tablet: tooltips on the labels and readouts whose meaning or unit is not obvious (fire control, BCS setup, fire missions and solutions, rocket fuze and guidance, vehicle status, app interfaces). The new fire mission fields change their tooltip with the target type.

### Fixed

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
- SPH autoloader: magazine changes are now sent to the vehicle's owner, so the loader works when the gunner is not on the machine that owns the vehicle.
- APS: module ammo/reload state is now applied by the vehicle's owner via an event instead of being overwritten by each shooter; modules with no ammo left no longer intercept, and joining clients no longer reset APS state.
- Spike: the seeker camera only starts for the player-controlled shooter, not for AI units local to the machine.
- COBRA: placing a second COBRA no longer wipes the first one's data, and a shell is no longer missed by one COBRA because another already consumed it. Sirens are now heard by all players, not only the host.
- Datalink: transmissions are delivered to the machine that connected the target (where its handlers are registered), and registry entries are removed when the object is deleted or its player disconnects.
- Addons that extend ACE config classes (interaction menus, items, explosives, HuntIR, missile guidance) now list those ACE addons in `requiredAddons`, so the load order is guaranteed.
- `veh_uav06` no longer claims the vanilla AL-6 classes in its `units[]`.
- COBRA: sirens near a predicted impact did not sound on high ground. The impact position is ASL but the siren search read it as AGL, so the 500 m trigger radius shrank with terrain height and nothing triggered above 500 m ASL.
- Spike: the lead on moving targets and the minimum target distance used an ASL target position as AGL, so on high ground the missile over-led its target. The launcher sight also threw a script error every frame while a locked target was off screen.
- ROVER and Spike camera clocks now show minutes with two digits (14:05 instead of 14:5).
- Defender and Rhea magazines no longer reference guidance functions that never existed.
- CIWS: decoys for incoming shells no longer leave their AI crew and group behind. Zeus-placed radar vehicles get their radar switched on also for curators created mid-mission, on the machine that owns the vehicle.
- VLS: guidance reads the launch target from the vehicle instead of two shared globals, and an AI-fired round without a target flies unguided instead of erroring.
- SPH loader: loading and fuzing now use the applied settings; changing the ammo, charge or fuze selection afterwards no longer changes the loaded round or its fuze until Apply is pressed again. Dual-laser rounds now keep laser code 1.
- Tablet: opening a different tablet no longer resumes an app that tablet doesn't have, app buttons without an app return to the home screen, and the tablet stops cleanly when closed or when the player dies.
- Gunner sights no longer leave a per-frame handler running every time the player leaves the vehicle.
- Spike: the missile camera and its screen effects are always removed when the player dies, switches weapon or the missile hits.
- BCS page buttons work while controlling a UAV; the BCS target-type labels are translatable.
- ROVER tablet: 51 control positions used layout macros inside quoted strings, so the game received undefined names instead of numbers; the controls now sit where they were designed to.
- Tablet: the BCS new/engage fire mission pages, the BCS solution page and the MLRS page no longer share control IDs with other pages, so showing or hiding a control by ID can no longer hit the wrong page.
- Saved list selections (SPH ammo/fuze, VLS impact angle, MLRS fuze) restore correctly, including the last entry; the MLRS round-type page shows the applied PGM grid and altitude.

### Changed

- Ballistic tables are compiled once and cached instead of on every firing solution (BCS computed them per gun).
- Tablet app and page scripts are compiled once and cached instead of on every app/page switch (recompiled each time when `DISABLE_COMPILE_CACHE` is set).
- The MOF35 Mod3 time fuze waits with `CBA_fnc_waitAndExecute` instead of checking every frame.
- CI: key HEMTT lints are now errors, a new check rejects macros inside string literals (CBA/ACE macros and the project's own defines), and Dependabot keeps the GitHub Actions up to date.
- COBRA is now server-authoritative: only the server tracks shells and runs the scan, and it publishes COBRAs, firing positions, engagements and predicted impacts to clients (previously every machine ran its own simulation).
- Rebuilt the repo on HEMTT with modern CI/CD, replacing the old build tooling
