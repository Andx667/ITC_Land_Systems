#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Starts guidance on a freshly fired VLS projectile: reads the previously selected
 * target position and impact angle from the vehicle, stores the bomb's flying target,
 * and registers the per-frame guidance handler.
 *
 * Arguments (standard "Fired" EH arguments; only the indices below are used):
 * 0: Vehicle <Object>
 * 4: Ammo classname <String>
 * 6: Projectile <Object>
 * 7: Gunner <Object>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_vehicle, _weapon, _muzzle, _mode, _ammo, _magazine, _projectile, _gunner] call itc_land_vls_fnc_guide
 *
 * Public: No
 */

params ["_vehicle", "", "", "", "_ammo", "", "_projectile", "_gunner"];

if (!local _gunner) exitWith {};

private _angle = itc_land_target_IAtest;
private _targetCoordinates = itc_land_target_test;
private _azimuth = 0;//keep this 0 until target azimuth works

_vehicle setVariable [QGVAR(bomb_flying_target), _targetCoordinates];
private _dropTime = time;

//GUIDANCE
[FUNC(guidePfh), 0, [_projectile, _ammo, getPosATL _projectile, _targetCoordinates, "SEP", _dropTime, _angle, time,_azimuth, _targetCoordinates]] call CBA_fnc_addPerFrameHandler;
