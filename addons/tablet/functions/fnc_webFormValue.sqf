#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * A value of the HTML tablet's form (tablet_fnc_webForm), as the page sent it: a text box as
 * text, a select box's, list's or checkbox's index. Anything in the page can send anything, so a
 * value of the wrong type reads as "" or -1.
 *
 * Arguments:
 * 0: Field id <STRING>
 * 1: "text" or "index" <STRING> (default: "text")
 *
 * Return Value:
 * Text <STRING>, or index, -1 for none <NUMBER>
 *
 * Example:
 * ["grid"] call itc_land_tablet_fnc_webFormValue
 *
 * Public: No
 */

params ["_id", ["_kind", "text"]];

private _field = (GVAR(web) get "form") getOrDefault [_id, ""];
if (_kind == "index") exitWith {
    if (_field isEqualType 0) then {floor _field} else {-1}
};
if (_field isEqualType "") then {_field} else {str _field}
