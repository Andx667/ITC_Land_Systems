#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Fired EH handler for a longer-range GPS/INS-guided rocket (PGM230). Reads
 * the target position stored on the firing unit (itc_land_guidance_targetPos,
 * falling back to the like-named global variable), and, if one is set,
 * attaches an every-frame handler that computes the yaw/pitch error to the
 * target in the projectile's model space and applies a time-scaled turn rate
 * (12 degrees/second) to correct heading continuously, while pitch/bank is
 * only corrected when the vertical angle error exceeds 45 degrees or once
 * the projectile has covered half the total launch-to-target distance. Does
 * nothing if no target position has been assigned.
 *
 * Arguments:
 * 0: Unit/vehicle that fired the shot <OBJECT>
 * 1: Weapon fired <STRING> (unused)
 * 2: Muzzle used <STRING> (unused)
 * 3: Firing mode <STRING> (unused)
 * 4: Ammo classname fired <STRING>
 * 5: Magazine used <STRING> (unused)
 * 6: Fired projectile <OBJECT>
 * 7: Gunner of the firing vehicle <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_guidance_fnc_pgm230
 *
 * Public: No
 */

params ["_unit", "", "", "", "_ammo", "", "_projectile", "_gunner"];
private _targetPos = _unit getVariable ["itc_land_guidance_targetPos", itc_land_guidance_targetPos];

if(isNil{_targetPos}) exitWith {};
[_projectile, {
  params ["_projectile", "_args"];
  _args params ["_lastFrameTime", "_targetCoordinates", "_launchPos"];
  private _frameTime = time - _lastFrameTime;
  _args set [0, time];

  private _distance2D = _projectile distance2D _targetCoordinates;
  private _distance2DTotal = _launchPos distance2D _targetCoordinates;
  private _position = getPosASL _projectile;
  (_projectile call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];
  private _vectToTarget = _position vectorFromTo _targetCoordinates;
  private _vectToTargetDiff = _vectToTarget vectorDiff (vectorNormalized (velocity _projectile));
  private _vectorModelSpace = _projectile vectorWorldToModel _vectToTargetDiff;
  private _angleX = asin (_vectorModelSpace # 0);
  private _angleY = asin (_vectorModelSpace # 2);

  private _turnRate = 12 * _frameTime;
  _projectile setDir (getDir _projectile) + (_angleX min _turnRate  max -_turnRate );
  if(((-_angleY) > 45)) then {
    [_projectile, _pitch + (_angleY  min _turnRate  max -_turnRate), 0] call BIS_fnc_setPitchBank;
  };

  if(_distance2D < (_distance2DTotal / 2)) then {
    [_projectile, _pitch + (_angleY  min _turnRate  max -_turnRate), 0] call BIS_fnc_setPitchBank;
  };

}, 0, [time, _targetPos, getPosASL _projectile]] call EFUNC(common,addProjectilePFH);
