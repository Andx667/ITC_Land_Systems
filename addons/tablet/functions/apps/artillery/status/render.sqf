#include "..\..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Renders the artillery apps' status page: builds a color-coded hitpoint status list (OK/DAM/FAIL) for the current
 * vehicle and displays it, and updates the fuel percentage readout.
 *
 * Arguments:
 * 0: The tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_pageRender
 *
 * Public: No
 */

params ["_display"];
ITC_CURVEHICLE

private _allDamage = getAllHitPointsDamage _vehicle;
_allDamage params ["_hitPoints", "_selections", "_status"];

private _resString = "";

for "_i" from 0 to (count _status - 1) step 1 do {
    private _col = "acff99";
    private _stat = LLSTRING(Artillery_StatusOk);
    if (_status select _i > 0) then {_col = "ff7f00"; _stat = LLSTRING(Artillery_StatusDamaged);};
    if (_status select _i > 0.5) then {_col = "ff0000"; _stat = LLSTRING(Artillery_StatusFailed);};
    // ACE Repair ships a localized name for the common hitpoint classes (HitEngine -> "Engine")
    private _hitPoint = _hitPoints select _i;
    private _key = "STR_ACE_Repair_" + _hitPoint;
    private _label = [_selections select _i, _hitPoint] select (_hitPoint != "");
    if (isLocalized _key) then {_label = localize _key};
    _resString = _resString + format["<t align='left' color='#%1'>%2    %3</t>",_col,_label, _stat] + "<br/>";
};

(_display displayCtrl 2100) ctrlSetStructuredText parseText _resString;
(_display displayCtrl 2100) ctrlCommit 0;

[_display, 2013, format["%1%2",round ((fuel _vehicle) * 100),"%"]] call EFUNC(common,ctrlSetText);
