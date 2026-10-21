#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Requests a magazine change on the SPH gun. Magazine commands only work where
 * the vehicle is local, but the loader runs on the gunner's machine, so the change
 * is sent to the vehicle's owner (run immediately if that is this machine).
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

[QGVAR(changeMagazine), [_vehicle, _action, _magClass], _vehicle] call CBA_fnc_targetEvent;
