/*
 * Author: ToadBall, Yax, VKing
 * Hides all BCS app workspace panel controls (settings, setup, locStores, ammoStores,
 * engageMission, solutionMission, adjustMission), clearing the currently displayed page.
 *
 * Arguments:
 * 0: Tablet dialog display <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [findDisplay 32562] call itc_land_tablet_fnc_appClear
 *
 * Public: No
 */

{
  ctrlShow [_x, false];
} forEach [13501,13502,13503,13504,13505,13506,13507];
