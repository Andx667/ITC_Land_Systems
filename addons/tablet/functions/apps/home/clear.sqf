#include "..\..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Hides the Home app's app-list panel and fades the exit/menu controls back in when leaving the Home app.
 *
 * Arguments:
 * 0: The tablet dialog's display <DISPLAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_appClear;
 *
 * Public: No
 */

params ["_display"];
{
  ctrlShow [_x, false];
} forEach [13301];

[_display, 15010, 1] call FUNC(setFade);
[_display, 15011, 1] call FUNC(setFade);
