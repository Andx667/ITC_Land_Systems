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

### Fixed

- COBRA: impact/engagement/siren timing used the per-machine `time` in some places and `cba_missionTime` in others; everything now uses `cba_missionTime` so clients agree with the host.
- SAM-35: proximity detonation only spawned on the server, so client-fired missiles disappeared without exploding.
- APS: the elevation limit was never enforced (`&&` instead of `||`); removed leftover debug chat output.
- Packing a deployed item spawned the weapon holder at `[0,0,0]` and did nothing if the item was not local.
- Datalink: removed leftover debug chat output on client connect.
- SPH autoloader: magazine changes are now sent to the vehicle's owner, so the loader works when the gunner is not on the machine that owns the vehicle.
- APS: module ammo/reload state is now applied by the vehicle's owner via an event instead of being overwritten by each shooter; modules with no ammo left no longer intercept, and joining clients no longer reset APS state.
- Spike: the seeker camera only starts for the player-controlled shooter, not for AI units local to the machine.
- COBRA: placing a second COBRA no longer wipes the first one's data, and a shell is no longer missed by one COBRA because another already consumed it. Sirens are now heard by all players, not only the host.
- Datalink: transmissions are delivered to the machine that connected the target (where its handlers are registered), and registry entries are removed when the object is deleted or its player disconnects.

### Changed

- COBRA is now server-authoritative: only the server tracks shells and runs the scan, and it publishes COBRAs, firing positions, engagements and predicted impacts to clients (previously every machine ran its own simulation).

- Rebuilt the repo on HEMTT with modern CI/CD, replacing the old build tooling
