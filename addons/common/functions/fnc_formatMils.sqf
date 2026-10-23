#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Formats an angle in NATO mils for display in a mil system: 6400 as four digits ("1600"), 6000
 * converted and in Russian notation, hundreds and units split by a dash ("15-00").
 *
 * Arguments:
 * 0: Angle in 6400 mils <NUMBER>
 * 1: Mil system, 6400 or 6000 (default: 6400) <NUMBER>
 *
 * Return Value:
 * Formatted angle <STRING>
 *
 * Example:
 * [1600, 6000] call itc_land_common_fnc_formatMils // "15-00"
 *
 * Public: No
 */

params ["_mils", ["_system", 6400]];

private _prefix = ["", "-"] select (_mils < 0);
if (_system != 6000) exitWith {_prefix + ([round abs _mils, 4, 0] call CBA_fnc_formatNumber)};

private _value = round (abs _mils * 6000 / 6400);
format ["%1%2-%3", _prefix, [floor (_value / 100), 2] call CBA_fnc_formatNumber, [_value % 100, 2] call CBA_fnc_formatNumber]
