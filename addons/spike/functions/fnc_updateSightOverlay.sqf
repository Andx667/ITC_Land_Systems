#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Updates the pre-launch Spike LR gunner sight overlay each frame: repositions
 * the seeker-status control group depending on current zoom/field of view, sets
 * the DTV/HOT vision-mode label, and positions (or hides) the lock-reticle
 * controls based on the current lock information.
 *
 * Arguments:
 * 0: Gunner sight display to update <Display>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_display] call itc_land_spike_fnc_updateSightOverlay
 *
 * Public: No
 */

params ["_display"];
private _group = _display displayCtrl 170;
private _boxHidePosition = if (((call CBA_fnc_getFOV) # 0) > 0.1) then [{[22 * (safeZoneW / 64),10 *    (safeZoneH / 40)]}, {[-1,-1]}];
(_group controlsGroupCtrl 1020) ctrlSetPosition _boxHidePosition;
(_group controlsGroupCtrl 1020) ctrlCommit 0;
(_group controlsGroupCtrl 1011) ctrlSetText (if (currentVisionMode player == 0) then [{"DTV"}, {"HOT"}]);

itc_land_spike_lockInformation params ["_lockObject", "_lockPosition", "_lockLostTime", "_originalLockPosition"];
if (!isNil "_lockObject") then {
  private _screenPos = worldToScreen (_lockObject modelToWorld _lockPosition);
  private _screenPosX = (_screenPos # 0) - safeZoneX;
  private _screenPosY = (_screenPos # 1) - safeZoneY;
  _screenPosX = _screenPosX - (10 * (safeZoneW / 64));
  _screenPosY = _screenPosY - (10 * (safeZoneH / 40));
  (_group controlsGroupCtrl 1021) ctrlSetPosition [_screenPosX, _screenPosY];
  (_group controlsGroupCtrl 1022) ctrlSetPosition [_screenPosX, _screenPosY];
} else {
  (_group controlsGroupCtrl 1021) ctrlSetPosition [22 * (safeZoneW / 64),10 *   (safeZoneH / 40)];
  (_group controlsGroupCtrl 1022) ctrlSetPosition [-1, -1];
};
(_group controlsGroupCtrl 1021) ctrlCommit 0;
(_group controlsGroupCtrl 1022) ctrlCommit 0;
