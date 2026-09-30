#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Deploys a single unguided submunition ("Extra") from a fired 155mm Mof35 shell.
 * Spawns a placeholder cargo object that, after a short delay, becomes an
 * ITC_155Extra loitering submunition, searches nearby armored targets, and fires
 * a simulated HEAT projectile at the first target found within range, or
 * self-destructs if it descends below a minimum altitude.
 *
 * Arguments:
 * 0: Index of the submunition being deployed, used to offset its spawn position <NUMBER>
 * 1: World position to spawn the submunition at <ARRAY>
 * 2: Velocity vector of the parent projectile at deployment <ARRAY>
 * 3: Pitch of the parent projectile at deployment <NUMBER>
 * 4: Bank of the parent projectile at deployment <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1, position _projectile, velocity _projectile, _pitch, _bank] call itc_land_veh_weapons_fnc_deployExtra
 *
 * Public: No
 */

params ["_subMunitionIndex", "_position", "_velocity"];

private _profile = createHashMapFromArray [
    ["jitter", 3],
    // fire at the nearest living armored vehicle below
    ["findTarget", {
        params ["_projectile"];
        private _tanks = nearestObjects [[getPos _projectile # 0, getPos _projectile # 1, 0], ["Wheeled_APC_F", "Tank_F"], 50];
        private _index = _tanks findIf {alive _x && _x distance _projectile < 75};
        if (_index == -1) exitWith {[]};
        (getPos _projectile) vectorFromTo ((getPos (_tanks # _index)) vectorAdd [0, 0, 1])
    }],
    // self destruct just above the ground
    ["timeout", {
        params ["_projectile"];
        if !(getPosATL _projectile # 2 < 20 || getPosASL _projectile # 2 < 15) exitWith {false};
        private _heat = createVehicle ["R_MRAAWS_HEAT_F", (getPos _projectile) vectorAdd [0, 0, 10], [], 0, "FLY"];
        [_heat, -90, 0] call BIS_fnc_setPitchBank;
        _heat setVelocity [0, 0, -50];
        deleteVehicle _projectile;
        true
    }]
];

[_subMunitionIndex, _position, _velocity, _profile] call FUNC(deployCarrier);
