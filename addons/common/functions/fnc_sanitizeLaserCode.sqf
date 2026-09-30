#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Reads a laser code from an edit box. If it isn't a valid laser code it is replaced by the
 * default, and the edit box is corrected.
 *
 * Arguments:
 * 0: IDC of the edit box <NUMBER>
 * 1: Code to use if the input is invalid (default: 1111) <NUMBER>
 *
 * Return Value:
 * Valid laser code <NUMBER>
 *
 * Example:
 * [86008] call itc_land_common_fnc_sanitizeLaserCode
 *
 * Public: No
 */

params ["_idc", ["_default", 1111]];

private _code = parseNumber (ctrlText _idc);
if !([_code] call FUNC(isLaserCode)) then {
    _code = _default;
    ctrlSetText [_idc, str _default];
};

_code
