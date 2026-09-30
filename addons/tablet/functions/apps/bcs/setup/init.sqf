#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Initializes the BCS setup page: shows the setup workspace panel, sets its header and
 * battery name field, fills the battery type combo box from the ballistics config's
 * battery types, and populates the stored guns list box.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_pageInit
 *
 * Public: No
 */

params ["_display"];
#include "..\..\..\BCS_idc_defines.hpp"
#include "..\bcsDefines.hpp"
ctrlShow [13502, true];

[_display, IDC_workspace_header, "Battery Setup"] call EFUNC(common,ctrlSetText);
SETTEXT(4303,GVAR(bcs_bty_name));

//_tables = (configFile >> "itc_land_ballistics" >> "availableTables")  call BIS_fnc_getCfgData;
private _batteryTypes = (configFile >> "itc_land_ballistics" >> "batteryTypes")  call BIS_fnc_getCfgSubClasses;
GVAR(bcs_availableTables) = _batteryTypes;
private _gunNames = _batteryTypes apply {((configFile >> "itc_land_ballistics" >> "batteryTypes" >> _x >> "displayName")  call BIS_fnc_getCfgData)};
private _shellTypes = _batteryTypes apply {((configFile >> "itc_land_ballistics" >> "batteryTypes" >> _x >> "ammunition")  call BIS_fnc_getCfgData)};
GVAR(bcs_shellTypes) = _shellTypes;
[4304,_gunNames,(GVAR(bcs_bty_type) # 0),_batteryTypes] call FUNC(fillComboBox);
private _activeTypeName = getText (configFile >> "itc_land_ballistics" >> "batteryTypes" >> (GVAR(bcs_bty_type) # 1) >> "displayName");
private _activeTypeText = format["Active Type: %1", _activeTypeName];
SETTEXT(4318,_activeTypeText);

private _gunStrings = GVAR(bcs_bty_guns) apply {format["%1               %2               %3              %4               %5", (_x param [5, GVAR(bcs_bty_name)]), _x # 0, _x # 1, _x # 3, _x # 4]};
[4315,_gunStrings,-1] call FUNC(fillComboBox);
