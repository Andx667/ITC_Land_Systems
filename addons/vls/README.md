# VLS

`itc_land_vls`: [Vertical launch system](../../docs/systems/air-defence.md#vertical-launch-system) and its interface.

## Dependencies

- ITC: `itc_land_common`, `itc_land_veh_sights`, `itc_land_veh_weapons`, `itc_land_ciws`
- ACE: `ace_interaction`

## Files

- `CfgAmmo.hpp`
- `CfgDisplay.hpp`
- `CfgMagazines.hpp`
- `CfgVehicles.hpp`
- `CfgWeapons.hpp`

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_adHocLaunch` |  | Reads the ad-hoc target grid, elevation and impact-angle fields from the VLS ad-hoc targeting dialog, converts the grid to a world position, stores the resulting target data on the current vehicle, then fires the currently selected weapon at it. |
| `fnc_AGCAS` |  | Extrapolates a guided projectile's flight path forward using its current bank, bank rate, pitch and dive rate, and checks whether that path intersects terrain (Automatic Ground Collision Avoidance System check). |
| `fnc_angleToTarget` |  | Calculates the horizontal and vertical angle offsets between a projectile's current heading/velocity vector and a target position. |
| `fnc_determineSteerPoint` |  | Determines guidance stage transitions ("SEP" -> "TURN" -> "GLIDE") for a guided projectile based on elapsed separation time and vertical velocity, and returns the current stage together with the active steer point. |
| `fnc_fired` |  | Handles the vehicle "Fired" event for VLS-guided munitions: if the gunner is local, starts the projectile's guidance loop and plays the cruise-missile fired effect. |
| `fnc_guide` |  | Starts guidance on a freshly fired VLS projectile: reads the previously selected target position and impact angle from the vehicle, stores the bomb's flying target, and registers the per-frame guidance handler. |
| `fnc_guidePfh` |  | Per-frame handler that drives VLS projectile guidance each frame: refreshes the projectile's tracked position/time, determines the current steer point/stage, and either hands off to the terminal steering logic or performs the initial pitch-down turn onto the target, removing itself once the projectile is no longer alive. |
| `fnc_onChar` |  | Handles the ad-hoc target dialog's onChar event: whenever the grid, elevation or name edit field is typed into, saves its current text to the corresponding variable on the current vehicle. |
| `fnc_onLoad` |  | Handles the VLS targeting dialog's onLoad event: populates the saved-target list box, restores the last selected saved target and impact angle, and populates the ad-hoc grid/elevation/name edit fields from the current vehicle's stored variables. |
| `fnc_onSelectAngle` |  | Handles the ad-hoc impact-angle list box's onLBSelChanged event: stores the selected index and its associated angle value on the current vehicle. |
| `fnc_onSelectTarget` |  | Handles the saved-target list box's onLBSelChanged event: stores the selected index and its associated saved target data on the current vehicle. |
| `fnc_readAdHocTarget` |  | Reads the ad-hoc target grid and elevation from the VLS dialog's edit boxes, remembers them on the vehicle and converts them to a world position. |
| `fnc_removeTGT` |  | Removes the currently selected saved target from the VLS target list box and from the current vehicle's saved-target array. |
| `fnc_saveTGT` |  | Reads the ad-hoc grid, elevation, impact-angle and name fields from the VLS targeting dialog, saves them to the current vehicle, and appends the resulting target as a new entry in the vehicle's saved-target list box and target array. |
| `fnc_selectedLaunch` |  | Launches the current weapon at the currently selected saved target: reads the saved target's position and impact angle, stores them on the current vehicle, then fires. |
| `fnc_steerTo` |  | Performs terminal steering for a guided VLS projectile: banks and pitches it toward the steer point (with AGCAS-driven pull-ups), initiates the terminal dive once close enough to reach the desired impact angle, and applies the resulting pitch/bank. |
| `fnc_updateData` |  | Refreshes a VLS guidance data array in place with the projectile's current position and the current frame's timestamp, for use by the per-frame guidance handler. |
