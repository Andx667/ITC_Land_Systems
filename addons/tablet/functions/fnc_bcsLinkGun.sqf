#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Links a gun on the datalink to the BCS battery under the next free gun number
 * (tablet_fnc_bcsNextId); its position, altitude and direction come from the vehicle
 * (bcs_fnc_refreshLinkedGuns).
 *
 * Arguments:
 * 0: Gun vehicle <OBJECT>
 *
 * Return Value:
 * Gun number, "" for a gun dead or already linked <STRING>
 *
 * Example:
 * [_gunVehicle] call itc_land_tablet_fnc_bcsLinkGun
 *
 * Public: No
 */

params ["_gunVehicle"];

if (!alive _gunVehicle || {_gunVehicle in (GVAR(bcs_bty_guns) apply {_x param [6, objNull]})}) exitWith {""};
private _num = ["gun"] call FUNC(bcsNextId);
GVAR(bcs_bty_guns) append ([[[_num, "", [0, 0, 0], 0, 0, GVAR(bcs_bty_name), _gunVehicle]]] call EFUNC(bcs,refreshLinkedGuns));
_num
