#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Handles the sirenPlay event on every machine: plays the siren's sound
 * repeatedly until its end time has passed. The server publishes the end time
 * and extends it when more impacts are predicted near the siren. Machines
 * without an interface play no sound; the server clears the siren's active
 * flag when it stops so it can be triggered again.
 *
 * Arguments:
 * 0: Siren object <Object>
 * 1: Sound class to play <String>
 * 2: Distance the sound can be heard at <Number>
 * 3: Seconds between repeats of the sound <Number>
 * 4: End time when the siren was triggered (cba_missionTime) <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_siren, "alarmCar", 200, 2, cba_missionTime + 30] call itc_land_cobra_fnc_sirenPlay
 *
 * Public: No
 */

params ["_siren", "_sirenSound", "_sirenDistance", "_sirenDuration", "_endTime"];

[{
    params ["_args", "_pfhId"];
    _args params ["_siren", "_sirenSound", "_sirenDistance", "_endTime"];
    // The end time is also passed in, in case this event arrives before the published variable
    if (isNull _siren || {cba_missionTime >= ((_siren getVariable [QGVAR(sirenEndTime), 0]) max _endTime)}) exitWith {
        if (isServer && {!isNull _siren}) then {
            _siren setVariable [QGVAR(sirenActive), false];
        };
        [_pfhId] call CBA_fnc_removePerFrameHandler;
    };
    if (hasInterface) then {
        _siren say3D [_sirenSound, _sirenDistance, 1];
    };
    }, _sirenDuration, [_siren, _sirenSound, _sirenDistance, _endTime]] call CBA_fnc_addPerFrameHandler;
