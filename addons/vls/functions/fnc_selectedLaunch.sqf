#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Launches the current weapon at the currently selected saved target: reads the saved
 * target's position and impact angle, stores them on the current vehicle, then fires.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this] call itc_land_vls_fnc_selectedLaunch
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _target = _vehicle getVariable [QGVAR(selectedTGT),[]];
if ((count _target) < 1) exitWith {};

private _targetData = parseSimpleArray (_target # 1);

_vehicle setVariable [QGVAR(targetAngl), (_targetData # 2), true];

_vehicle setVariable [QGVAR(targetPos), (_targetData # 1), true];

_vehicle fire (currentWeapon _vehicle);
