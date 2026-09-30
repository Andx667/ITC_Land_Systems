#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Listbox selection-changed handler for the MLRS FCI round type selector.
 * Looks up the selected magazine's fuze config and repopulates the fuze
 * mode combobox with the available modes (restoring the previous
 * selection if still valid), then shows or hides the guidance/PGM
 * elements based on the round's guidance type (laser_coded, gps_inertial
 * or none).
 *
 * Arguments:
 * 0: Listbox control that triggered the event <Control>
 * 1: Selected listbox index <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [(_this select 0), (_this select 1)] call itc_land_tablet_fnc_mlrsfci_onlblselchanged_roundType
 *
 * Public: No
 */

params ["_control","_index"];

//Generate globals
private _selectedMagIndex = _index;
private _selectedMagClass = lbData [2402,_index];
private _selectedMagConfig = configFile >> "CfgMagazines" >> _selectedMagClass;

//player sideChat Format ["%1 %2 %3",_control,_index, lbData [86001,_index]];

private _fuze = getText (_selectedMagConfig >> "itc_land_fuze");
private _fuzeModeArray = getArray (configFile >> "ITC_Land_CfgFuzes" >> _fuze >> "modes"); 
private _fuzeDescArray = getArray (configFile >> "ITC_Land_CfgFuzes" >> _fuze >> "modeDesc");

if ( !(isNil "itc_land_selectedFuzeIndex") && {itc_land_selectedFuzeIndex <= (lbSize 1904)}) then {
    //Recall last selection in ComboBox
    [1904, _fuzeDescArray, itc_land_selectedFuzeIndex, _fuzeModeArray] call FUNC(fillComboBox);
    [1904, lbCurSel 1904] call FUNC(mlrsfci_onlblselchanged_fuzemode);    
} else {
    //select first item in ComboBox
    [1904, _fuzeDescArray, 0, _fuzeModeArray] call FUNC(fillComboBox);
    [1904, 0] call FUNC(mlrsfci_onlblselchanged_fuzemode);        
};

//Guided munition elements: only GPS guided rounds take a target grid and altitude
private _isPgm = ((getArray (_selectedMagConfig >> "itc_land_guidance")) param [0, ""]) == "gps_inertial";
[[1907, 1908, 1909, 1910, 1911], _isPgm] call EFUNC(common,ctrlShowMany);
if (_isPgm) then {
    ctrlSetText [1909, format ["%1", missionNamespace getVariable ["itc_land_guidance_targetGrid", "0000000000"]]];
    ctrlSetText [1911, format ["%1", missionNamespace getVariable ["itc_land_guidance_targetAlt", 0]]];
};
