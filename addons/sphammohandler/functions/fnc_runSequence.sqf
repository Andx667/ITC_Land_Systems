#include "..\script_component.hpp"

/*
 * Author: ITC Addons Team
 * Runs a list of steps one after another in the unscheduled environment. Each step
 * waits its delay (counted from the previous step), then calls its code with the
 * shared arguments. A delay of 0 runs the step immediately.
 *
 * Arguments:
 * 0: Steps, each [delay in seconds, code] <ARRAY>
 * 1: Arguments passed to every step's code <ANY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [[[0, {hint "a"}], [2, {hint "b"}]], []] call itc_land_sphammohandler_fnc_runSequence
 *
 * Public: No
 */

params ["_steps", "_args"];
if (_steps isEqualTo []) exitWith {};

(_steps # 0) params ["_delay", "_code"];

private _runStep = {
    params ["_steps", "_args", "_code"];
    _args call _code;
    [_steps select [1], _args] call FUNC(runSequence);
};

if (_delay <= 0) exitWith {
    [_steps, _args, _code] call _runStep;
};

[_runStep, [_steps, _args, _code], _delay] call CBA_fnc_waitAndExecute;
