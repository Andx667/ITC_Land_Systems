# Cobra

`itc_land_cobra`: [Counter-battery radar](../../docs/systems/cobra.md) and sirens.

## Dependencies

- ITC: `itc_land_common`

## Files

- `CfgMisc.hpp`
- `CfgVehicles.hpp`

## Settings

CBA settings in `initSettings.inc.sqf`: `itc_land_cobra_range`, `itc_land_cobra_engagementTime`.

## CBA events

Internal events this addon handles (raised with `CBA_fnc_*Event`):

- `itc_land_cobra_sirenPlay` (`XEH_postInit.sqf`)
- `itc_land_cobra_requestState` (`XEH_postInit.sqf`)
- `itc_land_cobra_state` (`XEH_postInit.sqf`)
- `itc_land_cobra_cobrasChanged` (`XEH_postInit.sqf`)
- `itc_land_cobra_firingPositionChanged` (`XEH_postInit.sqf`)
- `itc_land_cobra_engagementChanged` (`XEH_postInit.sqf`)
- `itc_land_cobra_impactAdded` (`XEH_postInit.sqf`)

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_debugDrawDetections` |  | Debug overlay drawing for COBRA: scan arc edges, predicted impacts, firing positions and engagements. |
| `fnc_debugLines` |  | Lines of the debug overlay for a COBRA radar: scanning, range, facing and what it has found. |
| `fnc_fired` |  | Handles the "FiredBIS" event, which runs on every machine, on the server only. |
| `fnc_getCobraData` |  | Datalink event callback that gathers a COBRA vehicle's tracked firing positions, engagements and active shells, and transmits them back to the requesting origin over the datalink. |
| `fnc_init` |  | Initializes the server-side COBRA counter-battery state: the list of COBRA vehicles, the tracked shells, the recorded origins, firing positions, engagements and predicted impacts, and the engagement ID counter. |
| `fnc_processEngagement` |  | Groups detected firing origins into named "engagements" - clusters of shots within 300m of each other fired within the configured engagement-time window - updating the shot count and timestamps for an existing engagement, or creating a new one with an auto-incrementing "CBxxxx" identifier if none of the recent engagements are close enough. |
| `fnc_processImpact` |  | Records a predicted shell impact (position and calculated impact time) in the mission's active-shells list and sends it to the clients (impactAdded), then triggers any COBRA-linked sirens within range of the impact point. |
| `fnc_processOrigin` |  | Groups detected firing-origin positions into clusters (within 15m of each other), incrementing the shot count and timestamp for an existing cluster, or creating a new one if none of the tracked positions are close enough. |
| `fnc_scan` |  | Server-side once-per-second scan over all COBRA radar vehicles: drops destroyed COBRAs, then checks each tracked indirect-fire shell against every stationary COBRA's turret arc, detection range and terrain line-of-sight. |
| `fnc_sirenInit` |  | Registers an object as a COBRA-linked siren (server-only): records its class in the mission-wide siren-type registry and stores its siren sound class, trigger distance and repeat duration on the object, falling back to default alarm values if fewer than 4 arguments are supplied. |
| `fnc_sirenPlay` |  | Handles the sirenPlay event on every machine: plays the siren's sound repeatedly until its end time has passed. |
| `fnc_sirenTrigger` |  | Server-side: triggers a COBRA-linked siren for a predicted shell impact if the siren is within its trigger distance of the impact position. |
| `fnc_sirenTypes` |  | Returns an array of COBRA siren type class names, gathered from both config-defined siren types (any CfgVehicles class with a positive ITC_Land_COBRA_SirenTypes config entry) and mission-defined siren types (registered at runtime via fnc_sirenInit), in a format depending on mode. |
| `fnc_vehicleInit` |  | Registers a COBRA counter-battery radar vehicle with the server-side COBRA simulation (see itc_land_cobra_fnc_scan) and sends the updated list of COBRA vehicles to the clients (cobrasChanged). |
