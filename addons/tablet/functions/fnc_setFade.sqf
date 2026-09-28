#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Sets the fade level of a control on the tablet display and commits the
 * change immediately.
 *
 * Arguments:
 * 0: Tablet display <Display>
 * 1: Control IDC <Number>
 * 2: Fade value, 0 (visible) to 1 (fully faded) <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562, 15010, 1] call itc_land_tablet_fnc_setFade
 *
 * Public: No
 */

params ["_display", "_ctrl", "_fade"];

(_display displayCtrl _ctrl) ctrlSetFade _fade;
(_display displayCtrl _ctrl) ctrlCommit 0;
