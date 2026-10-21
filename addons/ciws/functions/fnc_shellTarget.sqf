#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Spawns and tracks a targetable decoy object representing an incoming
 * projectile, so that CIWS-enabled weapons can lock on to and engage it.
 * After a 1 second delay, resolves a target classname from the fired ammo's
 * itc_land_ciws_target config entry (defaulting to "itc_land_shell") with a
 * side-specific suffix (_b/_o/_i) based on the gunner's side, spawns it
 * behind the projectile with matching velocity, disables its crew AI, then
 * adds a per-frame handler that keeps the decoy positioned relative
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
    private _initialClass = if (_classTarget != "") then [{_classTarget},{"itc_land_shell"}];
    private _class = if ((side _gunner) == west) then [{_initialClass + "_b"},{_initialClass + "_o"}];
    _class = if ((side _gunner) == resistance) then [{_initialClass + "_i"},{_class}];
    private _target = _class createVehicle [0,0,1000];
    _target setPos (_projectile modelToWorld [0,-5,0]);
    _target setVelocity (velocity _projectile);
    _target setObjectTexture [0,""];
    // The crew gives the decoy a side so CIWS AI treats it as hostile
    createVehicleCrew _target;
    (group driver _target) deleteGroupWhenEmpty true;
    driver _target disableAI "ALL";
    gunner _target disableAI "ALL";
    if (missionNamespace getVariable [QGVAR(debug), false]) then {
        private _log = {
            params ["_label", "_projectile", "_target"];
            private _cram = vehicles select {((typeOf _x) find "itc_land_cram") == 0 || {((typeOf _x) find "itc_land_ciws") == 0}};
            diag_log format ["[ITC CIWS] %1 target=%2 alive=%3 side=%4 posATL=%5 vel=%6 projAlive=%7", _label, typeOf _target, alive _target, side group driver _target, getPosATL _target, round speed _target, alive _projectile];
            {
                private _gunner = gunner _x;
                diag_log format ["[ITC CIWS]   %1 radar=%2 gunner=%3 knows=%4 sensorTargets=%5 dist=%6", typeOf _x, isVehicleRadarOn _x, side group _gunner, _gunner knowsAbout _target, count getSensorTargets _x, round (_x distance _target)];
            } forEach _cram;
        };
        ["decoy created", _projectile, _target] call _log;
        for "_i" from 1 to 6 do {
            [{
                params ["_log", "_projectile", "_target", "_i"];
                if (!isNull _target) then {[format ["decoy +%1 s", _i * 3], _projectile, _target] call _log};
                }, [_log, _projectile, _target, _i], _i * 3] call CBA_fnc_waitAndExecute;
        };
    };
    [{
        (_this select 0) params ["_projectile", "_target"];
        private _canIntercept = (getPosATL _projectile # 2 > 30);
        private _descending = (velocity _projectile # 2 < 0);
        if (!alive _projectile || (!alive _target && _canIntercept)) exitWith {
            deleteVehicle _projectile;
            deleteVehicleCrew _target;
            deleteVehicle _target;
            [_this select 1] call CBA_fnc_removePerFrameHandler;
        };
        if (!_canIntercept && alive _target && _descending) then {
            deleteVehicleCrew _target;
            deleteVehicle _target;
        } else {
            _target setPos (_projectile modelToWorld [1,-5,1]);
            _target setVelocity (velocity _projectile);
        };
        }, 0, [_projectile, _target]] call CBA_fnc_addPerFrameHandler;
    }, _this, 1] call CBA_fnc_waitAndExecute;
