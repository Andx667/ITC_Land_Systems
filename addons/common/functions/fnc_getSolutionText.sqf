#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Formats one value of the vehicle's selected fire solution as a 4 digit string for display.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Index into the solution, 1 for azimuth, 3 for quadrant <NUMBER>
 *
 * Return Value:
 * Formatted value, or "----" if no solution is selected <STRING>
 *
 * Example:
 * [_vehicle, 1] call itc_land_common_fnc_getSolutionText
 *
 * Public: No
 */

params ["_vehicle", "_index"];

private _solution = [_vehicle] call FUNC(getFireSolution);
if (_solution isEqualTo []) exitWith {"----"};

[_solution select _index, 4, 0] call CBA_fnc_formatNumber
