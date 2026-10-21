#include "..\script_component.hpp"

/*
 * Author: Yax
 * Attempts to intercept an incoming projectile with each of a vehicle's APS (Active Protection System) modules that report being able to
 * intercept it. On a successful chance roll (pk), destroys or replaces the incoming projectile; on a failed roll, spawns a visual
 * countermeasure round. Runs on the machine that owns the projectile. The module's ammo count and last fired time are updated
 * optimistically on this machine and sent to the vehicle's owner (onModuleFired), which applies and publishes the authoritative state.
 *
 * Arguments:
 * 0: Incoming projectile <OBJECT>
 * 1: Vehicle with APS module(s) attempting interception <OBJECT>
 *
 * Return Value:
 * True if a module destroyed the projectile <BOOL>
 *
 * Example:
 * [_projectile, _vehicle] call itc_land_aps_fnc_attemptIntercept
 *
 * Public: No
 */

params ["_projectile", "_vehicle"];

private _killed = false;
private _apsModules = _vehicle getVariable ["itc_land_aps_modules", []];
{
    if (_killed) exitWith {};
    private _canIntercept = [_vehicle, _x, _projectile] call FUNC(canIntercept);
    if (_canIntercept) then {
        private _index = _forEachIndex;
        private _module = +_x;
        private _pk = _module select 8;
        private _triggersAmmo = _module select 10;

        // When the vehicle is remote, apply the shot locally right away so the next frame does not fire
        // the same module again; the owner's event handler applies it to the shared state
        if (!local _vehicle) then {
            _module set [7, (_module select 7) - 1];
            _module set [11, cba_missionTime];
            _apsModules set [_index, _module];
            _vehicle setVariable ["itc_land_aps_modules", _apsModules];
        };
        [QGVAR(moduleFired), [_vehicle, _index, cba_missionTime], _vehicle] call CBA_fnc_targetEvent;

        private _kill = random 1 <= _pk;
        if (missionNamespace getVariable [QGVAR(debug), false]) then {
            diag_log format ["[ITC APS] %1 %2 fired at %3 m: %4", typeOf _vehicle, _module select 0, round (_projectile distance _vehicle), ["miss", "kill"] select _kill];
        };

        if (_kill) then {
            if (_triggersAmmo) then {
                triggerAmmo _projectile;
            } else {
                private _newProjectile = "ammo_Penetrator_PG7" createVehicle [0,0,100];
                private _pos = getPosASL _projectile;
                (_projectile call bis_fnc_getPitchBank) params ["_pitch", "_bank"];
                deleteVehicle _projectile;
                [_newProjectile, _pitch, _bank] call bis_fnc_setPitchBank;
                _newProjectile setPosASL _pos;
                triggerAmmo _newProjectile;
            };
            _killed = true;
        } else {
            private _velocity = velocity _projectile;
            private _inverseMagnitude = -1 * (vectorMagnitude _velocity);
            private _ammo = "B_127x108_APDS" createVehicle [0,0,100];
            _ammo setVelocity ((vectorNormalized _velocity) vectorMultiply _inverseMagnitude);
            _ammo setPosASL (getPosASL _projectile);
        };
    };
} forEach _apsModules;

_killed
