#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's COBRA actions, as the classic data page's:
 *   cbrSave         the selected firing position into the BCS location stores
 *   cbrCounterFire  a BCS fire mission on it (the BCS opens on its engagement)
 *
 * Arguments:
 * 0: Vehicle (the tablet's app is kept on it) <OBJECT>
 * 1: Action <STRING>
 * 2: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "cbrCounterFire", nil] call itc_land_tablet_fnc_webActionCbr
 *
 * Public: No
 */

params ["_vehicle", "_action", "_value"];

private _selected = (GVAR(web) get "form") getOrDefault ["engagement", -1];
private _engagements = missionNamespace getVariable ["itc_land_cobra_engagements", []];
if (!(_selected isEqualType 0) || {_selected < 0} || {_selected >= count _engagements}) exitWith {};
private _engagement = _engagements # _selected;

switch (_action) do {
    case "cbrSave": {
        if (isNil QGVAR(bcs_locations)) then {GVAR(bcs_locations) = []};
        private _pos = _engagement # 2 # 0;
        GVAR(bcs_locations) pushBack [_engagement # 0, [_pos] call EFUNC(common,posToGrid), _pos, round (_pos # 2), false];
        [format [LLSTRING(WebPointSaved), _engagement # 0]] call FUNC(webNotice);
    };
    case "cbrCounterFire": {
        GVAR(bcs_pendingTarget) = [_engagement # 2 # 0];
        if ("bcs" in getArray (configFile >> "CfgWeapons" >> (GVAR(web) get "tablet") >> "apps")) then {
            ["bcs"] call FUNC(webStartApp);
        };
    };
};
