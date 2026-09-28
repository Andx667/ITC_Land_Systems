#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Per-frame scan for a stationary COBRA radar vehicle: checks each tracked
 * indirect-fire shell against the vehicle's turret arc, detection range and
 * terrain line-of-sight, and for each detected shell calculates its impact
 * and origin points, then records the engagement and processes the origin and
 * impact before removing the shell from the tracked list (also removing any
 * shell that is no longer alive). Also purges expired active-shell impact
 * predictions from the mission's active-shells list.
 *
 * Arguments:
 * 0: COBRA radar vehicle performing the scan <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_cbr] call itc_land_cobra_fnc_scan
 *
 * Public: No
 */

params ["_cbr"];
_shells = missionNamespace getVariable "itc_land_cobra_shells";
_toRemove = [];
{
  _dir = deg (_cbr animationPhase "mainTurret");
  _dir = (getDir _cbr - _dir);
  if(_dir > 360) then {_dir = _dir - 360;};
  _angleTo = abs (((_dir) + 360) - ((_cbr getDir _x) + 360));
  _inRange = _x distance _cbr < 10000;
  if(_angleTo < 23 && _inRange && !(terrainIntersectASL [getPosASL _x, (getPosASL _cbr) vectorAdd [0,0,3]])) then {
    _toRemove pushBack _x;
    _impact = [_x] call FUNC(calcImpact);
    [_cbr, _impact] call FUNC(processImpact);
    _origin = [_x] call FUNC(calcOrigin);
    [_cbr, _origin] call FUNC(processOrigin);
    [_cbr, _origin] call FUNC(processEngagement);
  };
  if(!alive _x) then {
    _toRemove pushBack _x;
  }
} forEach _shells;
missionNamespace setVariable ["itc_land_cobra_shells", _shells - _toRemove];

_activeShells = missionNamespace getVariable "itc_land_cobra_activeShells";
_toRemoveShells = [];
{
  if(time > _x # 1) then {_toRemoveShells pushBack _x;};
} forEach _activeShells;
missionNamespace setVariable ["itc_land_cobra_activeShells",_activeShells - _toRemoveShells];
