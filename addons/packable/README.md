# Packable

`itc_land_packable`: [Packing and unpacking](../../docs/systems/uavs.md#packable-equipment) of equipment.

## Dependencies

- ITC: `itc_land_common`
- ACE: `ace_common`, `ace_interaction`

## Files

- `CfgVehicles.hpp`
- `CfgWeapons.hpp`

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_canunpack` |  | Checks whether a unit is eligible to unpack a packable item: the unit must be a man (not inside a vehicle) and must be carrying at least one item whose CfgWeapons config inherits from itc_land_packableItem. |
| `fnc_Pack` |  | Packs a deployed item (e.g. |
| `fnc_unPack` |  | Unpacks a carried item into its deployed vehicle form (e.g. |
