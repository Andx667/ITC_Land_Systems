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

[_display, IDC_workspace_header, LLSTRING(Bcs_BatterySetup)] call EFUNC(common,ctrlSetText);
SETTEXT(4303,GVAR(bcs_bty_name));
// the next free gun number, so guns are numbered 1, 2, 3, ...
SETTEXT(4306,(["gun"] call FUNC(bcsNextId)));

//_tables = (configFile >> "itc_land_ballistics" >> "availableTables")  call BIS_fnc_getCfgData;
private _batteryTypes = (configFile >> "itc_land_ballistics" >> "batteryTypes")  call BIS_fnc_getCfgSubClasses;
GVAR(bcs_availableTables) = _batteryTypes;
private _gunNames = _batteryTypes apply {((configFile >> "itc_land_ballistics" >> "batteryTypes" >> _x >> "displayName")  call BIS_fnc_getCfgData)};
[4304,_gunNames,(GVAR(bcs_bty_type) # 0),_batteryTypes] call FUNC(fillComboBox);
private _activeTypeName = getText (configFile >> "itc_land_ballistics" >> "batteryTypes" >> (GVAR(bcs_bty_type) # 1) >> "displayName");
private _activeTypeText = format[LLSTRING(Bcs_ActiveType), _activeTypeName];
SETTEXT(4318,_activeTypeText);

// linked guns show their datalink ID, or LOST once the vehicle is destroyed or gone
private _gunStrings = GVAR(bcs_bty_guns) apply {
    private _vehicle = _x param [6, objNull];
    private _link = if (count _x < 7) then {""} else {
        if (alive _vehicle) then {_vehicle getVariable [QEGVAR(datalink,id), ""]} else {LLSTRING(Bcs_GunLost)}
    };
    format["%1               %2               %3              %4               %5      %6", (_x param [5, GVAR(bcs_bty_name)]), _x # 0, _x # 1, _x # 3, round (_x # 4), _link]
};
[4315,_gunStrings,-1] call FUNC(fillComboBox);

// guns to link: alive ITC guns of the active battery type on the datalink, friendly, not linked yet, nearest first
private _linked = GVAR(bcs_bty_guns) apply {_x param [6, objNull]};
private _friendly = side group ACE_player;
GVAR(bcs_linkableGuns) = vehicles select {
    alive _x
    && {!(_x in _linked)}
    && {_x getVariable [QEGVAR(datalink,id), ""] != ""}
    && {[_x] call EFUNC(bcs,getGunBatteryType) == GVAR(bcs_bty_type) # 1}
    && {
        private _side = if (crew _x isEqualTo []) then {(getNumber (configOf _x >> "side")) call BIS_fnc_sideType} else {side _x};
        _friendly getFriend _side >= 0.6
    }
};
GVAR(bcs_linkableGuns) = [GVAR(bcs_linkableGuns), [], {_x distance ACE_player}] call BIS_fnc_sortBy;
private _linkStrings = GVAR(bcs_linkableGuns) apply {
    format ["%1  %2  %3", _x getVariable [QEGVAR(datalink,id), ""], getText (configOf _x >> "displayName"), [getPosASL _x] call EFUNC(common,posToGrid)]
};
if (_linkStrings isEqualTo []) then {_linkStrings = [LLSTRING(Bcs_NoGunsToLink)]};
[4320, _linkStrings, 0] call FUNC(fillComboBox);
