#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Sets the text of a display control.
 *
 * Arguments:
 * 0: Display <DISPLAY>
 * 1: Control IDC <NUMBER>
 * 2: Text <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 46, 101, "1200"] call itc_land_common_fnc_ctrlSetText
 *
 * Public: No
 */

params ["_display", "_ctrl", "_text"];

(_display displayCtrl _ctrl) ctrlSetText _text;
