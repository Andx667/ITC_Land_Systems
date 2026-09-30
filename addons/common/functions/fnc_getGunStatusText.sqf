#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Builds the autoloader status text of a vehicle, optionally with the progress of the
 * current multi-round fire mission.
 *
 * Arguments:
 * 0: Vehicle <OBJECT>
 * 1: Append round progress when a round count is set (default: true) <BOOL>
 *
 * Return Value:
 * Status text, e.g. "READY TO FIRE ( 2 / 4 )" <STRING>
 *
 * Example:
 * [_vehicle] call itc_land_common_fnc_getGunStatusText
 *
 * Public: No
 */

params ["_vehicle", ["_showRounds", true]];

private _statusText = ((_vehicle getVariable ["itc_land_ammoHandler_status", [0,0,"WAITING"]]) select 2);
private _roundCount = _vehicle getVariable ["itc_land_roundCount", 0];
if (!_showRounds || {_roundCount < 1}) exitWith {_statusText};

private _roundsFired = _vehicle getVariable ["itc_land_roundsFired", 0];
if (_roundsFired == _roundCount) exitWith {
    format ["%1 ( %2 / %3 ROUNDS COMPLETE )", _statusText, _roundsFired, _roundCount]
};
format ["%1 ( %2 / %3 )", _statusText, _roundsFired + 1, _roundCount]
