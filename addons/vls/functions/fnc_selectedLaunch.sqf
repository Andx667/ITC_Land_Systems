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
 * [_this] spawn itc_land_vls_fnc_selectedLaunch
 *
 * Public: No
 */

waitUntil {
    !(isNull (findDisplay 86002))
};
private _vehicle = [] call EFUNC(common,getCurVehicle);
private _target = _vehicle getVariable ["ITC_Land_VLS_selectedTGT",[]];
if ((count _target) < 1) exitWith {};

private _targetData = parseSimpleArray (_target # 1);

_vehicle setVariable ["itc_land_vls_targetAngl", (_targetData # 2), true];
itc_land_target_IAtest = _vehicle getVariable "itc_land_vls_targetAngl";

_vehicle setVariable ["itc_land_vls_targetPos", (_targetData # 1), true];
itc_land_target_test = _vehicle getVariable "itc_land_vls_targetPos";

_vehicle fire (currentWeapon _vehicle);
