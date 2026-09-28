#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Finds where a ray from an origin position intersects the terrain or objects,
 * defaulting the ray direction to the direction from the origin toward the
 * world position at the center of the screen when no direction is supplied.
 *
 * Arguments:
 * 0: Origin position (ASL) to trace from <Position>
 * 1: Direction vector to trace along (default: direction to the screen-center world position) <Array>
 * 2: True to intersect with objects instead of terrain surfaces <Boolean> (default: false)
 *
 * Return Value:
 * ASL position where the ray intersects terrain or an object; nothing is
 * returned if no intersection is found within range <Position>
 *
 * Example:
 * [_originPosition, _direction, _object] call itc_land_spike_fnc_intersectScreenToWorld
 *
 * Public: No
 */
params ["_originPosition", "_direction", ["_object", false]];
if (isNil "_direction") then {
  _direction = _originPosition vectorFromTo (AGLToASL (screenToWorld [0.5,0.5]));
};
private _vect = _direction;
private _polar = _vect call cba_fnc_vect2polar;
[_originPosition, _polar # 1, _polar # 2, _object] call FUNC(intersectAtPolar);
