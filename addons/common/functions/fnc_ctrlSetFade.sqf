#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Sets the fade value of a display control and commits the change immediately.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Control IDC <NUMBER>
 * 2: Fade value <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 46, 101, 1] call itc_land_common_fnc_ctrlSetFade
 *
 * Public: No
 */

params ["_display", "_ctrl", "_fade"];

(_display displayCtrl _ctrl) ctrlSetFade _fade;
(_display displayCtrl _ctrl) ctrlCommit 0;
