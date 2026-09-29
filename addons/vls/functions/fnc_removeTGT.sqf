#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Removes the currently selected saved target from the VLS target list box and from
 * the current vehicle's saved-target array.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this] call itc_land_vls_fnc_removeTGT
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);

//get selected target
private _target = _vehicle getVariable ["ITC_Land_VLS_selectedTGT",[]];
if ((count _target) < 1) exitWith {};

lbDelete [4103, _target # 0];

private _targetsArray = _vehicle getVariable ["ITC_Land_VLS_TGTList",[]];
_targetsArray deleteAt (_target # 0);
_vehicle setVariable ["ITC_Land_VLS_TGTList",_targetsArray,true];
