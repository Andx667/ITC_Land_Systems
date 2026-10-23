#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Drops the firing solutions whose quadrant the gun cannot lay: below the main turret's minElev
 * or above its maxElev, or outside given limits. The firing tables can reach further than some
 * guns (the 155 mm high-angle tables go to 80 degrees, the PzH 2000 elevates to 72, the Boxer
 * RCH 155 to 65). The limits are relative to the hull, so on a slope the real limit differs by
 * the hull's pitch. A vehicle whose turret elevation is counted from a raised barrel (the CUP
 * M1129's mortar: -5 to 35) gives its real quadrant range as itc_land >> elevationLimits[]
 * (see getAimAngles for its elevationOffset).
 *
 * Arguments:
 * 0: Vehicle with the gun in its main turret <OBJECT>, or the limits [min, max] in degrees <ARRAY>
 * 1: Firing solutions as from ballistics_fnc_calcShellTypeSolutions (quadrant in mils at index 3) <ARRAY>
 *
 * Return Value:
 * The solutions the gun can lay <ARRAY>
 *
 * Example:
 * [_vehicle, _solutions] call itc_land_common_fnc_filterSolutionsByElevation
 * [[-5, 70], _solutions] call itc_land_common_fnc_filterSolutionsByElevation
 *
 * Public: No
 */

params [["_gun", []], "_solutions"];

private _limits = _gun;
if (_gun isEqualType objNull) then {
    _limits = getArray (configOf _gun >> "itc_land" >> "elevationLimits");
    if (_limits isEqualTypeArray [0, 0]) exitWith {};
    private _turretConfig = [_gun, [0]] call BIS_fnc_turretConfig;
    private _minElev = _turretConfig >> "minElev";
    private _maxElev = _turretConfig >> "maxElev";
    _limits = if (isNumber _minElev && {isNumber _maxElev}) then {[getNumber _minElev, getNumber _maxElev]} else {[]};
};
// without both limits there is nothing to check against
if !(_limits isEqualTypeArray [0, 0]) exitWith {_solutions};

// in mils, with a mil of tolerance for the rounded quadrant
private _minQuadrant = (_limits # 0) * 6400 / 360 - 1;
private _maxQuadrant = (_limits # 1) * 6400 / 360 + 1;

_solutions select {(_x # 3) >= _minQuadrant && {(_x # 3) <= _maxQuadrant}}
