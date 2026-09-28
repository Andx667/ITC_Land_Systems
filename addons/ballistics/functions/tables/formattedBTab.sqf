#include "..\..\script_component.hpp"

/*
 * Author: ToadBall, Yax, VKing
 * Generates a formatted ballistic table as SQF source text and copies it to the clipboard, for use by designers & config makers.
 * Calls calcBallistics.sqf to compute the raw table, derives min/max range at the median height offset, and formats the result as
 * an SQF array assignment ready to be pasted into a table file.
 *
 * Arguments:
 * 0: Magazine classname (CfgMagazines) <STRING>
 * 1: Minimum gun elevation angle, degrees <NUMBER>
 * 2: Maximum gun elevation angle, degrees <NUMBER>
 * 3: Gun elevation angle step, degrees <NUMBER>
 * 4: Minimum height offset to slice at <NUMBER>
 * 5: Maximum height offset to slice at <NUMBER>
 * 6: Height step between slices <NUMBER>
 * 7: Muzzle velocity, m/s <NUMBER> (default: magazine's initSpeed)
 * 8: Air friction coefficient <NUMBER> (default: ammo's airFriction)
 *
 * Return Value:
 * None (formatted SQF table text is copied to the clipboard and stored in the global variable FORMATTEDBTAB)
 *
 * Example:
 * ["itc_Sh_82mm_HE", 45, 85, 1, -2000, 2000, 100] call itc_land_ballistics_fnc_formattedBTab
 *
 * Public: No
 */

private _magazine = _this select 0;
private _elevMin = _this select 1;
private _elevMax = _this select 2;
private _elevStep = _this select 3;
private _heightMin = _this select 4;
private _heightMax = _this select 5;
private _heightStep = _this select 6;
private _muzzleVelocity = _this select 7;
private _airFriction = _this select 8;

hint "4...";
private _ammo = getText(configFile >> "CfgMagazines" >> _magazine >> "ammo");
btabammo = _ammo;


// Normal artillery shell calculation
_ammo = getText(configFile >> "CfgMagazines" >> _magazine >> "ammo");
if((count _this) < 8) then {
    _muzzleVelocity = getNumber(configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
};
if((count _this) < 9) then {
    _airFriction = getNumber(configFile >> "CfgAmmo" >> _ammo >> "airFriction");
};
hint "2...";

private _btab = [_magazine, _elevMin, _elevMax, _elevStep, _heightMin, _heightMax, _heightStep, _muzzleVelocity, _airFriction] call compile preprocessFileLineNumbers QPATHTOF(functions\tables\calcBallistics.sqf);

_btab = _btab select 0;

hint "1...";

// Calculate min and max range based on median offset.
private _mo = floor(((_heightMax - _heightMin) / _heightStep)*0.5);
private _rangeMin = 999999;
private _rangeMax = -1;
for [{private _i=0;},{_i < count(_btab)},{_i=_i+1;}] do
{
    private _slice = (_btab select _i) select 2;
    if (count _slice >= (_mo+1)) then
    {
        private _range = (_slice select _mo) select 0;
        if (_range < _rangeMin) then {_rangeMin = _range;};
        if (_range > _rangeMax) then {_rangeMax = _range;};
    };
};

debugMR = _rangeMax;

// Generate SQF
private _sqf = "";
_sqf = _sqf + format ["// ARTY+ACE Module ballistics table.%1// Magazine: %2%1// Ammo: %3%1// AirFriction: %4%1// MuzzleVelocity: %5%1%1", toString [10], _magazine, _ammo, _airFriction, _muzzleVelocity];
_sqf = _sqf + format ["private _minHeight = %1;%2", _heightMin, toString[10]];
_sqf = _sqf + format ["private _maxHeight = %1;%2", _heightMax, toString[10]];
_sqf = _sqf + format ["private _hstep = %1;%2", _heightStep, toString[10]];
_sqf = _sqf + format ["private _minRange = %1;%2", _rangeMin, toString[10]];
_sqf = _sqf + format ["private _maxRange = %1;%2", _rangeMax, toString[10]];
_sqf = _sqf + format ["private _btab = [%1", toString[10]];
for [{private _i=0;},{_i < count(_btab);},{_i=_i+1;}] do
{
    private _tail = ",";
    if (_i == (count(_btab) - 1)) then
    {
        _tail = "";
    };
    _sqf =_sqf + format ["    %1%2%3", (_btab select _i), _tail, toString [10] ];
};
_sqf = _sqf + format ["];%1%1",toString [10]];

_sqf = _sqf + format ["[_btab, _minRange, _maxRange, _minHeight, _maxHeight, _hstep]%1",toString[10]];

hint "0";

copyToClipboard _sqf;
FORMATTEDBTAB = _sqf;
