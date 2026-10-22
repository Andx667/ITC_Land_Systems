#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Drops the firing solutions whose quadrant the vehicle's gun cannot lay: below the main turret's
 * minElev or above its maxElev. The firing tables can reach further than some guns (the 155 mm
 * high-angle tables go to 80 degrees, the PzH 2000 elevates to 72, the Boxer RCH 155 to 65). The
 * limits are relative to the hull, so on a slope the real limit differs by the hull's pitch.
 *
 * Arguments:
 * 0: Vehicle with the gun in its main turret <OBJECT>
 * 1: Firing solutions as from ballistics_fnc_calcShellTypeSolutions (quadrant in mils at index 3) <ARRAY>
 *
 * Return Value:
 * The solutions the gun can lay <ARRAY>
 *
 * Example:
 * [_vehicle, _solutions] call itc_land_common_fnc_filterSolutionsByElevation
 *
 * Public: No
 */

params ["_vehicle", "_solutions"];

private _turretConfig = [_vehicle, [0]] call BIS_fnc_turretConfig;
private _minElev = _turretConfig >> "minElev";
private _maxElev = _turretConfig >> "maxElev";
// without both limits in the config there is nothing to check against
if !(isNumber _minElev && {isNumber _maxElev}) exitWith {_solutions};

// in mils, with a mil of tolerance for the rounded quadrant
private _minQuadrant = getNumber _minElev * 6400 / 360 - 1;
private _maxQuadrant = getNumber _maxElev * 6400 / 360 + 1;

_solutions select {(_x # 3) >= _minQuadrant && {(_x # 3) <= _maxQuadrant}}
