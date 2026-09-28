/*
 * Author: ToadBall, Yax, VKing
 * Hides the missile app's page-specific UI controls (FCS and status panels) when the app is closed or switched away from.
 *
 * Arguments:
 * 0: The tablet dialog display <Display> (unused)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_appClear
 *
 * Public: No
 */

{
  ctrlShow [_x, false];
} forEach [13701,13420];
