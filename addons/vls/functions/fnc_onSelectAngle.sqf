#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles the ad-hoc impact-angle list box's onLBSelChanged event: stores the selected
 * index and its associated angle value on the current vehicle.
 *
 * Arguments:
 * 0: List box control <Control>
 * 1: Selected index <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control, _index] call itc_land_vls_fnc_onSelectAngle
 *
 * Public: No
 */

params ["_control","_index"];

private _vehicle = [] call EFUNC(common,getCurVehicle);
private _targetAngl = lbData [4110,_index];
_vehicle setVariable ["ITC_Land_VLS_adHocData_angl",[_index,_targetAngl],true];
