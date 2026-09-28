#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Finds all air vehicles friendly to ace_player that carry a laser-designator
 * turret, for use in the rover UI's aircraft selection list.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Air vehicles that are friendly and have a laser-capable turret <ARRAY>
 *
 * Example:
 * [] call itc_land_rover_fnc_getAircraft
 *
 * Public: No
 */

private _planes = [];
private ["_turret"];
{
  if ( ((side ace_player) getFriend (side _x)) >=0.6 ) then {
    if (_x isKindOf "Air") then {
      _turret = [_x] call FUNC(getLaserTurret);
      if (!isNil "_turret") then {_planes pushBack _x};
    };
  };
} forEach vehicles;
_planes
