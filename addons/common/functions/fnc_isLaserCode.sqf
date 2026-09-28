#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Validates whether a number is a valid laser code: must be between 1111 and 1788, and must not contain the digits 0 or 9.
 *
 * Arguments:
 * 0: Laser code to validate <NUMBER>
 *
 * Return Value:
 * True if the laser code is valid <BOOLEAN>
 *
 * Example:
 * [1234] call itc_land_common_fnc_isLaserCode
 *
 * Public: No
 */

params ["_number"];

if(_number < 1111 || _number > 1788) exitWith{false};
if((str _number) find "0" >= 0 || (str _number) find "9" >= 0) exitWith {false};

true
