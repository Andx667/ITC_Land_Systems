# BCS

`itc_land_bcs`: [Battery fire missions](../../docs/systems/bcs.md): target methods, sheaf patterns, per-gun solutions.

## Dependencies

- ITC: `itc_land_common`, `itc_land_datalink`
- ACE: `ace_common`, `ace_huntir`

## CBA events

Internal events this addon handles (raised with `CBA_fnc_*Event`):

- `itc_land_bcs_fireDataReceived` (`XEH_postInit.sqf`)

## Functions

| Function | Public | What it does |
| --- | --- | --- |
| `fnc_adjustGrid` |  | Adjusts a position along and perpendicular to a given observer-target (OT) direction, and vertically, producing an artillery grid-correction style adjustment (add/drop, left/right, up/down). |
| `fnc_calcSolutions` |  | Calculates a full battery fire-mission solution: derives each gun's individual aim point from the sheaf pattern (parallel, converged, linear, open or special/custom) selected in the engagement settings, and computes both a battery-centre ballistic solution and a per-gun ballistic solution via EFUNC(ballistics,calcShellTypeSolutions), which applies the round's aim height and adds its fuze setting. |
| `fnc_calculateTarget` |  | Calculates a target position from one of four input methods: a grid reference, a shift from a known point, a polar shift from a known point, or a quick-lay offset from the battery's own position. |
| `fnc_getBatteryElevationLimits` |  | Gets the elevation limits of a BCS battery type, for guns the BCS knows no vehicle of (hand- entered guns, the battery-centre solution): the battery type's elevationLimits[] in config, or else the widest minElev/maxElev of the main turrets of all public vehicles carrying its weapon, so only solutions no gun of that type can lay are dropped. |
| `fnc_getBatteryPosition` |  | Calculates the average (centre) position of a list of howitzers by summing each gun's easting, northing and elevation and dividing by the gun count. |
| `fnc_getGunBatteryType` |  | Gets the BCS battery type a vehicle can be linked to as a gun of the battery: the battery type (cannon or rocket) whose weapon the vehicle's main turret carries, for vehicles with ITC fire control, a mounted tablet and an ITC gunner sight (they show the fire data the FDC sends). |
| `fnc_gunInit` |  | Sets up an ITC gun for fire direction over the datalink; other vehicles are skipped. |
| `fnc_matchGunSolution` |  | Finds a gun's firing line for the selected battery solution: the gun's solution with the same charge and the same angle (low or high). |
| `fnc_onEndMission` |  | Datalink handler for the end of a fire mission ("fdc"/"endMission"): clears the gun's fire orders if they are for that mission, which hides the FCI ORDERS panel. |
| `fnc_onFireData` |  | Datalink handler for fire data the FDC sends to a gun ("fdc"/"fireData"). |
| `fnc_onGunFired` |  | Fired handler of an ITC gun: the first shot of the main gun after fire data from the FDC arrived is reported back to the FDC ("fdc"/"shot" with the mission and the time of flight), which starts its SHOT and SPLASH countdown. |
| `fnc_refreshLinkedGuns` |  | Updates the guns linked in Battery Setup from their vehicles: grid, position, elevation and direction as they are now. |
