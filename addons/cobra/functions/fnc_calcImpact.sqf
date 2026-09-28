#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Simulates the forward ballistic trajectory of a fired shell, stepping the
 * simulation forward frame by frame (applying air friction and gravity) until
 * the simulated position drops below the terrain height, in order to predict
 * where and when the shell will impact.
 *
 * Arguments:
 * 0: Shell/projectile object to simulate forward to impact <Object>
 *
 * Return Value:
 * Array containing the simulated impact position (ASL) and the simulated
 * time of flight in seconds <Array>
 *
 * Example:
 * [_shell] call itc_land_cobra_fnc_calcImpact
 *
 * Public: No
 */

params ["_shell"];
private _ammo = typeOf _shell;
private _vel = vectorMagnitude (velocity _shell);
private _airFriction = getNumber(configFile >> "CfgAmmo" >> _ammo >> "airFriction");
private _grav = -9.80665;
private _fps = 60;
private _elevation = (_shell call BIS_fnc_getPitchBank) # 0;
private _fc = 0;
private _useElevation = _elevation;

// Set t0 parameters
private _vx = _vel * cos(_useElevation);
private _vy = _vel * sin(_useElevation);
private _frame = 1 / _fps;
private _x = 0;
private _y = 0.1;
private _alt = 0;
private _aboveLand = true;
private _simulatedPos = [];
while {_aboveLand} do
{

    if(_fc % 5 == 0) then {
        private _simulatedPosXY = ((getPosASL _shell) getPos [_x, getDir _shell]) vectorAdd [0,0,_y];
        _simulatedPos = [_simulatedPosXY # 0, _simulatedPosXY # 1, ((getPosASL _shell) # 2) + _y];
        _alt = _simulatedPos # 2;
        private _terrainAlt = getTerrainHeightASL  _simulatedPos;
        _aboveLand = _terrainAlt < _alt;
    };

    // Calculate next velocity frame
    _vx = _vx + (_vx * _vel * _airFriction * _frame);
    _vy = _vy + (_vy * _vel * _airFriction * _frame);
    _vy = _vy + (_grav * _frame);
    _vel = sqrt(_vx*_vx + _vy*_vy);
    // Increment positions
    _y = _y + (_vy * _frame);
    _x = _x + (_vx * _frame);
    // Increment frame count.
    _fc = _fc + 1;
};

[_simulatedPos, _fc * _frame]
