#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Per-frame handler of a submunition carrier shell's fuze. Tracks the shell and, when the fuze
 * mode triggers, removes itself and releases the magazine's submunition:
 *  - "prox": once the shell descends below the set height above ground
 *  - "time": once the set time has passed since firing, keeping the shell's heading and speed
 *  - "delay": when the shell has been destroyed, extrapolating its last velocity by the set delay
 *
 * Arguments:
 * 0: Per-frame handler values <ARRAY>
 *    0: Projectile <OBJECT>
 *    1: Magazine class <STRING>
 *    2: Last known position (ATL) <ARRAY>
 *    3: Fuze mode <STRING>
 *    4: Fuze value: height in meters, time or delay in seconds <NUMBER>
 *    5: Time the shell was fired <NUMBER>
 *    6: Last velocity above 10 m/s <ARRAY>
 * 1: Per-frame handler ID <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[_projectile, _magazine, getPosATL _projectile, "time", 12, time, [0,0,0]], _pfhId] call itc_land_veh_weapons_fnc_fuze
 *
 * Public: No
 */

params ["_pfhValues", "_pfhId"];
_pfhValues params ["_projectile", "_magazine", "_position", "_fuzeMode", "_fuzeValue", "_firedTime", "_velocity"];

if (alive _projectile) then {
    _position = getPosATL _projectile;
    _pfhValues set [2, _position];
    private _currentVelocity = velocity _projectile;
    if (vectorMagnitude _currentVelocity > 10) then {
        _velocity = _currentVelocity;
        _pfhValues set [6, _velocity];
    };
};

private _triggered = switch (_fuzeMode) do {
    case "prox": {((getPosATL _projectile) select 2 < _fuzeValue && (velocity _projectile) # 2 < 0) || !alive _projectile};
    case "time": {time > _firedTime + _fuzeValue || !alive _projectile};
    default {!alive _projectile};
};
if (!_triggered) exitWith {};

[_pfhId] call CBA_fnc_removePerFrameHandler;
private _submunitionClass = getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_submunition");

switch (_fuzeMode) do {
    case "prox": {
        deleteVehicle _projectile;
        _submunitionClass createVehicle _position;
    };
    case "time": {
        private _heading = getDir _projectile;
        private _pitchBank = _projectile call BIS_fnc_getPitchBank;
        private _currentVelocity = velocity _projectile;
        deleteVehicle _projectile;

        private _submunition = createVehicle [_submunitionClass, _position, [], 0, "FLY"];
        _submunition setDir _heading;
        ([_submunition] + _pitchBank) call BIS_fnc_setPitchBank;
        _submunition setVelocity _currentVelocity;
    };
    default {
        // the shell is gone, so extend its last known flight path by the delay
        private _travel = (vectorNormalized _velocity) vectorMultiply (_fuzeValue * vectorMagnitude _velocity);
        _submunitionClass createVehicle (_position vectorAdd _travel);
    };
};
