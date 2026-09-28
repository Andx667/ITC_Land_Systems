#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Fired EH handler for a dual-mode GPS/laser-guided munition (IGM15x). Reads
 * the target position and laser code stored on the firing vehicle
 * (itc_land_guidance_targetPos / itc_land_guidance_laserCode, laser code
 * defaulting to 1111), and, if a target position is set, attaches a
 * per-frame handler that steers the projectile toward that GPS position by
 * default, switching to the live laser spot returned by
 * ace_laser_fnc_seekerFindLaserSpot whenever one matching the code is found.
 * Corrections to heading and pitch/bank are only applied while the pitch
 * error is under 20 degrees. Does nothing if no target position has been
 * assigned.
 *
 * Arguments:
 * 0: Vehicle/unit that fired the shot <OBJECT>
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
 * [_vehicle, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_guidance_fnc_igm15x
 *
 * Public: No
 */

params ["_vehicle", "", "", "", "_ammo", "", "_projectile", "_gunner"];

//First we need to use GPS guidance to get to target area.
private _targetPos = _vehicle getVariable "itc_land_guidance_targetPos";
//We then need a laser code for terminal guidance
private _laserCode = _vehicle getVariable ["itc_land_guidance_laserCode",1111];

if(isNil{_targetPos}) exitWith {};
[{
  (_this select 0) params ["_projectile", "_ammo", "_position", "_targetCoordinates","_laserCode"];
  if (!alive _projectile) exitWith {
      [_this select 1] call CBA_fnc_removePerFrameHandler;
  };

  private _position = getPosASL _projectile;
  (_this select 0) set [2, _position];
  (_projectile call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];

  private _spot = [getPosASL _projectile, velocity _projectile, 20, 10000, [1500, 1550], _laserCode] call ace_laser_fnc_seekerFindLaserSpot;
  if (!isNil{_spot select 0}) then {
    _targetCoordinates = _spot select 0;
  };

  _dElev = (_position select 2) - (_targetCoordinates select 2);
  _distHorizontal = [_position select 0, _position select 1, 0] distance [_targetCoordinates select 0, _targetCoordinates select 1, 0];
  _angleTo = atan(_dElev / _distHorizontal);

  _diff = abs(_pitch - (_angleTo * -1));

  if(_diff < 20) then {
    if((_projectile getDir _targetCoordinates) > getDir _projectile) then {
      _projectile setDir (getDir _projectile + 0.5);
    } else {
      _projectile setDir (getDir _projectile - 0.5);
    };

    _turnRate = 2;
    if(_pitch > (_angleTo * -1)) then {
      [_projectile, _pitch - (_diff / _turnRate), 0] call BIS_fnc_setPitchBank;
    } else {
      [_projectile, _pitch + (_diff / _turnRate), 0] call BIS_fnc_setPitchBank;
    };
  };

}, 0.1, [_projectile, _ammo, getPosATL _projectile, _targetPos, _laserCode]] call CBA_fnc_addPerFrameHandler;
