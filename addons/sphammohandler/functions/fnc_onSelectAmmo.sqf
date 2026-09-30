#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * RscListBox onLBSelChanged handler for the SPH ammo-loader's ammo listbox. Stores the
 * newly selected magazine's index, classname and config on the vehicle, updates the
 * dialog header and charge label, refreshes the fuze list for the new ammo, and shows
 * or hides the laser-coded / dual laser-coded / GPS-inertial guidance input fields
 * according to the selected ammo's guidance type.
 *
 * Arguments:
 * 0: The listbox control that triggered the selection change <Control>
 * 1: Index of the newly selected ammo listbox item <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [86001, 0] call itc_land_sphammohandler_fnc_onSelectAmmo
 *
 * Public: No
 */

params ["_control","_index"];

//private _vehicle = vehicle ace_player;
private _vehicle = [] call EFUNC(common,getCurVehicle);

//Generate globals
private _selectedMagIndex = _index;
private _selectedMagClass = lbData [86001,_index];
private _selectedMagConfig = configFile >> "CfgMagazines" >> _selectedMagClass;

_vehicle setVariable ["itc_land_currentMagInfo",[_selectedMagIndex,_selectedMagClass,_selectedMagConfig],true];

//Get Displayname and set header text
private _displayName = getText(_selectedMagConfig >> "displayName");
ctrlSetText [86002, format["PREPARE: %1", _displayName]];

//Set current Charge label
private _maxChargeIndex =  getNumber(_selectedMagConfig >> "itc_land_maxChargeIndex");
private _curChargeIndex = _vehicle getVariable ["itc_land_currentChargeIndex",1];
ctrlSetText [86003, format["CHARGE: %1 / %2", _curChargeIndex, _maxChargeIndex]];

[] call FUNC(fillFuzeList);
private _selectedFuzeIndex = _vehicle getVariable ["itc_land_selectedFuzeIndex",0];
if ( _selectedFuzeIndex <= (lbSize 86004)) then {
    //Recall last selection in ComboBox
    lbSetCurSel [86004, _selectedFuzeIndex];
} else {
    //select first item in ComboBox
    lbSetCurSel [86004, 0];
};

//Guided munition elements: laser code 1 (LGM), laser code 2, and grid/altitude (PGM)
private _guidanceType = (getArray (_selectedMagConfig >> "itc_land_guidance")) param [0, ""];
[[86007, 86008], _guidanceType in ["laser_coded", "laser_coded_2"]] call EFUNC(common,ctrlShowMany);
[[86023, 86024], _guidanceType == "laser_coded_2"] call EFUNC(common,ctrlShowMany);
[[86012, 86013, 86014, 86015], _guidanceType == "gps_inertial"] call EFUNC(common,ctrlShowMany);
