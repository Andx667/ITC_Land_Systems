#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Extrapolates a guided projectile's flight path forward using its current bank, bank rate,
 * pitch and dive rate, and checks whether that path intersects terrain (Automatic Ground
 * Collision Avoidance System check).
 *
 * Arguments:
 * 0: Guidance data array <Array>
 *   0: Projectile <Object>
 *   1: Steer point <Position>
 *   2: Frame time <Number>
 *   3: Horizontal angle to target <Number>
 *   4: Vertical angle to target <Number>
 *   5: Guidance stage <String>
 * 1: Current bank angle <Number>
 * 2: Current bank rate <Number>
 * 3: Current pitch angle <Number>
 * 4: Current dive rate <Number>
 *
 * Return Value:
 * True if the extrapolated flight path intersects terrain <Boolean>
 *
 * Example:
 * [[_projectile, _steerPoint, _frameTime, _angleX, _angleY, _stage, _position, _angle], _bank, _bankRate, _pitch, _diveRate] call itc_land_vls_fnc_AGCAS
 *
 * Public: No
 */

params ["_guidance","_bank","_bankRate","_pitch","_diveRate"];
_guidance params ["_projectile", "_steerPoint","_frameTime", "_angleX", "_angleY","_stage"];

_pitch = _pitch + 0.01;

private _speed = vectorMagnitude (velocity _projectile);
private _levelTime = if(_bank != 0 && _bankRate != 0)then[{(abs _bank) / _bankRate},{0}];
private _pitchTime = (10 - _pitch) / _diveRate;
private _pullDist = ((_levelTime * _speed) + (_pitchTime * _speed)) max 300;
private _velocityDirDist = ((vectorNormalized (velocity _projectile)) vectorMultiply _pullDist);
private _intersectPos = (getPosASL _projectile) vectorAdd _velocityDirDist;
//private _intersectPos = _projectile modelToWorldWorld [0,_pullDist,-50];

private _intersects = lineIntersectsSurfaces [getPosASL _projectile, _intersectPos, _projectile];
(count _intersects > 0)
