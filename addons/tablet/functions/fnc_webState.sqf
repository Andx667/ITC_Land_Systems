#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Builds the state the HTML tablet draws (tablet.html): the view of the app shown, from its
 * tablet_fnc_webView* function: header, sidebar, fire mission list and the workspace blocks,
 * with the form values (tablet_fnc_webForm) and the view key the page keeps its drafts for.
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
private _apps = getArray (configFile >> "CfgWeapons" >> (GVAR(web) get "tablet") >> "apps");
private _app = _vehicle getVariable [QGVAR(app), "home"];
// an app this tablet does not have (another tablet was used here) or a page never started: start it
if (!(_app == "home" || {_app in _apps}) || {isNil {_vehicle getVariable QGVAR(page)}}) then {
    [["home", _app] select (_app in _apps)] call FUNC(webStartApp);
    _app = _vehicle getVariable QGVAR(app);
};

private _shared = getText (configFile >> "itc_land" >> "apps" >> _app >> "sharedApp");
private _view = switch ([_app, _shared] select (_shared != "")) do {
    case "artillery": {[_vehicle, _app] call FUNC(webViewArtillery)};
    case "bcs": {[_vehicle] call FUNC(webViewBcs)};
    case "cbr": {[_vehicle] call FUNC(webViewCbr)};
    default {[_vehicle, _apps] call FUNC(webViewHome)};
};
_view set ["form", GVAR(web) get "form"];
_view set ["key", GVAR(web) get "formKey"];
_view set ["rev", GVAR(web) get "formRev"];

createHashMapFromArray [
    ["v", 2],
    ["view", _view]
]
