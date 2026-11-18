# APS

`itc_land_aps`: [Active protection](../../docs/systems/aps.md).

## Dependencies

- ITC: `itc_land_common`

## Files

- `CfgVehicles.hpp`

## Settings

CBA settings in `initSettings.inc.sqf`: `itc_land_aps_enabled`.

## CBA events

Internal events this addon handles (raised with `CBA_fnc_*Event`):

- `itc_land_aps_moduleFired` (`functions/fnc_postInit.sqf`)

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_attemptIntercept` |  | Attempts to intercept an incoming projectile with each of a vehicle's APS (Active Protection System) modules that report being able to intercept it. |
| `fnc_canIntercept` |  | Checks whether a given APS (Active Protection System) module on a vehicle is currently able to intercept an incoming projectile, verifying range, reload state, traverse/elevation limits relative to the module's mount (turret or hull), and line of sight. |
| `fnc_fired` |  | "Fired" class event handler. |
| `fnc_onModuleFired` |  | Handles the moduleFired event on the machine that owns the vehicle: decrements the APS module's remaining ammo, stores when it fired, and publishes the module state to all machines. |
| `fnc_postInit` |  | Addon postInit entry point. |
| `fnc_vehicleInit` |  | Initializes a vehicle's APS (Active Protection System) modules from its "itc_land_aps" config class, and stores the resulting module array in the vehicle's "itc_land_aps_modules" variable (public) if any modules are defined. |
