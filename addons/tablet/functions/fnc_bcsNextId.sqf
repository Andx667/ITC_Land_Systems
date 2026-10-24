#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * The ID for the next BCS gun or known point: the lowest free one, so new entries need no typing
 * and do not overwrite one (an ID that exists updates that entry). Guns are numbered 1, 2, 3, ...
 * (linked and hand-entered alike, a removed gun's number is used again), known points AB0001,
 * AB0002, ...
 *
 * Arguments:
 * 0: "gun" or "point" <STRING>
 *
 * Return Value:
 * ID <STRING>
 *
 * Example:
 * ["gun"] call itc_land_tablet_fnc_bcsNextId
 *
 * Public: No
 */

params ["_kind"];

private _gun = _kind == "gun";
private _taken = (missionNamespace getVariable [[QGVAR(bcs_locations), QGVAR(bcs_bty_guns)] select _gun, []]) apply {_x # 0};
private _format = ["AB%1", "%1"] select _gun;
private _digits = [4, 1] select _gun;
private _number = 1;
while {format [_format, [_number, _digits] call CBA_fnc_formatNumber] in _taken} do {_number = _number + 1};
format [_format, [_number, _digits] call CBA_fnc_formatNumber]
