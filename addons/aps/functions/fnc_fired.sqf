#include "..\script_component.hpp"

/*
 * Author: Yax
 * "Fired" class event handler. For locally fired rocket/missile projectiles, adds a per-frame handler that raycasts ahead of the
 * projectile every 0.05s and attempts an APS intercept against any object it detects with APS modules, until the projectile dies.
 *
 * Arguments:
 * 0: Unit that fired <OBJECT>
 * 1: Weapon classname <STRING>
 * 2: Muzzle classname <STRING>
 * 3: Firing mode <STRING>
 * 4: Ammo classname <STRING>
 * 5: Magazine classname <STRING>
 * 6: Fired projectile <OBJECT>
 * 7: Gunner <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_aps_fnc_fired
 *
 * Public: No
 */

params ["_unit", "_weapon", "", "", "_ammo", "", "_projectile", "_gunner"];

if (!local _unit) exitWith {};

private _simulation = getText (configFile >> "cfgAmmo" >> _ammo >> "simulation");

if (!(_simulation in ["shotRocket", "shotMissile"])) exitWith {};

[_projectile, {
  params ["_projectile"];
  private _begin = getPosASL _projectile;
  private _end = _begin vectorAdd ((vectorDir _projectile) vectorMultiply 30);
  private _intersects = lineIntersectsWith  [_begin, _end, objNull, objNull];
  if (count _intersects > 0) exitWith {
    { // forEach _intersects
      private _aps = _x getVariable ["itc_land_aps_modules", nil];
      if (!(isNil "_aps")) then {
        [_projectile, _x] call FUNC(attemptIntercept);
      };
    } forEach _intersects;
  };
}, 0.05, [], {setAccTime 1}] call EFUNC(common,addProjectilePFH);
