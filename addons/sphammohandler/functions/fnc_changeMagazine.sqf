#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Requests a magazine change on the SPH gun. Turret magazine and weapon commands only
 * work where the main turret is local, which is the gunner's machine, not the vehicle's
 * owner (the driver's). The change is sent to the main turret's unit, or to the vehicle
 * when the gunner seat is empty (run immediately if that is this machine).
 *
 * Arguments:
 * 0: SPH vehicle <OBJECT>
 * 1: Action: "remove" (remove a magazine), "add" (add a magazine) or
 *    "closeBreech" (reload the gun with a magazine in its chamber) <STRING>
 * 2: Magazine classname <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, "remove", "itc_Sh_155mm_HE"] call itc_land_sphammohandler_fnc_changeMagazine
 *
 * Public: No
 */

params ["_vehicle", "_action", "_magClass"];

private _target = _vehicle turretUnit [0];
if (isNull _target) then {_target = _vehicle};

[QGVAR(changeMagazine), [_vehicle, _action, _magClass], _target] call CBA_fnc_targetEvent;
