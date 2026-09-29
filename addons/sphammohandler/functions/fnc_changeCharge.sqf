#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Adjusts the vehicle's currently selected propellant charge index by the given
 * increment, clamping the result between 1 and the maximum charge index defined for
 * the currently selected ammunition, and updates the charge label in the SPH
 * ammo-loader dialog.
 *
 * Arguments:
 * 0: Amount to change the current charge index by, may be negative <Number>
 *
 * Return Value:
 * The new current charge index <Number>
 *
 * Example:
 * [1] call itc_land_sphammohandler_fnc_changeCharge
 *
 * Public: No
 */

params ["_increment"];
//private _vehicle = vehicle ace_player;
private _vehicle = [] call EFUNC(common,getCurVehicle);

//if charge has not been set for whatever reason then set to charge one and increment from there
private _curChargeIndex = _vehicle getVariable ["itc_land_currentChargeIndex",1];

//get the currently selected ammunitions maximum charge
private _selectedMagConfig = (_vehicle getVariable "itc_land_currentMagInfo") # 2;
private _maxChargeIndex = getNumber (_selectedMagConfig >> "itc_land_maxChargeIndex");

//generate new charge value ensuring it is not bellow 1 or above maximum charge
_curChargeIndex = ((_curChargeIndex + _increment) min _maxChargeIndex) max 1;

ctrlSetText [86003, format["CHARGE: %1 / %2", _curChargeIndex, _maxChargeIndex]];

_vehicle setVariable ["itc_land_currentChargeIndex",_curChargeIndex,true];

_curChargeIndex;
