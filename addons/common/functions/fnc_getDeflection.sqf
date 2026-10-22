#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Takes two directions in degrees and calculates the deflection between them in mils, with the US
 * convention: 3200 along the fixed direction, more to the left, less to the right.
 *
 * Arguments:
 * 0: Direction to fixed point <NUMBER>
 * 1: Direction to deflect to: Gun direction / Target direction <NUMBER>
 *
 * Return Value:
 * Deflection in mils <STRING>
 *
 * Example:
 * [16, 16] call itc_land_common_fnc_getDeflection
 *
 * Public: No
 */

params ["_fixed","_deflecting"];

// Deflection as on a US panoramic telescope: 3200 when the target lies along the fixed direction,
// counting up to the left and down to the right ("left add, right subtract")
private _df = 3200 + (_fixed - _deflecting) / 360 * 6400;
_df = (_df % 6400 + 6400) % 6400;

[_df,4,0] call CBA_fnc_formatNumber;
