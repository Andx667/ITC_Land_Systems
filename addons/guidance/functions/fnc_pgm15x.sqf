#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Fired EH handler for a GPS/INS-guided precision munition (PGM15x). Reads
 * the target position previously stored on the firing vehicle
 * (itc_land_guidance_targetPos) and, if one is set, attaches a per-frame
 * handler that steers the projectile's heading and pitch/bank toward that
 * fixed position every 0.1 seconds, only applying corrections while the
 * pitch error is under 20 degrees. Does nothing if no target position has
 * been assigned.
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
 * [_vehicle, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_guidance_fnc_pgm15x
 *
 * Public: No
 */

params ["_vehicle", "", "", "", "_ammo", "", "_projectile", "_gunner"];
private _targetPos = _vehicle getVariable "itc_land_guidance_targetPos";
if(isNil{_targetPos}) exitWith {};
[{
  (_this select 0) params ["_projectile", "_ammo", "_position", "_targetCoordinates"];
  if (!alive _projectile) exitWith {
      [_this select 1] call CBA_fnc_removePerFrameHandler;
  };

  _position = getPosASL _projectile;
  (_this select 0) set [2, _position];
  (_projectile call BIS_fnc_getPitchBank) params ["_pitch", "_bank"];

  private _dElev = (_position select 2) - (_targetCoordinates select 2);
  private _distHorizontal = [_position select 0, _position select 1, 0] distance [_targetCoordinates select 0, _targetCoordinates select 1, 0];
  private _angleTo = atan(_dElev / _distHorizontal);

  private _diff = abs(_pitch - (_angleTo * -1));

  if(_diff < 20) then {
    if((_projectile getDir _targetCoordinates) > getDir _projectile) then {
      _projectile setDir (getDir _projectile + 0.5);
    } else {
      _projectile setDir (getDir _projectile - 0.5);
    };

    private _turnRate = 2;
    if(_pitch > (_angleTo * -1)) then {
      [_projectile, _pitch - (_diff / _turnRate), 0] call BIS_fnc_setPitchBank;
    } else {
      [_projectile, _pitch + (_diff / _turnRate), 0] call BIS_fnc_setPitchBank;
    };
  };
}, 0.1, [_projectile, _ammo, getPosATL _projectile, _targetPos]] call CBA_fnc_addPerFrameHandler;
