#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Converts an angle from degrees to mils and formats it as a zero-padded string, with a "-" prefix for negative values.
 *
 * Arguments:
 * 0: Input number (degrees) <NUMBER>
 * 1: Number of decimal places <NUMBER>
 * 2: Number of integer places, used for adding leading 0s <NUMBER>
 *
 * Return Value:
 * Formatted number <STRING>
 *
 * Example:
 * [45, 0, 4] call itc_land_common_fnc_FormatAsMils
 *
 * Public: No
 */

params ["_input", "_decimalPlaces", "_integerPlaces"];

_input = _input * (6400 / 360);

private _prefix = ["", "-"] select (_input < 0);
private _return = [abs (_input), _integerPlaces, _decimalPlaces, false] call CBA_fnc_formatNumber;
(_prefix + _return)
