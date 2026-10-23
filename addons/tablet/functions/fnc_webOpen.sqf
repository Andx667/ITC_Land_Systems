#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Opens the tablet in HTML (itc_land_tablet_web, a CT_WEBBROWSER control, Arma 3 2.20+; the
 * setting "Tablet in HTML" makes tablet_fnc_open come here): loads html\tablet.html, wires the
 * page's messages to tablet_fnc_webReceive, draws the COBRA picture on the native map control,
 * and sends the page the state (tablet_fnc_webState) twice a second while it is open. The app
 * and page are the vehicle's, as in the classic tablet, so it opens where either tablet left.
 *
 * Arguments:
 * 0: Tablet weapon config class name <STRING> (default: "itc_land_tablet_fdc")
 *
 * Return Value:
 * None
 *
 * Example:
 * ["itc_land_tablet_fdc"] call itc_land_tablet_fnc_webOpen
 *
 * Public: No
 */

params [["_tabletClass", "itc_land_tablet_fdc", [""]]];

if !(isArray (configFile >> "CfgWeapons" >> _tabletClass >> "apps")) exitWith {};
if !(createDialog "itc_land_tablet_web") exitWith {};
private _display = findDisplay 32570;
private _ctrl = _display displayCtrl 32571;

ITC_CURVEHICLE
_vehicle setVariable [QGVAR(apps), getArray (configFile >> "CfgWeapons" >> _tabletClass >> "apps")];

GVAR(web) = createHashMapFromArray [
    ["tablet", _tabletClass],
    ["sent", ""],
    ["form", createHashMap],
    ["formKey", ""],
    ["formRev", 0],
    ["mapRect", []],
    ["solutionKey", []],
    ["solutions", [[], []]]
];

(_display displayCtrl 32576) ctrlSetFade ([] call ace_common_fnc_ambientBrightness);
(_display displayCtrl 32576) ctrlCommit 0;
private _map = _display displayCtrl 32574;
_map ctrlShow false;
_map ctrlAddEventHandler ["Draw", {[_this select 0] call FUNC(cbrDrawMap)}];

// the handlers go on before the page loads, so PageLoaded cannot fire into a control without them
_ctrl ctrlAddEventHandler ["JSDialog", {
    params ["_ctrl", "", "_message"];
    [_ctrl, _message] call FUNC(webReceive);
    true
}];
_ctrl ctrlAddEventHandler ["PageLoaded", {
    params ["_ctrl"];
    GVAR(web) set ["sent", ""];
    [_ctrl] call FUNC(webSend);
}];
[_ctrl, ["LoadFile", QPATHTOF(html\tablet.html)]] call GVAR(webAction);

[{
    params ["_ctrl", "_pfhID"];
    if (isNull _ctrl || {!alive ACE_player}) exitWith {
        [_pfhID] call CBA_fnc_removePerFrameHandler;
        if (!isNull _ctrl) then {(ctrlParent _ctrl) closeDisplay 2};
    };
    // the night frame fades in as the ambient light goes, as on the classic tablet
    private _night = (ctrlParent _ctrl) displayCtrl 32576;
    _night ctrlSetFade ([] call ace_common_fnc_ambientBrightness);
    _night ctrlCommit 0.5;
    [_ctrl] call FUNC(webSend);
}, 0.5, _ctrl] call CBA_fnc_addPerFrameHandler;
