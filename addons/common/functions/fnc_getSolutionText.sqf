#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Formats one value of the vehicle's selected fire solution for display: 4 digits, or Russian
 * notation ("15-00") for a gun in the 6000 mil system (getMilSystem).
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

[_solution select _index, [_vehicle] call FUNC(getMilSystem)] call FUNC(formatMils)
