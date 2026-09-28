#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Per-frame handler that drives VLS projectile guidance each frame: refreshes the
 * projectile's tracked position/time, determines the current steer point/stage, and
 * either hands off to the terminal steering logic or performs the initial pitch-down
 * turn onto the target, removing itself once the projectile is no longer alive.
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
 * [[_projectile, _ammo, _position, _targetCoordinates, _stage, _time, _angle, _lastFrameTime, _azimuth, _steerPoint], _pfhId] call itc_land_vls_fnc_guidePfh
 *
 * Public: No
 */

(_this select 0) params ["_projectile", "_ammo", "_position", "_targetCoordinates", "_stage", "_time", "_angle", "_lastFrameTime","_azimuth","_steerPoint"];
if (_lastFrameTime == time) exitWith {};

if (!alive _projectile) exitWith {
    [_this select 1] call CBA_fnc_removePerFrameHandler;
};
private _frameTime = time - _lastFrameTime;
_this call FUNC(updateData);

private _angles = [_projectile, _steerPoint, _position] call FUNC(angleToTarget);

private _return = ([_projectile, _steerPoint, _frameTime] + _angles + [_stage, _targetCoordinates,_azimuth,_time]) call FUNC(determineSteerPoint);
_stage = (_return # 0);
(_this select 0) set [9, (_return # 1)];

if(_stage != "SEP" && _stage != "TURN") then {
  _stage = ([_projectile, _steerPoint, _frameTime] + _angles + [_stage, _position, _angle]) call FUNC(steerTo);
} else {
  if(_stage == "TURN") then {
    (_projectile call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];
    _projectile setDir (_projectile getDir _targetCoordinates);
    if (_pitch > 0) then {
      [_projectile, _pitch - (_frameTime * 10), 0] call BIS_fnc_setPitchBank;
    };
  };
};
(_this select 0) set [4, _stage];
