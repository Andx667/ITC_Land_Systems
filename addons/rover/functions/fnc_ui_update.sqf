#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Handles a selection change in the rover UI's aircraft list box: stores the
 * newly selected index/aircraft, recreates the video feed for it, and
 * recomputes the camera's optics memory point position from its laser turret
 * (or driver optics if it has none).
 *
 * Arguments:
 * 0: List box control that triggered the update <CONTROL>
 * 1: Index of the newly selected item in the list box <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control, _index] call itc_land_rover_fnc_ui_update
 *
 * Public: No
 */

params ["_control","_index"];

missionNamespace setVariable ["itc_land_rover_ui_curSelIndex",_index];
missionNamespace setVariable ["itc_land_rover_ui_curAircraft",itc_land_rover_ui_aircraftList # _index];
private _plane = missionNamespace getVariable ["itc_land_rover_ui_curAircraft",objNull];

private _feed = [_plane] call FUNC(createFeed);

private _turret = [_plane] call FUNC(getLaserTurret);
if (isNil "_turret") exitWith {};
if (count _turret == 1 && {_turret # 0 == -1}) then {
  private _memPointName = getText (configOf _plane >> "memoryPointDriverOptics");
  itc_land_rover_mempointPos = _plane selectionPosition _memPointName;
} else {
  private _turretConfig = [_plane, _turret] call CBA_fnc_getTurret;
  private _memPointName = getText (_turretConfig >> "memoryPointGunnerOptics");
  itc_land_rover_mempointPos = _plane selectionPosition _memPointName;
};
