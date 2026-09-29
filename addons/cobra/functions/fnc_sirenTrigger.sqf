#include "..\script_component.hpp"

/*
 * Author: ToadBall, Yax
 * Triggers a COBRA-linked siren for a predicted shell impact if the siren is
 * within its trigger distance of the impact position. Extends the siren's
 * active end time to cover the new impact, and, if not already running,
 * spawns a loop that plays the siren's configured (or mission-overridden)
 * sound repeatedly at its configured duration until the end time passes.
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
private _sirenTriggerDist = _siren getVariable ["sirenTriggerDist", 500];

if(_siren distance _position < _sirenTriggerDist) then {

  private _sirenActive = _siren getVariable ["sirenActive", false];
  private _sirenEndTime = _siren getVariable ["sirenEndTime", time];
  private _sirenType = typeOf _siren;
  private _sirenParams = _siren getVariable ["sirenParams",[false]];
  
  if(_impactTime > _sirenEndTime) then {
    _siren setVariable ["sirenEndTime", _impactTime];
  };
  if(!_sirenActive) then {
    _siren setVariable ["sirenActive", true];
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


    [{
      params ["_args", "_pfhId"];
      _args params ["_siren", "_sirenSound", "_sirenDistance"];
      if (time >= _siren getVariable ["sirenEndTime", 0]) exitWith {
        _siren setVariable ["sirenActive", false];
        [_pfhId] call CBA_fnc_removePerFrameHandler;
      };
      _siren say3D [_sirenSound, _sirenDistance, 1];
    }, _sirenDuration, [_siren, _sirenSound, _sirenDistance]] call CBA_fnc_addPerFrameHandler;
  };
};
