#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Computes the time fuze setting (FS) of a firing solution: the time after firing at which the
 * shell, on the way down, passes its round's burst height above the target
 * (itc_land_burstHeight, metres). Exact for the vacuum trajectories of the firing tables. A shell
 * that never climbs that high gets the time of its highest point. Rounds without a burst height
 * use the time of flight plus their itc_land_timeModifier (the Extra/Falat cargo rounds, whose
 * carriers need their own timing). Rounds whose fuze has no time mode get -1.
 *
 * Arguments:
 * 0: Magazine class <STRING>
 * 1: Firing solution [charge, azimuth, deflection, quadrant, time of flight, impact velocity,
 *    impact angle, maximum ordinate, distance, height above the gun of the aim point] <ARRAY>
 *
 * Return Value:
 * Fuze setting in seconds, or -1 if the round has no time fuze <NUMBER>
 *
 * Example:
 * ["itc_land_g155smo", _solution] call itc_land_ballistics_fnc_calcFuzeSetting
 *
 * Public: No
 */

#define BTAB_GRAVITY 9.80665

params ["_magazine", "_solution"];

private _config = configFile >> "CfgMagazines" >> _magazine;
private _fuze = configFile >> "ITC_Land_CfgFuzes" >> getText (_config >> "itc_land_fuze");
if !("time" in getArray (_fuze >> "modes")) exitWith {-1};

_solution params ["", "", "", "", "_timeOfFlight", "", "", "", "", ["_aimHeight", 0]];
private _burstHeight = getNumber (_config >> "itc_land_burstHeight");
if (_burstHeight <= 0) exitWith {(_timeOfFlight + getNumber (_config >> "itc_land_timeModifier")) max 0};

// the burst point above the gun: the target (the aim point less the round's aim offset) plus the burst height
private _burstAltitude = _aimHeight - getNumber (_config >> "itc_land_heightModifier") + _burstHeight;
private _climbRate = (_aimHeight + BTAB_GRAVITY * _timeOfFlight ^ 2 / 2) / _timeOfFlight;
private _root = _climbRate ^ 2 - 2 * BTAB_GRAVITY * _burstAltitude;
if (_root < 0) exitWith {_climbRate / BTAB_GRAVITY};

// the later root: passing the burst altitude on the way down
((_climbRate + sqrt _root) / BTAB_GRAVITY) min _timeOfFlight
