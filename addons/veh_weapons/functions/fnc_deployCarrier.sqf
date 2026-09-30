#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Deploys one loitering submunition from a fired shell. A placeholder cargo object is spawned
 * first; after 4 seconds it is swapped for an ITC_155Extra, and from 8 seconds on the profile's
 * target search runs. When it finds a target a HEAT round is fired along the returned direction.
 * The profile's timeout check can end the submunition earlier.
 *
 * Arguments:
 * 0: Index of the submunition being deployed, offsets its spawn position <NUMBER>
 * 1: World position to spawn at <ARRAY>
 * 2: Velocity vector of the parent projectile <ARRAY>
 * 3: Profile <HASHMAP>
 *    "jitter": maximum random velocity added per axis <NUMBER>
 *    "findTarget": code receiving [projectile, search arguments], returns the direction vector to fire along or [] <CODE>
 *    "timeout": code receiving [projectile, fired time], returns true if it ended the submunition <CODE>
 * 4: Argument handed to the target search (default: []) <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [1, _position, _velocity, _profile, 1111] call itc_land_veh_weapons_fnc_deployCarrier
 *
 * Public: No
 */

params ["_subMunitionIndex", "_position", "_velocity", "_profile", ["_searchArgs", []]];

private _jitter = _profile get "jitter";
private _carrier = createVehicle ["Land_FoodContainer_01_F", _position vectorAdd ((vectorNormalized _velocity) vectorMultiply _subMunitionIndex), [], 0, "FLY"];
_carrier setVelocity (_velocity vectorAdd [random _jitter, random _jitter, random _jitter]);

[{
    params ["_pfhValues", "_pfhId"];
    _pfhValues params ["_projectile", "_firedTime", "_profile", "_searchArgs"];

    // open the parachute: swap the carrier for the real submunition
    if (time > _firedTime + 4 && typeOf _projectile == "Land_FoodContainer_01_F") then {
        private _submunition = createVehicle ["ITC_155Extra", getPos _projectile, [], 0, "FLY"];
        _submunition setVelocity (velocity _projectile);
        deleteVehicle _projectile;
        _projectile = _submunition;
        _pfhValues set [0, _submunition];
    };

    if (time > _firedTime + 8 && typeOf _projectile == "ITC_155Extra") then {
        private _direction = [_projectile, _searchArgs] call (_profile get "findTarget");
        if (_direction isNotEqualTo []) exitWith {
            private _heat = createVehicle ["R_MRAAWS_HEAT_F", getPos _projectile, [], 0, "FLY"];
            [_heat, -90, 0] call BIS_fnc_setPitchBank;
            _heat setVelocity (_direction vectorMultiply 5000);
            deleteVehicle _projectile;
            [_pfhId] call CBA_fnc_removePerFrameHandler;
        };
    };

    if (isNull _projectile) exitWith {[_pfhId] call CBA_fnc_removePerFrameHandler};

    if ([_projectile, _firedTime] call (_profile get "timeout")) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };

    if (!alive _projectile) exitWith {
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
}, 0.5, [_carrier, time, _profile, _searchArgs]] call CBA_fnc_addPerFrameHandler;
