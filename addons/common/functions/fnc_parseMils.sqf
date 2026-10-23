#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Reads an angle typed in mils (a BCS input such as an OT direction) in a mil system and returns
 * it in NATO mils. In the 6000 system the Russian notation "15-00" is accepted as well as "1500".
 *
 * Arguments:
 * 0: Typed angle <STRING>
 * 1: Mil system, 6400 or 6000 (default: 6400) <NUMBER>
 *
 * Return Value:
 * Angle in 6400 mils <NUMBER>
 *
 * Example:
 * ["15-00", 6000] call itc_land_common_fnc_parseMils // 1600
 *
 * Public: No
 */

params ["_text", ["_system", 6400]];

// "15-00": the dash separates hundreds and units; a leading dash stays the sign
private _negative = (_text select [0, 1]) == "-";
private _value = parseNumber ((_text select [parseNumber _negative]) splitString "-" joinString "");
if (_negative) then {_value = -_value};

if (_system == 6000) then {_value * 6400 / 6000} else {_value}
