#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Builds the state the HTML tablet draws (tablet.html): the view of the app shown, from its
 * tablet_fnc_webView* function: header, sidebar, fire mission list and the workspace blocks,
 * with the form values (tablet_fnc_webForm) and the view key the page keeps its drafts for, the
 * last action's result (tablet_fnc_webNotice) and the status bar (datalink ID or vehicle, time). The
 * ammunition handler's view comes from sphammohandler_fnc_webView.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * State <HASHMAP>
 *
 * Example:
 * toJSON ([] call itc_land_tablet_fnc_webState)
 *
 * Public: No
 */

private _vehicle = [] call EFUNC(common,getCurVehicle);
// what every view has: the form, the last action's result for 8 s, and the status bar
private _finish = {
    params ["_view"];
    _view set ["form", GVAR(web) get "form"];
    _view set ["key", GVAR(web) get "formKey"];
    _view set ["rev", GVAR(web) get "formRev"];
    (GVAR(web) getOrDefault ["notice", []]) params [["_text", ""], ["_kind", ""], ["_until", 0]];
    if (time < _until) then {_view set ["notice", createHashMapFromArray [["text", _text], ["c", _kind]]]};
    if !("status" in _view) then {
        private _id = ACE_player getVariable [QEGVAR(datalink,id), ""];
        _view set ["status", [
            [getText (configOf _vehicle >> "displayName"), format [LLSTRING(WebStatusId), _id]] select (_id != "" && {_vehicle == ACE_player}),
            [dayTime, "HH:MM"] call BIS_fnc_timeToString
        ]];
    };
    createHashMapFromArray [["v", 2], ["view", _view]]
};
if ((GVAR(web) get "kind") == "ammo") exitWith {
    [[_vehicle] call EFUNC(sphammohandler,webView)] call _finish
};
private _apps = getArray (configFile >> "CfgWeapons" >> (GVAR(web) get "tablet") >> "apps");
private _app = _vehicle getVariable [QGVAR(app), "home"];
// an app this tablet does not have (another tablet was used here) or a page never started: start it
if (!(_app == "home" || {_app in _apps}) || {isNil {_vehicle getVariable QGVAR(page)}}) then {
    [["home", _app] select (_app in _apps)] call FUNC(webStartApp);
    _app = _vehicle getVariable QGVAR(app);
};

// the app's view function (tablet\CfgMisc.hpp); home has no config
private _viewFunction = getText (configFile >> "itc_land" >> "apps" >> _app >> "webView");
[[_vehicle, _app] call ([missionNamespace getVariable _viewFunction, FUNC(webViewHome)] select (_viewFunction == ""))] call _finish
