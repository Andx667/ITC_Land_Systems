#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Fired EH for weapons that can be engaged by the CIWS system. Runs only on
 * the machine where the gunner is local, and only when the CIWS system is
 * enabled (GVAR(enabled)). Checks whether the fired ammo's base class
 * matches one of the configured interceptable ammo classes
 * (GVAR(interceptable)); if so, forwards the Fired EH parameters to
 * FUNC(shellTarget) to spawn a trackable decoy target for the CIWS to
 * engage.
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
 * [_vehicle, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_ciws_fnc_fired
 *
 * Public: No
 */

params ["", "", "", "", "_ammo", "", "_projectile", "_gunner"];
if(!local _gunner) exitWith {}; //make sure it doesn't get executed everywhere
if(!GVAR(enabled)) exitWith {};  //if the CIWS system is turned off, stop the script

private _interceptable = false;
{ //loop through interceptable ammo base classes
  if(_ammo isKindOf [_x, configFile >> "cfgAmmo"]) exitWith {_interceptable = true;};
}forEach GVAR(interceptable);

if(!_interceptable) exitWith {}; //if the ammo can't be intercepted, kill the script;

_this call FUNC(shellTarget);
