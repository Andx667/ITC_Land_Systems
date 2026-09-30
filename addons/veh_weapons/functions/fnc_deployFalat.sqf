#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Deploys a single laser-guided submunition ("Falat") from a fired shell.
 * Spawns a placeholder cargo object that, after a short delay, becomes an
 * ITC_155Extra loitering submunition, searches for a matching laser spot, and
 * fires a simulated HEAT projectile at it, or triggers itself after a timeout
 * if no laser spot is ever found.
 *
 * Arguments:
 * 0: Index of the submunition being deployed, used to select its laser code <NUMBER>
 * 1: World position to spawn the submunition at <ARRAY>
 * 2: Velocity vector of the parent projectile at deployment <ARRAY>
 * 3: Pitch of the parent projectile at deployment <NUMBER>
 * 4: Bank of the parent projectile at deployment <NUMBER>
 * 5: Guidance info array: [[laserCode0, laserCode1], targetGrid, targetAlt] <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1, position _projectile, velocity _projectile, _pitch, _bank, _guidanceInfo] call itc_land_veh_weapons_fnc_deployFalat
 *
 * Public: No
 */

params ["_subMunitionIndex", "_position", "_velocity", "_pitch", "_bank", "_guidanceInfo"];

private _laserCode = 1111;
if (_subMunitionIndex < 2) then {
    _laserCode = _guidanceInfo # 0 # _subMunitionIndex;
};

private _profile = createHashMapFromArray [
    ["jitter", 5],
    // fire at the laser spot matching this submunition's code
    ["findTarget", {
        params ["_projectile", "_laserCode"];
        private _positionASL = getPosASL _projectile;
        private _spot = [_positionASL, [0, 0, -1], 90, 300, [1500, 1550], _laserCode] call ace_laser_fnc_seekerFindLaserSpot;
        if (isNil {_spot select 0}) exitWith {[]};
        _positionASL vectorFromTo (_spot select 0)
    }],
    // detonate in place if no laser spot was ever found
    ["timeout", {
        params ["_projectile", "_firedTime"];
        if !(time > _firedTime + 180 && typeOf _projectile == "ITC_155Extra") exitWith {false};
        private _heat = createVehicle ["R_MRAAWS_HEAT_F", getPos _projectile, [], 0, "FLY"];
        [_heat, -90, 0] call BIS_fnc_setPitchBank;
        triggerAmmo _heat;
        deleteVehicle _projectile;
        true
    }]
];

[_subMunitionIndex, _position, _velocity, _profile, _laserCode] call FUNC(deployCarrier);
