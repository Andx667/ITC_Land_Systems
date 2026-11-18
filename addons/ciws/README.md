# CIWS

`itc_land_ciws`: [CIWS](../../docs/systems/air-defence.md#ciws) and the shell decoys they track.

## Dependencies

- ITC: `itc_land_common`

## Files

- `CfgAmmo.hpp`
- `CfgMagazines.hpp`
- `CfgMisc.hpp`
- `CfgVehicles.hpp`
- `CfgWeapons.hpp`

## Settings

CBA settings in `initSettings.inc.sqf`: `itc_land_ciws_enabled`.

## CBA events

Internal events this addon handles (raised with `CBA_fnc_*Event`):

- `itc_land_ciws_radarOn` (`functions/fnc_init.sqf`)

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_fired` |  | Fired EH for weapons that can be engaged by the CIWS system. |
| `fnc_init` |  | Post-init entry point for the CIWS system. |
| `fnc_radarOn` |  | Handles the radarOn event on the machine that owns the vehicle: switches its radar on. |
| `fnc_shellTarget` |  | Spawns and tracks a targetable decoy object representing an incoming projectile, so that CIWS-enabled weapons can lock on to and engage it. |
