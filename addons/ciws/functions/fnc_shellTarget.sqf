#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Spawns and tracks a targetable decoy object representing an incoming
 * projectile, so that CIWS-enabled weapons can lock on to and engage it.
 * After a 1 second delay, resolves a target classname from the fired ammo's
 * itc_land_ciws_target config entry (defaulting to "itc_land_shell") with a
 * side-specific suffix (_b/_o/_i) based on the gunner's side, spawns it
 * behind the projectile with matching velocity and no mass, strips its crew
 * AI, then adds a per-frame handler that keeps the decoy positioned relative
 * to the projectile each frame, removes it once the projectile drops below
 * 30m ASL while still descending and uninterceptable, and cleans up both
 * objects once the projectile or the decoy is no longer alive.
 *
 * Arguments:
 * 0: Vehicle/unit that fired the shot <OBJECT> (unused)
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
 * [_vehicle, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_ciws_fnc_shellTarget
 *
 * Public: No
 */

[{
  params ["", "", "", "", "_ammo", "", "_projectile", "_gunner"];
  private _classTarget = getText (configFile >> "cfgAmmo" >> _ammo >> "itc_land_ciws_target");
  private _initialClass = if(_classTarget != "") then [{_classTarget},{"itc_land_shell"}];
  private _class = if((side _gunner) == west) then [{_initialClass + "_b"},{_initialClass + "_o"}];
  _class = if((side _gunner) == resistance) then [{_initialClass + "_i"},{_class}];
  private _target = _class createVehicle [0,0,1000];
  _target setPos (_projectile modelToWorld [0,-5,0]);
  _target setVelocity (velocity _projectile);
  _target setMass 0;
  _target setObjectTexture [0,""];
  createVehicleCrew _target;
  driver _target disableAI "ALL";
  gunner _target disableAI "ALL";
  _target deleteVehicleCrew (gunner _target);
  [{
      (_this select 0) params ["_projectile", "_target"];
      private _canIntercept = (getPosATL _projectile # 2 > 30);
      private _descending = (velocity _projectile # 2 < 0);
      if (!alive _projectile || (!alive _target && _canIntercept)) exitWith {
          deleteVehicle _projectile;
          deleteVehicle _target;
          [_this select 1] call CBA_fnc_removePerFrameHandler;
      };
      if(!_canIntercept && alive _target && _descending) then {
        deleteVehicle _target;
      } else {
        _target setPos (_projectile modelToWorld [1,-5,1]);
        _target setVelocity (velocity _projectile);
      };
  }, 0, [_projectile, _target]] call CBA_fnc_addPerFrameHandler;
}, _this, 1] call CBA_fnc_waitAndExecute;
