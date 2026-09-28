/*
 * Author: ToadBall, Yax, VKing
 * Hides the CBR app's sub-page panels (Settings, Map and Data workspaces) when the app is closed or switched away from.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_tablet_fnc_appClear;
 *
 * Public: No
 */

{
  ctrlShow [_x, false];
} forEach [13600,13601,13602];
