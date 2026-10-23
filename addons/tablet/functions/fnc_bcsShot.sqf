#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Records that a BCS fire mission was fired: its impact time (now plus the time of flight) starts
 * the SHOT/SPLASH countdown, and Alert To Splash seconds before impact a beep and a hint warn the
 * FDC, also with the tablet closed (right away if the time of flight is shorter). Called by the
 * SHOT button and when the first linked gun reports the shot over the datalink. A pending alert
 * is dropped when the mission ends or SHOT is recorded again.
 *
 * Arguments:
 * 0: Mission ID, e.g. "FM0001" <STRING>
 * 1: Time of flight in seconds <NUMBER>
 *
 * Return Value:
 * True if the mission exists <BOOL>
 *
 * Example:
 * ["FM0001", 23.4] call itc_land_tablet_fnc_bcsShot
 *
 * Public: No
 */

params ["_ident", "_timeOfFlight"];

private _mission = GVAR(bcs_missions) param [GVAR(bcs_missions) findIf {_x # 0 == _ident}, []];
if (_mission isEqualTo []) exitWith {false};

private _impactTime = time + _timeOfFlight;
_mission set [6, _impactTime];

[{
    params ["_ident", "_impactTime"];
    if (GVAR(bcs_missions) findIf {_x # 0 == _ident && {_x # 6 == _impactTime}} == -1) exitWith {};
    playSound "FD_Timer_F";
    [format [LLSTRING(Bcs_SplashAlert), _ident, round (_impactTime - time)]] call ace_common_fnc_displayTextStructured;
}, [_ident, _impactTime], (_timeOfFlight - GVAR(bcs_splash_time)) max 0] call CBA_fnc_waitAndExecute;

true
