#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Traces a ray from an origin position at a given azimuth/elevation and finds
 * where it intersects either objects or the terrain surface, stepping outward
 * in 1000m increments up to a maximum range of 16km.
 *
 * Arguments:
 * 0: Origin position (ASL) to trace the ray from <Position>
 * 1: Horizontal (azimuth) angle of the ray, in degrees <Number>
 * 2: Vertical (elevation) angle of the ray, in degrees <Number>
 * 3: True to intersect with objects (vehicle player) instead of terrain surfaces <Boolean>
 *
 * Return Value:
 * ASL position where the ray intersects terrain or an object; nothing is
 * returned if no intersection is found within range <Position>
 *
 * Example:
 * [_origin, _angleX, _angleY, _object] call itc_land_spike_fnc_intersectAtPolar
 *
 * Public: No
 */
params ["_origin","_angleX","_angleY", "_object"];

scopeName "return";

private _vectorIntersect = [1050, _angleX, _angleY] call CBA_fnc_polar2vect;
private _vectorIntersectDir = vectorNormalized _vectorIntersect;

for "_i" from 0 to 15 step 1 do {
  private _startPos = _origin vectorAdd (_vectorIntersectDir vectorMultiply (_i * 1000));
  private _endPos = _startPos vectorAdd _vectorIntersect;
  if (_object) then {
    private _intersect = lineIntersectsObjs [_startPos, _endPos, (vehicle player)];
    if(count _intersect > 0) then {
      (_intersect # 0) breakOut "return";
    };
  } else {
    private _intersect = lineIntersectsSurfaces [_startPos, _endPos, (vehicle player)];
    if(count _intersect > 0) then {
      (_intersect # 0 # 0) breakOut "return";
    };
  };
};
