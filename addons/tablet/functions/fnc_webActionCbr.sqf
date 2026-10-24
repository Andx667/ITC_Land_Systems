#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The HTML tablet's COBRA actions, as the classic data page's:
 *   cbrSave         the selected firing position into the BCS location stores
 *   cbrCounterFire  a BCS fire mission on it (the BCS opens on its engagement)
 *
 * Arguments:
 * 0: Vehicle (the tablet's app is kept on it) <OBJECT>
 * 1: App ("cbr") <STRING>
 * 2: Action <STRING>
 * 3: Value <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "cbr", "cbrCounterFire", nil] call itc_land_tablet_fnc_webActionCbr
 *
 * Public: No
 */

params ["_vehicle", "_app", "_action", "_value"];

private _selected = ["engagement", "index"] call FUNC(webFormValue);
private _engagements = missionNamespace getVariable ["itc_land_cobra_engagements", []];
if (_selected < 0 || {_selected >= count _engagements}) exitWith {};
private _engagement = _engagements # _selected;

switch (_action) do {
    case "cbrSave": {
        [_engagement # 0, _engagement # 2 # 0] call FUNC(bcsRecordPoint);
        [format [LLSTRING(WebPointSaved), _engagement # 0]] call FUNC(webNotice);
    };
    case "cbrCounterFire": {
        GVAR(bcs_pendingTarget) = [_engagement # 2 # 0];
        if ("bcs" in getArray (configFile >> "CfgWeapons" >> (GVAR(web) get "tablet") >> "apps")) then {
            ["bcs"] call FUNC(webStartApp);
        };
    };
};
