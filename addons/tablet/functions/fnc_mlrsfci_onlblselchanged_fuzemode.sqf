#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Listbox selection-changed handler for the MLRS FCI fuze mode selector.
 * Stores the selected fuze index/mode/description on the current vehicle
 * and shows/hides and updates the fuze time text field depending on
 * whether the selected fuze mode is a "time" fuze.
 *
 * Arguments:
 * 0: Listbox control that triggered the event <Control>
 * 1: Selected listbox index <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(_this select 0), (_this select 1)] call itc_land_tablet_fnc_mlrsfci_onlblselchanged_fuzemode
 *
 * Public: No
 */

params ["_control","_index"];
private _vehicle = [] call EFUNC(common,getCurVehicle);
private _curMag = (currentMagazine _vehicle);
//Generate globals

_vehicle setVariable ["itc_land_selectedFuzeIndex",_index,true];
_vehicle setVariable ["itc_land_selectedFuzeMode",lbData [1904,_index],true];
_vehicle setVariable ["itc_land_selectedFuzeDesc",lbText [1904,_index],true];

private _fuzeTime = _vehicle getVariable ["itc_land_mlrsfci_fuzeTime",0];

private _fuzeType = lbData [1904, _index];
    ctrlShow [1905, false];
    ctrlShow [1906, false];

if(_fuzeType == "time") then {
    ctrlShow [1905, true];
    ctrlShow [1906, true];
    ctrlSetText [1906,format["%1", _fuzeTime]];
} else {
    ctrlShow [1905, false];
    ctrlShow [1906, false];
};
