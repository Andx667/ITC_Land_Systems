#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Per-frame handler of a submunition carrier shell's fuze. Tracks the shell and, when the fuze
 * mode triggers, removes itself and releases the magazine's submunition:
 *  - "prox": once the shell descends below the set height above ground
 *  - "time": once the set time has passed since firing, keeping the shell's heading and speed
 *  - "delay": just before the shell hits, it is removed (no burst on impact) and the submunition
 *    bursts the set delay later where the shell would be by then: half a metre into the ground,
 *    or past a roof or wall it went through, short of the ground beyond. A shell that hits
 *    something without being seen coming (inside a frame) bursts on impact, as point detonating.
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

if (_fuzeMode == "delay") exitWith {
    if (!alive _projectile) exitWith {[_pfhId] call CBA_fnc_removePerFrameHandler};
    // look ahead about two frames for the surface the shell is about to hit
    private _start = getPosASL _projectile;
    private _currentVelocity = velocity _projectile;
    private _speed = vectorMagnitude _currentVelocity;
    private _hits = lineIntersectsSurfaces [_start, _start vectorAdd (_currentVelocity vectorMultiply ((2 * diag_deltaTime) max 0.05)), _projectile, objNull, true, 1, "GEOM", "FIRE"];
    if (_hits isEqualTo [] || {_speed < 1}) exitWith {};

    [_pfhId] call CBA_fnc_removePerFrameHandler;
    (_hits # 0) params ["_impact", "", "_hitObject"];
    private _direction = vectorNormalized _currentVelocity;
    // into the ground it only digs in; through a roof or wall it goes on for the delay, short of the ground beyond
    private _depth = 0.5;
    if (!isNull _hitObject) then {
        private _travel = _speed * _fuzeValue;
        private _beyond = lineIntersectsSurfaces [_impact vectorAdd (_direction vectorMultiply 0.05), _impact vectorAdd (_direction vectorMultiply _travel), objNull, objNull, true, -1, "GEOM", "FIRE"];
        private _ground = _beyond findIf {isNull (_x # 2)};
        _depth = if (_ground == -1) then {_travel} else {((_impact distance (_beyond # _ground # 0)) - 0.5) max 0.5};
    };
    deleteVehicle _projectile;

    [{
        params ["_submunitionClass", "_burst"];
        private _submunition = createVehicle [_submunitionClass, [0, 0, 0], [], 0, "CAN_COLLIDE"];
        _submunition setPosASL _burst;
    }, [
        getText (configFile >> "CfgMagazines" >> _magazine >> "itc_land_submunition"),
        _impact vectorAdd (_direction vectorMultiply _depth)
    ], ((_start distance _impact) / _speed) + _fuzeValue] call CBA_fnc_waitAndExecute;
};

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
};
