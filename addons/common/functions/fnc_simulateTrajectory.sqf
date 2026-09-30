#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Simulates the ballistic trajectory of a shell frame by frame, applying air friction and
 * gravity, until the simulated position drops below the terrain. Run forward it predicts
 * where and when the shell will impact; run backward it estimates where it was fired from.
 *
 * Arguments:
 * 0: Shell in flight <OBJECT>
 * 1: Simulate backward in time to find the origin (default: false) <BOOL>
 *
 * Return Value:
 * [terrain position (ASL), simulated time of flight in seconds] <ARRAY>
 *
 * Example:
 * [_shell] call itc_land_common_fnc_simulateTrajectory
 *
 * Public: No
 */

params ["_shell", ["_backward", false]];

private _direction = [1, -1] select _backward;
private _vel = vectorMagnitude (velocity _shell);
private _ammo = typeOf _shell;
private _airFriction = _direction * getNumber (configFile >> "CfgAmmo" >> _ammo >> "airFriction");
private _grav = -9.80665 * _direction;
private _frame = 1 / 60;
private _elevation = (_shell call BIS_fnc_getPitchBank) # 0;
private _frameCount = 0;

private _vx = _vel * cos _elevation;
private _vy = _vel * sin _elevation;
private _x = 0;
private _y = 0.1;
private _aboveLand = true;
private _simulatedPos = [];

while {_aboveLand} do {
    // the terrain check is expensive, so only test every 5th frame
    if (_frameCount % 5 == 0) then {
        private _simulatedPosXY = ((getPosASL _shell) getPos [_x, getDir _shell]) vectorAdd [0, 0, _y];
        _simulatedPos = [_simulatedPosXY # 0, _simulatedPosXY # 1, ((getPosASL _shell) # 2) + _y];
        _aboveLand = (getTerrainHeightASL _simulatedPos) < (_simulatedPos # 2);
    };

    _vx = _vx + (_vx * _vel * _airFriction * _frame);
    _vy = _vy + (_vy * _vel * _airFriction * _frame);
    _vy = _vy + (_grav * _frame);
    _vel = sqrt (_vx * _vx + _vy * _vy);

    _y = _y + (_direction * _vy * _frame);
    _x = _x + (_direction * _vx * _frame);
    _frameCount = _frameCount + 1;
};

[_simulatedPos, _frameCount * _frame]
