#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Refreshes a VLS guidance data array in place with the projectile's current position
 * and the current frame's timestamp, for use by the per-frame guidance handler.
 *
 * Arguments:
 * 0: Guidance data array <Array>
 *   0: Projectile <Object>
 *   1: Ammo classname <String>
 *   2: Projectile position (ASL) <Position>
 *   3: Target coordinates <Position>
 *   4: Guidance stage <String>
 *   5: Time guidance started <Number>
 *   6: Desired impact angle <Number>
 *   7: Time of last PFH frame <Number>
 *   8: Azimuth <Number>
 *   9: Steer point <Position>
 * 1: Per-frame handler ID <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_projectile, _ammo, _position, _targetCoordinates, _stage, _time, _angle, _lastFrameTime, _azimuth, _steerPoint], _pfhId] call itc_land_vls_fnc_updateData
 *
 * Public: No
 */

(_this select 0) params ["_projectile", "_ammo", "_position", "_targetCoordinates", "_stage", "_time", "_angle", "_lastFrameTime","_azimuth","_steerPoint"];
(_this select 0) set [7, time];
_position = getPosASL _projectile;
(_this select 0) set [2, _position];
