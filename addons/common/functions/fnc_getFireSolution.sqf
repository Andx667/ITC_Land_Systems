#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Gets the fire solution currently selected in the vehicle's firing command interface.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 *
 * Return Value:
 * [charge, azimuth, deflection, quadrant, tof, impact velocity, impact angle, max ordinate, distance],
 * or an empty array if no solution is selected <ARRAY>
 *
 * Example:
 * [_vehicle] call itc_land_common_fnc_getFireSolution
 *
 * Public: No
 */

params ["_vehicle"];

private _index = _vehicle getVariable "itc_land_tablet_fcs_solutions_index";
if (isNil "_index") exitWith {[]};

(_vehicle getVariable ["itc_land_tablet_fcs_solutions", []]) param [_index, []]
