#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * RscListBox onLBSelChanged handler for the SPH ammo-loader's fuze combobox. Stores
 * the newly selected fuze index, mode and description on the vehicle, and shows or
 * hides the timed-fuze delay input field depending on whether the selected fuze mode
 * is "time".
 *
 * Arguments:
 * 0: The listbox control that triggered the selection change <Control>
 * 1: Index of the newly selected fuze listbox item <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [86004, 0] call itc_land_sphammohandler_fnc_onSelectFuze
 *
 * Public: No
 */

params ["_control","_index"];

//Generate globals
//private _vehicle = vehicle ace_player;
private _vehicle = [] call EFUNC(common,getCurVehicle);
private _selectedFuzeIndex = _index;
_vehicle setVariable ["itc_land_selectedFuzeIndex",_selectedFuzeIndex,true];

private _fuzeMode = lbData [86004,_index];
_vehicle setVariable ["itc_land_selectedFuzeMode",_fuzeMode,true];

private _fuzeDesc =  lbText [86004,_index];
_vehicle setVariable ["itc_land_selectedFuzeDesc",_fuzeDesc,true];

private _fuzeTime = _vehicle getVariable ["itc_land_fuzeTime",0];

    ctrlShow [86005, false];
    ctrlShow [86006, false];
    
if(_fuzeMode == "time") then {
    ctrlShow [86005, true];
    ctrlShow [86006, true];
    ctrlSetText [86006,format["%1", _fuzeTime]];
} else {
    ctrlShow [86005, false];
    ctrlShow [86006, false];    
};
