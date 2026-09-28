#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Calculates the horizontal and vertical angle offsets between a projectile's current
 * heading/velocity vector and a target position.
 *
 * Arguments:
 * 0: Projectile <Object>
 * 1: Target / steer point position <Position>
 * 2: Projectile's current position <Position>
 *
 * Return Value:
 * Horizontal and vertical angle offsets to the target, in degrees <Array>
 *
 * Example:
 * [_projectile, _steerPoint, _position] call itc_land_vls_fnc_angleToTarget
 *
 * Public: No
 */

params ["_projectile", "_target", "_position"];
private _vectToTarget = _position vectorFromTo _target;
private _vectToTargetDiff = _vectToTarget vectorDiff (vectorNormalized (velocity _projectile));
private _vectorModelSpace = _projectile vectorWorldToModel _vectToTargetDiff;
private _angleX = ((getPos _projectile) getDir _target) - (getDir _projectile);
if(_angleX < 0) then {_angleX = _angleX + 360};
if(_angleX > 180) then {_angleX = _angleX - 360};
private _angleY = asin (_vectorModelSpace # 2);
[_angleX, _angleY]
