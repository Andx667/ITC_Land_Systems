#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Server-side: triggers a COBRA-linked siren for a predicted shell impact if
 * the siren is within its trigger distance of the impact position. Extends the
 * siren's published end time to cover the new impact, and, if not already
 * running, raises the sirenPlay event on every machine so the siren's
 * configured (or mission-overridden) sound repeats until the end time passes.
 *
 * Arguments:
 * 0: Siren object to trigger <Object>
 * 1: Predicted impact position <Position>
 * 2: Predicted time the shell will impact <Number>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_siren, _position, _impactTime] call itc_land_cobra_fnc_sirenTrigger
 *
 * Public: No
 */

params ["_siren","_position","_impactTime"];
private _sirenTriggerDist = _siren getVariable [QGVAR(sirenTriggerDist), 500];

if (_siren distance _position < _sirenTriggerDist) then {

    private _sirenActive = _siren getVariable [QGVAR(sirenActive), false];
    private _sirenEndTime = _siren getVariable [QGVAR(sirenEndTime), cba_missionTime];
    private _sirenType = typeOf _siren;
    private _sirenParams = _siren getVariable [QGVAR(sirenParams),[false]];

    if (_impactTime > _sirenEndTime) then {
        _siren setVariable [QGVAR(sirenEndTime), _impactTime, true];
    };
    if (!_sirenActive) then {
        _siren setVariable [QGVAR(sirenActive), true];
        private ["_sirenSound","_sirenDistance","_sirenDuration"];
        ([1] call FUNC(sirenTypes)) params ["_configTypes","_missionTypes"];

        if (_sirenType in _configTypes) then {
            _sirenSound = (configFile >> "CfgVehicles" >> _sirenType >> "ITC_Land_COBRA_SirenParams" >> "soundClass") call BIS_fnc_getCfgData;
            _sirenDistance = (configFile >> "CfgVehicles" >> _sirenType >> "ITC_Land_COBRA_SirenParams" >> "soundDistance") call BIS_fnc_getCfgData;
            _sirenDuration = (configFile >> "CfgVehicles" >> _sirenType >> "ITC_Land_COBRA_SirenParams" >> "soundDuration") call BIS_fnc_getCfgData;
        };
        if ((_sirenType in _missionTypes) && { (!(_sirenType in _configTypes)) }) then {
            if ( !(_sirenParams # 0) ) then { _sirenSound = "alarmCar"; _sirenDistance = 200; _sirenDuration = 2; };
        };
        if (_sirenParams # 0) then { //if siren has been modified by mission maker then let these overwrite any other defined params
            _sirenSound = (_sirenParams # 1);
            _sirenDistance = (_sirenParams # 2);
            _sirenDuration = (_sirenParams # 3);
        };


        private _endTime = _siren getVariable [QGVAR(sirenEndTime), _impactTime];
        [QGVAR(sirenPlay), [_siren, _sirenSound, _sirenDistance, _sirenDuration, _endTime]] call CBA_fnc_globalEvent;
    };
};
