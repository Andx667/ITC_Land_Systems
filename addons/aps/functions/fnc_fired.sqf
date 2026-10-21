#include "..\script_component.hpp"

/*
 * Author: Yax
 * "Fired" class event handler. For locally fired rocket/missile projectiles, adds a per-frame handler that raycasts ahead of the
 * projectile every frame and attempts an APS intercept against any object it detects with APS modules, until the projectile dies.
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
if (!GVAR(enabled)) exitWith {};

private _simulation = getText (configFile >> "cfgAmmo" >> _ammo >> "simulation");

if (!(_simulation in ["shotRocket", "shotMissile"])) exitWith {};

if (missionNamespace getVariable [QGVAR(debug), false]) then {
    diag_log format ["[ITC APS] tracking %1 fired by %2 at %3 m/s", _ammo, typeOf _unit, round vectorMagnitude velocity _projectile];
};

// every frame: a rocket covers several metres per frame and a module's window is only its range
[_projectile, {
    params ["_projectile", "", "_pfhId"];
    private _begin = getPosASL _projectile;
    private _end = _begin vectorAdd ((vectorDir _projectile) vectorMultiply 30);
    private _intersects = lineIntersectsWith  [_begin, _end, objNull, objNull];
    if (count _intersects > 0) exitWith {
        { // forEach _intersects
            private _aps = _x getVariable ["itc_land_aps_modules", nil];
            // a killed projectile can stay alive for a few frames: stop tracking it so no module fires at it again
            if (!(isNil "_aps") && {[_projectile, _x] call FUNC(attemptIntercept)}) exitWith {
                [_pfhId] call CBA_fnc_removePerFrameHandler;
            };
        } forEach _intersects;
    };
}] call EFUNC(common,addProjectilePFH);
