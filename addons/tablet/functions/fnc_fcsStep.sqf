#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Steps the FCI's selected firing solution (the one the gunner sight shows) one back or on,
 * within the solutions of the last calculation (tablet_fnc_fcsCalculate).
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Step, -1 back or 1 on <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [vehicle player, 1] call itc_land_tablet_fnc_fcsStep
 *
 * Public: No
 */

params ["_vehicle", ["_step", 0, [0]]];

if !(_step in [-1, 1]) exitWith {};
private _index = _vehicle getVariable ["itc_land_tablet_fcs_solutions_index", 0];
private _count = count (_vehicle getVariable ["itc_land_tablet_fcs_solutions", []]);
_vehicle setVariable ["itc_land_tablet_fcs_solutions_index", (_index + _step) min (_count - 1) max 0, true];
