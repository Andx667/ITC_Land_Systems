#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles the saved-target list box's onLBSelChanged event: stores the selected index
 * and its associated saved target data on the current vehicle.
 *
 * Arguments:
 * 0: List box control <Control>
 * 1: Selected index <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control, _index] call itc_land_vls_fnc_onSelectTarget
 *
 * Public: No
 */

params [["_control", controlNull, [controlNull]], ["_index", 0, [0]]];

private _vehicle = [] call EFUNC(common,getCurVehicle);

private _targetData = lbData [4103,_index];
_vehicle setVariable [QGVAR(selectedTGT),[_index,_targetData],true];
