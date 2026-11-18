# Common

`itc_land_common`: Shared functions (grid and position conversion, projectile tracking, firing solution and UI helpers) and dialog base classes.

## Files

- `CfgEden.hpp`
- `CfgUI.hpp`

## Settings

CBA settings in `initSettings.inc.sqf`: `itc_land_common_russianMils`.

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_addProjectilePFH` |  | Runs code every frame (or every delay seconds) for as long as a projectile is alive, and removes the per-frame handler once it is gone. |
| `fnc_applyFuzeSelection` |  | Handles a classic fuze combo box selection: selects the fuze mode (setFuzeSelection) and shows the time input only for time fuzes. |
| `fnc_ctrlSetFade` |  | Sets the fade value of a display control and commits the change immediately. |
| `fnc_ctrlSetText` |  | Sets the text of a display control. |
| `fnc_ctrlShowMany` |  | Shows or hides several controls of the active dialog at once. |
| `fnc_filterSolutionsByElevation` |  | Drops the firing solutions whose quadrant the gun cannot lay: below the main turret's minElev or above its maxElev, or outside given limits. |
| `fnc_FormatAsMeters` |  | Formats a distance in meters as a zero-padded string, with a "-" prefix for negative values. |
| `fnc_FormatAsMils` |  | Converts an angle from degrees to mils and formats it as a zero-padded string, with a "-" prefix for negative values. |
| `fnc_formatMils` |  | Formats an angle in NATO mils for display in a mil system: 6400 as four digits ("1600"), 6000 converted and in Russian notation, hundreds and units split by a dash ("15-00"). |
| `fnc_getAimAngles` |  | Gets the gun's current azimuth and quadrant elevation in degrees. |
| `fnc_getAltitudeMSL` |  | Returns an object's altitude above mean sea level, rounded to whole meters. |
| `fnc_getBarrel` |  | Gets the main gun's barrel from the main turret's muzzle and breech memory points (gunBeg and gunEnd): the breech position, taken as the point the barrel elevates about, and the barrel length. |
| `fnc_getCurVehicle` |  | Returns the vehicle the player is currently viewing from: the connected UAV if the camera is on a UAV, otherwise the vehicle ace_player is in. |
| `fnc_getDeflection` |  | Takes two directions in degrees and calculates the deflection between them in mils, with the US convention: 3200 along the fixed direction, more to the left, less to the right. |
| `fnc_getFdcOrders` |  | The fire orders the FDC sent the vehicle (itc_land_bcs_fireData), as the values the ammunition handler and the MLRS FCI fill in: round, fuze, charge and fuze setting of the sent firing line, round count, and the target of a GPS guided round. |
| `fnc_getFireSolution` |  | Gets the fire solution currently selected in the vehicle's firing command interface. |
| `fnc_getFuzeConfig` |  | The fuze config of a magazine (ITC_Land_CfgFuzes, named by the magazine's itc_land_fuze): its "modes" and their names in "modeDesc". |
| `fnc_getGunStatusText` |  | Builds the autoloader status text of a vehicle, optionally with the progress of the current multi-round fire mission. |
| `fnc_getLoaderReadout` |  | Builds the three loader readout lines (ammo, fuze, guidance) from the settings applied in the SPH ammo handler. |
| `fnc_getMilSystem` |  | Gets the mil system angles are shown in for a gun or a BCS battery type: 6000 (Russian, shown as "15-00") for the battery types with milSystem = 6000 in config (the Russian guns) while the itc_land_common_russianMils setting is on, else 6400 (NATO). |
| `fnc_getSolutionText` |  | Formats one value of the vehicle's selected fire solution for display: 4 digits, or Russian notation ("15-00") for a gun in the 6000 mil system (getMilSystem). |
| `fnc_gridToPos` |  | Converts a map grid string and an elevation above mean sea level into a world position. |
| `fnc_isLaserCode` |  | Validates whether a number is a valid laser code: must be between 1111 and 1788, and must not contain the digits 0 or 9. |
| `fnc_parseMils` |  | Reads an angle typed in mils (a BCS input such as an OT direction) in a mil system and returns it in NATO mils. |
| `fnc_posToGrid` |  | Converts a world position into a displayable map grid string. |
| `fnc_resolveFuzeSetting` |  | Applies the selected fuze mode to the vehicle: stores the mode and the value the fuze will use (proximity height, time or delay) and builds the text shown in the interface. |
| `fnc_setFuzeSelection` |  | Selects a fuze mode of a magazine for the vehicle: stores its index, mode and name on the vehicle (itc_land_common_selectedFuzeIndex / Mode / Desc), where the ammunition handler, the FCI and resolveFuzeSetting read it. |
| `fnc_setGpsTarget` |  | Sets the target of the vehicle's GPS guided rounds: the position they fly to (itc_land_guidance_targetPos), and the grid and altitude it was entered as, so the ammunition handler and the FCI can show them again. |
| `fnc_sightViewCheck` |  | Per-frame check for sight overlays: hides the overlay's control group while the camera is not in gunner view, and hides it and removes the calling per-frame handler once the player no longer holds the required role. |
| `fnc_simulateTrajectory` |  | Simulates the ballistic trajectory of a shell frame by frame, applying air friction and gravity, until the simulated position drops below the terrain. |
