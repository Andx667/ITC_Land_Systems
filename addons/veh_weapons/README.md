# Weapons

`itc_land_veh_weapons`: Howitzer and rocket launcher weapons, [munitions](../../docs/systems/artillery.md#munitions), fuzes, submunitions and the SAM-35 proximity fuze.

## Dependencies

- ITC: `itc_land_common`

## Files

- `CfgAmmo.hpp`
- `CfgMagazines.hpp`
- `CfgMagazines_105mm.hpp`
- `CfgMagazines_122mm.hpp`
- `CfgMagazines_127mm.hpp`
- `CfgMagazines_152mm.hpp`
- `CfgMagazines_155mm.hpp`
- `CfgMagazines_230mm.hpp`
- `CfgVehicles.hpp`
- `CfgWeapons.hpp`
- `CfgWeapons_howitzers.hpp`
- `CfgWeapons_howitzers_magazines105mm.hpp`
- `CfgWeapons_howitzers_magazines122mm.hpp`
- `CfgWeapons_howitzers_magazines127mm.hpp`
- `CfgWeapons_howitzers_magazines152mm.hpp`
- `CfgWeapons_howitzers_magazines155mm.hpp`
- `CfgWeapons_mlrs.hpp`
- `ITC_Land_CfgFuzes.hpp`

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_adjustMuzzleVelG15x` |  | Fired event handler that applies a small random variance to a fired G15x-family projectile's initial velocity, simulating shot-to-shot dispersion. |
| `fnc_deployCarrier` |  | Deploys one loitering submunition from a fired shell. |
| `fnc_deployExtra` |  | Deploys a single unguided submunition ("Extra") from a fired 155mm Mof35 shell. |
| `fnc_deployFalat` |  | Deploys a single laser-guided submunition ("Falat") from a fired shell. |
| `fnc_fired` |  | Main "Fired" event handler for ITC weapons. |
| `fnc_firedMof35` |  | Fired event handler for ITC Howitzers firing Mof35-fuzed shells. |
| `fnc_firedMof35Mod3` |  | Fired event handler for ITC Howitzers firing Mof35Mod3-fuzed shells. |
| `fnc_firedSAM35` |  | Fired event handler for ITC SAM launchers firing SAM35 proximity-fuzed missiles. |
| `fnc_fuze` |  | Per-frame handler of a submunition carrier shell's fuze. |
