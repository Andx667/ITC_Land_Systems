#include "..\script_component.hpp"

/*
 * Author: Yax
 * Checks whether a given APS (Active Protection System) module on a vehicle is currently able to intercept an incoming projectile,
 * verifying range, reload state, traverse/elevation limits relative to the module's mount (turret or hull), and line of sight.
 *
 * Arguments:
 * 0: Vehicle mounting the APS module <OBJECT>
 * 1: APS module data: [name, position, turret, direction, traverseLim, elevateLim, range, ammoCount, pk, reloadTime, triggersAmmo, lastFiredTime] <ARRAY>
 * 2: Incoming projectile <OBJECT>
 *
 * Return Value:
 * True if the module is able to intercept the projectile right now <BOOLEAN>
 *
 * Example:
 * [_vehicle, _apsModuleData, _projectile] call itc_land_aps_fnc_canIntercept
 *
 * Public: No
 */

params ["_vehicle", "_aps", "_projectile"];
_aps params [
    "_name",
    "_position",
    "_turret",
    "_direction",
    "_traverseLim",
    "_elevateLim",
    "_range",
    "_ammoCount",
    "_pk",
    "_reloadTime",
    "_triggersAmmo",
    "_lastFiredTime"
];

private _apsPosition = _vehicle modelToWorldWorld _position;
private _projectilePosition = getPosASL _projectile;

// logs why the module does not fire when debugging (itc_land_aps_debug), returns false;
// "out of range" is not logged, it repeats every frame while the projectile closes in
private _reject = {
    if (_this != "out of range" && {missionNamespace getVariable [QGVAR(debug), false]}) then {
        diag_log format ["[ITC APS] %1 %2: no intercept, %3 (projectile %4 m)", typeOf _vehicle, _name, _this, round (_apsPosition distance _projectilePosition)];
    };
    false
};

// out of ammo
if (_ammoCount <= 0) exitWith { "out of ammo" call _reject };

// out of range
if (_apsPosition distance _projectilePosition > _range) exitWith { "out of range" call _reject };

// reloading
if (_lastFiredTime + _reloadTime > cba_missionTime) exitWith { "reloading" call _reject };

private _vectToProjectile = _apsPosition vectorFromTo _projectilePosition;
private _vectPolar = _vectToProjectile call CBA_fnc_vect2Polar;

_vectPolar params ["", "_azimuth", "_elevation"];

private _mountDirection = (getDir _vehicle);
if (!isNil "_turret") then {
    private _turretVector = ([_vehicle, _turret] call ace_common_fnc_getTurretDirection) # 1;
    _mountDirection = (_turretVector call CBA_fnc_vect2Polar) # 1;
};

// signed angle between the module's facing and the projectile, -180..180 (wraps across north)
private _offset = ((_azimuth - (_mountDirection + _direction)) % 360 + 540) % 360 - 180;
if (abs _offset >= _traverseLim) exitWith { format ["outside traverse (%1 deg off)", round _offset] call _reject };

if (_elevation < -_elevateLim || _elevation > _elevateLim) exitWith { format ["outside elevation (%1 deg)", round _elevation] call _reject };

// los check from aps module
private _intersects = lineIntersectsWith [_apsPosition, _projectilePosition, _vehicle, _projectile];
if (count _intersects > 0) exitWith { format ["no line of sight (%1)", _intersects apply {typeOf _x}] call _reject };


true
