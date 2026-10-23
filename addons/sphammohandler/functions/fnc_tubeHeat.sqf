#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Mortar tube heat, counted in rounds: each round adds one, the tube sheds the sustained rate
 * (itc_land >> mortarSustainedRate, rounds a minute, default 4). Below the rapid-fire limit
 * (itc_land >> mortarRapidRounds, default 16) the crew fires as fast as it loads; at the limit
 * the next round waits until the tube is down to the sustained rate.
 *
 * Arguments:
 * 0: Mortar vehicle <OBJECT>
 * 1: Add a fired round <BOOL> (default: false)
 *
 * Return Value:
 * Seconds before the next round may be prepared <NUMBER>
 *
 * Example:
 * [_vehicle, true] call itc_land_sphammohandler_fnc_tubeHeat
 *
 * Public: No
 */

params ["_vehicle", ["_addRound", false]];

private _config = configOf _vehicle >> "itc_land";
private _rapidRounds = [16, getNumber (_config >> "mortarRapidRounds")] select (isNumber (_config >> "mortarRapidRounds"));
private _sustainedRate = [4, getNumber (_config >> "mortarSustainedRate")] select (isNumber (_config >> "mortarSustainedRate"));

(_vehicle getVariable ["itc_land_tubeHeat", [0, 0]]) params ["_heat", "_time"];
_heat = 0 max (_heat - (CBA_missionTime - _time) * _sustainedRate / 60);
if (_addRound) then {
    _heat = _heat + 1;
    _vehicle setVariable ["itc_land_tubeHeat", [_heat, CBA_missionTime], true];
};

((_heat + 1 - _rapidRounds) max 0) * 60 / _sustainedRate
