#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Sends the HTML tablet its state (webState) when it changed since the last send: JSON, base64
 * encoded so it can sit in the JavaScript source, through ctrlWebBrowserAction "ExecJS".
 *
 * Arguments:
 * 0: Browser control <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ctrl] call itc_land_tablet_fnc_webSend
 *
 * Public: No
 */

params ["_ctrl"];

if (isNull _ctrl || {isNil QGVAR(web)}) exitWith {};
private _json = toJSON ([] call FUNC(webState));
if (_json == GVAR(web) get "sent") exitWith {};
GVAR(web) set ["sent", _json];

private _base64 = [_ctrl, ["ToBase64", _json]] call GVAR(webAction);
[_ctrl, ["ExecJS", format ["window.ITC && ITC.receive('%1');", _base64]]] call GVAR(webAction);
