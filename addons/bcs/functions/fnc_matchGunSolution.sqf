#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Finds a gun's firing line for the selected battery solution: the gun's solution with the same
 * charge and the same angle (low or high). A gun's list can differ from the battery's (a gun out
 * of range for a charge, or one that cannot lay that quadrant), so the lists are not matched by index.
 *
 * Arguments:
 * 0: The gun's solutions <ARRAY> of [charge, azimuth, deflection, quadrant (mils), ...]
 * 1: Selected battery solution <ARRAY>
 *
 * Return Value:
 * The gun's firing line, or [] if it has none for this charge and angle <ARRAY>
 *
 * Example:
 * [_gunSolutions, _batterySolution] call itc_land_bcs_fnc_matchGunSolution
 *
 * Public: No
 */

params ["_solutions", "_reference"];

if (_reference isEqualTo []) exitWith {[]};

// high angle above 800 mils (45 degrees), where the range is greatest
private _highAngle = (_reference # 3) > 800;
private _index = _solutions findIf {(_x # 0) isEqualTo (_reference # 0) && {((_x # 3) > 800) isEqualTo _highAngle}};
if (_index == -1) exitWith {[]};

_solutions # _index
