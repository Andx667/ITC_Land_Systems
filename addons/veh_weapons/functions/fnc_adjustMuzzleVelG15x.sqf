#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Fired event handler that applies a small random variance to a fired G15x-family
 * projectile's initial velocity, simulating shot-to-shot dispersion.
 *
 * Arguments:
 * 0: Vehicle that fired the weapon <OBJECT>
 * 1: Weapon class fired <STRING>
 * 2: Muzzle class used <STRING>
 * 3: Fire mode used <STRING>
 * 4: Ammo/simulation class of the fired round <STRING>
 * 5: Magazine class fired <STRING>
 * 6: Fired projectile whose velocity will be randomized <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [itc_gun, "itc_weapon", "itc_muzzle", "manual", "itc_ammo", "itc_mag", _projectile] call itc_land_veh_weapons_fnc_adjustMuzzleVelG15x
 *
 * Public: No
 */

params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile"];

private _currentSpeed = vectorMagnitude (velocity _projectile);
private _randomFactor = random [(_currentSpeed / 100) * -0.5,0,(_currentSpeed / 100) * 0.5];
private _targetSpeed = _currentSpeed + _randomFactor;
private _targetVelocity = (vectorNormalized velocity _projectile) vectorMultiply _targetSpeed;
_projectile setVelocity _targetVelocity;
//player sideChat format["Adjusting velocity from %1 to %2", _currentSpeed, _targetSpeed];
