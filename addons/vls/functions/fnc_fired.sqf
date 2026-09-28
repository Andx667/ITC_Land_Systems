#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles the vehicle "Fired" event for VLS-guided munitions: if the gunner is local,
 * starts the projectile's guidance loop and plays the cruise-missile fired effect.
 *
 * Arguments (standard "Fired" EH arguments; only the indices below are used):
 * 4: Ammo classname <String>
 * 6: Projectile <Object>
 * 7: Gunner <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_vls_fnc_fired
 *
 * Public: No
 */

params ["", "", "", "", "_ammo", "", "_projectile", "_gunner"];
if (!local _gunner) exitWith {};
_this call FUNC(guide);
_this call BIS_fnc_effectFiredCruiseMissile;
